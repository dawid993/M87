import { LightningElement } from 'lwc';

export default class EngagementKanban extends LightningElement {
    handleSearchOptions(event){
        this.template.querySelector('c-engagement-kanban-board').applySearchOptions(event.detail.searchOptions);        
    }
}