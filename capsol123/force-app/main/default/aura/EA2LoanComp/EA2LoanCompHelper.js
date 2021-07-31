({
	  //Bhanu CS-2072 Start
	  checkUserPermission: function (component, event, helper) {
         var action = component.get('c.checkLoggedInUserAccess');
          action.setParams({
            "source": "Case"
        });
         action.setCallback(this, function (response) {
                         if (response.getReturnValue()==false){
                 alert('You do not have the level of access necessary to perform the operation you requested.');
           	     $A.get("e.force:closeQuickAction").fire();
            }else{
               //this.checkCaseStatus(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
     //Bhanu CS-2072 ends
    checkCaseStatus : function(component,event,helper) {
        
		var act=component.get('c.collectCaseStatus');
        act.setParams({'recordId':component.get('v.recordId')});
        act.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                if(resp.getReturnValue()!=null){
                    console.log(resp.getReturnValue());
                    component.set('v.CaseDetails',resp.getReturnValue());
                    component.set('v.showLoanComp',true);
                }else{
                    component.set('v.showErrorComp',true);
                }
            }else{
                alert('please check with your Administrator!');
            }
        });
        $A.enqueueAction(act);
                       
	}
})