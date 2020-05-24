import { createElement } from 'lwc';
import kanbanOptions from 'c/engagementKanbanOptions';

const predefinedStatusesNumber = 4;
const predefinedStatuses = ['To Do', 'In Progress', 'Done - success', 'Done - failure'];

const predefinedPrioritiesNumber = 3;
const predefinedPriorities = ['Low', 'Medium', 'High'];

const predefinedOwnersNumber = 1;
const expectedPredefinedOwners = ['ALL_OWNERS_SEARCH'];

const createElementAndReturn = () => {
    const kanbanOptionsElement = createElement('c-engagement-kanban-options', {
        is: kanbanOptions
    });

    document.body.appendChild(kanbanOptionsElement);
    return kanbanOptionsElement;
}

const retrieveOptionsElements = (optionClass, kanbanOptionsElement) => {
    return kanbanOptionsElement.shadowRoot.querySelectorAll(`div[class='selected-option ${optionClass}'] lightning-pill`);
}

const flushPromises = () => {
    return new Promise(resolve => setImmediate(resolve));
}

describe('c-egagement-kanban-options test', () => {

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('has ligtning-card rendered', () => {
        const kanbanOptionsElement = createElementAndReturn();

        let lightingCardElement = kanbanOptionsElement.shadowRoot.querySelector('lightning-card');
        expect(lightingCardElement).toBeTruthy();
    });

    it('has predefined statuses options', () => {
        const kanbanOptionsElement = createElementAndReturn();
        const predefinedStatusesElements = retrieveOptionsElements('statuses', kanbanOptionsElement);
        if (predefinedStatusesElements.length != predefinedStatusesNumber) {
            fail(`Number of statuses must be ${predefinedStatusesNumber}`);
        }

        const predefinedStatusesAttrValues = Array.from(predefinedStatusesElements).map(statusElement => statusElement.dataset.id);
        expect(predefinedStatusesAttrValues.sort()).toEqual(predefinedStatuses.sort());

    });

    it('has predefined priorities options', () => {
        const kanbanOptionsElement = createElementAndReturn();
        const predefinedPrioritiesElements = retrieveOptionsElements('priorities', kanbanOptionsElement);
        if (predefinedPrioritiesElements.length != predefinedPrioritiesNumber) {
            fail(`Number of priorities must be ${predefinedPrioritiesNumber}`);
        }

        const predefinedPrioritiesAttrValues = Array.from(predefinedPrioritiesElements).map(priorityElement => priorityElement.dataset.id);
        expect(predefinedPrioritiesAttrValues.sort()).toEqual(predefinedPriorities.sort());
    });

    it('does status option remove work properly', () => {
        const kanbanOptionsElement = createElementAndReturn();
        const predefinedStatusesElements = retrieveOptionsElements('statuses', kanbanOptionsElement);
        const toDoElement = Array.from(predefinedStatusesElements).find(statusElement => statusElement.dataset.id === 'To Do');
        if (!toDoElement) {
            fail("Cannot find 'To Do' element");
        }

        toDoElement.dispatchEvent(new CustomEvent('remove', {
            bubles: true
        }));

        return flushPromises().then(() => {
            const predefinedStatusesElementsAfterDelete = retrieveOptionsElements('statuses', kanbanOptionsElement);
            expect(predefinedStatusesElementsAfterDelete.length).toBe(predefinedStatusesNumber - 1);
            const restStatusesElements = Array.from(predefinedStatusesElementsAfterDelete).map(statusElement => statusElement.dataset.id);
            expect(restStatusesElements.sort()).toEqual(['Done - failure','Done - success','In Progress']);
        });
    });

    it('does priority status option remove work properly', () => {
        const kanbanOptionsElement = createElementAndReturn();
        const predefinedPrioritiesElements = retrieveOptionsElements('priorities', kanbanOptionsElement);
        const lowPriority = Array.from(predefinedPrioritiesElements).find(priorityElement => priorityElement.dataset.id === 'Low');
        if (!lowPriority) {
            fail("Cannot find 'Low' priority element");
        }

        lowPriority.dispatchEvent(new CustomEvent('remove', {
            bubles: true
        }));

        return flushPromises().then(() => {
            const predefinedPrioritiesElementsAfterDelete = retrieveOptionsElements('priorities', kanbanOptionsElement);
            expect(predefinedPrioritiesElementsAfterDelete.length).toBe(predefinedPrioritiesNumber - 1);
            const restPrioritiesElements = Array.from(predefinedPrioritiesElementsAfterDelete).map(priorityElement => priorityElement.dataset.id);
            expect(restPrioritiesElements.sort()).toEqual(['High', 'Medium']);
        });
    });

    it('Is event fired on connected callback',() => {
        const kanbanOptionsElement = createElement('c-engagement-kanban-options', {
            is: kanbanOptions
        });      
        const handler = jest.fn();
        window.addEventListener('search',handler);
        
        document.body.appendChild(kanbanOptionsElement);
        kanbanOptionsElement.shadowRoot.querySelector('lightning-button').click();

        return flushPromises().then(() => {
            expect(handler).toHaveBeenCalled();           
        })
    });

    it('should have predefined all option owner selected',()=>{
        const kanbanOptionsElement = createElementAndReturn();
        const predefinedOwnerOptions = retrieveOptionsElements('owners', kanbanOptionsElement);
        expect(predefinedOwnerOptions.length).toBe(predefinedOwnersNumber);
        const currentPredefinedOwners = Array.from(predefinedOwnerOptions).map(ownerElement => ownerElement.dataset.id);
            expect(currentPredefinedOwners.sort()).toEqual(expectedPredefinedOwners);

    });

    it('should show find owner popup',()=>{
        const kanbanOptionsElement = createElementAndReturn();
        const ownerCombobox = kanbanOptionsElement.shadowRoot.querySelector("lightning-combobox[data-id='owner']");
        
        if(!ownerCombobox){
            fail('Cannot find owner combobox.');
        }

        ownerCombobox.dispatchEvent( new CustomEvent('change',{
            bubbles : true,
            detail : {
                value : 'Find owner'
            }
        }));

        return flushPromises().then(() => {
            const ownerPopup = kanbanOptionsElement.shadowRoot.querySelector('.owner-search-box');
            expect(ownerPopup).toBeTruthy();
        });
    });   
});
