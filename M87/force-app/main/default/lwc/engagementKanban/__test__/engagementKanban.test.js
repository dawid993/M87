import { createElement } from 'lwc';
import engagementKanban from 'c/engagementKanban';

import {flushPromises} from 'c/testUtility';

describe('c-engagement-kanban tests', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    })

    it('Has c-engagement-kanban-options rendered', () =>{
        const engagementKanbanElement = createElement('c-engagement-kanban', {
            is: engagementKanban
        })

        document.body.appendChild(engagementKanbanElement)

        let engagementOptions = engagementKanbanElement.shadowRoot.querySelector('c-engagement-kanban-options');
        expect(engagementOptions).toBeTruthy();
    });

    it('Has c-engagement-kanban-board rendered', () =>{
        const engagementKanbanElement = createElement('c-engagement-kanban', {
            is: engagementKanban
        })

        document.body.appendChild(engagementKanbanElement)

        let engagementBoard = engagementKanbanElement.shadowRoot.querySelector('c-engagement-kanban-board');
        expect(engagementBoard).toBeTruthy();
    });

    it('Should invoke kanban board search method.', () =>{
        const engagementKanbanElement = createElement('c-engagement-kanban', {
            is: engagementKanban
        })

        document.body.appendChild(engagementKanbanElement)

        const engagementOptions = engagementKanbanElement.shadowRoot.querySelector('c-engagement-kanban-options');
        const engagementBoard = engagementKanbanElement.shadowRoot.querySelector('c-engagement-kanban-board');
        engagementBoard.applySearchOptions = jest.fn((x) => {});
        engagementOptions.dispatchEvent(new CustomEvent('search',{
            detail : {searchOptions : 'status'}
        }));

        return flushPromises().then(() => {
            console.log('flushPromises');
            expect(engagementBoard.applySearchOptions).toHaveBeenCalled();
            console.log(engagementBoard.applySearchOptions.mock.calls[0])
        })
        
    });

   
})