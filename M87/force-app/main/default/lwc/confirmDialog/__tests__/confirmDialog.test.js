import { createElement } from 'lwc';
import confirmDialog from 'c/confirmDialog';
import {clearDocument, flushPromises} from 'c/testUtility';

import {
    CONFIRM_EVENT_NAME,
    CANCEL_EVENT_NAME
} from 'c/events';

import { selectElement } from 'c/inputs';

describe('c-confirm-dialog', () => {  
    afterEach(() => {
        clearDocument(document);
    });

    it('Should render component with text', () => {
        const confirmText = 'Would you like to confirm?';
        const confirmDialogElement = createElement('c-confirm-dialog', {
            is: confirmDialog
        });
        confirmDialogElement.confirmText = confirmText;
        document.body.appendChild(confirmDialogElement);

        const textElement = selectElement(confirmDialogElement,'.dialog-text lightning-formatted-text');
        expect(textElement.value).toMatch(confirmText);
    });

    it('Should fire confirm event', () => {
        const confirmDialogElement = createElement('c-confirm-dialog', {
            is: confirmDialog
        });
        document.body.appendChild(confirmDialogElement);

        let confirmEventFired = false;
        confirmDialogElement.addEventListener(CONFIRM_EVENT_NAME, () => {
            confirmEventFired = true
        });

        const confirmButton = selectElement(confirmDialogElement,'lightning-button[data-id="confirm-button"]');        
        expect(confirmButton).toBeTruthy();
        confirmButton.click();

        return flushPromises().then(() => {
            expect(confirmEventFired).toBe(true);
        });        
    });

    it('Should fire cancel event', () => {
        const confirmDialogElement = createElement('c-confirm-dialog', {
            is: confirmDialog
        });
        document.body.appendChild(confirmDialogElement);

        let cancelEventFired = false;
        confirmDialogElement.addEventListener(CANCEL_EVENT_NAME, () => {
            cancelEventFired = true
        });

        const confirmButton = selectElement(confirmDialogElement,'lightning-button[data-id="cancel-button"]');        
        expect(confirmButton).toBeTruthy();
        confirmButton.click();

        return flushPromises().then(() => {
            expect(cancelEventFired).toBe(true);
        });        
    });
});