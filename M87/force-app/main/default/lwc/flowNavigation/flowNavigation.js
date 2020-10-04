import { LightningElement, api } from 'lwc';
import {CONTINUE_FLOW_EVENT_NAME, BACK_FLOW_EVENT_NAME} from 'c/flowsUtils';

export default class FlowNavigation extends LightningElement {   

    @api 
    showContinue;

    @api
    showBack;

    @api
    showFinish
    
    sendContinueEvent(event){        
        this.dispatchEvent(new CustomEvent(CONTINUE_FLOW_EVENT_NAME));
    }

    back(event){       
        this.dispatchEvent(new CustomEvent(BACK_FLOW_EVENT_NAME));
    }
}