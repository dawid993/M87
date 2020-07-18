import { LightningElement } from 'lwc';
import FlowMixin from 'c/flowMixin';

const LEAD_DETAILS_STEP = {
    id: 'LEAD_DETAIL',
    label: 'Lead details',
    order: 1,
};

const CREATE_COMMUNITY_USER_DECISION_STEP = {
    id: 'COMMUNITY_USER_DECISION_STEP',
    label: 'Create community user',
    order: 2,
}

const COMMUNITY_USER_STEP = {
    id: 'COMMUNITY_USER',
    label: 'Community user',
    order: 3,
}

const REVIEW_STEP = {
    id: 'REVIEW',
    label: 'Review',
    order: 4,
}

const STEPS_DESCRIPTION = [LEAD_DETAILS_STEP, CREATE_COMMUNITY_USER_DECISION_STEP, COMMUNITY_USER_STEP, REVIEW_STEP];

export default class EngagementLeadFlow extends FlowMixin(LightningElement) {

    _leadFlowData;

    constructor() {
        super(STEPS_DESCRIPTION);
        this._currentStep = 1;
        this._leadFlowData = {};
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
        this._leadFlowData[LEAD_DETAILS_STEP.id] = data;
        this.currentStepNumber = this.onCurrentStepContinuation(this._leadFlowData, data);
    }

    onCommunityUserCreationDecision(data) {
        this._leadFlowData[CREATE_COMMUNITY_USER_DECISION_STEP.id] = data;
        const skippedSteps = data ? [] : [COMMUNITY_USER_STEP.order];
        this.currentStepNumber = this.onCurrentStepContinuation(this._leadFlowData, data, skippedSteps);
    }

    onCommunityUserCreation(data) {
        this._leadFlowData[COMMUNITY_USER_STEP.id] = data;
        this.currentStepNumber = this.onCurrentStepContinuation(this._leadFlowData, data);
    }

    restoreFlowData(snapshot) {
        this._leadFlowData = snapshot.applicationState;
    }

    fireNavigationEventWithCurrentState() {
        this.fireUpdateNavigationBarEvent(STEPS_DESCRIPTION, this.currentStepNumber, this.skippedSteps);
    }
}