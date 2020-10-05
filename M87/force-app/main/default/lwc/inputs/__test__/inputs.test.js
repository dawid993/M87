import { canFieldBeSaved, areLightningInputsValid } from 'c/inputs';

const FIELD_1 = 'FIELD_1';
const FIELD_2 = 'FIELD_2';

const validFieldNames = [FIELD_1, FIELD_2];

function getTestEvent(fieldName) {
    return {
        target: {
            dataset: {
                fieldName: fieldName
            }
        }
    }
}

describe('c-inputs', () => {
    it('field name should be valid, then block should be invoked', () => {
        let result = false;
        canFieldBeSaved(validFieldNames, getTestEvent(FIELD_1)).then(() => result = true);
        expect(result).toBe(true);
    });

    it('field name should be invalid, catch function should be invoked', () => {
        let result = false;
        let catchInvoked = false
        canFieldBeSaved(validFieldNames, getTestEvent('FIELD_INVALID'))
            .then(() => result = true)
            .catch(() => catchInvoked = true);
        expect(result).toBe(false);
        expect(catchInvoked).toBe(true);
    });
});