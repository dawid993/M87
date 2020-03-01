/* eslint-disable no-unused-vars */
/* eslint-disable no-return-assign */
/* eslint-disable no-console */
/* eslint-disable no-new */
/* eslint-disable-next-line no-unused-vars */
import { LightningElement, track, api } from "lwc";
import searchAddressLabel from "@salesforce/label/c.SearchAddress";
import searchByPostCodeContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCode";
import setSearchByPostCodeOrStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.setSearchByPostCodeOrStreet";
import setSearchByPostCodeAndCityAndStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.setSearchByPostCodeAndCityAndStreet";
import setFullSearchParametersContinuation from "@salesforce/apexContinuation/AddressSearchController.setFullSearchParameters";
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
        return (separator) => (phrase) => Immutable.List(phrase.split(separator))  
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
            (results) => Immutable.List(results),
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
        this.addressSaveMethod = ImmutabilityService.deepFreeze(value);
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
        console.log(addressParts)
        let addressPartsSize = addressParts.size;
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
        return searchByPostCodeContinuation({ postCode: addressStructure.get(0)});
    }

    setSearchByPostCodeOrStreet(addressStructure) {
        return setSearchByPostCodeOrStreetContinuation({
            postCode: addressStructure.get(0),
            street: addressStructure.get(1)
        });
    }

    setSearchByPostCodeAndCityAndStreet(addressStructure) {
        return setSearchByPostCodeAndCityAndStreetContinuation({
            postCode: addressStructure.get(0),
            city: addressStructure.get(1),
            street: addressStructure.get(2)
        });
    }

    setFullSearchParameters(addressStructure) {
        return setFullSearchParametersContinuation({
            postCode: addressStructure.get(0),
            city: addressStructure.get(1),
            street: addressStructure.get(2),
            houseNumber: addressStructure.get(3)
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
        return Immutable.List(currentSearchResults);
    }

    publishResults(results) {        
        this.searchResults = results
        if (this.searchResults.size > 0) {
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
        let addressId = event.currentTarget.dataset.addressId;
        if (addressId && this.searchResults && this.searchResults.size > 0) {
            this.assignAddressComposition.reduce(this.reducer,addressId)
        }
    }

    saveAddress() {
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
