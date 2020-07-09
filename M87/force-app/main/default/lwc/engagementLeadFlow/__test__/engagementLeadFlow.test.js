import { createElement } from 'lwc';
import { clearDocument, createElementAndAddToDocument, flushPromises } from 'c/testUtility';
import engagementLeadFlow from 'c/engagementLeadFlow';

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
                stepData : { testParam : 'testValue'}
            }
        }));
        
        return flushPromises().then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-community-user-creation');
            expect(communityUserCreation).toBeTruthy();
        });
    });

    it('should revert to lead details step', () => {
        const element = 
            createElementAndAddToDocument('c-engagement-lead-flow', document, engagementLeadFlow, createElement);
        let leadDetails = element.shadowRoot.querySelector('c-lead-details');
        leadDetails.dispatchEvent(new CustomEvent('evaluation', {
            detail: {
                stepData : {testParam : 'testValue'}
            }
        }));
        
        return flushPromises().then(() => {
            const communityUserCreation = element.shadowRoot.querySelector('c-community-user-creation');           
            communityUserCreation.dispatchEvent(new CustomEvent('revertstep'));
            return flushPromises();
        }).then(() => {
            leadDetails = element.shadowRoot.querySelector('c-lead-details');
            expect(leadDetails).toBeTruthy();
        });
    });
});