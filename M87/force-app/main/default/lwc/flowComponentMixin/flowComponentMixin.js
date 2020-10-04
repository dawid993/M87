import { LightningElement,api } from 'lwc';
import { EVALUATION_EVENT_NAME,REVERT_EVENT_NAME } from 'c/flowsUtils';

const FlowComponentMixin = (superclass) => class extends superclass {
    _navigationContext = {};

    @api
    set navigationContext(value) {
        this._navigationContext = value;
    }

    get navigationContext() {
        return this._navigationContext;
    }

    dispatchEvaluationEvent(detailData){
        this.dispatchEvent(new CustomEvent(EVALUATION_EVENT_NAME, {
            detail: {
                stepData: detailData
            }
        }));
    }

    dispatchRevertEvent(){
        this.dispatchEvent(new CustomEvent(REVERT_EVENT_NAME));
    }
}

export default FlowComponentMixin;