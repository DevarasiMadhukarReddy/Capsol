({
  doInit: function(component, event, helper) {
      helper.getContactRecord(component);     
  },
 createRecord: function(component, event, helper) {
      helper.createRecordHelper(component);
   },
 
   closeModal: function(component, event, helper) {
      // set "isOpen" attribute to false for hide/close model box 
       var dismissActionPanel = $A.get("e.force:closeQuickAction");
       dismissActionPanel.fire();
   },
 
   openModal: function(component, event, helper) {
      // set "isOpen" attribute to true to show model box
      component.set("v.isOpen", true);
   },
})