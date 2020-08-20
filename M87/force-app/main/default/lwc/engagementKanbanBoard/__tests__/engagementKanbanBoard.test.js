import { createElement } from 'lwc'
import engagementKanbanBoard from 'c/engagementKanbanBoard';
import retrieveEngagementCases from '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases';
import changeCaseStatus from '@salesforce/apex/EngagementKanbanController.changeCaseStatus';
import { flushPromises, createElementAndAddToDocument, clearDocument } from 'c/testUtility';

jest.mock(
    '@salesforce/apex/EngagementKanbanController.changeCaseStatus',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

const toDoColumnSelector = "div[data-status='To Do']";

const engagementCases = require('./data/cases.json')

const createBubbledEvent = (type, props = {}) => {
    const event = new Event(type, { bubbles: true });
    Object.assign(event, props);
    return event;
};

const getFakeDataTransfer = () => (
    {
        getData: function (param) {
            return '1'
        }
    }
);

const createDraggableDiv = () => {
    const draggableDiv = document.createElement('div');
    draggableDiv.setAttribute('draggable', true);
    return draggableDiv;
}

describe('c-engagement-kanban-board tests', () => {
    afterEach(() => clearDocument(document));

    it('has lightning card been rendered', () => {
        const engagementKanbanBoardElement = 
            createElementAndAddToDocument('c-engagement-kanban-board', document, engagementKanbanBoard, createElement);
        const engagementBoard = engagementKanbanBoardElement.shadowRoot.querySelector('lightning-card');
        expect(engagementBoard).toBeTruthy();
    });

    it('is drop event supported', () => {
        changeCaseStatus.mockResolvedValue({ success: true });
        const engagementKanbanBoardElement =
            createElementAndAddToDocument('c-engagement-kanban-board', document, engagementKanbanBoard, createElement);

        const column = engagementKanbanBoardElement.shadowRoot.querySelector(toDoColumnSelector);
        const draggableDiv = column.appendChild(createDraggableDiv());
        const dataTransfer = getFakeDataTransfer();

        column.appendChild = jest.fn();
        const dropEvent = createBubbledEvent('drop', { 'dataTransfer': dataTransfer });

        draggableDiv.dispatchEvent(dropEvent);
        expect(column.appendChild.mock.calls.length).toBe(1);

        return new Promise((resolve) => {
            expect(changeCaseStatus).toHaveBeenCalled();
            expect(changeCaseStatus.mock.calls[0][0]).toEqual({ caseId: '1', status: 'To Do' });
            resolve();
        });
    });

    it('does case retrieval work', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement =
            createElementAndAddToDocument('c-engagement-kanban-board', document, engagementKanbanBoard, createElement);    
        engagementKanbanBoardElement.applySearchOptions({});

        return flushPromises().then(() => {
            const taskId = engagementKanbanBoardElement.shadowRoot.querySelector("[data-task-id]")
                .getAttribute('data-task-id');
            expect(taskId).toBe('00000001');
        });
    });

    it('Should invoke view case event', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement = createElement('c-engagement-kanban-board', {
            is: engagementKanbanBoard
        });

        let viewCaseEventFired = false;

        engagementKanbanBoardElement.addEventListener('viewtask_pub_comp', (event) => {
            viewCaseEventFired = true;
        });

        document.body.appendChild(engagementKanbanBoardElement);
        engagementKanbanBoardElement.applySearchOptions({});

        return flushPromises().then(() => {
            const headerContainer = engagementKanbanBoardElement.shadowRoot
                .querySelector(".task-header-container .option-container");
            headerContainer.dispatchEvent(new Event('mouseover'));
            const viewCaseElement = headerContainer.querySelector('li:nth-child(1)');
            viewCaseElement.dispatchEvent(new Event('click'));
            expect(viewCaseEventFired).toBeTruthy();
        });
    });

    it('Should invoke flow event', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement = createElement('c-engagement-kanban-board', {
            is: engagementKanbanBoard
        });

        let invokeFlowEvent = false;

        engagementKanbanBoardElement.addEventListener('invokeflow_pub_comp', (event) => {
            invokeFlowEvent = true;
        });

        document.body.appendChild(engagementKanbanBoardElement);
        engagementKanbanBoardElement.applySearchOptions({});

        return flushPromises().then(() => {
            const headerContainer = engagementKanbanBoardElement.shadowRoot
                .querySelector(".task-header-container .option-container");
            headerContainer.dispatchEvent(new Event('mouseover'));
            const viewCaseElement = headerContainer.querySelector('li:nth-child(2)');
            viewCaseElement.dispatchEvent(new Event('click'));
            expect(invokeFlowEvent).toBeTruthy();
        });
    });
})