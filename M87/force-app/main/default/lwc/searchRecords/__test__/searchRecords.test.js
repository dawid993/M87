import { createElement } from 'lwc';
import { flushPromises, clearDocument } from 'c/testUtility';
import searchRecords from 'c/searchRecords';

function createSearchRecordsElement(document) {
    const element = createElement('c-search-records', { is: searchRecords });
    document.body.appendChild(element);
    apexSearchFunctionMock.mockResolvedValue(searchResults);
    element.searchFunction = apexSearchFunctionMock;
    return element;
}

function dispatchOnChangeEventOnSearchField(searchRecordsElement) {
    const inputField = searchRecordsElement.shadowRoot.querySelector("lightning-input");
    inputField.value = defaultSearchPhrase;
    inputField.dispatchEvent(new CustomEvent('change'));
}

const apexSearchFunctionMock = jest.fn();
const searchResults = require('./data/searchResults.json');

const defaultSearchPhrase = 'DEFAULT SEARCH PFRASE';

describe('c-search-records', () => {
    beforeEach(() => jest.useFakeTimers());
    afterEach(() => clearDocument(document));

    it('Should perform search when search field is changed', () => {
        const searchRecordsElement = createSearchRecordsElement(document);
        dispatchOnChangeEventOnSearchField(searchRecordsElement);

        expect(apexSearchFunctionMock).not.toBeCalled();
        expect(setTimeout).toHaveBeenCalledTimes(1);

        jest.runAllTimers();
        expect(apexSearchFunctionMock).toBeCalled();

        return flushPromises().then(() => {
            const unorderedList = searchRecordsElement.shadowRoot.querySelectorAll('ul li');
            console.log(unorderedList);
            expect(unorderedList.length).toBe(2);
        });
    });

    it('Should dispatch event on element selection', () => {
        const searchRecordsElement = createSearchRecordsElement(document);
        dispatchOnChangeEventOnSearchField(searchRecordsElement);        
        
        jest.runAllTimers();   

        let eventFired = false;
        document.body.addEventListener('optionselected',() => {
            eventFired = true;
        })

        return flushPromises().then(() => {
            const liElement = searchRecordsElement.shadowRoot.querySelector('li:nth-child(1)');
            expect(liElement.dataset.id).toBe("1"); 
            liElement.click();    
            expect(eventFired).toBe(true);   
        });
    });
});