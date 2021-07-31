/*
Class Name              :baqCreateEditController 
Description             :This class is mainly facus on getting OpportunityId from URL and update on BAQ__c visualforce page.

Developer Name          :Vaibhav Wadhai
Created Date            :7th july 2017    
CH-01: 11/15/2017; Naga added to check the Id of the controller ; if Id is null (New) then pass the Oppty Id to BAQ                         
*/
public class baqCreateEditController {

    public BAQ__c baq;
    public Id ids{get;set;}
    public baqCreateEditController(ApexPages.StandardController stdController) {
     Id pageId = stdController.getId();//Ch-01;11/15/2017
     ids=ApexPages.currentPage().getParameters().get('param');//Getting param value from URL which is getting from custom Button 'New BAQ'             
     System.debug('***ids'+ids);
     baq=(BAQ__c)StdController.getRecord();
     System.debug('***baq'+baq);
     if(pageId==null)//Ch-01;11/15/2017
       baq.Opportunity__c=ids;    
      
    }
    
}