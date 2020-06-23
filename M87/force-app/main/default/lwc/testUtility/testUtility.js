function flushPromises() {
    return new Promise(resolve => setImmediate(resolve));
}

function clearDocument(document){
    while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
    }
}

function createElementAndAddToDocument(elementName,document,isParam,createFunction){
    const element = createFunction(elementName,{ is : isParam});
    document.body.appendChild(element);
    return element;
}

export {
    flushPromises,    
    clearDocument,
    createElementAndAddToDocument
}