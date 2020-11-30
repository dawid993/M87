import { api, LightningElement } from 'lwc';

import {
    CONFIRM_EVENT_NAME,
    CANCEL_EVENT_NAME
} from 'c/events';

export default class ConfirmDialog extends LightningElement {

    _confirmText = 'Confirmation text.';

    @api
    set confirmText(value) {
        this._confirmText = value;
    }

    get confirmText() {
        return this._confirmText;
    }

    fireConfirmEvent() {
        this.dispatchEvent(new CustomEvent(CONFIRM_EVENT_NAME));
    }

    fireCancelEvent() {
        this.dispatchEvent(new CustomEvent(CANCEL_EVENT_NAME));
    }
}