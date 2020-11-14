import { createElement } from 'lwc';
import { clearDocument, createElementAndAddToDocument, jestUtils } from 'c/testUtility';
import leadDetails from 'c/leadDetails';
import { CONTINUE_FLOW_EVENT_NAME, EVALUATION_EVENT_NAME } from 'c/flowsUtils'
import { selectElements, selectElement } from 'c/inputs';


import { registerLdsTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

const mockGetObjectInfo = require('./data/objectInfo.json');
const mockGetPicklistValues = require('./data/picklistValues.json')
const getObjectInfoAdapter = registerLdsTestWireAdapter(getObjectInfo);
const getPicklistValuesAdapter = registerLdsTestWireAdapter(getPicklistValues);

describe('c-lead-details', () => {
    afterEach(() => {
        clearDocument(document);
    });
    it('should render form fields', () => {
        const leadDetailsElement = createElementAndAddToDocument('c-lead-details', document, leadDetails, createElement);
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="leadTitle"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="leadName"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="email"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="phone"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="companyName"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="numberOfEmployees"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="annualRevenue"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="doNotCall"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-input[data-name="companyName"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-combobox[data-name="industry"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-combobox[data-name="status"]')).toBeTruthy();
        expect(leadDetailsElement.shadowRoot.querySelector('lightning-combobox[data-name="rating"]')).toBeTruthy();
    });

    it('should render flow navigation', () => {
        const leadDetailsElement = createElementAndAddToDocument('c-lead-details', document, leadDetails, createElement);
        expect(leadDetailsElement.shadowRoot.querySelector('c-flow-navigation')).toBeTruthy();
    });

    /*
    * Its rather for test coverage since we cannot cross shadow dom in combobox.
    * and i dont have idea how i can make any assertion here.
    */
    it('should fire @wire adapter for getObjectInfo and getPicklistValuesAdapter', () => {
        const leadDetailsElement = createElementAndAddToDocument('c-lead-details', document, leadDetails, createElement);
        getObjectInfoAdapter.emit(mockGetObjectInfo);
        getPicklistValuesAdapter.emit(mockGetPicklistValues);
    });

    it('should fire evaluation event', () => {
        const leadDetailsElement = createElementAndAddToDocument('c-lead-details', document, leadDetails, createElement);
           
        jestUtils.mockCheckValidityForElements(
            selectElements(leadDetailsElement, 'lightning-combobox[data-name],lightning-input[data-name]'),
            jest.fn(() => true)
        );

        let eventFired = false;
        leadDetailsElement.addEventListener(EVALUATION_EVENT_NAME,() =>{
            eventFired = true;
        });
    
        const navigationElem = selectElement(leadDetailsElement,'c-flow-navigation');
        navigationElem.dispatchEvent(new CustomEvent(CONTINUE_FLOW_EVENT_NAME));
        expect(eventFired).toBe(true);
    });

    it('should invoke report validity on elements', () => {
        const leadDetailsElement = createElementAndAddToDocument('c-lead-details', document, leadDetails, createElement);
        const inputs = selectElements(leadDetailsElement, 'lightning-combobox[data-name],lightning-input[data-name]');
        jestUtils.mockCheckValidityForElements(inputs,jest.fn(() => false));

        const reportValidityMock = jest.fn();
        jestUtils.mockReportValidity(inputs,reportValidityMock);

        let eventFired = false;
        leadDetailsElement.addEventListener(EVALUATION_EVENT_NAME,() =>{
            eventFired = true;
        });
    
        const navigationElem = selectElement(leadDetailsElement,'c-flow-navigation');
        navigationElem.dispatchEvent(new CustomEvent(CONTINUE_FLOW_EVENT_NAME));
        expect(eventFired).toBe(false);
        expect(reportValidityMock.mock.calls.length).toBe(inputs.length);
    });
});