import { ShowToastEvent } from 'lightning/platformShowToastEvent';

function createErrorToast(message, title = 'Error') {
    return new ShowToastEvent({
        'title' : title,
        'message' : message,
        'variant' : 'error',
    });
}

export {createErrorToast}