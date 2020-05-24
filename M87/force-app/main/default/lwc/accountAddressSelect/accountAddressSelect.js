import { LightningElement, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ImmutabilityService from "c/immutabilityService";

import SHIPPING_STREET from '@salesforce/schema/Account.ShippingStreet'
import SHIPPING_POSTCODE from '@salesforce/schema/Account.ShippingPostalCode'
import SHIPPING_CITY from '@salesforce/schema/Account.ShippingCity'
import SHIPPING_STATE from '@salesforce/schema/Account.ShippingState'
import BUILDING_NUMBER from '@salesforce/schema/Account.Building_Number__c'
import ADDRESS_SOURCE_ID from '@salesforce/schema/Account.AddressSourceId__c'
import ID_FIELD from '@salesforce/schema/Account.Id'

export default class AccountAddressSelect extends LightningElement {

    @api
    recordId

    saveMethod = this.saveAddress.bind(this)

    saveAddress(event){        
        const selectedAddress = event.detail.selectedAddress;       
        const recordInput = this.createSaveRecord(selectedAddress)
        updateRecord(recordInput).then(() => {                     
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account updated',
                    variant: 'success'
                })
            ).catch(err => console.log(err))
        })
    }

    createSaveRecord(address){        
        const fields = {}
        fields[SHIPPING_CITY.fieldApiName] = address.city
        fields[SHIPPING_STREET.fieldApiName] = address.street
        fields[SHIPPING_POSTCODE.fieldApiName] = address.postCode
        fields[SHIPPING_STATE.fieldApiName] = address.disctrict
        fields[BUILDING_NUMBER.fieldApiName] = address.houseNumber
        fields[ADDRESS_SOURCE_ID.fieldApiName] = address.id
        fields[ID_FIELD.fieldApiName] = this.recordId

        return ImmutabilityService.deepFreeze({fields})
    }
}