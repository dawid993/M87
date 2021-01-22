export {
    titleValidation,
    dueDateValidation,
    noteContentValidation
};

const titleValidation = (template, elemId) => () => {
    const titleElement = template.querySelector(elemId);
    if (titleElement) {
        titleElement.showHelpMessageIfInvalid();
    }
    return titleElement ? titleElement.checkValidity() : false;
}

const dueDateValidation = (template, elemId) => () => {
    const dueDateElement = template.querySelector(elemId);
    if (dueDateElement) {
        dueDateElement.showHelpMessageIfInvalid();
    }
    return dueDateElement ? dueDateElement.checkValidity() : false;
}

const noteContentValidation = (template, elemId) => () => {
    const noteContentElement = template.querySelector(elemId);
    if (noteContentElement) {
        noteContentElement.showHelpMessageIfInvalid();
    }
    return noteContentElement ? noteContentElement.checkValidity() : false;
}
