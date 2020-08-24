import { LightningElement, track, api } from 'lwc';
import retrieveEngagementCases from '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases';
import changeCaseStatus from '@salesforce/apex/EngagementKanbanController.changeCaseStatus';
import DomElementsUtils from 'c/domElementsUtils';
import KanbanBoardElementCreator from 'c/kanbanBoardElementCreator'

const caseIconUrl = '/resource/Case_Icon';
const customIconUrl = '/resource/Custom_Icon';

const viewTaskPublicEventName = 'viewtask_pub_comp';
const invokeFlowPublicEventName = 'invokeflow_pub_comp';

const casesStatuses = [
    'In Progress',
    'To Do',
    'Done - success',
    'Done - failure',
];

const kanbanColumnSelector = '.kanban-column .kanban-column-drop';

export default class EngagementKanbanBoard extends LightningElement {

    @track
    showSpinner = false;

    _elementCreator;

    connectedCallback() {
        this._elementCreator = new KanbanBoardElementCreator(
            caseIconUrl,
            customIconUrl,
            this.handleDrag,
            this._fireViewCaseEventComposition(this),
            this._fireInvokeCaseFlowEventComposition(this)
        );
    }

    _fireViewCaseEventComposition = (sourceComponent) => (taskId) => () => {
        if (!taskId) return;
        sourceComponent.dispatchEvent(new CustomEvent(viewTaskPublicEventName, {
            bubbles: true,
            composed: true,
            detail: {
                'taskId': taskId
            }
        }));
    }

    _fireInvokeCaseFlowEventComposition = (sourceComponent) => (taskId) => () => {
        if (!taskId) return
        sourceComponent.dispatchEvent(new CustomEvent(invokeFlowPublicEventName, {
            bubbles: true,
            composed: true,
            detail: {
                'taskId': taskId
            }
        }));
    }

    @api
    applySearchOptions(searchOptions) {
        const searchParameter = { 'searchOptions': JSON.stringify(searchOptions) };
        return Promise.resolve()
            .then(() => this._toggleSpinner())
            .then(() => this._purgeAllColumns())
            .then(() => retrieveEngagementCases(searchParameter))
            .then(result => this._mapTaskToDivElements(result.detailedResult))
            .then(result => this._renderColumns(result))
            .then(() => this._toggleSpinner())
            .catch(err => console.log(err));
    }

    handleDrop(event) {
        const targetColumn = event.currentTarget;
        const taskId = event.dataTransfer.getData('task-id');
        if (targetColumn && taskId) {
            return Promise.resolve()
                .then(() => this._toggleSpinner())
                .then(() => this._moveTaskBetweenColumns(targetColumn, taskId))
                .then((result) => changeCaseStatus({ "caseId": result.taskId, "status": result.status }))
                .then(() => this._toggleSpinner())
                .catch(err => console.log(err));
        }
    }

    handleDrag(event) {        
        event.dataTransfer.setData('task-id',  event.target.dataset.taskId);        
    }

    handleDragOver(event) {
        event.preventDefault();
    }

    _purgeAllColumns() {
        this.template.querySelectorAll(kanbanColumnSelector).forEach(DomElementsUtils.removeAllChild);
    }

    _mapTaskToDivElements(casesTasks = []) {
        const casesContainers = this._createCaseContainers();
        casesTasks.forEach(caseElement => {
            if (casesContainers.has(caseElement.Status))
                casesContainers.get(caseElement.Status).push(this._createTaskElement(caseElement));
        });

        return casesContainers;
    }

    _renderColumns(casesContainers = new Map()) {
        casesContainers.forEach((cases, key) => {
            const column = this.template.querySelector(`[data-status='${key}']`);
            if (column) cases.forEach(caseDiv => column.appendChild(caseDiv));
        });
    }

    _moveTaskBetweenColumns(targetColumn, taskId) {
        let result = {};
        const createResult = () => ({
            "taskId": taskId,
            "status": targetColumn.dataset.status
        });

        if (targetColumn && taskId) {
            targetColumn.appendChild(this.template.querySelector("[data-task-id='" + taskId + "']"));
            result = createResult();
        }

        return result;
    }   

    _toggleSpinner() {
        this.showSpinner = !this.showSpinner;
    }

    _createCaseContainers() {
        const casesContainers = new Map();
        casesStatuses.forEach(status => casesContainers.set(status, []));

        return casesContainers;
    }

    _createTaskElement(caseTask) {
        return this._elementCreator.createTaskElement(caseTask);
    }
}