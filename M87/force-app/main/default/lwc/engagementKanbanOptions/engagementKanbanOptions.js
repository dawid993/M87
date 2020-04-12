import { LightningElement, track } from 'lwc';
import ImmutabilityService from "c/immutabilityService";
import reducers from 'c/functionReduction';

const toDoStatus = 'To Do';
const inProgressStatus = 'In Progress';
const doneSuccessStauts = 'Done - success';
const doneFailureStatus = 'Done - failure';

const lowPriority = 'Low';
const mediumPriority = 'Medium';
const highPriority = 'High';

const allOwners = 'All';
const findOwner = 'Find owner';

export default class EngagementKanbanOptions extends LightningElement {
    searchPhrase

    @track
    selectedOwners = [allOwners];

    @track
    selectedStatuses = [toDoStatus, inProgressStatus, doneSuccessStauts, doneFailureStatus];

    @track
    selectedPriorities = [lowPriority, mediumPriority, highPriority];

    @track
    showOwnerSearchDialog = false;

    get statusOptions() {
        return ImmutabilityService.deepFreeze([
            { label: toDoStatus, value: toDoStatus },
            { label: inProgressStatus, value: inProgressStatus },
            { label: doneSuccessStauts, value: doneSuccessStauts },
            { label: doneFailureStatus, value: doneFailureStatus },
        ]);
    }

    get priorityOptions() {
        return ImmutabilityService.deepFreeze([
            { label: lowPriority, value: lowPriority },
            { label: mediumPriority, value: mediumPriority },
            { label: highPriority, value: highPriority },
        ]);
    }

    get ownerOptions() {
        return ImmutabilityService.deepFreeze([
            { label: allOwners, value: allOwners },
            { label: findOwner, value: findOwner },
        ]);
    }

    applySearchOptions() {
        const searchOptions = this.createOptionsObject(this.searchPhrase, this.selectedOwners, 
            this.selectedStatuses, this.selectedPriorities);
        this.fireSearchOptionEvent(searchOptions);
    }

    createOptionsObject(phrase, owners, statuses, priorities) {
        return {
            searchPhrase: phrase,
            selectedOwners: owners,
            selectedStatuses: statuses,
            selectedPriorities: priorities,
        };
    }

    fireSearchOptionEvent(searchOptions) {
        if (searchOptions) {
            this.dispatchEvent(new CustomEvent('search', {
                bubbles: true,
                detail: {
                    'searchOptions': searchOptions,
                }
            }));
        }
    }

    handleSearchPhraseChange(event) {        
        if (event.detail.value) {
            this.searchPhrase = event.detail.value;
        }
    }

    handleOwnerSelection(event) {
        if (event && event.detail.value) {
            const selectedOwner = event.detail.value;
            if (selectedOwner === allOwners
                && !this.selectedOwners.find(option => option === selectedOwner)) {
                this.selectedOwners.push(selectedOwner);
            } else if (selectedOwner === findOwner) {
                this.showOwnerSearchDialog = true;
            }
        }
    }

    handleStatusSelection(event) {
        if (event && event.detail.value) {
            this.addOptionToList(event.detail.value, this.selectedStatuses);
            this.clearComboboxValue(event.currentTarget);
        }
    }

    handlePrioritySelection(event) {
        if (event && event.detail.value) {
            this.addOptionToList(event.detail.value, this.selectedPriorities);
            this.clearComboboxValue(event.currentTarget);
        }
    }

    addOptionToList(option, targetList) {
        if (!targetList.find(currentOption => currentOption === option)) {
            targetList.push(option);
        }
    }

    clearComboboxValue(combobox) {
        if (combobox) {
            combobox.value = '';
        }
    }

    handleStatusDelete(event) {
        let status = event.currentTarget.label;
        if (status) {
            this.selectedStatuses = this.removeOptionFromList(status, this.selectedStatuses)
        }
    }

    handlePriorityDelete(event) {
        let priority = event.currentTarget.label;
        if (priority) {
            this.selectedPriorities = this.removeOptionFromList(priority, this.selectedPriorities)
        }
    }

    removeOptionFromList(option, targetList) {
        return targetList.filter(currentOption => currentOption !== option);
    }
}