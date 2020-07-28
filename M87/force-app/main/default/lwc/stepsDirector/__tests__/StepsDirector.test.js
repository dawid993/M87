import StepsDirector from 'c/stepsDirector';
import { TEST_STEPS_DATA } from 'c/testUtility';

const EXAMPLE_STEP_DATA = [
    { applicationState: 'TEST' },
    { currentStepState: 'TEST' },
    [],
];

describe('c-steps-director', () => {
    it('should show correct step number', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        expect(stepDirector.steps).toEqual(TEST_STEPS_DATA.STEPS);
    });

    it('should throw exception because incorrect steps format', () => {
        let exceptionThrown = false;
        try {
            const stepDirector = new StepsDirector({});
        } catch (err) {
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBe(true);
    });

    it('should continue to next step', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        const stepNumber = stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);

        expect(stepDirector.currentStepNumber).toBe(2);
        expect(stepNumber).toBe(2);
    });

    it('should have only continue navigation action', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);

        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack": false,
            "showContinue": true,
            "showFinish": false,
        });
    });

    it('should have continue and back navigation action', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack": true,
            "showContinue": true,
            "showFinish": false,
        });
    });

    it('should have only finish navigation action', () => {
        const stepDirector = new StepsDirector(['FINAL_STEP']);

        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack": false,
            "showContinue": false,
            "showFinish": true,
        });
    });

    it('should have back and finish navigation action', () => {
        const stepDirector = new StepsDirector(['FIRST_STEP', 'FINAL_STEP']);
        stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);

        expect(stepDirector.currentStepNavigationOption).toEqual({
            "showBack": true,
            "showContinue": false,
            "showFinish": true,
        });
    });

    it('should remember steps data after revertion', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
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
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        const numberOfStepsToPerform = 5;
        let exceptionThrown = false;

        try {
            for (let i = 0; i < numberOfStepsToPerform; i++) {
                stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
            }
        } catch (err) {
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBe(false);
        expect(stepDirector.currentStepNumber).toBe(6);
    });

    it('should throw exception because all steps have already been performed', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        const numberOfStepsToPerform = 6;
        let exceptionThrown = false;

        try {
            for (let i = 0; i < numberOfStepsToPerform; i++) {
                stepDirector.onCurrentStepContinuation(...EXAMPLE_STEP_DATA);
            }
        } catch (err) {
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBe(true);
        expect(stepDirector.currentStepNumber).toBe(6);
    });

    it('should calculate next step regarding skipped steps', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        const step = stepDirector.onCurrentStepContinuation({}, {}, [2, 3, 4]);

        expect(step).toBe(5);
        expect(stepDirector.currentStepNumber).toBe(5);
    });

    it('should register step listener', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        let exceptionThrown = false;
        try {
            stepDirector.registerStepListener(TEST_STEPS_DATA.STEPS[0].id);
        } catch (err) {
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBeFalsy();
    });

    it('should throw exception when register step listener', () => {
        const stepDirector = new StepsDirector(TEST_STEPS_DATA.STEPS);
        let exceptionThrown = false;
        try {
            stepDirector.registerStepListener('NO_EXISTING_STEP');
        } catch (err) {
            exceptionThrown = true;
        }

        expect(exceptionThrown).toBeTruthy();
    });
});