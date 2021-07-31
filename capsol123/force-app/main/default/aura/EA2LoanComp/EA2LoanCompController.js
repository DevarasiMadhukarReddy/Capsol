({
	closeQA : function(component, event, helper) {
		if(component.get('v.classic')){
			window.parent.location='/'+component.get('v.recordId');
		}else{
			$A.get("e.force:closeQuickAction").fire();
		}
	},
    doInit:function(component, event, helper) {
        //Bhanu CS-2072 Start
         helper.checkUserPermission(component, event, helper);
          //Bhanu CS-2072 ends
       helper.checkCaseStatus(component, event, helper);
    }
})