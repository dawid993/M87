import KanbanBoardElementCreator from 'c/kanbanBoardElementCreator';

export default class KanbanBoardElementCreatorBuilder{

    _kanbanBoardElementCreator;

    constructor(){
        this._kanbanBoardElementCreator = new KanbanBoardElementCreator();
    }

    setCaseIconUrl(iconUrl){
        this._kanbanBoardElementCreator.caseIconUrl = iconUrl;
        return this;
    }

    setCustomIconUrl(iconUrl){
        this._kanbanBoardElementCreator.customIconUrl = iconUrl;
        return this;
    }

    setHoverFunction(hoverFunction){
        this._kanbanBoardElementCreator.hoverFunction = hoverFunction;
        return this;
    }

    setDragFunction(dragFunction){
        this._kanbanBoardElementCreator.dragFunction = dragFunction;
        return this;
    }

    setFireViewCaseEventFunction(func){
        this._kanbanBoardElementCreator.fireViewCaseEvent = func;
        return this;
    }

    setFireInvokeCaseFlowEventFunction(func){
        this._kanbanBoardElementCreator.fireInvokeCaseFlowEvent = func;
        return this;
    }

    build(){        
        return this._kanbanBoardElementCreator;
    }
}