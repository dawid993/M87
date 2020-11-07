const LEAD_DETAILS_STEP = {
    id: 'LEAD_DETAIL',
    label: 'Lead details',
    order: 1,
};

const CREATE_COMMUNITY_USER_DECISION_STEP = {
    id: 'COMMUNITY_USER_DECISION_STEP',
    label: 'Create community user',
    order: 2,
};

const COMMUNITY_USER_STEP = {
    id: 'COMMUNITY_USER',
    label: 'Community user',
    order: 3,
};

const REVIEW_STEP = {
    id: 'REVIEW',
    label: 'Review',
    order: 4,
};

const STEPS_DESCRIPTION = [LEAD_DETAILS_STEP, CREATE_COMMUNITY_USER_DECISION_STEP, COMMUNITY_USER_STEP, REVIEW_STEP];

export {
    LEAD_DETAILS_STEP,
    CREATE_COMMUNITY_USER_DECISION_STEP,
    COMMUNITY_USER_STEP,
    REVIEW_STEP,
    STEPS_DESCRIPTION
}