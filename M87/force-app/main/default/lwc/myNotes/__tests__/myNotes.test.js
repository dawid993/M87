import { createElement } from 'lwc';
import MyNotes from 'c/myNotes';

import { createElementAndAddToDocument, htmlTestUtils } from 'c/testUtility';
import { selectElement } from 'c/inputs';

const ELEMENT_NAME = 'c-my-notes';

const createNoteElement = () => {
    return createElementAndAddToDocument(ELEMENT_NAME, document, MyNotes, createElement);
}

describe('c-my-notes', () => {
    afterEach(() => {
        htmlTestUtils.clearDocument(document);
    });

    it('should set and return header', () => {
        const element = createElement('c-my-notes', {
            is: MyNotes
        });

        const testHeader = 'My test header';
        element.notesHeader = testHeader;

        document.body.appendChild(element);

        expect(element.notesHeader).toMatch(testHeader);
    });

    it('should render lightning card with header', () => {
        const element = createElement('c-my-notes', {
            is: MyNotes
        });

        const testHeader = 'My test header';
        element.notesHeader = testHeader;

        document.body.appendChild(element);
        const lightningCard = selectElement(element, 'lightning-card');
        expect(lightningCard.title).toMatch(testHeader);
    });

    it('should render table and new note tabs', () => {
        const element = createNoteElement();
        const testHeader = 'My test header';
        element.notesHeader = testHeader;  

        const tableTab = selectElement(element, 'lightning-tab[data-tab-id="note-table"]');
        expect(tableTab).toBeTruthy();

        const tableElement = selectElement(element, 'c-my-notes-table');
        expect(tableElement).toBeTruthy();

        const addNoteElement = selectElement(element,'lightning-tab[data-tab-id="new-note"]');
        expect(addNoteElement).toBeTruthy();
    });
});