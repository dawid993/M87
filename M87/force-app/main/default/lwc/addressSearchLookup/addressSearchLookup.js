/* eslint-disable no-unused-vars */
/* eslint-disable no-return-assign */
/* eslint-disable no-console */
/* eslint-disable no-new */
/* eslint-disable-next-line no-unused-vars */
import { LightningElement, track } from "lwc";
import searchAddressLabel from "@salesforce/label/c.SearchAddress";
import searchByPostCodeContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCode";
import setSearchByPostCodeOrStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.setSearchByPostCodeOrStreet";
import setSearchByPostCodeAndCityAndStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.setSearchByPostCodeAndCityAndStreet";
import setFullSearchParametersContinuation from "@salesforce/apexContinuation/AddressSearchController.setFullSearchParameters";

const ENTER_KEY = 13
const addressSeparator = ','

export default class AddressSearchLookup extends LightningElement {
    label = {
        searchAddressLabel: searchAddressLabel
    };

    @track
    showSearchResults = false;

    @track
    searchResults = [];

    @track
    selectedAddress = {}

    @track
    showSpinner = false

    searchAddresses(event) {
        const searchPhrase = event.target.value;
        const isEnterPressed = event.which === ENTER_KEY
        if (searchPhrase && isEnterPressed) {
            this.clearPreviousResultsAndHideResultPanel()
            const addressParts = searchPhrase.split(addressSeparator);
            const searchMethod = this.getSearchFunction(addressParts);
            this.runSearch(searchMethod)
        }
    }

    runSearch(searchMethod) {
        searchMethod()
            .then(results => {
                const resultsProxy = Object.freeze(results)
                const currentSearchResults = []

                resultsProxy.forEach(result => {
                    currentSearchResults.push(result);
                });

                this.searchResults = Object.freeze(currentSearchResults)
                return resultsProxy
            })
            .then(results => {
                results = []
                if (this.searchResults.length > 0) {
                    this.showSearchResults = true
                }
            })
            .catch(err => console.log(err))
            .then(result => this.showSpinner = false)
        this.showSpinner = true
    }

    getSearchFunction(addressParts) {
        let addressPartsSize = addressParts.length;
        return addressPartsSize === 1 ? this.searchByPostCode.bind(this, addressParts[0])
            : addressPartsSize === 2 ? this.setSearchByPostCodeOrStreet.bind(this, addressParts[0], addressParts[1])
                : addressPartsSize === 3 ? this.setSearchByPostCodeAndCityAndStreet.bind(this, addressParts[0],
                    addressParts[1], addressParts[2])
                    : addressPartsSize === 4 ? this.setFullSearchParameters.bind(this, addressParts[0], addressParts[1],
                        addressParts[2], addressParts[3])
                        : this.createDefaultSearchFunction();
    }

    searchByPostCode(postCode) {
        return searchByPostCodeContinuation({ postCode: postCode });
    }

    setSearchByPostCodeOrStreet(postCode, street) {
        return setSearchByPostCodeOrStreetContinuation({
            postCode: postCode,
            street: street
        })
    }

    setSearchByPostCodeAndCityAndStreet(postCode, city, street) {
        return setSearchByPostCodeAndCityAndStreetContinuation({
            postCode: postCode,
            city: city,
            street: street
        })
    }

    setFullSearchParameters(postCode, city, street, houseNumber) {
        return setFullSearchParametersContinuation({
            postCode: postCode,
            city: city,
            street: street,
            houseNumber: houseNumber
        })
    }

    createDefaultSearchFunction() {
        return () => {
            new Promise(resolve => {
                resolve([]);
            });
        };
    }

    clearPreviousResultsAndHideResultPanel() {
        this.showSearchResults = false;
        this.searchResults = [];
    }

    handleContainerClick(event) {
        this.clearPreviousResultsAndHideResultPanel()
    }

    assignAddress(event) {
        let addressId = event.currentTarget.dataset.addressId
        if (addressId) {
            this.selectedAddress = this.searchResults.find(element => element.Id === addressId)
        }
    }
}
