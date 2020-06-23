import { LightningElement } from 'lwc';

const engagementBoardMarkup = 'c-engagement-kanban-board';

export default class EngagementKanban extends LightningElement {
    handleSearchOptions(event){
        this.template.querySelector(engagementBoardMarkup).applySearchOptions(event.detail.searchOptions);        
    }   
}