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

import FlowComponentMixin from 'c/flowComponentMixin';
const leadFormFields = [
    { name: 'leadTitle', defaultValue: '' },
    { name: 'leadName', defaultValue: '' },
    { name: 'email', defaultValue: '' },
    { name: 'phone', defaultValue: '' },
    { name: 'companyName', defaultValue: '' },
    { name: 'industry', defaultValue: '' },
    { name: 'numberOfEmployees', defaultValue: 0 },
    { name: 'annualRevenue', defaultValue: 0 },
    { name: 'doNotCall', defaultValue: false },
    { name: 'status', defaultValue: '' },
    { name: 'rating', defaultValue: '' },
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
        if(value){
            this.leadInfo = Object.assign({},value);
        }
    }

    get stepData(){
        return Object.assign({},this.leadInfo);
    }

    constructor() {
        super();        
        ResourcesLoader.loadStyles(this, [leadIcon, globalStyles]);
    }

    connectedCallback() {
        if(!this.leadInfo){
            this.leadInfo = this._createDefaultLead();
        }
        
        this.newLeadImageSrc = leadIcon;
    }

    saveLeadDetails(event) {        
        this.dispatchEvaluationEvent(this.leadInfo);
    }

    _createDefaultLead() {
        const defaultLead = {};
        leadFormFields.forEach(field => defaultLead[field.name] = field.defaultValue);
        return defaultLead;
    }

    onFormFieldChange(event) {        
        const fieldName = event.target.dataset.name;
        const value = event.target.value;
        if (fieldName && value && this._isLeadFormField(fieldName)) {
            this.leadInfo[fieldName] = value;
        }
    }

    _isLeadFormField(fieldName) {
        return leadFormFields.find(field => field.name === fieldName);
    }
}