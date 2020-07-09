import { LightningElement,api } from 'lwc';

export default class CommunityUserCreation extends LightningElement {
    _navigationContext = {};

    @api
    set navigationContext(value) {
        this._navigationContext = value;
    }

    get navigationContext() {
        return this._navigationContext;
    }

    backToPreviousStep(event){                
        this.dispatchEvent(new CustomEvent('revertstep'));
    }
}