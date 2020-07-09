import { createElement } from 'lwc'
import AddressSearchLookup from 'c/addressSearchLookup'
import searchByPostCodeContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCode"
import searchByPostCodeOrStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCodeOrStreet";
import searchByPostCodeAndCityAndStreetContinuation from "@salesforce/apexContinuation/AddressSearchController.searchByPostCodeAndCityAndStreet";
import fullSearchParametersContinuation from "@salesforce/apexContinuation/AddressSearchController.fullSearchParameters";

jest.mock(
    '@salesforce/apexContinuation/AddressSearchController.searchByPostCode',
    () => {
        return {
            default: jest.fn()
        }
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apexContinuation/AddressSearchController.searchByPostCodeOrStreet',
    () => {
        return {
            default: jest.fn()
        }
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apexContinuation/AddressSearchController.searchByPostCodeAndCityAndStreet',
    () => {
        return {
            default: jest.fn()
        }
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apexContinuation/AddressSearchController.fullSearchParameters',
    () => {
        return {
            default: jest.fn()
        }
    },
    { virtual: true }
);

const TEST_POST_CODE = '60-000'
const TEST_CITY = 'Test City'
const TEST_DISCTRICT = 'Test Disctrict'
const TEST_HOUSE_NUMBER = 'Test HouseNumber'
const TEST_STREET = 'Test Street'

const ENTER_KEY = 13

const SUCCESS_SEARCH_RESULTS = [
    {
        city: TEST_CITY,
        district: TEST_DISCTRICT,
        houseNumber: TEST_HOUSE_NUMBER,
        id: '0000000001',
        postCode: TEST_POST_CODE,
        street: TEST_STREET
    },
    {
        city: TEST_CITY,
        district: TEST_DISCTRICT,
        houseNumber: TEST_HOUSE_NUMBER,
        id: '0000000002',
        postCode: TEST_POST_CODE,
        street: TEST_STREET
    }
]

describe('c-address-search-lookup tests', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    })

    function flushPromises() {
        return new Promise(resolve => setImmediate(resolve));
    }

    it('component has input field', () => {
        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })
        document.body.appendChild(addressLookupElement)
        const searchInput = addressLookupElement.shadowRoot.querySelector('lightning-input')

        expect(searchInput).toBeTruthy()
    })

    it('component has help panel', () => {
        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })
        document.body.appendChild(addressLookupElement)
        const helpHeader = addressLookupElement.shadowRoot.querySelector('.search-header')
        expect(helpHeader).toBeTruthy()
    })

    it('search by post code', () => {
        searchByPostCodeContinuation.mockResolvedValue(SUCCESS_SEARCH_RESULTS)

        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })

        document.body.appendChild(addressLookupElement)

        const searchInput = addressLookupElement.shadowRoot.querySelector('lightning-input')
        searchInput.value = TEST_POST_CODE
        searchInput.dispatchEvent(new KeyboardEvent('keypress', { which: ENTER_KEY, bubbles: true }))

        return flushPromises().then(() => {
            const searchResults = addressLookupElement.shadowRoot.querySelectorAll('.address-element')
            expect(searchResults.length).toEqual(SUCCESS_SEARCH_RESULTS.length)
            expect(searchByPostCodeContinuation.mock.calls[0][0]).toEqual({ postCode: TEST_POST_CODE })
        })
    })

    it('search by postcode,street', () => {
        searchByPostCodeOrStreetContinuation.mockResolvedValue(SUCCESS_SEARCH_RESULTS)

        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })

        document.body.appendChild(addressLookupElement)

        const searchInput = addressLookupElement.shadowRoot.querySelector('lightning-input')
        searchInput.value = TEST_POST_CODE + ',' + TEST_STREET
        searchInput.dispatchEvent(new KeyboardEvent('keypress', { which: ENTER_KEY, bubbles: true }))

        return flushPromises().then(() => {
            const searchResults = addressLookupElement.shadowRoot.querySelectorAll('.address-element')
            expect(searchResults.length).toEqual(SUCCESS_SEARCH_RESULTS.length)
            expect(searchByPostCodeOrStreetContinuation.mock.calls[0][0]).toEqual({ postCode: TEST_POST_CODE, street: TEST_STREET })
        })
    })

    it('search by postcode,city,street', () => {
        searchByPostCodeAndCityAndStreetContinuation.mockResolvedValue(SUCCESS_SEARCH_RESULTS)

        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })

        document.body.appendChild(addressLookupElement)

        const searchInput = addressLookupElement.shadowRoot.querySelector('lightning-input')
        searchInput.value = TEST_POST_CODE + ',' + TEST_CITY + ',' + TEST_STREET
        searchInput.dispatchEvent(new KeyboardEvent('keypress', { which: ENTER_KEY, bubbles: true }))

        return flushPromises().then(() => {
            const searchResults = addressLookupElement.shadowRoot.querySelectorAll('.address-element')
            expect(searchResults.length).toEqual(SUCCESS_SEARCH_RESULTS.length)
            expect(searchByPostCodeAndCityAndStreetContinuation.mock.calls[0][0]).toEqual(
                {
                    postCode: TEST_POST_CODE,
                    city: TEST_CITY,
                    street: TEST_STREET,
                })
        })
    })

    it('search by full parameters option', () => {
        fullSearchParametersContinuation.mockResolvedValue(SUCCESS_SEARCH_RESULTS)

        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })

        document.body.appendChild(addressLookupElement)

        const searchInput = addressLookupElement.shadowRoot.querySelector('lightning-input')
        searchInput.value = TEST_POST_CODE + ',' + TEST_CITY + ',' + TEST_STREET + ',' + TEST_HOUSE_NUMBER
        searchInput.dispatchEvent(new KeyboardEvent('keypress', { which: ENTER_KEY, bubbles: true }))

        return flushPromises().then(() => {
            const searchResults = addressLookupElement.shadowRoot.querySelectorAll('.address-element')
            expect(searchResults.length).toEqual(SUCCESS_SEARCH_RESULTS.length)
            expect(fullSearchParametersContinuation.mock.calls[0][0]).toEqual(
                {
                    postCode: TEST_POST_CODE,
                    city: TEST_CITY,
                    street: TEST_STREET,
                    houseNumber: TEST_HOUSE_NUMBER
                })
        })
    })

    it('save current address',() => {
        searchByPostCodeOrStreetContinuation.mockResolvedValue(SUCCESS_SEARCH_RESULTS)

        const addressLookupElement = createElement('c-address-search-lookup', {
            is: AddressSearchLookup
        })

        let eventFired = false;
        addressLookupElement.addEventListener('addressselected',() => eventFired = true);

        document.body.appendChild(addressLookupElement)

        const searchInput = addressLookupElement.shadowRoot.querySelector('lightning-input')
        searchInput.value = TEST_POST_CODE + ',' + TEST_STREET
        searchInput.dispatchEvent(new KeyboardEvent('keypress', { which: ENTER_KEY, bubbles: true }))

        return flushPromises().then(() => {
            const searchResults = addressLookupElement.shadowRoot.querySelectorAll('.address-element')
            expect(searchResults.length).toEqual(SUCCESS_SEARCH_RESULTS.length)
            expect(searchByPostCodeOrStreetContinuation.mock.calls[0][0]).toEqual({ postCode: TEST_POST_CODE, street: TEST_STREET })
            searchResults[0].click()
            return new Promise((resolve) => resolve())
        }).then(() => {
            let saveButton = addressLookupElement.shadowRoot.querySelector('lightning-button')
            saveButton.click()              
            return new Promise((resolve) => resolve())
        }).then(() => {
            expect(eventFired).toBeTruthy()   
        })
    })
})
