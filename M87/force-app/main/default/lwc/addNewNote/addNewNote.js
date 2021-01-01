import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NewNote from '@salesforce/label/c.NewNote';
import Note from '@salesforce/label/c.Note';
import NoteTitle from '@salesforce/label/c.NoteTitle';
import SaveNote from '@salesforce/label/c.SaveNote';
import NoteSaveSuccess from "@salesforce/label/c.NoteSaveSuccess";

import {
    TITLE_ID,
    DUE_DATE_ID,
    CONTENT_ID
} from './elementIds';

const titleValidation = template => () => {
    const titleElement = template.querySelector(TITLE_ID);
    if (titleElement) {
        titleElement.showHelpMessageIfInvalid();
    }
    return titleElement ? titleElement.checkValidity() : false;
}

const dueDateValidation = template => () => {
    const dueDateElement = template.querySelector(DUE_DATE_ID);
    if (dueDateElement) {
        dueDateElement.showHelpMessageIfInvalid();
    }
    return true;
}

const noteContentValidation = template => () => {
    const noteContentElement = template.querySelector(CONTENT_ID);
    if (noteContentElement) {
        noteContentElement.showHelpMessageIfInvalid();
    }
    return noteContentElement ? noteContentElement.checkValidity() : false;
}

export default class AddNewNote extends LightningElement {
    get labels() {
        return {
            NewNote,
            Note,
            NoteTitle,
            SaveNote
        }
    }

    saveNote() {
        const toast = this._validate() ? this._successToast() : this._failureToast();       
        this.dispatchEvent(toast);        
    }

    _successToast() {
        return new ShowToastEvent({
            title: 'Saved!',
            message: NoteSaveSuccess,
            variant: 'Success',
        });
    }

    _failureToast() {
        return new ShowToastEvent({
            title: 'Error!',
            message: 'Cannot save',
            variant: 'Error',
        });
    }

    _validate() {
        const validationRules = [
            titleValidation(this.template),
            dueDateValidation(this.template),
            noteContentValidation(this.template)
        ];

        return validationRules.reduce((previous, currentValidation) => {
            return currentValidation() && previous;
        }, true);
    }
}