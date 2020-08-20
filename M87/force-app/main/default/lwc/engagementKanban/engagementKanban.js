import { LightningElement, wire } from 'lwc';
import reloadEngagementCases from '@salesforce/messageChannel/ReloadEngagementCases__c';

import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';

const engagementBoardMarkup = 'c-engagement-kanban-board';
const engagemetKanbanOptions = 'c-engagement-kanban-options';


export default class EngagementKanban extends LightningElement {

    _reloadEngagementCasesSubscription;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this._subscribeReloadEngagementCases();
    }

    disconnectedCallback() {
        this._unsubscribeReloadEngagementCases();
    }

    _subscribeReloadEngagementCases() {
        if (!this._reloadEngagementCasesSubscription) {
            this._reloadEngagementCasesSubscription = subscribe(
                this.messageContext,
                reloadEngagementCases,
                (message) => this._refreshBoard(),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    _unsubscribeReloadEngagementCases() {
        unsubscribe(this._reloadEngagementCasesSubscription);
        this._reloadEngagementCasesSubscription = null;
    }


    handleSearchOptions(event) {
        this.template.querySelector(engagementBoardMarkup).applySearchOptions(event.detail.searchOptions);
    }

    _refreshBoard() {        
        const searchOptions = this.template.querySelector(engagemetKanbanOptions).getCurrentSearchOptions();
        if(searchOptions){
            this._applySearchOptionsOnBoard(searchOptions);
        }
    }   

    _applySearchOptionsOnBoard(searchOptions) {
        this.template.querySelector(engagementBoardMarkup).applySearchOptions(searchOptions);
    }

}