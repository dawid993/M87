import { LightningElement,api } from 'lwc';

const EVALUATION_EVENT_NAME = 'evaluation';
const REVERT_EVENT_NAME = 'revertstep';

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