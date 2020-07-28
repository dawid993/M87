import { createElement } from 'lwc';
import manualFileUpload from 'c/manualFileUpload';
import { clearDocument, createElementAndAddToDocument, flushPromises } from 'c/testUtility';

function createFileMockAndAssignToElement(name,type,size,element){
    const fileList = [];
    fileList[0] = new File(
        [new ArrayBuffer(size)],
        name,
        {type : type}
    );

    Object.defineProperty(element,'files',{value : fileList});
}

describe('c-manual-file-upload',() => {
    afterEach(() => {
        clearDocument(document);
    });

    it('should perform file upload sucesfully', () => {  
        const manualUpload = createElementAndAddToDocument('c-manual-file-upload', document, manualFileUpload,
            createElement);
        const htmlInputFile = manualUpload.shadowRoot.querySelector("input[type='file']");
        expect(htmlInputFile).toBeTruthy();
        createFileMockAndAssignToElement('test.png','image/png',1000,htmlInputFile);        
        htmlInputFile.dispatchEvent(new CustomEvent('change'));      
        
        return manualUpload.getFileAsBase64().then((result) => {
            expect(result).toBeTruthy();            
        });  
    });

    it('should reject file upload because of length', () => {
        expect.assertions(2);
        const manualUpload = createElementAndAddToDocument('c-manual-file-upload', document, manualFileUpload,
            createElement);

        const htmlInputFile = manualUpload.shadowRoot.querySelector("input[type='file']");
        expect(htmlInputFile).toBeTruthy();
        createFileMockAndAssignToElement('test.png','image/png',3000000,htmlInputFile);        
        htmlInputFile.dispatchEvent(new CustomEvent('change'));      
        
        return manualUpload.getFileAsBase64().catch((err) => {            
            expect(err.message).toMatch('File is invalid or not loaded.');            
        });  
    });

    it('should reject file upload because of type', () => {
        expect.assertions(2);
        const manualUpload = createElementAndAddToDocument('c-manual-file-upload', document, manualFileUpload,
            createElement);

        const htmlInputFile = manualUpload.shadowRoot.querySelector("input[type='file']");
        expect(htmlInputFile).toBeTruthy();
        createFileMockAndAssignToElement('test.png','application/json',10000,htmlInputFile);        
        htmlInputFile.dispatchEvent(new CustomEvent('change'));      
        
        return manualUpload.getFileAsBase64().catch((err) => {            
            expect(err.message).toMatch('File is invalid or not loaded.');            
        });  
    });
});