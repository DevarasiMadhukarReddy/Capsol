({
	//Bhanu CS-2072 Start  
    doInit: function (component, event, helper) {
       helper.checkUserPermission(component, event, helper);

    },
    //Bhanu CS-2072 ends
    closeQA : function(component, event, helper) {
		if(component.get('v.classic')){
			window.parent.location='/'+component.get('v.recordId');
		}else{
			$A.get("e.force:closeQuickAction").fire();
		}
	}
})