import { LightningElement } from 'lwc';

export default class StepListener {
    _listeners;

    constructor() {
        this._listeners = new Map();
    }

    register(stepName,stepListenerFunction){
        if(!stepName && !stepListenerFunction){
            throw new Error('Cannot register such listener.');           
        }

        if(this._listeners.has(stepName)){
            throw new Error('Step is already registered.');
        }
        
        this._listeners.set(stepName,stepListenerFunction);
    }

    onStep(stepName,stepData){
        if(this._listeners.has(stepName)){
            const func = this._listeners.get(stepName);            
            func(stepData);
        }
    }

}