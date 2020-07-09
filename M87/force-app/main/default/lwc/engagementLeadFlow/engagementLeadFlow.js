import { LightningElement, track, api } from 'lwc';
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
        super(STEPS_DESCRIPTION.map(stepDesc => stepDesc.id));
        this._currentStep = 1;
        this._leadFlowData = {};
        this.registerStepsListeners();
        this.revertFunction = this.restoreFlowData.bind(this);
    }

    get isLeadDetailsStep() {
        return this._currentStep === LEAD_DETAILS_STEP.order;
    }

    get isCommunityUserCreationDecision() {
        return this._currentStep === CREATE_COMMUNITY_USER_DECISION_STEP.order;
    }

    get isCommunityUserStep() {
        return this._currentStep === COMMUNITY_USER_STEP.order;
    }

    get isReviewStep() {
        return this._currentStep === REVIEW_STEP.order;
    }

    registerStepsListeners() {
        this._stepDirector.registerStepListener(LEAD_DETAILS_STEP.id, this.onLeadDetailsFinish.bind(this));
        this._stepDirector.registerStepListener(CREATE_COMMUNITY_USER_DECISION_STEP.id,this.onCommunityUserCreationDecision.bind(this));
    }

    onLeadDetailsFinish(data) {
        debugger;
        this._leadFlowData[LEAD_DETAILS_STEP.id] = data;
        this._currentStep = this._stepDirector.onCurrentStepContinuation(this._leadFlowData, data);
    }

    onCommunityUserCreationDecision(data) {
        this._leadFlowData[CREATE_COMMUNITY_USER_DECISION_STEP.id] = data;
        const skippedSteps = data ? [] : [COMMUNITY_USER_STEP.id];
        this._currentStep = this._stepDirector.onCurrentStepContinuation(this._leadFlowData, data, skippedSteps);
    }

    restoreFlowData(snapshot) {
        this._leadFlowData = snapshot.applicationState;
    }
}