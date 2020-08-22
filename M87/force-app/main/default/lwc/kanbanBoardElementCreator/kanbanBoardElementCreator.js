import DomElementsUtils from 'c/domElementsUtils';

export default class KanbanBoardElementCreator{

    _caseIconUrl;

    _customIconUrl;

    _hoverFunction;

    _dragFunction;

    _fireViewCaseEvent;

    _fireInvokeCaseFlowEvent

    constructor(caseIconUrl, customIconUrl,dragFunction,fireViewCaseEvent,fireInvokeCaseFlowEvent){
        this._caseIconUrl = caseIconUrl;
        this._customIconUrl = customIconUrl;       
        this._dragFunction = dragFunction;
        this._fireViewCaseEvent = fireViewCaseEvent;
        this._fireInvokeCaseFlowEvent = fireInvokeCaseFlowEvent;
    }

    createTaskElement(caseTask) {
        const elementsFunctions = [
            this._createTaskElementHeader.bind(this, caseTask,this._caseIconUrl,this._customIconUrl,this._onOptionContainerHover.bind(this)),
            this._createCaseDescription.bind(null, caseTask),
            this._createFooterSection.bind(this, caseTask)
        ];

        return elementsFunctions.reduce(DomElementsUtils.divReduceAppend, this._createDraggableDiv(caseTask,this._dragFunction));
    }

    _createDraggableDiv(caseTask,dragFunction) {        
        const divContainer = document.createElement('div');
        divContainer.setAttribute('data-task-id', caseTask.Id);
        divContainer.setAttribute('data-task-status', caseTask.Status);
        divContainer.setAttribute('class', 'task-element');
        divContainer.setAttribute('draggable', true);
        divContainer.ondragstart = dragFunction;

        return divContainer;
    }

    _createTaskElementHeader(caseTask,caseIconUrl,customIconUrl,hoverFunction){        
        const taskElementHeaderFunctions = [
            this._createCaseImage.bind(this,caseIconUrl),
            this._createCaseHeader.bind(this, caseTask),
            this._createOptionIcon.bind(this,customIconUrl,hoverFunction)
        ];

        const container = document.createElement('div');
        container.classList.add('task-header-container');
        return taskElementHeaderFunctions.reduce(DomElementsUtils.divReduceAppend, container);
    }

    _createCaseImage(caseIconUrl) {
        const imgSrc = document.createElement('img');
        imgSrc.setAttribute('src', caseIconUrl);
        imgSrc.classList.add('case-icon');

        return imgSrc;
    }

    _createCaseHeader(caseTask) {
        const header = document.createElement('h2');
        header.textContent = caseTask.Subject;

        return header;
    }

    _createOptionIcon(customIconUrl,hoverFunction) {
        const optionContainer = document.createElement('div');
        optionContainer.classList.add('option-container');
        const optionIcon = document.createElement('img');
        const optionBox = this._createOptionBox();

        optionIcon.setAttribute('src', customIconUrl);
        optionIcon.classList.add('option-icon');
        optionContainer.appendChild(optionIcon);
        optionContainer.appendChild(optionBox);

        optionContainer.onmouseover = hoverFunction;

        return optionContainer;
    }

    _createOptionBox() {
        const optionBox = document.createElement('div');
        optionBox.classList.add('option-box');
        return optionBox;
    }

    _createCaseDescription(caseTask) {
        const description = document.createElement('div');
        description.setAttribute('class', 'description');
        description.textContent = caseTask.Description;
        return description;
    }

    _createFooterSection(caseTask) {
        const footer = document.createElement('div')
        footer.classList.add('footer-container');
        footer.appendChild(this._createFooterElement('Owner', caseTask.Owner.Name));
        footer.appendChild(this._createFooterElement('Priority', caseTask.Priority));

        return footer;
    }

    _createFooterElement(label, content) {
        const footerElement = document.createElement('div')
        footerElement.classList.add('footer-element');
        const labelDiv = document.createElement('div');
        labelDiv.textContent = label;
        const valueDiv = document.createElement('div');
        valueDiv.textContent = content;

        footerElement.appendChild(labelDiv);
        footerElement.appendChild(valueDiv);

        return footerElement;
    }

    _onOptionContainerHover(event) {
        if (event.currentTarget) {
            const taskElement = event.currentTarget.closest('.task-element');
            const optionBox = event.currentTarget.querySelector('.option-box');
            const ulElement = event.currentTarget.querySelector('.option-box ul');

            if (!ulElement) {
                const options = document.createElement('ul');
                options.appendChild(this._createCaseViewOption(taskElement.dataset.taskId));
                options.appendChild(this._createInvokeFlowOption(taskElement.dataset.taskId));
                optionBox.appendChild(options);
            }
        }
    }

    _createCaseViewOption(taskId) {
        const caseViewOption = document.createElement('li');
        caseViewOption.textContent = 'View Case';
        caseViewOption.onclick = this._fireViewCaseEvent(taskId);
        return caseViewOption;
    }

    _createInvokeFlowOption(taskId) {
        const invokeFlowOption = document.createElement('li');
        invokeFlowOption.textContent = 'Invoke Flow';
        invokeFlowOption.setAttribute('data-task-id', taskId);
        invokeFlowOption.onclick = this._fireInvokeCaseFlowEvent(taskId);

        return invokeFlowOption;
    }
}