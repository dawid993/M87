import { LightningElement, api, wire, track } from 'lwc';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';
import leadIcon from '@salesforce/resourceUrl/new_lead_image';

import LEAD_OBJECT from '@salesforce/schema/Lead';
import INDUSTRY_FIELD from '@salesforce/schema/Lead.Industry';
import STATUS_FIELD from '@salesforce/schema/Lead.Status';
import RATING_FIELD from '@salesforce/schema/Lead.Rating';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import { areLightningInputsValid, showErrorMessagesForLightningInputs } from 'c/inputs';

import FlowComponentMixin from 'c/flowComponentMixin';

const leadFormFields = [
    { name: 'leadTitle', defaultValue: null },
    { name: 'leadName', defaultValue: null },
    { name: 'email', defaultValue: null },
    { name: 'phone', defaultValue: null },
    { name: 'companyName', defaultValue: null },
    { name: 'industry', defaultValue: null },
    { name: 'numberOfEmployees', defaultValue: 0 },
    { name: 'annualRevenue', defaultValue: 0 },
    { name: 'doNotCall', defaultValue: false },
    { name: 'status', defaultValue: null },
    { name: 'rating', defaultValue: null },
];

export default class LeadDetails extends FlowComponentMixin(LightningElement) {

    _leadMasterRecordTypeId;

    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    _leadObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$_leadObjectInfo.data.defaultRecordTypeId', fieldApiName: INDUSTRY_FIELD })
    _industryPicklist({ error, data }) {
        if (data) {
            this.industryPicklistOptions = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$_leadObjectInfo.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    _statusPicklist({ error, data }) {
        if (data) {
            this.statusPicklistOptions = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$_leadObjectInfo.data.defaultRecordTypeId', fieldApiName: RATING_FIELD })
    _ratingPicklist({ error, data }) {
        if (data) {
            this.ratingPicklistOptions = data.values;
        }
    }

    leadInfo;

    newLeadImageSrc;

    @track
    industryPicklistOptions;

    @track
    statusPicklistOptions;

    @track
    ratingPicklistOptions;

    @api
    set stepData(value) {
        if (value) {
            this.leadInfo = Object.assign({}, value);
        }
    }

    get stepData() {
        return Object.assign({}, this.leadInfo);
    }

    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [leadIcon, globalStyles]);
    }

    connectedCallback() {
        if (!this.leadInfo) {
            this.leadInfo = this._createDefaultLead();
        }

        this.newLeadImageSrc = leadIcon;
    }

    saveLeadDetails() {
        const inputs = this._selectAllInputsAsArray();
        if (areLightningInputsValid(inputs)) {
            this.dispatchEvaluationEvent(this.leadInfo);
        } else {
            showErrorMessagesForLightningInputs(inputs);
        }
    }

    _createDefaultLead() {
        const defaultLead = {};
        leadFormFields.forEach(field => defaultLead[field.name] = field.defaultValue);
        return defaultLead;
    }

    onFormFieldChange(event) {
        const fieldName = event.target.dataset.name;
        const value = fieldName !== 'doNotCall' ? event.target.value : event.target.checked;
        if (fieldName && this._isLeadFormField(fieldName)) {
            this.leadInfo[fieldName] = value;
        }
    }

    _isLeadFormField(fieldName) {
        return leadFormFields.find(field => field.name === fieldName);
    }

    _selectAllInputsAsArray() {
        return Array.from(this.template.querySelectorAll('lightning-input,lightning-combobox'));
    }
}