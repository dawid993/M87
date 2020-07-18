import StepDirector from 'c/stepsDirector';

const FlowMixin = (superclass) => class extends superclass {
    _stepDirector;    

    _currentStep;

    _revertFunction;

    _afterRevertFunction;

    _afterCurrentStepActions;   

    currentStepData;    

    get currentStepOption() {
        return this._stepDirector.currentStepNavigationOption;
    }

    get skippedSteps(){
        return this._stepDirector.skippedSteps;
    }

    get currentStepNumber(){
        return this._currentStep;
    }

    set currentStepNumber(value){
        this._currentStep = value;
    }

    constructor(steps) {
        super();
        this._stepDirector = new StepDirector(steps);
    }

    onCurrentStepContinuation(applicationState,currentStepData,skippedSteps = []){
        return this._stepDirector.onCurrentStepContinuation(applicationState,currentStepData,skippedSteps);
    }

    registerStepListener(stepName,stepFunction){
        this._stepDirector.registerStepListener(stepName,stepFunction);
    }

    performCurrentStepAction(currentStepData) {
        this._stepDirector.performActionForCurrentStep(currentStepData);
    }

    evaluateFlowStep(event) { 
        if(event.detail){
            const currentStepData = event.detail.stepData != undefined   ?  event.detail.stepData : {};        
            this.performCurrentStepAction(currentStepData); 
            this._afterCurrentStepActions();       
        }        
    }

    revertStep(event) {  
        const snapshotData = this._stepDirector.onStepRevertion();   
        this._revertFunction(snapshotData);
        this.currentStepData = snapshotData.stepData;
        this._currentStep = snapshotData.currentStep;  
        this._afterRevertFunction();      
    }

    fireUpdateNavigationBarEvent(steps,currentStep, skippedSteps = []){        
        this.dispatchEvent(new CustomEvent('navigationupdate',{
            detail : {
                'steps' : steps,
                'currentStep' : currentStep,
                'skippedSteps' : new Set(skippedSteps)
            },
            bubbles : true
        }));
    }

    registerOnRevertFunction(func){
        this._revertFunction = func;
    }

    registerOnAfterRevertFunction(func){
        this._afterRevertFunction = func;
    }

    registerOnAfterCurrentStepActions(func){
        this._afterCurrentStepActions = func; 
    }

}

export default FlowMixin;