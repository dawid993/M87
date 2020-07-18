import StepListener from 'c/stepListener';
import LwcImmutabilityService from 'c/immutabilityService';

const INVALID_STEPS_EXCEPTION_MESSAGE = 'Invalid format of steps.';
const NO_MORE_STEPS_EXCEPTION_MESSAGE = 'Cannot find next steps to perform.';
const NO_PREVIOUS_STEPS_EXCEPTION_MESSAGE = 'Cannot find previous steps.';
const INVALID_SKIPPED_STEPS_EXCEPTION_MESSAGE = 'Skipped steps are invalid';
const NO_SUCH_STEPS_FOR_LISTENER = 'Cannot register listener for step which doesnt exists.';

export default class StepsDirector {
    _currentStepNumber;

    _steps = [];

    _skippedSteps = new Set();

    _stepSnapshots = [];

    _stepNavigationOption = {};

    _stepListenerService;

    constructor(steps) {
        this.steps = steps;
        this._currentStepNumber = 1;
        this._stepNavigationOption = this._calculateStepNavigationOption(this._currentStepNumber);
        this._stepListenerService = new StepListener();
    }

    get steps() {
        return this._steps;
    }

    set steps(value) {
        if (!value || !Array.isArray(value)) {
            throw new Error(INVALID_STEPS_EXCEPTION_MESSAGE);
        }

        this._steps = [...value];
    }

    get skippedSteps() {
        return this._skippedSteps;
    }

    get currentStepNumber() {
        return this._currentStepNumber;
    }

    get currentStepNavigationOption() {
        return this._stepNavigationOption;
    }

    registerStepListener(stepName, stepFunction) {
        if (this._steps.find(step => step.id === stepName)) {
            this._stepListenerService.register(stepName, stepFunction);
        } else {
            throw new Error(NO_SUCH_STEPS_FOR_LISTENER);
        }
    }

    performActionForCurrentStep(stepData) {
        this.performActionForStep(this._steps[this._currentStepNumber - 1].id, stepData);
    }

    performActionForStep(stepName, stepData) {
        this._stepListenerService.onStep(stepName, stepData);
    }

    onCurrentStepContinuation(applicationState, currentStepData, skippedSteps = []) {
        this._throwExceptionIfNoMoreSteps();
        this._throwExceptionIfSkippedStepsInvalid(skippedSteps);

        this._createAndSaveCurrentStepSnapshot(applicationState,currentStepData);

        if (skippedSteps.length > 0) {
            skippedSteps.forEach(this._skippedSteps.add, this._skippedSteps);
        }

        this._currentStepNumber = this._calculateNewStep();
        this._stepNavigationOption = this._calculateStepNavigationOption(this._currentStepNumber);

        return this._currentStepNumber;
    }

    _throwExceptionIfNoMoreSteps() {
        if (this._currentStepNumber > this._steps.length) {
            throw new Error(NO_MORE_STEPS_EXCEPTION_MESSAGE);
        }
    }

    _throwExceptionIfSkippedStepsInvalid(skippedSteps) {
        if (!this._validateSkippedSteps(skippedSteps)) {
            throw new Error(INVALID_SKIPPED_STEPS_EXCEPTION_MESSAGE);
        }
    }

    _createAndSaveCurrentStepSnapshot(applicationState, currentStepData) {
        const stepSnapshot = this._createCurrentStepSnapshot(applicationState, currentStepData);
        this._stepSnapshots.push(stepSnapshot);
        return stepSnapshot;
    }

    _createCurrentStepSnapshot(currentApplicationState, currentStepData) {
        return {
            stepNumber: this._currentStepNumber,
            stepData: currentStepData,
            applicationState: currentApplicationState,
            skippedSteps: Array.from(this._skippedSteps),
            navigationOptions: this._stepNavigationOption,
        }
    }

    _validateSkippedSteps(skippedSteps) {
        if (Array.isArray(skippedSteps)) {
            const reducer = (valid, current) => valid && current > 0 && current < this._steps.length;
            let valid = skippedSteps.reduce(reducer, true);

            return valid;
        }

        return false;
    }

    _calculateStepNavigationOption(stepNumber) {
        return {
            showBack: stepNumber > 1,
            showContinue: stepNumber < this._steps.length,
            showFinish: stepNumber == this._steps.length,
        };
    }

    _calculateNewStep() {
        let nextStep = this._currentStepNumber + 1;
        while (this._skippedSteps.has(nextStep)) {
            nextStep = nextStep + 1;
        }

        return nextStep;
    }

    onStepRevertion() {
        this._throwExceptionWhenNoPreviousSteps();        
        const revertedStepsHistory = this._stepSnapshots.filter(
            snapshot => snapshot.stepNumber <= this._currentStepNumber - 1
        );
        const stepSnapshot = revertedStepsHistory.pop();
        this._currentStepNumber = stepSnapshot.stepNumber;
        this._stepSnapshots = revertedStepsHistory;
        this._skippedSteps = new Set(stepSnapshot.skippedSteps);
        this._stepNavigationOption = stepSnapshot.navigationOptions;

        return this._createRevertStepWrapper(stepSnapshot,this._currentStepNumber);
    }

    _throwExceptionWhenNoPreviousSteps(){
        if (this._currentStepNumber === 1) {
            throw new Error(NO_PREVIOUS_STEPS_EXCEPTION_MESSAGE);
        }
    }

    _calculatePreviousStep() {
        let previousStep = this._currentStepNumber - 1;
        while (this._skippedSteps.has(previousStep)) {
            previousStep = previousStep - 1;
        }

        return previousStep;
    }

    _createRevertStepWrapper(stepSnapshot,revertStepNumber){
        return {
            applicationState: stepSnapshot.applicationState,
            stepData: stepSnapshot.stepData,
            skippedSteps: stepSnapshot.skippedSteps,
            currentStep: revertStepNumber,
        };
    }

}