import { Maybe, Empty, Either } from 'c/jsFunctional';

const updateFunction = (obj) => {
    obj.testValue++;
    return obj;
}

const _testObj = { testValue: 1 };

function getTestObj() {
    return Object.assign({}, _testObj);
}

const getResolveFunction = obj => resolve => resolve(obj);
const getRejectedFunction = obj => (resolve,rejected) => rejected(obj);

describe('js-functional', () => {

    it('maybe nothing factory test, should not update value', () => {
        const maybe = Maybe.getNothing();

        let testValue = 0;
        maybe.then(() => testValue++);
        expect(testValue).toBe(0);
    });

    it('maybe nothing test, should not update value', () => {
        const maybe = Maybe();
        let testValue = 0;
        maybe.then(() => testValue++);
        expect(testValue).toBe(0);
    });

    it('should update value', () => {
        const obj = getTestObj();
        Maybe(obj).then(updateFunction);

        expect(obj.testValue).toBe(2);
    });

    it('should update value twice', () => {
        const obj = getTestObj();
        Maybe(obj)
            .then(updateFunction)
            .then(updateFunction);

        expect(obj.testValue).toBe(3);
    });

    it('empty factory test, should update value', () => {
        let testValue = 0;
        const updateTestValue = () => testValue++;

        Empty.getEmpty().then(updateTestValue);

        expect(testValue).toBe(1);
    });

    it('empty factory test, should update value twice', () => {
        let testValue = 0;
        const updateTestValue = () => testValue++;

        Empty.getEmpty()
            .then(updateTestValue)
            .then(updateTestValue);

        expect(testValue).toBe(2);
    });

    it('should update value because no empty', () => {
        const obj = getTestObj();

        Empty(obj).then(updateFunction);
        expect(obj.testValue).toBe(2);
    });

    it('should update value twice because no empty', () => {
        const obj = getTestObj();

        Empty(obj)
            .then(updateFunction)
            .then(updateFunction);

        expect(obj.testValue).toBe(3);
    });

    it('should perform callback because either resolved', () => {
        const obj = getTestObj();

        Either(getResolveFunction(obj)).then(updateFunction);

        expect(obj.testValue).toBe(2);
    });

    it('should perform callback twice because either resolved', () => {
        const obj = getTestObj();

        Either(getResolveFunction(obj))
            .then(updateFunction)
            .then(updateFunction);

        expect(obj.testValue).toBe(3);
    });

    it('should not perform catch callback because either resolved', () => {
        const obj = getTestObj();
        let catchCallbackExecuted = false;

        Either(getResolveFunction(obj))
            .then(updateFunction)
            .catch(() => catchCallbackExecuted = true);

        expect(obj.testValue).toBe(2);
        expect(catchCallbackExecuted).toBe(false);
    });

    it('should perform catch callback because either rejected', () => {
        const obj = getTestObj();
        let catchCallbackExecuted = false;

        Either(getRejectedFunction(obj))
            .then(updateFunction)
            .catch(() => catchCallbackExecuted = true);

        expect(obj.testValue).toBe(1);
        expect(catchCallbackExecuted).toBe(true);
    });

    it('should perform catch callback and dont perform then callback because either rejected', () => {
        const obj = getTestObj();
        let catchCallbackExecuted = false;

        Either(getRejectedFunction(obj))
            .then(updateFunction)
            .then(updateFunction)
            .catch(() => catchCallbackExecuted = true);

        expect(obj.testValue).toBe(1);
        expect(catchCallbackExecuted).toBe(true);
    });

    it('should perform then callback after catch callback', () => {
        const obj = getTestObj();
        let catchCallbackExecuted = false;

        Either(getRejectedFunction(obj))
            .then(updateFunction)            
            .catch(() => catchCallbackExecuted = true)
            .then(() => updateFunction(obj));

        expect(obj.testValue).toBe(2);
        expect(catchCallbackExecuted).toBe(true);
    });
    
    it('should not perform catch callbacks and perform then callbacks', () => {
        const obj = getTestObj();
        let catchCallbackExecutedNumber = 0;
        const increaseCatchCallbackNumber = () => catchCallbackExecutedNumber++;

        Either(getResolveFunction(obj))
            .catch(increaseCatchCallbackNumber)
            .then(() => updateFunction(obj))
            .catch(increaseCatchCallbackNumber)
            .then(() => updateFunction(obj));

        expect(obj.testValue).toBe(3);
        expect(catchCallbackExecutedNumber).toBe(0);
    });

    it('should perform then callbacks twice and perform catch once callbacks', () => {
        const obj = getTestObj();
        let catchCallbackExecutedNumber = 0;
        const increaseCatchCallbackNumber = () => catchCallbackExecutedNumber++;

        Either(getRejectedFunction(obj))
            .catch(increaseCatchCallbackNumber)
            .then(() => updateFunction(obj))
            .catch(increaseCatchCallbackNumber)
            .then(() => updateFunction(obj));

        expect(obj.testValue).toBe(3);
        expect(catchCallbackExecutedNumber).toBe(1);
    });

    it('should reject one then callbackse and perform catch once callbacks', () => {
        expect.assertions(3);

        const obj = getTestObj();
        const errorMessage = 'ERROR IN TEST';
        let catchCallbackExecutedNumber = 0;
        const increaseCatchCallbackNumber = () => catchCallbackExecutedNumber++;

        Either(getRejectedFunction(obj))
            .catch(increaseCatchCallbackNumber)
            .then(() => {throw new Error(errorMessage)})
            .catch((err) => {
                expect(err.message).toMatch(errorMessage);
                increaseCatchCallbackNumber();
            })
            .then(() => updateFunction(obj));

        expect(obj.testValue).toBe(2);
        expect(catchCallbackExecutedNumber).toBe(2);
    });

    it('should catch error which occur in catch callback', () => {        
        const obj = getTestObj();
        const errorMessage = 'ERROR IN TEST';
        let catchCallbackExecutedNumber = 0;
        const increaseCatchCallbackNumber = () => catchCallbackExecutedNumber++;

        Either(getRejectedFunction(obj))
            .catch(() => {
                increaseCatchCallbackNumber();
                throw new Error(errorMessage)
            })
            .then(updateFunction)
            .catch(increaseCatchCallbackNumber)
            .then(() => updateFunction(obj));

        expect(obj.testValue).toBe(2);
        expect(catchCallbackExecutedNumber).toBe(2);
    });
});