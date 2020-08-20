({
    invokeFlow: function (component, event, helper) {
        const caseTaskId = event.getParam('taskId');
        helper.clearAllModals(component);
        if (caseTaskId) {
            component.set('v.caseId', caseTaskId);
            component.set('v.showFlowContainer', true);
        }
    },

    viewTask: function (component, event, helper) {
        const caseTaskId = event.getParam('taskId');
        helper.clearAllModals(component);
        if (caseTaskId) {
            component.set('v.caseId', caseTaskId);
            component.set('v.showViewTaskContainer', true);
        }
    },

    closeFlowDialog: function (component, event, helper) {
        component.set("v.showFlowContainer", false);
    },

    closeViewTaskDialog: function (component, event, helper) {
        component.set('v.showViewTaskContainer', false);
    }
})
