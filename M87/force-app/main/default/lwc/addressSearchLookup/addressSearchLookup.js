/* eslint-disable no-unused-vars */
/* eslint-disable no-return-assign */
/* eslint-disable no-console */
/* eslint-disable no-new */
/* eslint-disable-next-line no-unused-vars */
import { LightningElement, track, api } from "lwc";
import searchAddressLabel from "@salesforce/label/c.SearchAddress";
import searchByPostCodeContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCode";
import searchByPostCodeOrStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCodeOrStreet";
import searchByPostCodeAndCityAndStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCodeAndCityAndStreet";
import fullSearchParametersContinuation from "@salesforce/apexContinuation/AddressSearchController.fullSearchParameters";
import ImmutabilityService from "c/immutabilityService";

import { loadScript } from 'lightning/platformResourceLoader';
import ImmutableResource from '@salesforce/resourceUrl/immutable_js'

const ENTER_KEY = 13;
const addressSeparator = ','

export default class AddressSearchLookup extends LightningElement {

    connectedCallback() {
        Promise.all([
            loadScript(this, ImmutableResource)
        ]).
        then(() => {

        })
        .catch(err => console.log(err))

    }
    label = {
        searchAddressLabel: searchAddressLabel
    }

    addressSaveMethod    

    @track
    showSearchResults = false

    @track
    searchResults = []

    @track
    selectedAddress = {}

    @track
    showSpinner = false

    @api
    get saveMethod() {
        return this.addressSaveMethod;
    }

    get splitPhrases() {
        return (separator) => (phrase) => ImmutabilityService.deepFreeze(phrase.split(separator))  
    }

    get searchAddressComposition() {
        return [
            this.splitPhrases(addressSeparator),            
            this.getSearchFunction.bind(this),
            this.runSearchWithMethod.bind(this)
        ]
        
    }

    get publishResultComposition() {
        return [
            (results) => ImmutabilityService.deepFreeze(results),
            this.mapResultsToList.bind(null),
            this.publishResults.bind(this)
        ]
    }

    get assignAddressComposition(){
        return [
           (addressId) => this.searchResults.find(element => element.id === addressId),
           ImmutabilityService.deepFreeze,
           (address) => this.selectedAddress = address
        ]
    }


    get reducer() {        
        return (parameter, currentFunction) => {            
            let returnValue = currentFunction(parameter)
            return returnValue
        }
    }

    set saveMethod(value) {
        this.addressSaveMethod = value;
    }

    searchAddresses(event) {             
        const searchPhrase = event.target.value;
        const isEnterPressed = event.which === ENTER_KEY;        
        if (searchPhrase && isEnterPressed) {            
            this.clearPreviousResultsAndHideResultPanel()            
            this.searchAddressComposition.reduce(this.reducer, searchPhrase)
        }
    }

    getSearchFunction(addressParts) {        
        let addressPartsSize = addressParts.length;
        let searchFunctions = [
            this.searchByPostCode,
            this.setSearchByPostCodeOrStreet,
            this.setSearchByPostCodeAndCityAndStreet,
            this.setFullSearchParameters
        ]
        let searchFunction = searchFunctions.find((func, index) => index === addressPartsSize - 1)
        searchFunction = searchFunction.bind(null, addressParts)
        return ImmutabilityService.deepFreeze(searchFunction);
    }

    searchByPostCode(addressStructure) {       
        return searchByPostCodeContinuation({ postCode: addressStructure[0]});
    }

    setSearchByPostCodeOrStreet(addressStructure) {
        return searchByPostCodeOrStreetContinuation({
            postCode: addressStructure[0],
            street: addressStructure[1]
        });
    }

    setSearchByPostCodeAndCityAndStreet(addressStructure) {
        return searchByPostCodeAndCityAndStreetContinuation({
            postCode: addressStructure[0],
            city: addressStructure[1],
            street: addressStructure[2]
        });
    }

    setFullSearchParameters(addressStructure) {
        return fullSearchParametersContinuation({
            postCode: addressStructure[0],
            city: addressStructure[1],
            street: addressStructure[2],
            houseNumber: addressStructure[3]
        });
    }

    createDefaultSearchFunction() {
        return () => {
            new Promise(resolve => {
                resolve([]);
            });
        };
    }

    runSearchWithMethod(searchMethod) {        
        searchMethod()
            .then(results => { 
                return this.publishResultComposition.reduce(this.reducer, results)
            })           
            .catch(err => console.log(err))
            .then(() => this.showSpinner = false)

        this.showSpinner = true;
    }

    mapResultsToList(results) {
        const currentSearchResults = [];
        results.forEach(result => {
            currentSearchResults.push(result);
        });        
        return ImmutabilityService.deepFreeze(currentSearchResults);
    }

    publishResults(results) {        
        this.searchResults = results
        if (this.searchResults.length > 0) {
            this.showSearchResults = true;
        }
    }    

    clearPreviousResultsAndHideResultPanel() {
        this.showSearchResults = false;
        this.searchResults = [];
    }

    handleContainerClick(event) {
        this.clearPreviousResultsAndHideResultPanel();
    }

    assignAddress(event) {
        console.log('assignAddress',event.currentTarget.dataset.addressId)
        let addressId = event.currentTarget.dataset.addressId;
        if (addressId && this.searchResults && this.searchResults.length > 0) {
            this.assignAddressComposition.reduce(this.reducer,addressId)
        }
    }

    saveAddress() {       
        console.log(this.saveMethod,this.selectedAddress) 
        if (this.saveMethod && this.selectedAddress) {
            this.showSpinner = true;

            new Promise(resolve => {
                this.saveMethod(this.selectedAddress);
                resolve();
            })
            .then(() => (this.showSpinner = false))
            .catch(err => console.log(err));
        }
    }
}
