import {canFieldBeSaved, areLightningInputsValid} from 'c/inputs';

const FIELD_1 = 'FIELD_1';
const FIELD_2 = 'FIELD_2';

const validFieldNames = [FIELD_1, FIELD_2];

function getTestEvent(fieldName){
    return {
        target : {
            dataset : {
                fieldName : fieldName
            }
        }
    }
}

describe('c-inputs', () => {
    it('field name should be valid',() => {
        let result = false;        
        canFieldBeSaved(validFieldNames,getTestEvent(FIELD_1)).then(canBeSaved => result = canBeSaved);
        expect(result).toBe(true);
    });

    it('field name should be invalid',() => {
        let result = false;        
        canFieldBeSaved(validFieldNames,getTestEvent('FIELD_INVALID')).then(canBeSaved => result = canBeSaved);
        expect(result).toBe(false);
    });
});