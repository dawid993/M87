import communityUserCreation from 'c/communityUserCreation';
import searchForUsernameOrEmail from '@salesforce/apex/CommunityUserCreationController.searchForUsernameOrEmail';

import { createElement } from 'lwc';
import { htmlTestUtils, jestUtils, eventTestUtils } from 'c/testUtility';
import { CONTINUE_FLOW_EVENT_NAME, EVALUATION_EVENT_NAME } from 'c/flowsUtils';

import { checkIfAllInputsHaveClassAssigned } from 'c/inputs';

const apexSearchResponse_1 = require('./data/usernameAndEmailSearchResponse_1.json');
const apexSearchResponse_2 = require('./data/usernameAndEmailSearchResponse_2.json');

const firstNameFieldId = 'firstName';
const lastNameFieldId = 'lastName';
const userFieldId = 'userName';
const emailFieldId = 'email';

jest.mock(
    '@salesforce/apex/CommunityUserCreationController.searchForUsernameOrEmail',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

function createCommunityUserCreationElement() {
    return htmlTestUtils.createElementAndAddToDocument('c-community-user-creation',
        document, communityUserCreation, createElement);
}

function selectLightningInputWithFieldName(fieldName, element) {
    return element.shadowRoot.querySelector('lightning-input[data-field-name="' + fieldName + '"]');
}

function selectAllLightningInputsWithFieldNameAttribute(element) {
    return Array.from(element.shadowRoot.querySelector('lightning-input[data-field-name]'));
}

function assignValue(fieldId, value, communityUserCreationElement) {
    const field = selectLightningInputWithFieldName(fieldId, communityUserCreationElement);
    field.value = value;
    field.dispatchEvent(eventTestUtils.createBlurEvent());
}

/*
* LWC in JEST offers only empty implementation
* checkValidity : () => {}
* I dont have idea how to make it better so manually added mocked method.
* checkValidity is @api method
*/

function mockCheckValidityForElements(elements = [], withValue) {
    elements.forEach(element => element.checkValidity = jest.fn(() => withValue));
}

function selectAllLightningInputsWithFieldNameAsArray(element) {
    return Array.from(element.shadowRoot.querySelectorAll('lightning-input[data-field-name]'));
}

function mockAllLightningInputsCheckValidityWithValue(element, withValue) {
    const arr = selectAllLightningInputsWithFieldNameAsArray(element);
    mockCheckValidityForElements(arr, withValue);
}

describe('c-community-user-creation', () => {
    afterEach(() => {
        htmlTestUtils.clearDocument(document);
        searchForUsernameOrEmail.mockClear();
    });

    it('should have form inputs', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        expect(selectLightningInputWithFieldName(firstNameFieldId, communityUserCreationElement)).toBeTruthy();
        expect(selectLightningInputWithFieldName(lastNameFieldId, communityUserCreationElement)).toBeTruthy();
        expect(selectLightningInputWithFieldName(userFieldId, communityUserCreationElement)).toBeTruthy();
        expect(selectLightningInputWithFieldName(emailFieldId, communityUserCreationElement)).toBeTruthy();
    });

    it('should update first name field and save', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        mockAllLightningInputsCheckValidityWithValue(communityUserCreationElement, true);
        assignValue(firstNameFieldId, 'testValue', communityUserCreationElement);
        const navigationComponent = communityUserCreationElement.shadowRoot.querySelector('c-flow-navigation');

        let eventFired = false;
        navigationComponent.addEventListener(CONTINUE_FLOW_EVENT_NAME, () => {
            eventFired = true;
        });

        eventTestUtils.dispatchEvent(CONTINUE_FLOW_EVENT_NAME, {}, navigationComponent);

        expect(eventFired).toBe(true);
    });

    it('should not be able to submit form, all fields invalid', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        mockAllLightningInputsCheckValidityWithValue(communityUserCreationElement, false);
        searchForUsernameOrEmail.mockResolvedValue(apexSearchResponse_1);
        let eventFired = false;
        communityUserCreationElement.addEventListener(EVALUATION_EVENT_NAME, () => {
            eventFired = true;
        });

        const navigationComponent = communityUserCreationElement.shadowRoot.querySelector('c-flow-navigation');
        eventTestUtils.dispatchEvent(CONTINUE_FLOW_EVENT_NAME, {}, navigationComponent);

        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(false);
            expect(searchForUsernameOrEmail).toBeCalledTimes(0);
        });        
    });

    it('should run apex validation because email input valid', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        mockAllLightningInputsCheckValidityWithValue(communityUserCreationElement, false);
        selectLightningInputWithFieldName('email',communityUserCreationElement).checkValidity = jest.fn(() => true);

        searchForUsernameOrEmail.mockResolvedValue(apexSearchResponse_1);
        let eventFired = false;
        communityUserCreationElement.addEventListener(EVALUATION_EVENT_NAME, () => {
            eventFired = true;
        });

        const navigationComponent = communityUserCreationElement.shadowRoot.querySelector('c-flow-navigation');
        eventTestUtils.dispatchEvent(CONTINUE_FLOW_EVENT_NAME, {}, navigationComponent);

        return jestUtils.flushPromises().then(() => {
            expect(eventFired).toBe(false);
            expect(searchForUsernameOrEmail).toBeCalledTimes(1);
        });        
    });

    it('should be able to submit form, all fields valid', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        mockAllLightningInputsCheckValidityWithValue(communityUserCreationElement, true);
        searchForUsernameOrEmail.mockResolvedValue(apexSearchResponse_1);
        let eventFired = false;
        communityUserCreationElement.addEventListener(EVALUATION_EVENT_NAME, () => {
            eventFired = true;
        });

        const navigationComponent = communityUserCreationElement.shadowRoot.querySelector('c-flow-navigation');
        eventTestUtils.dispatchEvent(CONTINUE_FLOW_EVENT_NAME, {}, navigationComponent);
      
        return jestUtils.flushPromises().then(() => {            
            expect(eventFired).toBe(true);
            expect(searchForUsernameOrEmail).toBeCalledTimes(1);
        });
    });

    it('should not be able to save form, username and email unavailable', () => {
        const communityUserCreationElement = createCommunityUserCreationElement();
        mockAllLightningInputsCheckValidityWithValue(communityUserCreationElement, true);
        searchForUsernameOrEmail.mockResolvedValue(apexSearchResponse_2);

        const navigationComponent = communityUserCreationElement.shadowRoot.querySelector('c-flow-navigation');

        let eventFired = false;
        communityUserCreationElement.addEventListener(EVALUATION_EVENT_NAME, () => {
            eventFired = true;
        });

        eventTestUtils.dispatchEvent(CONTINUE_FLOW_EVENT_NAME, {}, navigationComponent);

        return jestUtils.flushPromises().then(() => {            
            expect(eventFired).toBe(false);
            expect(searchForUsernameOrEmail).toBeCalledTimes(1);
        });

    });

});