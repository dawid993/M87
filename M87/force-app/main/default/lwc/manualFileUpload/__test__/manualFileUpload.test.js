import { createElement } from 'lwc';
import manualFileUpload from 'c/manualFileUpload';
import { clearDocument, createElementAndAddToDocument } from 'c/testUtility';

function createFileMockAndAssignToElement(name, type, size, element) {
    const fileList = [];
    fileList[0] = new File(
        [new ArrayBuffer(size)],
        name,
        { type: type }
    );

    Object.defineProperty(element, 'files', { value: fileList });
}

describe('c-manual-file-upload', () => {

    beforeEach(() => {
        createElementAndAddToDocument('c-manual-file-upload', document, manualFileUpload, createElement);
    });

    afterEach(() => {
        clearDocument(document);
    });

    it('should perform file upload sucesfully', () => {
        const manualUpload = document.querySelector('c-manual-file-upload');
        const htmlInputFile = manualUpload.shadowRoot.querySelector("input[type='file']");
        expect(htmlInputFile).toBeTruthy();
        createFileMockAndAssignToElement('test.png', 'image/png', 1000, htmlInputFile);
        htmlInputFile.dispatchEvent(new CustomEvent('change'));

        return manualUpload.getFileAsBase64().then((result) => {
            expect(result).toBeTruthy();
        });
    });

    it('should reject file upload because of length', () => {
        expect.assertions(2);
        const manualUpload = document.querySelector('c-manual-file-upload');

        const htmlInputFile = manualUpload.shadowRoot.querySelector("input[type='file']");
        expect(htmlInputFile).toBeTruthy();
        createFileMockAndAssignToElement('test.png', 'image/png', 3000000, htmlInputFile);
        htmlInputFile.dispatchEvent(new CustomEvent('change'));

        return manualUpload.getFileAsBase64().catch((err) => {
            expect(err.message).toMatch('File is invalid or not loaded.');
        });
    });

    it('should reject file upload because of type', () => {
        expect.assertions(2);
        const manualUpload = document.querySelector('c-manual-file-upload');

        const htmlInputFile = manualUpload.shadowRoot.querySelector("input[type='file']");
        expect(htmlInputFile).toBeTruthy();
        createFileMockAndAssignToElement('test.png', 'application/json', 10000, htmlInputFile);
        htmlInputFile.dispatchEvent(new CustomEvent('change'));

        return manualUpload.getFileAsBase64().catch((err) => {
            expect(err.message).toMatch('File is invalid or not loaded.');
        });
    });

    it('should return file is not loaded', () => {
        const manualUpload = document.querySelector('c-manual-file-upload');
        expect(manualUpload.isFileLoaded()).toBe(false);
    });
});