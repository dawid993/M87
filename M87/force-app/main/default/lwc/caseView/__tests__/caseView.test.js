import { createElement } from 'lwc';
import { clearDocument, createElementAndAddToDocument, flushPromises } from 'c/testUtility';
import caseView from 'c/caseView';

describe('c-case-view', () => {
    afterEach(() => {
        clearDocument(document);
    });
    it('should change mode', () => {
        const element =
            createElementAndAddToDocument('c-case-view', document, caseView, createElement);
        const actionButton = element.shadowRoot.querySelector('lightning-button-icon');
        let readCaseComponent = element.shadowRoot.querySelector('c-case-read-mode');
        let editCaseComponent = element.shadowRoot.querySelector('c-case-edit-mode');
        expect(actionButton).toBeTruthy();
        expect(readCaseComponent).toBeTruthy();
        expect(editCaseComponent).toBeFalsy();

        actionButton.click();

        return flushPromises().then(() => {
            readCaseComponent = element.shadowRoot.querySelector('c-case-read-mode');
            editCaseComponent = element.shadowRoot.querySelector('c-case-edit-mode');
            expect(readCaseComponent).toBeFalsy();
            expect(editCaseComponent).toBeTruthy();
        })

    });
});
