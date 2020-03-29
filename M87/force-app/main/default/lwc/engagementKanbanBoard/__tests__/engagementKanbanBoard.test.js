import { createElement } from 'lwc'
import { registerLdsTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import engagementKanbanBoard from 'c/engagementKanbanBoard';
import retrieveEngagementCases from '@salesforce/apex/EngagementKanbanController.retrieveEngagementCases';
import changeCaseStatus from '@salesforce/apex/EngagementKanbanController.changeCaseStatus';


jest.mock(
    '@salesforce/apex/EngagementKanbanController.changeCaseStatus',
    () => {
        return {
            default: jest.fn()
        }
    },
    { virtual: true }
);

const retrieveEngagementCasesAdapter = registerLdsTestWireAdapter(retrieveEngagementCases)
const engagementCases = require('./data/cases.json')

const createBubbledEvent = (type, props = {}) => {
    const event = new Event(type, { bubbles: true });
    Object.assign(event, props);
    return event;
};

const createDraggableDiv = () => {
    const draggableDiv = document.createElement('div');
    draggableDiv.setAttribute('draggable',true)

    return draggableDiv
}
        

describe('c-engagement-kanban-board tests', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    })

    it('has lightning card rendered', () => {
        const engagementKanbanBoardElement = createElement('c-engagement-kanban-board', {
            is: engagementKanbanBoard
        })
        document.body.appendChild(engagementKanbanBoardElement)
        const engagementBoard = engagementKanbanBoardElement.shadowRoot.querySelector('lightning-card')
        expect(engagementBoard).toBeTruthy()
    })

    it('is drop event supported', () => {       
        const engagementKanbanBoardElement = createElement('c-engagement-kanban-board', {
            is: engagementKanbanBoard
        })

        changeCaseStatus.mockResolvedValue({success : true})
        document.body.appendChild(engagementKanbanBoardElement)

        const column = engagementKanbanBoardElement.shadowRoot.querySelector("div[data-status='To Do']")        
        const draggableDiv = column.appendChild(createDraggableDiv())
        const dataTransfer = {
            getData : function(param){
                return '1'
            }
        }
        column.appendChild = jest.fn()
        const dropEvent = createBubbledEvent('drop', { 'dataTransfer': dataTransfer })

        draggableDiv.dispatchEvent(dropEvent)
        expect(column.appendChild.mock.calls.length).toBe(1)
        return new Promise((resolve) => {
            console.log(1)
            expect(changeCaseStatus).toHaveBeenCalled()
            expect(changeCaseStatus.mock.calls[0][0]).toEqual({ caseId: '1', status: 'To Do' })          
            resolve() 
        })

    })

    it('does case retrieval work', () => {
        const engagementKanbanBoardElement = createElement('c-engagement-kanban-board', {
            is: engagementKanbanBoard
        })
         
        document.body.appendChild(engagementKanbanBoardElement)

        retrieveEngagementCasesAdapter.emit(engagementCases)

        return Promise.resolve().then(() => {
            const taskId = engagementKanbanBoardElement.shadowRoot.querySelector("[data-task-id]").getAttribute('data-task-id');
            expect(taskId).toBe('00000001') 
        }); 

    })
})