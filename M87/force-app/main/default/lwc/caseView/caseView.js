import { LightningElement,api,wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import reloadEngagementCases from '@salesforce/messageChannel/ReloadEngagementCases__c';


const READ_MODE = "READ";
const EDIT_MODE = "EDIT";

export default class CaseView extends LightningElement {
    @api
    caseId  
    
    @wire(MessageContext)
    messageContext

    _currentMode = READ_MODE

    get isReadMode(){
        return this._currentMode === READ_MODE;
    }

    get isEditMode(){
        return this._currentMode === EDIT_MODE;
    }

    _changeMode(){        
        this._currentMode = this._currentMode === READ_MODE ? EDIT_MODE : READ_MODE;
    }

    performOnSuccessActions(event){        
        this._changeMode();
        publish(this.messageContext, reloadEngagementCases, {});
    }
}