import { LightningElement, api } from 'lwc';

export default class DialogBar extends LightningElement {
    @api
    title
    
    closeDialogBar() {        
        this.dispatchEvent(new CustomEvent('dialogclose', { bubbles: true, composed: true }));        
    }
}