import { api, LightningElement } from 'lwc';

import YourNotes from '@salesforce/label/c.YourNotes';
import NewNote from '@salesforce/label/c.NewNote';


export default class MyNotes extends LightningElement {
    _notesHeader = 'Notes';

    @api
    set notesHeader(value) {
        this._notesHeader = value;
    }

    get notesHeader() {
        return this._notesHeader;
    }

    get labels(){
        return {
            YourNotes,
            NewNote
        }
    }

    renderedCallback(){
        const elem = this.template.querySelector('c-my-notes-table');
    }

    
}