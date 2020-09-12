import DomElementsUtils from 'c/domElementsUtils';
import { Empty,Maybe } from 'c/jsFunctional';

export default class KanbanBoardElementCreator{

    _caseIconUrl;  

    _customIconUrl;    

    _hoverFunction;   

    _dragFunction;   

    _fireViewCaseEvent;    

    _fireInvokeCaseFlowEvent;      

    get caseIconUrl() {
        return this._caseIconUrl;
    }

    set caseIconUrl(value) {
        this._caseIconUrl = value;
    }

    get customIconUrl() {
        return this._customIconUrl;
    }
    
    set customIconUrl(value) {
        this._customIconUrl = value;
    }

    get hoverFunction() {
        return this._hoverFunction;
    }
    
    set hoverFunction(value) {
        this._hoverFunction = value;
    }

    get dragFunction() {
        return this._dragFunction;
    }

    set dragFunction(value) {
        this._dragFunction = value;
    }

    get fireViewCaseEvent() {
        return this._fireViewCaseEvent;
    }
    
    set fireViewCaseEvent(value) {
        this._fireViewCaseEvent = value;
    }

    get fireInvokeCaseFlowEvent() {
        return this._fireInvokeCaseFlowEvent;
    }

    set fireInvokeCaseFlowEvent(value) {
        this._fireInvokeCaseFlowEvent = value;
    }    

    createTaskElement(caseTask) {       
        const elementsFunctions = [
            this._createTaskElementHeader.bind(this, caseTask),
            this._createCaseDescription.bind(this, caseTask),
            this._createFooterSection.bind(this, caseTask)
        ];

        return elementsFunctions.reduce(
            DomElementsUtils.divReduceAppend,
            this._createDraggableDiv(caseTask,this._dragFunction)
        );
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

    _createTaskElementHeader(caseTask){        
        const taskElementHeaderFunctions = [
            this._createCaseImage.bind(this),
            this._createCaseHeader.bind(this, caseTask),
            this._createOptionIcon.bind(this)
        ];

        const container = document.createElement('div');
        container.classList.add('task-header-container');
        return taskElementHeaderFunctions.reduce(DomElementsUtils.divReduceAppend, container);
    }

    _createCaseImage() {
        const imgSrc = document.createElement('img');
        imgSrc.setAttribute('src', this._caseIconUrl);
        imgSrc.classList.add('case-icon');

        return imgSrc;
    }

    _createCaseHeader(caseTask) {
        const header = document.createElement('h2');
        header.textContent = caseTask.Subject;

        return header;
    }

    _createOptionIcon() {
        const optionContainer = document.createElement('div');
        optionContainer.classList.add('option-container');
        const optionIcon = document.createElement('img');
        const optionBox = this._createOptionBox();

        optionIcon.setAttribute('src', this._customIconUrl);
        optionIcon.classList.add('option-icon');
        optionContainer.appendChild(optionIcon);
        optionContainer.appendChild(optionBox);

        optionContainer.onmouseover = this._onOptionContainerHover.bind(this);

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
        const footer = document.createElement('div');
        footer.classList.add('footer-container');
        footer.appendChild(this._createFooterElement('Owner', caseTask.Owner.Name));
        footer.appendChild(this._createFooterElement('Priority', caseTask.Priority));

        return footer;
    }

    _createFooterElement(label, content) {
        const footerElement = document.createElement('div');
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
        const addOptions = (elements) => elements.optionBox.appendChild(
            this._createOptionList(elements.taskElement.dataset.taskId)
        );

        Maybe(event)
        .then(event => this._findTargetOptionElements(event))
        .then(elements => Empty(elements.ulElement).then(() => addOptions(elements)));               
    }

    _findTargetOptionElements(event) {
        return {
            taskElement: event.currentTarget.closest('.task-element'),
            optionBox: event.currentTarget.querySelector('.option-box'),
            ulElement: event.currentTarget.querySelector('.option-box ul')
        };
    }

    _createOptionList(taskId) {
        const options = document.createElement('ul');
        options.appendChild(this._createCaseViewOption(taskId));
        options.appendChild(this._createInvokeFlowOption(taskId));
        
        return options;
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