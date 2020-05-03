import { LightningElement, track, api } from 'lwc';
import LwcImmutabilityService from 'c/immutabilityService';
import { loadStyle } from 'lightning/platformResourceLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';

const defaultIconName = 'standard:contact';
const timeoutInterval = 1000;

export default class SearchRecords extends LightningElement {
    @track
    showSpinner = false;

    @track
    showSearchResults = false;

    searchResults = [];

    @api
    set searchFunction(value) {
        this._searchFunction = value ? value : () => [];
    }

    get searchFunction() {
        return this._searchFunction;
    }

    @api
    iconName = defaultIconName;

    timeoutId

    constructor() { 
        super();       
        Promise.all([
            loadStyle(this, globalStyles)
        ]).then(result => console.log('result',result)).catch(err => console.log(err));
    }

    searchRecords(event) {
        const searchPhrase = event.target.value;
        if (searchPhrase) {
            if (this.timeoutId) {
                clearTimeout(this.timeoutId);
            }

            this.timeoutId = setTimeout(() => {
                this.performSearch(searchPhrase)
            }, timeoutInterval);
        }
    }

    performSearch(searchPhrase) {
        this.showSpinner = true;
        this.searchFunction({ 'searchPhrase': searchPhrase })
            .then(result => {
                this.searchResults = [];
                this.searchResults.push(...LwcImmutabilityService.deepFreeze(result.detailedResult));
                this.showSearchResults = true;
                this.showSpinner = false;
            })
    }

    hideResults(event) {
        this.showSearchResults = false;
    }

    notifyOptionSelected(event) {
        const resultId = event.target.dataset.id;
        if (resultId) {
            const selectedOption = this.searchResults.find(elem => elem.id === resultId);
            this.dispatchEvent(new CustomEvent('optionselected', {
                bubbles: true,
                detail: {
                    'selectedOption': selectedOption
                }
            }));
        }
    }
}