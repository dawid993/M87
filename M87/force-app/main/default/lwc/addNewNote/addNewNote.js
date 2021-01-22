import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NewNote from '@salesforce/label/c.NewNote';
import Note from '@salesforce/label/c.Note';
import NoteTitle from '@salesforce/label/c.NoteTitle';
import SaveNote from '@salesforce/label/c.SaveNote';
import NoteSaveSuccess from '@salesforce/label/c.NoteSaveSuccess';

import saveSingleNote from '@salesforce/apex/MyNotesController.saveSingleNote';

import {
    TITLE_ID,
    DUE_DATE_ID,
    CONTENT_ID
} from './elementIds';

import {
    titleValidation,
    dueDateValidation,
    noteContentValidation
} from './validators';

const defaultFailedMessage = 'Cannot save. Please try again.';

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
        if (this._areNoteFieldsValid()) {
            const note = this._buildNote();
            saveSingleNote({ newNote: note })
                .then(result => {
                    result.success ? this._fireSuccessToast() : this._fireFailureToast()
                })
                .catch(this._fireFailureToast)
        } else {
            this._fireFailureToast();
        }
    }

    _buildNote() {
        return {
            title: this.template.querySelector(TITLE_ID).value,
            dueDate: this.template.querySelector(DUE_DATE_ID).value,
            content: this.template.querySelector(CONTENT_ID).value,
        }
    }

    _fireSuccessToast() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Saved!',
            message: NoteSaveSuccess,
            variant: 'Success',
        }));
    }

    _fireFailureToast(message = defaultFailedMessage) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error!',
            message: message,
            variant: 'Error',
        }));
    }

    _areNoteFieldsValid() {
        const validationRules = [
            titleValidation(this.template, TITLE_ID),
            dueDateValidation(this.template, DUE_DATE_ID),
            noteContentValidation(this.template, CONTENT_ID)
        ];

        return validationRules.reduce(
            (previous, currentValidation) => {
                return currentValidation() && previous;
            },
            true
        );
    }
}