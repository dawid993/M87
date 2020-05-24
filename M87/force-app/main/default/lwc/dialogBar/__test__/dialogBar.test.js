import { createElement } from 'lwc';
import dialogBar from 'c/dialogBar';

import {flushPromises} from 'c/testUtility';

function createDialogBar(){
    return createElement('c-dialog-bar', {
        is: dialogBar
    })
}

describe('c-dialog-bar', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('Should fire close event', () => {
        const dialogBar = createDialogBar();
        document.body.appendChild(dialogBar)

        let isEventFired = false;

        document.body.addEventListener('dialogclose', () => isEventFired = true);
        const closeIcon = dialogBar.shadowRoot.querySelector('lightning-icon');
        expect(closeIcon).toBeTruthy();
        closeIcon.click();

        expect(isEventFired).toBe(true);
    });
});