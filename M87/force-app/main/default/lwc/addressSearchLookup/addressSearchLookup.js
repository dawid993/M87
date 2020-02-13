import { LightningElement } from 'lwc';
import searchAddressLabel from '@salesforce/label/c.SearchAddress'

const searchElements = ['street','postCode','city']

export default class AddressSearchLookup extends LightningElement {
    label = {
        'searchAddressLabel' : searchAddressLabel,
    }

    searchAddresses(event){
        let searchPhrase = event.target.value        
        if(searchPhrase){
            let addressParts = searchPhrase.split(',')
            let searchStructure = this.createAddressSearchStructure(addressParts)            
        }
    }

    createAddressSearchStructure(addressParts){
        let searchStructure = {}
        searchElements.forEach((element,index) => {
            if(addressParts[index]){
                searchStructure[element] = addressParts[index]
            }
        });
        return searchStructure
    }
    
}