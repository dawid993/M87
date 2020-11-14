/*
* Added test steps here because i can see at least two components which need it.
*/

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

const STEPS = [STEP_1, STEP_2, STEP_3, STEP_4, STEP_5];

const TEST_STEPS_DATA = {
    'STEP_1': STEP_1,
    'STEP_2': STEP_2,
    'STEP_3': STEP_3,
    'STEP_4': STEP_4,
    'STEP_5': STEP_5,
    'STEPS': STEPS
};


function flushPromises() {
    return new Promise(resolve => setImmediate(resolve));
}

function clearDocument(document) {
    while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
    }
}

function createElementAndAddToDocument(elementName, document, isParam, createFunction) {
    const element = createFunction(elementName, { is: isParam });
    document.body.appendChild(element);
    return element;
}

function dispatchEvent(eventName, eventDetail, srcComponent) {
    srcComponent.dispatchEvent(new CustomEvent(eventName, {
        detail: eventDetail
    }));
}

/*
* Intention for this is to replace all ungrouped function above.
* I want to group function by type like -> htmlelement, event and so on
*/

const jestUtils = {
    flushPromises: () => new Promise(resolve => setImmediate(resolve)),

    mockCheckValidityForElements: (elements = [], fn) => {
        elements.forEach(element => element.checkValidity = fn);
    },

    mockReportValidity : (elements = [], fn) => {
        elements.forEach(element => element.reportValidity = fn);
    }
};

const htmlTestUtils = {
    clearDocument: document => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    },

    createElementAndAddToDocument: (elementName, document, isParam, createFunction) => {
        const element = createFunction(elementName, { is: isParam });
        document.body.appendChild(element);
        return element;
    },

    createDraggableDiv: () => {
        const draggableDiv = document.createElement('div');
        draggableDiv.setAttribute('draggable', true);
        return draggableDiv;
    }

};

const BLUR_EVENT_NAME = 'blur';

const eventTestUtils = {
    dispatchEvent: (eventName, eventDetail, srcComponent) => {
        srcComponent.dispatchEvent(new CustomEvent(eventName, {
            detail: eventDetail
        }));
    },

    createBubbledEvent: (type, props = {}) => {
        const event = new Event(type, { bubbles: true });
        Object.assign(event, props);
        return event;
    },

    createBlurEvent : () => new Event(BLUR_EVENT_NAME) ,
}

export {
    TEST_STEPS_DATA,
    flushPromises,
    clearDocument,
    createElementAndAddToDocument,
    dispatchEvent,
    jestUtils,
    htmlTestUtils,
    eventTestUtils
}