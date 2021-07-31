@istest
public class testManageRecordsController {
 
    public static testmethod void ManageRecordController(){
        Id recordId;
        String searchString='test';
        String selectedSObject='contact'; 
        Integer recordLimit=5;
        LoanDetailController ldc= new LoanDetailController ();
        LoanDetailController.recordInfo(recordid);   
         Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
              
        test.startTest();
        ManageRecordsController Mrc = new ManageRecordsController();
        
        ManageRecordsController.getLookupSerachRecords(searchString,selectedSObject,recordLimit); 
        
       // ManageRecordsController.getLookupSerachRecords(ct1.name,ct1,recordLimit); 
        test.stoptest();
         
    }

}