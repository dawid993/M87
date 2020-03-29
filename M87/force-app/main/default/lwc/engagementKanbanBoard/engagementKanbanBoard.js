import { LightningElement, track, wire } from 'lwc';
import retrieveEngagementCases from '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases';
import changeCaseStatus from '@salesforce/apex/EngagementKanbanController.changeCaseStatus';
import ImmutabilityService from "c/immutabilityService";
import reducers from 'c/functionReduction';

const caseIconUrl = '/resource/Case_Icon';

const inProgressStatus = 'In Progress';
const toDoStatus = 'To Do';
const doneSuccessStatus = 'Done - success';
const doneFailureStatus = 'Done - failure';

export default class EngagementKanbanBoard extends LightningElement {

    @track
    showSpinner = false

    get mapTaskToDivElements() {
        return casesContainers => casesTasks => {

            let createDivIfStatusPresented = caseElement => {
                if (casesContainers.has(caseElement.Status)) {
                    casesContainers.get(caseElement.Status).push(this.createTaskElement(caseElement))
                }
            }

            casesTasks.forEach(createDivIfStatusPresented)
            return ImmutabilityService.deepFreeze(casesContainers)
        }
    }

    get renderColumns() {
        return casesContainers => casesContainers.forEach((casesDivs, key) => {
            let column = this.template.querySelector(`[data-status='${key}']`);
            if (column) {
                casesDivs.forEach(caseDiv => {
                    column.appendChild(caseDiv)
                })
            }
        })
    }

    get moveTaskBetweenColumns() {
        return targetColumn => taskId => {
            let result;
            if (targetColumn) {
                targetColumn.appendChild(this.template.querySelector("[data-task-id='" + taskId + "']"));
                result = {
                    "taskId": taskId,
                    "status": targetColumn.dataset.status
                };
            } else {
                result = {};
            }

            return ImmutabilityService.deepFreeze(result);
        }
    }

    get apexChangeCaseStatus() {
        return (caseDesc) => {
            if (caseDesc.taskId && caseDesc.status) {
                changeCaseStatus({ "caseId": caseDesc.taskId, "status": caseDesc.status })
                    .then(result => this.toggleSpinner())
                    .catch(err => console.log(err));
            } else {
                console.log('Cannot call service. Invalid parameters');
            }

        }
    }

    get toggleSpinner() {
        return () => this.showSpinner = !this.showSpinner;
    }

    connectedCallback() {
        this.toggleSpinner();
    }

    @wire(retrieveEngagementCases)
    retrieveCases({ error, data }) {
        if (data) {
            const casesContainers = this.createCaseContainers();
            const renderTaskComposition = [
                this.mapTaskToDivElements(casesContainers),
                this.renderColumns.bind(this, casesContainers)
            ]

            renderTaskComposition.reduce(reducers.reducer, data);
            this.toggleSpinner();
        }
    }

    createCaseContainers() {
        const casesContainers = new Map();
        casesContainers.set(inProgressStatus, []);
        casesContainers.set(toDoStatus, []);
        casesContainers.set(doneSuccessStatus, []);
        casesContainers.set(doneFailureStatus, []);

        return casesContainers;
    }

    handleDrop(event) {
        const targetColumn = event.currentTarget;
        const taskId = event.dataTransfer.getData('task-id');

        if (targetColumn && taskId) {
            this.toggleSpinner()
            const dropComposition = [
                this.moveTaskBetweenColumns(targetColumn),
                this.apexChangeCaseStatus.bind(this)
            ];
            dropComposition.reduce(reducers.reducer, taskId);

        }
    }

    handleDrag(event) {
        let taskId = event.target.dataset.taskId;
        if (taskId) {
            event.dataTransfer.setData('task-id', taskId);
        }
    }

    handleDragOver(event) {
        event.preventDefault();
    }

    createTaskElement(caseTask) {
        let divReducer = (div, currentElemFunc) => {
            div.appendChild(currentElemFunc());
            return div;
        }

        let elementsFunctions = [
            this.createCaseImage,
            this.createCaseHeader.bind(null, caseTask),
            this.createCaseDescription.bind(null, caseTask),
            this.createOwnerField.bind(null, caseTask)
        ];

        return elementsFunctions.reduce(divReducer, this.createDraggableDiv(caseTask));

    }

    createDraggableDiv(caseTask) {
        const divContainer = document.createElement('div');
        divContainer.setAttribute('data-task-id', caseTask.Id);
        divContainer.setAttribute('class', 'task-element');
        divContainer.setAttribute('draggable', true);
        divContainer.ondragstart = this.handleDrag;

        return divContainer;
    }

    createCaseImage() {
        const imgSrc = document.createElement('img');
        imgSrc.setAttribute('src', caseIconUrl);

        return imgSrc;
    }

    createCaseHeader(caseTask) {
        const header = document.createElement('h2');
        header.textContent = caseTask.Subject;

        return header;
    }

    createCaseDescription(caseTask) {
        const description = document.createElement('div');
        description.textContent = caseTask.Description;
        return description;
    }

    createOwnerField(caseTask) {
        const owner = document.createElement('div')
        const labelDiv = document.createElement('div');
        labelDiv.setAttribute('style', 'float:left');
        labelDiv.textContent = 'Owner:';

        const ownerNameDiv = document.createElement('div');
        ownerNameDiv.setAttribute('data-owner', true);
        ownerNameDiv.setAttribute('style', 'float:right');
        ownerNameDiv.textContent = caseTask.Owner.Name;

        owner.appendChild(labelDiv);
        owner.appendChild(ownerNameDiv);

        return owner;
    }
}