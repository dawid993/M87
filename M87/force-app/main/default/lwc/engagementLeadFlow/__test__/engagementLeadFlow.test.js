import { createElement } from 'lwc';
import { clearDocument, createElementAndAddToDocument, flushPromises, dispatchEvent } from 'c/testUtility';
import engagementLeadFlow from 'c/engagementLeadFlow';

const evaluationEventName = 'evaluation';
const revertEventName = 'revertstep';

function stepDataDetail(detail){
    return {
        stepData : detail
    }
}

describe('c-engagement-lead-flow', () => {
    afterEach(() => {
        clearDocument(document);
    });

    it('should render lead details step', () => {
        const element =
            createElementAndAddToDocument('c-engagement-lead-flow', document, engagementLeadFlow, createElement);
        const leadDetails = element.shadowRoot.querySelector('c-lead-details');
        expect(leadDetails).toBeTruthy();

    });

    it('should continue to community user creation step', () => {
        const element =
            createElementAndAddToDocument('c-engagement-lead-flow', document, engagementLeadFlow, createElement);
        const leadDetails = element.shadowRoot.querySelector('c-lead-details');
        leadDetails.dispatchEvent(new CustomEvent('evaluation', {
            detail: {
                stepData: { testParam: 'testValue' }
            }
        }));

        return flushPromises().then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-create-community-user-decision');
            expect(communityUserCreation).toBeTruthy();
        });
    });

    it('should revert to lead details step', () => {
        const element =
            createElementAndAddToDocument('c-engagement-lead-flow', document, engagementLeadFlow, createElement);
        let leadDetails = element.shadowRoot.querySelector('c-lead-details');
        leadDetails.dispatchEvent(new CustomEvent('evaluation', {
            detail: {
                stepData: { testParam: 'testValue' }
            }
        }));

        return flushPromises().then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-create-community-user-decision');
            communityUserCreation.dispatchEvent(new CustomEvent('revertstep'));
            return flushPromises();
        }).then(() => {
            leadDetails = element.shadowRoot.querySelector('c-lead-details');
            expect(leadDetails).toBeTruthy();
        });
    });

    it('should continue to review and confirm when community user decision is no', () => {
        const element =
            createElementAndAddToDocument('c-engagement-lead-flow', document, engagementLeadFlow, createElement);

        let leadDetails = element.shadowRoot.querySelector('c-lead-details');
        dispatchEvent(evaluationEventName,stepDataDetail({}),leadDetails);
        

        return flushPromises().then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-create-community-user-decision');
            dispatchEvent(evaluationEventName,stepDataDetail(false),communityUserCreation);
            return flushPromises();            
        }).then(() => {
            const reviewAndConfirm = element.shadowRoot.querySelector('c-engagement-review-and-confirm');
            const createCommunityUser = element.shadowRoot.querySelector('c-community-user-creation');           
            expect(reviewAndConfirm).toBeTruthy();
            expect(createCommunityUser).toBeFalsy();
            dispatchEvent(revertEventName,null,reviewAndConfirm);
            return flushPromises();
        }).then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-create-community-user-decision');
            expect(communityUserCreation).toBeTruthy();
        });     
    });

    it('should continue to community user creation when community user decision is yes', () => {
        const element =
            createElementAndAddToDocument('c-engagement-lead-flow', document, engagementLeadFlow, createElement);

        let leadDetails = element.shadowRoot.querySelector('c-lead-details');
        dispatchEvent(evaluationEventName,stepDataDetail({}),leadDetails);
        

        return flushPromises().then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-create-community-user-decision');
            dispatchEvent(evaluationEventName,stepDataDetail(true),communityUserCreation);
            return flushPromises();            
        }).then(() => {
            const reviewAndConfirm = element.shadowRoot.querySelector('c-engagement-review-and-confirm');
            const createCommunityUser = element.shadowRoot.querySelector('c-community-user-creation');           
            expect(reviewAndConfirm).toBeFalsy();
            expect(createCommunityUser).toBeTruthy();
            dispatchEvent(evaluationEventName,stepDataDetail({}),createCommunityUser);
            return flushPromises();
        }).then(() => {
            const reviewAndConfirm = element.shadowRoot.querySelector('c-engagement-review-and-confirm');
            expect(reviewAndConfirm).toBeTruthy();
            dispatchEvent(revertEventName,null,reviewAndConfirm);
            return flushPromises();
        }).then(() => {
            const createCommunityUser = element.shadowRoot.querySelector('c-community-user-creation');  
            expect(createCommunityUser).toBeTruthy();
        });     
    });
});