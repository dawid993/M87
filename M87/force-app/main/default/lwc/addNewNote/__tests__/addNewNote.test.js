import { createElement } from 'lwc';
import AddNewNote from 'c/addNewNote';
import { createElementAndAddToDocument, htmlTestUtils, jestUtils, SHOW_TOAST_EVENT_NAME } from 'c/testUtility';
import { selectElement } from 'c/inputs';

import saveSingleNote from '@salesforce/apex/MyNotesController.saveSingleNote';

import {
    TITLE_ID,
    DUE_DATE_ID,
    CONTENT_ID
} from '../elementIds';

jest.mock(
    '@salesforce/apex/MyNotesController.saveSingleNote',
    () => ({ default: jest.fn() }),
    { virtual: true }
);

const ELEMENT_NAME = 'c-my-notes';

const SUCCESS_RESPONSE = Promise.resolve({ success: true });
const FAIL_RESPONSE = Promise.resolve({ success: false });

function createNoteElement() {
    return createElementAndAddToDocument(ELEMENT_NAME, document, AddNewNote, createElement);
}

function buildNoteObject(title, dueDate, content) {
    return [{
        newNote: {
            title,
            dueDate,
            content,
        }
    }];
}

function setupTest(element, areInputsValid) {
    const titleElement = selectElement(element, TITLE_ID);
    const dueDateElement = selectElement(element, DUE_DATE_ID);
    const contentElement = selectElement(element, CONTENT_ID);

    titleElement.value = 'Title test';
    dueDateElement.value = Date.now();
    contentElement.value = 'Content test';

    jestUtils.mockCheckValidityForElements(
        [
            titleElement,
            dueDateElement,
            contentElement,
        ],
        jest.fn(() => areInputsValid)
    );
}

function buildNoteObjectFromInputs(element) {
    return buildNoteObject(
        selectElement(element, TITLE_ID).value,
        selectElement(element, DUE_DATE_ID).value,
        selectElement(element, CONTENT_ID).value
    );
}

describe('c-add-new-note', () => {
    afterEach(() => {
        htmlTestUtils.clearDocument(document);
        jest.clearAllMocks();
    });

    it('should fire toast event when fields invalid', () => {
        expect.assertions(2);

        const element = createNoteElement();
        setupTest(element, false);

        let eventFired = false;
        element.addEventListener(SHOW_TOAST_EVENT_NAME, () => {
            eventFired = true;
        });

        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);
            expect(saveSingleNote).toHaveBeenCalledTimes(0);
        });
    });

    it('should fire success save action and toast event when fields valid', () => {
        expect.assertions(4);
        saveSingleNote.mockResolvedValue({ success: true })

        const element = createNoteElement();
        setupTest(element, true);

        let eventFired = false;
        element.addEventListener(SHOW_TOAST_EVENT_NAME, () => {
            eventFired = true;
        });

        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);
            expect(saveSingleNote).toHaveBeenCalledTimes(1);
            expect(saveSingleNote.mock.results[0].value).toEqual(SUCCESS_RESPONSE);
            expect(saveSingleNote.mock.calls[0]).toEqual(
                buildNoteObjectFromInputs(element)
            );
        });
    });

    it('should fire fail save action and toast event when fields valid', () => {
        expect.assertions(4);
        saveSingleNote.mockResolvedValue({ success: false })

        const element = createNoteElement();
        setupTest(element, true);

        let eventFired = false;
        element.addEventListener(SHOW_TOAST_EVENT_NAME, () => {
            eventFired = true;
        });

        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);
            expect(saveSingleNote).toHaveBeenCalledTimes(1);
            expect(saveSingleNote.mock.results[0].value).toEqual(FAIL_RESPONSE);
            expect(saveSingleNote.mock.calls[0]).toEqual(
                buildNoteObjectFromInputs(element)
            );
        });
    });

    it('should not fire save action and should fire toast event when only title invalid', () => {
        expect.assertions(2);
        saveSingleNote.mockResolvedValue({ success: false })

        const element = createNoteElement();
        setupTest(element, true);
        jestUtils.mockCheckValidityForElement(selectElement(element, TITLE_ID), jest.fn(() => false));

        let eventFired = false;
        element.addEventListener(SHOW_TOAST_EVENT_NAME, () => {
            eventFired = true;
        });

        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);
            expect(saveSingleNote).toHaveBeenCalledTimes(0);
        });
    });

    it('should not fire save action and should fire toast event when only due date invalid', () => {
        expect.assertions(2);
        saveSingleNote.mockResolvedValue({ success: false })

        const element = createNoteElement();
        setupTest(element, true);
        jestUtils.mockCheckValidityForElement(selectElement(element, DUE_DATE_ID), jest.fn(() => false));

        let eventFired = false;
        element.addEventListener(SHOW_TOAST_EVENT_NAME, () => {
            eventFired = true;
        });

        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);
            expect(saveSingleNote).toHaveBeenCalledTimes(0);
        });
    });

    it('should not fire save action and should fire toast event when only content invalid', () => {
        expect.assertions(2);
        saveSingleNote.mockResolvedValue({ success: false })

        const element = createNoteElement();
        setupTest(element, true);
        jestUtils.mockCheckValidityForElement(selectElement(element, CONTENT_ID), jest.fn(() => false));

        let eventFired = false;
        element.addEventListener(SHOW_TOAST_EVENT_NAME, () => {
            eventFired = true;
        });

        element.shadowRoot.querySelector('lightning-button').click();
        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(true);
            expect(saveSingleNote).toHaveBeenCalledTimes(0);
        });
    });
});