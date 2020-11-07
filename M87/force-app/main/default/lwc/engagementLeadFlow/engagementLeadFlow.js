import { LightningElement } from 'lwc';
import FlowMixin from 'c/flowMixin';

import {
    LEAD_DETAILS_STEP,
    CREATE_COMMUNITY_USER_DECISION_STEP,
    COMMUNITY_USER_STEP,
    REVIEW_STEP,
    STEPS_DESCRIPTION
} from 'c/stepsDescriptors';

export default class EngagementLeadFlow extends FlowMixin(LightningElement) {

    constructor() {
        super(STEPS_DESCRIPTION);
        this._currentStep = 1;
        this.registerStepsListeners();
        this.registerOnRevertFunction(this.restoreFlowData.bind(this));
        this.registerOnAfterRevertFunction(this.fireNavigationEventWithCurrentState.bind(this));
        this.registerOnAfterCurrentStepActions(this.fireNavigationEventWithCurrentState.bind(this));
    }

    connectedCallback() {
        this.fireNavigationEventWithCurrentState();
    }

    get isLeadDetailsStep() {
        return this.currentStepNumber === LEAD_DETAILS_STEP.order;
    }

    get isCommunityUserCreationDecision() {
        return this.currentStepNumber === CREATE_COMMUNITY_USER_DECISION_STEP.order;
    }

    get isCommunityUserStep() {
        return this.currentStepNumber === COMMUNITY_USER_STEP.order;
    }

    get isReviewStep() {
        return this.currentStepNumber === REVIEW_STEP.order;
    }

    registerStepsListeners() {
        this.registerStepListener(LEAD_DETAILS_STEP.id, this.onLeadDetailsFinish.bind(this));
        this.registerStepListener(CREATE_COMMUNITY_USER_DECISION_STEP.id, this.onCommunityUserCreationDecision.bind(this));
        this.registerStepListener(COMMUNITY_USER_STEP.id, this.onCommunityUserCreation.bind(this));
    }

    onLeadDetailsFinish(data) {
        this.applicationState[LEAD_DETAILS_STEP.id] = data;
        this.currentStepNumber = this.onCurrentStepContinuation(this.applicationState, data);
    }

    onCommunityUserCreationDecision(data) {
        this.applicationState[CREATE_COMMUNITY_USER_DECISION_STEP.id] = data;
        const skippedSteps = data ? [] : [COMMUNITY_USER_STEP.order];
        this.currentStepNumber = this.onCurrentStepContinuation(this.applicationState, data, skippedSteps);
    }

    onCommunityUserCreation(data) {
        this.applicationState[COMMUNITY_USER_STEP.id] = data;
        this.currentStepNumber = this.onCurrentStepContinuation(this.applicationState, data);
    }

    restoreFlowData(snapshot) {
        this.applicationState = snapshot.applicationState;
    }

    fireNavigationEventWithCurrentState() {
        this.fireUpdateNavigationBarEvent(STEPS_DESCRIPTION, this.currentStepNumber, this.skippedSteps);
    }    
}