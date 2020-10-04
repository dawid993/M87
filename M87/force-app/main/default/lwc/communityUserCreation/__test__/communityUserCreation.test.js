import communityUserCreation from 'c/communityUserCreation';

import { createElement } from 'lwc';
import { htmlTestUtils, jestUtils, eventTestUtils } from 'c/testUtility';
import {CONTINUE_FLOW_EVENT_NAME} from 'c/flowsUtils';

const firstNameFieldId = 'firstName';
const lastNameFieldId = 'lastName';
const userFieldId = 'userName';
const emailFieldId = 'email';

function createCommunityUserCreationElement() {
    return htmlTestUtils.createElementAndAddToDocument('c-community-user-creation',
        document, communityUserCreation, createElement);
}

function selectLightningInputWithFieldName(fieldName, element) {
    return element.shadowRoot.querySelector('lightning-input[data-field-name="' + fieldName + '"]');
}

/*
* LWC in JEST offers only empty implementation
* checkValidity : () => {}
* I dont have idea how to make it better so manually added mocked method.
* checkValidity is @api method
*/

function mockCheckValidityForElements(elements = [],withValue){
    elements.forEach(element => element.checkValidity = jest.fn(() => withValue));   
}

function selectAllLightningInputsWithFieldNameAsArray(element){
    return Array.from(element.shadowRoot.querySelectorAll('lightning-input[data-field-name]'));
}

function mockAllLightningInputsCheckValidityWithValue(element,withValue){
    const arr = selectAllLightningInputsWithFieldNameAsArray(element);
    mockCheckValidityForElements(arr,withValue);
}

describe('c-community-user-creation', () => {
    afterEach(() => htmlTestUtils.clearDocument(document));

    it('should have form inputs', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        expect(selectLightningInputWithFieldName(firstNameFieldId, communityUserCreationElement)).toBeTruthy();
        expect(selectLightningInputWithFieldName(lastNameFieldId, communityUserCreationElement)).toBeTruthy();
        expect(selectLightningInputWithFieldName(userFieldId, communityUserCreationElement)).toBeTruthy();
        expect(selectLightningInputWithFieldName(emailFieldId, communityUserCreationElement)).toBeTruthy();
    });

    it('should update first name field and save', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        mockAllLightningInputsCheckValidityWithValue(communityUserCreationElement,true);
        const firstNameField = selectLightningInputWithFieldName(firstNameFieldId, communityUserCreationElement);
        firstNameField.value = 'testValue';
        firstNameField.dispatchEvent(eventTestUtils.createBlurEvent());
        const navigationComponent = communityUserCreationElement.shadowRoot.querySelector('c-flow-navigation');
        eventTestUtils.dispatchEvent(CONTINUE_FLOW_EVENT_NAME, {}, navigationComponent);
    });
});