import { createElement } from 'lwc'
import engagementKanbanBoard from 'c/engagementKanbanBoard';
import retrieveEngagementCases from '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases';
import changeCaseStatus from '@salesforce/apex/EngagementKanbanController.changeCaseStatus';
import { htmlTestUtils, jestUtils, eventTestUtils } from 'c/testUtility';

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
const engagementCases = require('./data/cases.json');
const viewTaskEventName = 'viewtask_pub_comp';
const invokeFlowEventName = 'invokeflow_pub_comp';

const getFakeDataTransfer = () => ({
    getData: function (param) {
        return '1'
    }
}
);

describe('c-engagement-kanban-board tests', () => {
    afterEach(() => htmlTestUtils.clearDocument(document));

    it('should render lightning card', () => {
        const engagementKanbanBoardElement = htmlTestUtils.createElementAndAddToDocument('c-engagement-kanban-board',
            document, engagementKanbanBoard, createElement);
        const engagementBoard = engagementKanbanBoardElement.shadowRoot.querySelector('lightning-card');
        expect(engagementBoard).toBeTruthy();
    });

    it('should have draggable element with inner elements', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement = htmlTestUtils.createElementAndAddToDocument('c-engagement-kanban-board',
            document, engagementKanbanBoard, createElement);

        engagementKanbanBoardElement.applySearchOptions({});

        return jestUtils.flushPromises().then(() => {
            const draggableElement = engagementKanbanBoardElement.shadowRoot.querySelector('[draggable]');
            expect(draggableElement).toBeTruthy();
            expect(draggableElement.querySelector('.task-header-container')).toBeTruthy();
            expect(draggableElement.querySelector('.task-header-container')).toBeTruthy();

            const descriptionElement = draggableElement.querySelector('.description');
            expect(descriptionElement).toBeTruthy();
            expect(draggableElement.querySelector('.footer-container')).toBeTruthy();
        });
    });

    it('should move task to column and invoke apex action', () => {
        changeCaseStatus.mockResolvedValue({ success: true });
        const engagementKanbanBoardElement = htmlTestUtils.createElementAndAddToDocument('c-engagement-kanban-board',
            document, engagementKanbanBoard, createElement);

        const column = engagementKanbanBoardElement.shadowRoot.querySelector(toDoColumnSelector);
        const draggableDiv = column.appendChild(htmlTestUtils.createDraggableDiv());
        const dataTransfer = getFakeDataTransfer();

        column.appendChild = jest.fn();
        const dropEvent = eventTestUtils.createBubbledEvent('drop', { 'dataTransfer': dataTransfer });

        draggableDiv.dispatchEvent(dropEvent);

        return jestUtils.flushPromises().then(() => {
            expect(column.appendChild.mock.calls.length).toBe(1);
            expect(changeCaseStatus).toHaveBeenCalled();
            expect(changeCaseStatus.mock.calls[0][0]).toEqual({ caseId: '1', status: 'To Do' });
            expect(engagementKanbanBoardElement.shadowRoot.querySelector(toDoColumnSelector + ' > [draggable]'))
                .toBeTruthy();
        });
    });

    it('should retrieve case', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement = htmlTestUtils.createElementAndAddToDocument('c-engagement-kanban-board',
            document, engagementKanbanBoard, createElement);
        engagementKanbanBoardElement.applySearchOptions({});

        return jestUtils.flushPromises().then(() => {
            const taskId = engagementKanbanBoardElement.shadowRoot.querySelector("[data-task-id]")
                .getAttribute('data-task-id');
            expect(taskId).toBe('00000001');
        });
    });

    it('should invoke view case event', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement = htmlTestUtils.createElementAndAddToDocument('c-engagement-kanban-board',
            document, engagementKanbanBoard, createElement);

        let viewCaseEventFired = false;
        engagementKanbanBoardElement.addEventListener(viewTaskEventName, (event) => {
            viewCaseEventFired = true;
        });

        engagementKanbanBoardElement.applySearchOptions({});

        return jestUtils.flushPromises().then(() => {
            const headerContainer = engagementKanbanBoardElement.shadowRoot
                .querySelector(".task-header-container .option-container");
            headerContainer.dispatchEvent(new Event('mouseover'));
            const viewCaseElement = headerContainer.querySelector('li:nth-child(1)');
            viewCaseElement.dispatchEvent(new Event('click'));
            expect(viewCaseEventFired).toBeTruthy();
        });
    });

    it('should invoke flow event', () => {
        retrieveEngagementCases.mockResolvedValue(engagementCases);
        const engagementKanbanBoardElement = htmlTestUtils.createElementAndAddToDocument('c-engagement-kanban-board',
            document, engagementKanbanBoard, createElement);

        let invokeFlowEvent = false;
        engagementKanbanBoardElement.addEventListener(invokeFlowEventName, (event) => {
            invokeFlowEvent = true;
        });

        engagementKanbanBoardElement.applySearchOptions({});

        return jestUtils.flushPromises().then(() => {
            const headerContainer = engagementKanbanBoardElement.shadowRoot
                .querySelector(".task-header-container .option-container");
            headerContainer.dispatchEvent(new Event('mouseover'));
            const viewCaseElement = headerContainer.querySelector('li:nth-child(2)');
            viewCaseElement.dispatchEvent(new Event('click'));
            expect(invokeFlowEvent).toBeTruthy();
        });
    });
})