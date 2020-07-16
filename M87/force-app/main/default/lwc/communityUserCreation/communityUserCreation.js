import { LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';

export default class CommunityUserCreation extends FlowComponentMixin(LightningElement) {  

    backToPreviousStep(event){                
        this.dispatchRevertEvent();
    }

    saveCommunityUser(event){        
        this.dispatchEvaluationEvent();
    }
}