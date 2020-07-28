import { LightningElement, api } from 'lwc';

const FILE_UPLOAD_ELEMENT_SELECTOR = "[data-id='file-upload-element']";

const ALLOWED_TYPES = [
    'image/png',
    'image/jpeg',
    'application/pdf'
];

//In Bytes
const MAX_SIZE = 2660000;

const BASE_64_SPLIT_LITERAL = 'base64,';

export default class ManualFileUpload extends LightningElement {   
    
    @api
    getFileAsBase64(){
        return this._loadFileContent();
    }

    _loadFileContent(){ 
        const fileElement = this.template.querySelector(FILE_UPLOAD_ELEMENT_SELECTOR);

        return fileElement && fileElement.files[0] && this._isFileValid(fileElement.files[0]) ?
             this._readFile(fileElement.files[0]) :        
             Promise.reject(new Error('File is invalid or not loaded.'));             
    }

    _readFile(fileBlob){        
        return new Promise((resolve,reject) => {
            const fileReader = new FileReader();
            fileReader.readAsDataURL(fileBlob);
            fileReader.onload = this._onLoadHandler.bind(this,fileReader,resolve,reject);
            fileReader.onerror = this._onErrorHandler.bind(this,fileReader,reject);
        });        
    }

    _onLoadHandler(fileReader,resolve,reject){       
        try{
            resolve(fileReader.result.split(BASE_64_SPLIT_LITERAL)[1]);
        }catch(err){
            reject(new Error(err));
        }
    }

    _onErrorHandler(fileReader,reject){        
        reject(new Error(fileReader.error));       
    }

    _isFileValid(fileBlob){
        return [
            (currentFileBlob) => currentFileBlob.size <= MAX_SIZE,
            (currentFileBlob) => ALLOWED_TYPES.find(type => type === currentFileBlob.type)
        ]
        .reduce((isValid, currentCondition) => isValid && currentCondition(fileBlob),true);        
    }
}