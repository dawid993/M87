({    
    invokeFlow : function(component,event,helper){        
        const caseTaskId = event.getParam('taskId');
        if(caseTaskId){ 
                   
            component.set('v.showFlowContainer',true);   
        }
    },

    closeFlowDialog: function (component, event, helper) {
        component.set("v.showFlowContainer", false);
    }
})
