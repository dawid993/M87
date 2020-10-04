import {createErrorToast} from 'c/toastDialogs';

describe('c-toast-dialogs', () => {
    it('should return error toast message', () => {
        const toastDialog = createErrorToast('Test title','Test message');
        expect(toastDialog).toBeTruthy();      
    });
});