import StepsDirector from 'c/stepsDirector';

const STEP_1 = {
    id: 'STEP_1',
    label: 'STEP_1',
    order: 1,
};

const STEP_2 = {
    id: 'STEP_2',
    label: 'STEP_2',
    order: 2,
};

const STEP_3 = {
    id: 'STEP_3',
    label: 'STEP_3',
    order: 3,
};

const STEP_4 = {
    id: 'STEP_4',
    label: 'STEP_4',
    order: 4,
};

const STEP_5 = {
    id: 'STEP_5',
    label: 'STEP_5',
    order: 5,
};

const STEPS = [STEP_1,STEP_2,STEP_3,STEP_4,STEP_5];

const EXAMPLE_STEP_DATA = [
    {applicationState : 'TEST'},
    {currentStepState : 'TEST'},
    [],
];

describe('c-steps-director',() => {
    it('should show correct step number',() => {
        const stepDirector = new StepsDirector(STEPS);
        expect(stepDirector.steps).toEqual(STEPS);
    });

    it('should throw exception because incorrect steps format',() => {       
        let exceptionThrown = false;
        try{
            const stepDirector = new StepsDirector({});
        }catch(err){            
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBe(true);
    });

    it('should continue to next step',() => {
        const stepDirector = new StepsDirector(STEPS);
        const stepNumber = stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);

        expect(stepDirector.currentStepNumber).toBe(2);
        expect(stepNumber).toBe(2);
    });

    it('should have only continue navigation action',() => {
        const stepDirector = new StepsDirector(STEPS);

        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack" : false,
            "showContinue" : true,
            "showFinish" : false,
        });       
    });

    it('should have continue and back navigation action',() => {
        const stepDirector = new StepsDirector(STEPS);
        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack" : true,
            "showContinue" : true,
            "showFinish" : false,
        });       
    });

    it('should have only finish navigation action',() => {
        const stepDirector = new StepsDirector(['FINAL_STEP']);
        
        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack" : false,
            "showContinue" : false,
            "showFinish" : true,
        });       
    });

    it('should have back and finish navigation action',() => {
        const stepDirector = new StepsDirector(['FIRST_STEP','FINAL_STEP']);
        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
        
        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack" : true,
            "showContinue" : false,
            "showFinish" : true,
        });       
    });

    it('should remember steps data after revertion',() => {        
        const stepDirector = new StepsDirector(STEPS);   
        const currentTestStep = JSON.parse(JSON.stringify(EXAMPLE_STEP_DATA));
        const TEST_SKIPPED_STEP = 3;

        currentTestStep[2].push(TEST_SKIPPED_STEP);

        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
        stepDirector.onCurrentStepContinuation(...currentTestStep);
        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);

        const dataAfterRevert = stepDirector.onStepRevertion();

        expect(dataAfterRevert.skippedSteps).toEqual([TEST_SKIPPED_STEP]);
        expect(dataAfterRevert.currentStep).toBe(4);
        expect(stepDirector._currentStepNumber).toBe(4);        
    });

    it('should return last step number', () => {
        const stepDirector = new StepsDirector(STEPS);        
        const numberOfStepsToPerform = 5;
        let exceptionThrown = false;

        try{
            for(let i = 0; i < numberOfStepsToPerform; i++){
                stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
            } 
        }catch(err){
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBe(false);
        expect(stepDirector.currentStepNumber).toBe(6);               
    });

    it('should throw exception because all steps have already been performed', () => {
        const stepDirector = new StepsDirector(STEPS);        
        const numberOfStepsToPerform = 6;
        let exceptionThrown = false;

        try{
            for(let i = 0; i < numberOfStepsToPerform; i++){
                stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
            } 
        }catch(err){
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBe(true);
        expect(stepDirector.currentStepNumber).toBe(6);               
    });

    it('should calculate next step regarding skipped steps', () => {
        const stepDirector = new StepsDirector(STEPS);  
        const step = stepDirector.onCurrentStepContinuation({},{},[2,3,4]);

        expect(step).toBe(5);
        expect(stepDirector.currentStepNumber).toBe(5);
    });

    it('should register step listener', () => {
        const stepDirector = new StepsDirector(STEPS);
        let exceptionThrown = false;
        try{
            stepDirector.registerStepListener(STEPS[0].id);
        }catch(err){
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBeFalsy();
    });

    it('should throw exception when register step listener', () => {
        const stepDirector = new StepsDirector(STEPS);
        let exceptionThrown = false;
        try{
            stepDirector.registerStepListener('NO_EXISTING_STEP');
        }catch(err){
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBeTruthy();
    });
});