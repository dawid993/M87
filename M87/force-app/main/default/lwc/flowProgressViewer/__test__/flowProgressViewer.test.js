import { createElement } from 'lwc';
import {
    clearDocument,
    createElementAndAddToDocument,
    flushPromises,
    TEST_STEPS_DATA
} from 'c/testUtility';

import flowProgressViewer from 'c/flowProgressViewer';

const DEFAULT_UPDATE_EVENT_DETAIL = {
    'steps': TEST_STEPS_DATA.STEPS,
    'currentStep': 1,
    'skippedSteps': new Set()
};

function dispatchUpdateEvent(sourceElement, testDetail) {
    sourceElement.dispatchEvent(new CustomEvent('navigationupdate', { detail: testDetail }));
}

describe('c-flow-progress-viewer', () => {
    afterEach(() => {
        clearDocument(document);
    });
    it('should update navigation bar', () => {
        const flowProgressViewerElement =
            createElementAndAddToDocument('c-flow-progress-viewer', document, flowProgressViewer, createElement);
        const slot = flowProgressViewerElement.shadowRoot.querySelector('slot');
        expect(slot).toBeTruthy();
        dispatchUpdateEvent(slot, DEFAULT_UPDATE_EVENT_DETAIL);
        return flushPromises().then(() => {
            const renderedSteps = flowProgressViewerElement.shadowRoot.querySelectorAll('li');
            expect(renderedSteps.length).toBe(5);
            const activeElement = flowProgressViewerElement.shadowRoot.querySelector("li[class='active']");
            expect(activeElement.textContent).toMatch(TEST_STEPS_DATA.STEPS[0].label);
        });
    });

    it('should update navigation bar with skipped steps', () => {
        const flowProgressViewerElement =
            createElementAndAddToDocument('c-flow-progress-viewer', document, flowProgressViewer, createElement);
        const slot = flowProgressViewerElement.shadowRoot.querySelector('slot');
        expect(slot).toBeTruthy();

        const eventDetail = DEFAULT_UPDATE_EVENT_DETAIL;
        eventDetail.currentStep = 3;
        eventDetail.skippedSteps = new Set([2]);
        dispatchUpdateEvent(slot, eventDetail);
        return flushPromises().then(() => {
            const renderedSteps = flowProgressViewerElement.shadowRoot.querySelectorAll('li');
            expect(renderedSteps.length).toBe(5);
            const activeElement = flowProgressViewerElement.shadowRoot.querySelector("li[class='active']");
            expect(activeElement.textContent).toMatch(TEST_STEPS_DATA.STEPS[2].label);
            const skippedElement = flowProgressViewerElement.shadowRoot.querySelector("li[class='excluded']");
            expect(skippedElement.textContent).toMatch(TEST_STEPS_DATA.STEPS[1].label);
        });
    });
})