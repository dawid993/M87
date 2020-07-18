import { LightningElement, track } from 'lwc';

const ACTIVE_STEP_CLASS = 'active';
const EXCLUDED_STEP_CLASS = 'excluded';
const INACTIVE_STEP_CLASS = '';

export default class FlowProgressViewer extends LightningElement {

    _steps = [];
    _currentStep = 0;

    get steps() {
        return this._steps;
    }

    get currentStep() {
        return this._currentStep;
    }

    updateNavigationBar(event) {
        if (event && event.detail) {
            const steps = event.detail.steps ? event.detail.steps : [];
            this._currentStep = event.detail.currentStep ? event.detail.currentStep : 0;
            const skippedSteps = event.detail.skippedSteps ? event.detail.skippedSteps : new Set();
            this._steps = this.processSteps(steps, this._currentStep,skippedSteps);
        }

    }

    processSteps(steps, currentStep, skippedSteps) {
        const uiSteps = [];
        for (let step of steps) {
            uiSteps.push({
                label: step.label,
                order: step.order,
                assignedClass: step.order === currentStep ? ACTIVE_STEP_CLASS :
                    skippedSteps.has(step.order) ? EXCLUDED_STEP_CLASS : INACTIVE_STEP_CLASS,
            })
        }

        return uiSteps;
    }
}
