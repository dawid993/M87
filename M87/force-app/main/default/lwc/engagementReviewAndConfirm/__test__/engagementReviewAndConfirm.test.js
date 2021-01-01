import { createElement } from 'lwc';
import { clearDocument, jestUtils } from 'c/testUtility';

import engagementReview from 'c/engagementReviewAndConfirm';
import save from '@salesforce/apex/EngagementReviewAndConfirmController.saveLead';
import { selectElement } from 'c/inputs';
import { CONTINUE_FLOW_EVENT_NAME } from 'c/flowsUtils';
import { COMMUNITY_USER_STEP, LEAD_DETAILS_STEP } from 'c/stepsDescriptors';

import { CONFIRM_EVENT_NAME, CANCEL_EVENT_NAME } from 'c/events';

const formData = require('./data/formData.json');
const fileBase64Mock = 'YXNkYXNkYWRz';

function createSaveActionParameter(formData, fileBase64) {
    return {
        leadDTO: {
            leadDetails: formData[LEAD_DETAILS_STEP.id],
            communityUserDetails: formData[COMMUNITY_USER_STEP.id],
            fileAsBase64Blob: fileBase64
        }
    }
}

jest.mock(
    '@salesforce/apex/EngagementReviewAndConfirmController.saveLead',
    () => {
        return {
            default: jest.fn()
        }
    },
    { virtual: true }
);

describe('c-engagement-review-and-confirm', () => {
    beforeEach(() => {
        const reviewElement = createElement('c-engagement-review-and-confirm', { is: engagementReview });
        reviewElement.reviewData = formData;
        document.body.appendChild(reviewElement);
    });

    afterEach(() => {
        clearDocument(document);
        save.mockClear();
    });

    it('should pass review data to component', () => {
        const reviewElement = document.querySelector('c-engagement-review-and-confirm');
        expect(reviewElement.reviewData).toEqual(formData);
    });

    it('should invoke apex save lead action', () => {
        save.mockResolvedValueOnce({ success: true });
        const reviewElement = document.querySelector('c-engagement-review-and-confirm');
        const navigation = selectElement(reviewElement, 'c-flow-navigation');
        navigation.dispatchEvent(new CustomEvent(CONTINUE_FLOW_EVENT_NAME));
        return jestUtils.flushPromises().then(() => {
            const confirmDialog = selectElement(reviewElement, 'c-confirm-dialog');
            expect(confirmDialog).toBeTruthy();
            confirmDialog.dispatchEvent(new CustomEvent(CONFIRM_EVENT_NAME));
            return jestUtils.flushPromises();
        }).then(() => {
            expect(save.mock.calls.length).toBe(1);
            expect(save.mock.calls[0][0]).toEqual(createSaveActionParameter(formData));
        });
    });

    it('should invoke apex save lead action with file', () => {
        const reviewElement = document.querySelector('c-engagement-review-and-confirm');
        
        const fileUpload = selectElement(reviewElement, 'c-manual-file-upload');
        fileUpload.isFileLoaded = jest.fn(() => true);
        fileUpload.getFileAsBase64 = jest.fn(() => Promise.resolve(fileBase64Mock));

        const navigation = selectElement(reviewElement, 'c-flow-navigation');
        navigation.dispatchEvent(new CustomEvent(CONTINUE_FLOW_EVENT_NAME));
        return jestUtils.flushPromises().then(() => {
            const confirmDialog = selectElement(reviewElement, 'c-confirm-dialog');
            expect(confirmDialog).toBeTruthy();
            confirmDialog.dispatchEvent(new CustomEvent(CONFIRM_EVENT_NAME));
            return jestUtils.flushPromises();
        }).then(() => {
            expect(save.mock.calls.length).toBe(1);
            expect(save.mock.calls[0][0]).toEqual(createSaveActionParameter(formData,fileBase64Mock));
        });;
    });
});