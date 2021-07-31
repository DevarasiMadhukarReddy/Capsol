({
	 doInit: function(component, event, helper) {
        helper.getDetails(component, event, helper);
         
        
    },
    onSuccess : function(component, event, helper) {
        
        component.set("v.editBaq", false);
        var sMsg = 'Record has been successfully updated.';                 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: sMsg,
            type : 'success'
        });
        toastEvent.fire();   
        helper.getDetails(component, event, helper);
         
        
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
     
    editBaqController : function(component, event, helper){
        component.set("v.editBaq", true);
        
    },
    
    cancelBaq : function(component, event, helper){
        component.set("v.editBaq", false);
        
    },
    saveBaq : function(component, event, helper){
         helper.saveBaq(component, event, helper);
        
    },
    
    deleteBaqController : function(component, event, helper){
        console.log('del>>>');
        helper.deleteBaqHelper(component, event, helper);
    },
        UpdateColor : function(component, event, helper){
        var img = component.find('pen1');
          $A.util.addClass(img,'blue');
    }
})