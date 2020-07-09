import ImmutableUtils from 'c/ImmutableUtils';

describe('c-immutable-utils',() => {
    it('should clone object',() => {
        const sourceObj = {
            'prop1' : 'test',
            'prop2' : 2,
            'prop3' : {
                'prop3.1' : 3,
            }
        }
        
        const clonedObj = ImmutableUtils.deepClone(sourceObj);
        expect(Object.is(sourceObj,clonedObj)).toBeFalsy();
        expect(clonedObj).toEqual(sourceObj);
        clonedObj['prop1'] = 'changed';
        expect(clonedObj['prop1']).not.toEqual(sourceObj['prop1']);
    });

    it('should clone freeze',() => {
        const sourceObj = {
            'prop1' : 'test',
            'prop2' : 2,
            'prop3' : {
                'prop3.1' : 3,
            }
        }
        
        ImmutableUtils.deepFreeze(sourceObj);
        expect(Object.isFrozen(sourceObj)).toBeTruthy();
        expect(Object.isFrozen(sourceObj['prop3'])).toBeTruthy();
    });

    it('should clone and freeze',() => {
        const sourceObj = {
            'prop1' : 'test',
            'prop2' : 2,
            'prop3' : {
                'prop3.1' : 3,
            }
        }
        
        const clonedAndFrozen = ImmutableUtils.deepCloneAndFreeze(sourceObj);
        expect(Object.isFrozen(clonedAndFrozen)).toBeTruthy();
        expect(Object.isFrozen(sourceObj)).toBeFalsy();
    });

    it('should clone array',() => {
        const testArray = ['13',{'test': 1},144,new Date()];
        const clonedArray = ImmutableUtils.deepClone(testArray);

        expect(Object.is(testArray,clonedArray)).toBeFalsy();

        testArray[1]['test'] = 2;
        expect(testArray[1]['test']).toBe(2);
        expect(clonedArray[1]['test']).toBe(1);
    });
});