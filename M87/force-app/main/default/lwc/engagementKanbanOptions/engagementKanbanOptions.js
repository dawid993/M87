import { LightningElement, track } from 'lwc';
import ImmutabilityService from "c/immutabilityService";
import reducers from 'c/functionReduction';

export default class EngagementKanbanOptions extends LightningElement {
    searchOptions = {};
    
    @track
    selectedOwners = [];

    @track
    selectedStatuses = [];

    @track
    selectedPriorities = [];

    @track
    showOwnerSearchDialog = false;

    get statusOptions() {
        return ImmutabilityService.deepFreeze([
            { label: 'To Do', value: 'To Do' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'Done - success', value: 'Done - success' },
            { label: 'Done - failure', value: 'Done - failure' },
        ]);
    }

    get priorityOptions() {
        return ImmutabilityService.deepFreeze([
            { label: 'Low', value: 'Low' },
            { label: 'Medium', value: 'Medium' },
            { label: 'High', value: 'High' },
        ]);
    }

    get ownerOptions() {
        return ImmutabilityService.deepFreeze([
            { label: 'All Possible', value: 'All' },
            { label: 'Find owner', value: 'Find owner' },
        ]);
    }

    handleOwnerSelection(event) {
        debugger;
        if (event && event.detail.value) {
            if (event.detail.value === 'All' 
            && !this.selectedOwners.find(option => option === event.detail.value)) {
                this.selectedOwners.push(event.detail.value);
            }else{
                this.showOwnerSearchDialog = true;
                console.log(this.showOwnerSearchDialog)
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