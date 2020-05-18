import { LightningElement, track, api } from 'lwc';
import retrieveEngagementCases from '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases';
import changeCaseStatus from '@salesforce/apex/EngagementKanbanController.changeCaseStatus';
import ImmutabilityService from "c/immutabilityService";
import DomElementsUtils from 'c/domElementsUtils';

const caseIconUrl = '/resource/Case_Icon';
const customIconUrl = '/resource/Custom_Icon';

const inProgressStatus = 'In Progress';
const toDoStatus = 'To Do';
const doneSuccessStatus = 'Done - success';
const doneFailureStatus = 'Done - failure';

export default class EngagementKanbanBoard extends LightningElement {

    @track
    showSpinner = false

    purgeAllColumns() {
        this.template.querySelectorAll('.kanban-column [data-status]').forEach(DomElementsUtils.removeAllChild);
    }

    mapTaskToDivElements(casesContainers = new Map(), casesTasks = []) {
        casesTasks.forEach((caseElement) => {
            if (casesContainers.has(caseElement.Status)) {
                casesContainers.get(caseElement.Status).push(this.createTaskElement(caseElement))
            }
        });

        return ImmutabilityService.deepFreeze(casesContainers);
    }

    renderColumns(casesContainers = new Map()) {
        casesContainers.forEach((cases, key) => {
            let column = this.template.querySelector(`[data-status='${key}']`);
            if (column) {
                cases.forEach(caseDiv => {
                    column.appendChild(caseDiv)
                })
            }
        });
    }

    moveTaskBetweenColumns(targetColumn, taskId) {
        let result;
        if (targetColumn && taskId) {
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

    apexChangeCaseStatus(caseDesc) {
        if (caseDesc.taskId && caseDesc.status) {
            changeCaseStatus({ "caseId": caseDesc.taskId, "status": caseDesc.status })
                .then(result => this.toggleSpinner())
                .catch(err => console.log(err));
        } else {
            console.log('Cannot call service. Invalid parameters');
        }
    }

    toggleSpinner() {
        this.showSpinner = !this.showSpinner;
    }

    @api
    applySearchOptions(searchOptions) {
        this.toggleSpinner();
        retrieveEngagementCases({ 'searchOptions': JSON.stringify(searchOptions) })
            .then(response => {
                this.processEngagementCasesResponse(response.detailedResult)
            });
    }


    processEngagementCasesResponse(response) {
        if (response) {
            const casesContainers = this.createCaseContainers();
            this.purgeAllColumns();
            this.mapTaskToDivElements(casesContainers, response);
            this.renderColumns(casesContainers);
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
            this.toggleSpinner();
            const targetTask = this.moveTaskBetweenColumns(targetColumn, taskId);
            this.apexChangeCaseStatus(targetTask);
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
        const elementsFunctions = [
            this.createTaskElementHeader.bind(this, caseTask),
            this.createCaseDescription.bind(null, caseTask),
            this.createFooterSection.bind(this, caseTask)
        ];
        
        return elementsFunctions.reduce(DomElementsUtils.divReduceAppend, this.createDraggableDiv(caseTask));
    }

    createDraggableDiv(caseTask) {
        const divContainer = document.createElement('div');
        divContainer.setAttribute('data-task-id', caseTask.Id);
        divContainer.setAttribute('data-task-status', caseTask.Status);
        divContainer.setAttribute('class', 'task-element');
        divContainer.setAttribute('draggable', true);
        divContainer.ondragstart = this.handleDrag;

        return divContainer;
    }

    createTaskElementHeader(caseTask) {
        const taskElementHeaderFunctions = [
            this.createCaseImage.bind(this),
            this.createCaseHeader.bind(this,caseTask),
            this.createOptionIcon.bind(this)
        ];

        const container = document.createElement('div');
        container.classList.add('task-header-container');
        return taskElementHeaderFunctions.reduce(DomElementsUtils.divReduceAppend,container);        
    }

    createCaseImage() {
        const imgSrc = document.createElement('img');
        imgSrc.setAttribute('src', caseIconUrl);
        imgSrc.classList.add('case-icon');

        return imgSrc;
    }

    createCaseHeader(caseTask) {
        const header = document.createElement('h2');
        header.textContent = caseTask.Subject;

        return header;
    }

    createOptionIcon() {
        const optionContainer = document.createElement('div');
        optionContainer.classList.add('option-container');
        const optionIcon = document.createElement('img');
        const optionBox = this.createOptionBox();

        optionIcon.setAttribute('src', customIconUrl);
        optionIcon.classList.add('option-icon');
        optionContainer.appendChild(optionIcon);
        optionContainer.appendChild(optionBox);

        optionContainer.onmouseover = this.onOptionContainerHover.bind(this);

        return optionContainer;
    }

    createOptionBox() {
        const optionBox = document.createElement('div');
        optionBox.classList.add('option-box');
        return optionBox;
    }

    createCaseDescription(caseTask) {
        const description = document.createElement('div');
        description.setAttribute('class', 'description');
        description.textContent = caseTask.Description;
        return description;
    }

    createFooterSection(caseTask) {
        const footer = document.createElement('div')
        footer.classList.add('footer-container');
        footer.appendChild(this.createFooterElement('Owner', caseTask.Owner.Name));
        footer.appendChild(this.createFooterElement('Priority', caseTask.Priority));

        return footer;
    }

    createFooterElement(label, content) {
        const footerElement = document.createElement('div')
        footerElement.classList.add('footer-element');
        const labelDiv = document.createElement('div');
        labelDiv.textContent = label;
        const valueDiv = document.createElement('div');
        valueDiv.textContent = content;

        footerElement.appendChild(labelDiv);
        footerElement.appendChild(valueDiv);

        return footerElement;
    }

    onOptionContainerHover(event) {
        if (event.currentTarget) {
            const taskElement = event.currentTarget.closest('.task-element');
            const optionBox = event.currentTarget.querySelector('.option-box');
            const ulElement = event.currentTarget.querySelector('.option-box ul');

            if (!ulElement) {
                const options = document.createElement('ul');
                options.appendChild(this.createCaseViewOption(taskElement.dataset.taskId));
                options.appendChild(this.createInvokeFlowOption(taskElement.dataset.taskId));
                optionBox.appendChild(options);
            }
        }
    }

    createCaseViewOption(taskId) {
        const caseViewOption = document.createElement('li');
        caseViewOption.textContent = 'View Case';
        caseViewOption.onclick = this.fireViewCaseEvent.bind(this, taskId);
        return caseViewOption;
    }

    createInvokeFlowOption(taskId) {
        const invokeFlowOption = document.createElement('li');
        invokeFlowOption.textContent = 'Invoke Flow';
        invokeFlowOption.setAttribute('data-task-id', taskId);
        invokeFlowOption.onclick = this.fireInvokeCaseFlowEvent.bind(this, taskId);

        return invokeFlowOption;
    }

    fireViewCaseEvent(taskId) {
        console.log('fireViewCaseEvent', taskId);
        if (taskId) {
            this.dispatchEvent(new CustomEvent('viewtask', {
                bubbles: true,
                detail: {
                    'taskId': taskId
                }
            }));
        }
    }

    fireInvokeCaseFlowEvent(taskId) {
        if (taskId) {
            this.dispatchEvent(new CustomEvent('invokeflow', {
                bubbles: true,
                detail: {
                    'taskId': taskId
                }
            }));
        }
    }
}