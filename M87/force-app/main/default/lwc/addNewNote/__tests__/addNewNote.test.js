import { createElement } from 'lwc';
import AddNewNote from 'c/addNewNote';
import { createElementAndAddToDocument, htmlTestUtils, jestUtils } from 'c/testUtility';
import { selectElement } from 'c/inputs';
import {ShowToastEventName} from 'lightning/platformShowToastEvent';


const ELEMENT_NAME = 'c-my-notes';

import {
    TITLE_ID,
    DUE_DATE_ID,
    CONTENT_ID
} from '../elementIds';

function mockCheckValidity(element, mockValue) {
    element.checkValidity = jest.fn(() => mockValue);
};

function mockCheckValidityForElements(elements, mockValue) {
    elements.forEach(element => element.checkValidity = jest.fn(() => mockValue));
};

function createNoteElement() {
    return createElementAndAddToDocument(ELEMENT_NAME, document, AddNewNote, createElement);
}

describe('c-add-new-note', () => {
    afterEach(() => {
        htmlTestUtils.clearDocument(document);
    });

    it('should fire toast event when fields invalid', () => {
        expect.assertions(1);
        let eventFired = false;       
        const element = createNoteElement();
        element.addEventListener('lightning__showtoast',(event) => {
            eventFired = true;
        });

        const titleElement = selectElement(element, TITLE_ID);
        const dueDateElement = selectElement(element, DUE_DATE_ID);
        const contentElement = selectElement(element, CONTENT_ID);

        mockCheckValidityForElements([
            titleElement,
            dueDateElement,
            contentElement
        ], false);
       
        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);         
        });        
    });
});