import { LightningElement, api, track } from 'lwc';

const allowedCaseStatus = ['To Do', 'In Progress', 'Done - success', 'Done - failure']

export default class EngagementTask extends LightningElement {

    @track
    _taskCase = {}

    @api
    get taskCase() {
        return this._taskCase
    }

    set taskCase(value) {
        this._taskCase = value ? value : {}
    }

    @api
    changeCaseStatus(status) {        
        if(allowedCaseStatus.find( allowedStatus => allowedStatus === status)){
            this._taskCase.Status = status
        }
    }
}