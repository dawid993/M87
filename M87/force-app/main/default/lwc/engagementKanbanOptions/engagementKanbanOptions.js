import { LightningElement, track } from 'lwc';
import ImmutabilityService from "c/immutabilityService";
import apexSearchOwners from '@salesforce/apex/EngagementKanbanController.searchOwners';

const toDoStatus = 'To Do';
const inProgressStatus = 'In Progress';
const doneSuccessStauts = 'Done - success';
const doneFailureStatus = 'Done - failure';

const lowPriority = 'Low';
const mediumPriority = 'Medium';
const highPriority = 'High';

const allOwnersLabel = 'All';
const allOwnersId = 'ALL_OWNERS_SEARCH';
const allOwners = { id: allOwnersId, label: allOwnersLabel };
const findOwner = 'Find owner';

const pharseFieldId = 'phrase';
const ownerFieldId = 'owner';
const statusFieldId = 'status';
const priorityFieldId = 'priority';

const comboboxInvalidMessage = 'Please select at least one value.';
const phraseInvalidMessage = 'Phrase must be longer than 1 character.';

/*
* Because when phrase is 0 character long its ok, then we dont apply this option.
* When we want then search need to be longer than 1 character long.
*/
const phraseValidationFunction = phrase => phrase.length != 1;
const comboboxValidationFunction = comboboxValues => comboboxValues.length >= 1;

export default class EngagementKanbanOptions extends LightningElement {
    searchPhrase = '';

    @track
    selectedOwners = [allOwners];

    @track
    selectedStatuses = [toDoStatus, inProgressStatus, doneSuccessStauts, doneFailureStatus];

    @track
    selectedPriorities = [lowPriority, mediumPriority, highPriority];

    @track
    showOwnerSearchDialog = false;

    searchFunction = apexSearchOwners;

    get validationDescription() {
        return [
            {
                field: this.template.querySelector(`[data-id='${pharseFieldId}']`),
                propertyValue: this.searchPhrase,
                errorMsg: phraseInvalidMessage,
                validationFunction: phraseValidationFunction
            },
            {
                field: this.template.querySelector(`[data-id='${ownerFieldId}']`),
                propertyValue: this.selectedOwners,
                errorMsg: comboboxInvalidMessage,
                validationFunction: comboboxValidationFunction,
            },
            {
                field: this.template.querySelector(`[data-id='${statusFieldId}']`),
                propertyValue: this.selectedStatuses,
                errorMsg: comboboxInvalidMessage,
                validationFunction: comboboxValidationFunction,
            },
            {
                field: this.template.querySelector(`[data-id='${priorityFieldId}']`),
                propertyValue: this.selectedPriorities,
                errorMsg: comboboxInvalidMessage,
                validationFunction: comboboxValidationFunction,
            },
        ];
    }

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
            { label: allOwnersLabel, value: allOwnersLabel },
            { label: findOwner, value: findOwner },
        ]);
    }

    applySearchOptions() {
        if (this.validateSearchOptions()) {
            const searchOptions = this.createOptionsObject(
                this.searchPhrase,
                this.selectedOwners.map(owner => owner.id),
                this.selectedStatuses,
                this.selectedPriorities
            );
            this.fireSearchOptionEvent(searchOptions);
        }
    }

    validateSearchOptions() {
        const areSearchOptionsValid = this.validationDescription.reduce((acc, searchOption) => {
            const currentFieldResult = searchOption.validationFunction(searchOption.propertyValue);
            searchOption.field.setCustomValidity(currentFieldResult ? '' : searchOption.errorMsg);
            searchOption.field.showHelpMessageIfInvalid();
            return acc && currentFieldResult;

        }, true);

        return areSearchOptionsValid;

    }

    createOptionsObject(phrase, owners, statuses, priorities) {
        return {
            'phrase': phrase,
            'selectedOwners': owners,
            'selectedStatuses': statuses,
            'selectedPriorities': priorities,
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
        this.searchPhrase = event.detail.value ? event.detail.value : '';    
    }

    handleOwnerSelection(event) {
        if (event && event.detail.value) {
            const selectedOwner = event.detail.value;
            if (selectedOwner === allOwnersLabel && !this.selectedOwners.find(option => option === selectedOwner)) {
                this.selectedOwners = [];
                this.selectedOwners.push(allOwners);
            } else if (selectedOwner === findOwner) {
                this.showOwnerSearchDialog = true;
            }
            this.clearComboboxValue(event.currentTarget);
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
            this.selectedStatuses = this.removeOptionFromList(status, this.selectedStatuses);
        }
    }

    handleOwnerDelete(event) {
        let ownerId = event.target.dataset.id;
        if (ownerId) {
            this.selectedOwners = this.selectedOwners.filter(elem => elem.id != ownerId);
        }

        if (this.selectedOwners.length === 0) {
            this.addAllOwnerOption();
        }
    }

    handleStatusDelete(event) {
        let status = event.currentTarget.label;
        if (status) {
            this.selectedStatuses = this.removeOptionFromList(status, this.selectedStatuses);
        }
    }

    handlePriorityDelete(event) {
        let priority = event.currentTarget.label;
        if (priority) {
            this.selectedPriorities = this.removeOptionFromList(priority, this.selectedPriorities);
        }
    }

    removeOptionFromList(option, targetList) {
        return targetList.filter(currentOption => currentOption !== option);
    }

    closeOwnerSearchDialog(event) {
        this.showOwnerSearchDialog = false;
    }

    handleOptionSelected(event) {
        const selectedOwner = event.detail.selectedOption;
        if (selectedOwner && selectedOwner.id) {
            this.removeAllOwnerOption();
            this.selectedOwners.push(event.detail.selectedOption);
        }
    }

    removeAllOwnerOption() {
        if (this.selectedOwners.find(elem => elem.id === allOwnersId)) {
            this.selectedOwners = this.selectedOwners.filter(elem => elem.id != allOwnersId);
        }
    }

    addAllOwnerOption() {
        this.selectedOwners.push(allOwners);
    }
}