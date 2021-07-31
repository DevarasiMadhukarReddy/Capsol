({

        fetchListOfRecordTypes: function(component, event, helper) {

        var action = component.get("c.fetchRecordTypeValues");

        action.setParams({

            "objectName" : "Loan_Application__c"

        });

        

        action.setCallback(this, function(response) {

            var mapOfRecordTypes = response.getReturnValue();

            component.set("v.mapOfRecordType", mapOfRecordTypes);

            var recordTypeList = [];

            //Creating recordTypeList from retrieved Map

            for(var key in mapOfRecordTypes){

                recordTypeList.push(mapOfRecordTypes[key]);

            }

            

            if(recordTypeList.length == 0){

                helper.closeModal();

                helper.showCreateRecordModal(component, "", "Loan_Application__c");

            } else{

            component.set("v.lstOfRecordType", recordTypeList);

            }

            

        });

        $A.enqueueAction(action);

    },

    

  
    createRecord: function(component, event, helper, sObjectRecord) {

        var selectedRecordTypeName = component.find("recordTypePickList").get("v.value");

        if(selectedRecordTypeName != ""){

            var selectedRecordTypeMap = component.get("v.mapOfRecordType");

            var selectedRecordTypeId;

            

            //finding selected recordTypeId from recordTypeName

            for(var key in selectedRecordTypeMap){

                if(selectedRecordTypeName == selectedRecordTypeMap[key]){

                    selectedRecordTypeId = key;//match found, set value in selectedRecordTypeId variable

                    break;

                }

            }

            //Close Quick Action Modal here

            helper.closeModal();

            

            //Calling CreateRecord modal here without providing recordTypeId

            helper.showCreateRecordModal(component, selectedRecordTypeId, "Loan_Application__c");

        } else{

            alert('You did not select any record type');

        }

        

    },

    

    /*

     * closing quickAction modal window

     * */

    closeModal : function(component, event, helper){

        helper.closeModal();

    }

})