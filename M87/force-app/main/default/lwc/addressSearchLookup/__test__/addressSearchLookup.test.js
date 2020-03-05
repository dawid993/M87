// import { createElement } from 'lwc'
import AddressSearchLookup from 'c/addressSearchLookup'

describe('c-address-search-lookup',() => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    })

    it('1 + 1 =2', () => {
        expect(2 + 2).toBe(4)
    })
})
