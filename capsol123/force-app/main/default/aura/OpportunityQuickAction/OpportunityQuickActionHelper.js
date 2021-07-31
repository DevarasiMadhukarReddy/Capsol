({
    
    fetchListOfRecordTypes: function(component) {
        var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response) {
            component.set("v.lstOfRecordType", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getContactRecord: function(component, event, helper) {
        var action = component.get("c.getContact");
        
        action.setParams({
            "conId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.con",response.getReturnValue());
                this.validateContact(component);             
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    validateContact: function(component) {
        var con = component.get("v.con");
        console.log('contact is'+ con);
        if(!con){
            component.set("v.isOpen", false);
            component.set("v.validationErr", "Record data not found, Please try again.");
            return;
        }
        var fields = '';
        var isError = false;
        if(con.Email == null || con.Email.trim() == ''){
            fields += 'Email, ';
            isError = true;
        }
        if(con.MobilePhone == null || con.MobilePhone.trim() == ''){
            fields += 'Preferred Phone, ';
            isError = true;
        }
        if(con.AUM_from_other_source__c == null){
            fields += ' Unverified AUM, ';
            isError = true;
        }
        if(con.GDC_Prior_12_mo__c == null ){
            fields += 'Estimated GDC, ';
            isError = true;
        }
        if(con.AccountId == null || con.AccountId.trim() == ''){
            fields += 'Enterprise Name, ';
            isError = true;
        }
        if(con.Channel__c == null || con.Channel__c.trim() == ''){
            fields += 'Channel, ';
            isError = true;
        }
        console.log('******LeadSource ='+con.Lead_Source__c);
        /*if(con.Lead_Source__c == null){
            fields += 'Lead Source, ';
            isError = true;
        }
        if(con.Source_Type_Prospect__c == null){
            fields += 'Source Type, ';
            isError = true;
        }*/
      
        
        var externalFields = '';
        var isExternalFieldsError = false;
        if(this.isExtrnalFieldValidationRequired(component)){
            if(con.Outside_Recruiting_Firm_Fee__c == null){
                externalFields += 'Outside Recruiting Firm Fee, ';
                isExternalFieldsError = true;
            }
            if(con.Outside_Recruiting_Firm_Name__c == null || con.Outside_Recruiting_Firm_Name__c.trim() == ''){
                externalFields += 'Outside Recruiting Firm Name, ';
                isExternalFieldsError = true;
            }
            /*if(con.Outside_Recruiting_Firm_Payout__c == null){
                externalFields += 'Outside Recruiting Firm Payout, ';
                isExternalFieldsError = true;
            }*/
            if(con.Lead_Approval_Date__c == null){
                externalFields += 'Lead Approval Date, ';
                isExternalFieldsError = true;
            }
        }
        
        console.log("-isError-"+isError);
        console.log("-isExternalFieldsError-"+isExternalFieldsError);
        
        if(isExternalFieldsError){
            externalFields = externalFields.substring(0, externalFields.length - 2);
            component.set("v.externalFieldValidationErr", "To Create Opportunity Please provide External Fields : "+externalFields+" on related contact record.");
            component.set("v.isOpen", false)
            return;
        }else if(this.isExtrnalFieldValidationRequired(component) && !isExternalFieldsError){
            component.set("v.isOpen", true);
            this.fetchListOfRecordTypes(component);            
        }else if(isError){
            fields = fields.substring(0, fields.length - 2);
            component.set("v.validationErr", "To Create an Opportunity please provide "+fields+" on related contact record.");
            component.set("v.isOpen", false)
            return;
        }else{
            component.set("v.isOpen", true);
            this.fetchListOfRecordTypes(component); 
        }
        
        /*if(!isError && !isExternalFieldsError){  //if(!isError || !isExternalFieldsError){
            component.set("v.isOpen", true);
            this.fetchListOfRecordTypes(component);
        }else{
            if(isExternalFieldsError){
                externalFields = externalFields.substring(0, externalFields.length - 2);
                component.set("v.externalFieldValidationErr", "To Create Opportunity Please provide External Fields : "+externalFields+" on related contact record.");
                component.set("v.isOpen", false)
                return;
            }else if(isError){
                fields = fields.substring(0, fields.length - 2);
                component.set("v.validationErr", "To Create Opportunity Please provide "+fields+" on related contact record.");
                component.set("v.isOpen", false)
                return;
            }
        }*/
    },
   	isExtrnalFieldValidationRequired: function(component){
        var con = component.get("v.con");
        if((con.Outside_Recruiting_Firm_Name__c != null && con.Outside_Recruiting_Firm_Name__c.trim() != '') || 
           con.Outside_Recruiting_Firm_Fee__c != null || 
           con.Outside_Recruiting_Firm_Payout__c != null || con.Lead_Approval_Date__c != null)
        {
            return true;
        }else
        {
        	return false;    
        }
	},
    createRecordHelper: function(component) {
        component.set("v.isOpen", true);
        
        var action = component.get("c.getRecTypeId");
        
        var recordTypeLabel = component.find("selectid").get("v.value");
        var con = component.get("v.con");
        action.setParams({
            "recordTypeLabel": recordTypeLabel
        });
        console.log('value of recordtype labe is'+ recordTypeLabel);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var createRecordEvent = $A.get("e.force:createRecord");
                var RecTypeID  = response.getReturnValue();
                var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                console.log("Record type id is"+RecTypeID);
                console.log("Contact is"+component.get("v.recordId"));
                if(RecTypeID=='012U0000000Z8ypIAC'){
                console.log("Inside if");  
                console.log("value of date is "+ new Date(new Date().getFullYear(),new Date().getMonth(),new Date().getDate()));
                    var cd = (String)(new Date(new Date().getFullYear(),new Date().getMonth(),new Date().getDate()));
                    var todaydate=new Date();
                    createRecordEvent.setParams({
                    "entityApiName": 'Opportunity',
                    "recordTypeId": RecTypeID,
                    'defaultFieldValues': {
                        'Contact__c' : component.get("v.recordId"),
                        AccountId : con.AccountId, 
                        'Name': con.Name,
                        'CloseDate' : today
                       
                        
                    }
                });
                }else{
                console.log("Inside else");    
                createRecordEvent.setParams({
                    "entityApiName": 'Opportunity',
                    "recordTypeId": RecTypeID,
                    'defaultFieldValues': {
                        'Contact__c' : component.get("v.recordId"),
                        AccountId : con.AccountId,
                        'CloseDate' : new Date(new Date().getFullYear(),new Date().getMonth(),new Date().getDate()) 
                        
                        
                    }
                });
            
                }
                createRecordEvent.fire();
                
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})