function flushPromises() {
    return new Promise(resolve => setImmediate(resolve));
}

function clearDocument(document){
    while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
    }
}

export {
    flushPromises,    
    clearDocument
}