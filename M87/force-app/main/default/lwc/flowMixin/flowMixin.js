import StepDirector from 'c/stepsDirector';

const FlowMixin = (superclass) => class extends superclass {
    _stepDirector;

    _currentStep;

    _revertFunction;

    currentStepData;

    set revertFunction(func) {
        this._revertFunction = func;
    }

    get currentStepOption() {
        return this._stepDirector.currentStepNavigationOption;
    }

    constructor(steps) {
        super();
        this._stepDirector = new StepDirector(steps);
    }

    performCurrentStepAction(currentStepData) {
        this._stepDirector.performActionForCurrentStep(currentStepData);
    }

    evaluateFlowStep(event) {        
        const currentStepData = event.detail.stepData;
        if (currentStepData) {
            this.performCurrentStepAction(currentStepData);
        }
    }

    revertStep(event) { 
        const snapshotData = this._stepDirector.onStepRevertion();
        this._revertFunction(snapshotData);
        this.currentStepData = snapshotData.stepData;
        this._currentStep = snapshotData.currentStep;        
    }
}

export default FlowMixin;