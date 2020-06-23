import { LightningElement, api } from 'lwc';

export default class FlowNavigation extends LightningElement {
    @api 
    showContinue;

    @api
    showBack;

    @api
    showFinish
    
    sendContinueEvent(event){
        this.dispatchEvent(new CustomEvent('continueflow'));
    }

    back(event){
        this.dispatchEvent(new CustomEvent('backflow'));
    }
}