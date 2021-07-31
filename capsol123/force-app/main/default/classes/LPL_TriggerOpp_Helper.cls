public class LPL_TriggerOpp_Helper {
    public static Boolean runOnce = true;
    /*
##############Change History#############
CH.No       Description                                              Developer         Date
------------------------------------------------------------------------------------------------
CH-01     As part LBS Project changed the stage name, added 
Qualification stage logic and optimized the code                     Rinku Yadav       02/08/2021

CH-02     As part of LBSFNS-203/TASK0409034 the code has been        Rajnarayanan R    06/04/2021
updated with new condition for the updation of related contacts.

CH-03     As part of LBSFNS-345 the code has been updated with       Rajnarayanan R    03/06/2021
new condition for the updation of account field whenever             
contact is changes for Business Solutions Opportunity.

CH-04    User Story LBSFNS-226 Promo Codes on Opportunity             Anil Mannuru      06/21/2021

CH-05    As part of LBS project 101 SOQL fix                          Rinku Yadav       07/09/2021
*/
    // BUS1: Update the Business Solutions Statuses in Contact Object 
    public static void OpportunityCreateandUpdate(List<Opportunity> oppList,Map<Id, Opportunity> newmap,Map<Id, Opportunity> oppOldMap)
    { 
        
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();        
        /******CH-01: Commented the boolean********/
        //if( StaticFunction.runOnce() )
        //{
        Set<ID> OPPIDs = New Set<ID>();
        Set<ID> ConIds = new Set<ID>();
        list<contact> ConUp = new list<contact>();
        map<id,contact> ConMap= new map<id,contact>();
        Map<Id, Id> contactIdOpportunityMap = new Map<Id, Id>();
        /******CH-01: Added OppMap********/
        Map<Id, Opportunity> oppMap =new Map<Id, Opportunity>();
        
        for(Opportunity O : oppList)
        {
            /*****CH-05: Added the oppOldMap and newMap Cndition*******/
            if( o.RecordTypeId == OppRecordTypeId && (oppOldMap.get(o.Id).Type != newmap.get(o.Id).Type || oppOldMap.get(o.Id).Stagename != newmap.get(o.Id).Stagename) )
            {
                OPPIDs.add(O.ID);
                oppMap.put(o.Id,o);             
            }
        }        
        
        if( OPPIDs.size()>0 )
        {
            /**for(OpportunityContactRole OCR :[select id,opportunity.Contact__c,ContactId,OpportunityId,opportunity.CreatedDate From OpportunityContactRole where OpportunityId in : OPPIDs]){

// ConIds.add(OCR.opportunity.Contact__c);
ConIds.add(OCR.ContactId);
if(!contactIdOpportunityMap.containsKey(OCR.opportunity.Contact__c)){
contactIdOpportunityMap.put(OCR.opportunity.Contact__c,OCR.OpportunityId);

}
}**/
            /******CH-01: Removed the opportunity SOQL Query********/
            for(opportunity o : oppMap.values())
            {
                ConIds.add(o.Contact__c);
                if( !contactIdOpportunityMap.containsKey(o.Contact__c) )
                {
                    contactIdOpportunityMap.put(o.Contact__c,o.id);
                }
            }
            
        }
        /******CH-01 : Start********/
        If(ConIds != null && ConIds.size() > 0)
        {   
            List<Contact> conList = [SELECT id,lastname, Experiment_s__c,Experiment_s_Other_Reason__c,IAO_Advisor_Interest__c,CFO_Solutions_Status__c,
                                     Technology_Solutions_Subscription_Type__c,Technology_Solutions_Lead_Source_Type__c,Resilience_Plan_Solutions_Status__c
                                     FROM contact 
                                     WHERE id in : ConIds ];
            /*for(contact c : conList)
{
ConMap.put(c.id,c);
}*/
            /******CH-01 : End********/
            for(contact c : conList)
            {   
                ConMap.put(c.id,c);
                if( contactIdOpportunityMap.containsKey(c.Id) )
                {
                    if( newmap.containsKey(contactIdOpportunityMap.get(c.Id)) )
                    {
                        opportunity o = newmap.get(contactIdOpportunityMap.get(c.Id));
                        if((o.StageName== 'Engaged opportunity' 
                            || o.StageName== 'Influenced opportunity'
                            || o.StageName== 'Contract sent') )
                        {
                            if( o.Type == 'Marketing Solution' 
                               &&  ((ConMap.get(c.id).Experiment_s__c != 'Active') && (ConMap.get(c.id).Experiment_s__c != 'Closed-Won')) )
                            {
                                c.Experiment_s__c = 'Sales Qualified lead';
                                ConUp.add(c); 
                            }
                            else if( o.Type == 'Technology Solution' 
                                    &&  ((ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Active') && (ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Closed-Won')) )
                            {
                                c.Experiment_s_Other_Reason__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Admin Solution' 
                                    &&  ((ConMap.get(c.id).IAO_Advisor_Interest__c != 'Active') && (ConMap.get(c.id).IAO_Advisor_Interest__c != 'Closed-Won')) )
                            {
                                c.IAO_Advisor_Interest__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Finance Solution' 
                                    &&  ((ConMap.get(c.id).CFO_Solutions_Status__c != 'Active') && (ConMap.get(c.id).CFO_Solutions_Status__c != 'Closed-Won')) )
                            {
                                c.CFO_Solutions_Status__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }/******CH-02 : Start********/
                            else if( o.Type == 'LPL Assurance' 
                                    &&  ((ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Active') && (ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Closed-Won')) )
                            {                                
                                c.Technology_Solutions_Subscription_Type__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'M&A Solution-Premium Buyer Program' 
                                    &&  ((ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Active') && (ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Closed-Won')) )
                            {                                
                                c.Technology_Solutions_Lead_Source_Type__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Resilience Plan' 
                                    &&  ((ConMap.get(c.id).Resilience_Plan_Solutions_Status__c   != 'Active') && (ConMap.get(c.id).Resilience_Plan_Solutions_Status__c   != 'Closed-Won')) )
                            {                                
                                c.Resilience_Plan_Solutions_Status__c    = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            /******CH-02 : End********/
                        }
                        /******CH-01 : Start********/
                        if( o.StageName=='Qualification' )
                        {
                            if( o.Type == 'Marketing Solution'
                               && ((ConMap.get(c.id).Experiment_s__c != 'Active') && (ConMap.get(c.id).Experiment_s__c != 'Closed-Won') ) )                   
                            {
                                c.Experiment_s__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Technology Solution' 
                                    && ((ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Active') && (ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Closed-Won' )) )
                            {
                                c.Experiment_s_Other_Reason__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Admin Solution' 
                                    && ( (ConMap.get(c.id).IAO_Advisor_Interest__c != 'Active') && (ConMap.get(c.id).IAO_Advisor_Interest__c != 'Closed-Won')) )
                            {
                                c.IAO_Advisor_Interest__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Finance Solution' 
                                    && ((ConMap.get(c.id).CFO_Solutions_Status__c != 'Active') && (ConMap.get(c.id).CFO_Solutions_Status__c != 'Closed-Won')) )
                            {
                                c.CFO_Solutions_Status__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            /******CH-02 : Start********/
                            else if( o.Type == 'LPL Assurance' 
                                    &&  ((ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Active') && (ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Closed-Won')) )
                            {                               
                                c.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'M&A Solution-Premium Buyer Program' 
                                    &&  ((ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Active') && (ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Closed-Won')) )
                            {                               
                                c.Technology_Solutions_Lead_Source_Type__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Resilience Plan' 
                                    &&  ((ConMap.get(c.id).Resilience_Plan_Solutions_Status__c   != 'Active') && (ConMap.get(c.id).Resilience_Plan_Solutions_Status__c   != 'Closed-Won')) )
                            {                               
                                c.Resilience_Plan_Solutions_Status__c    = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            /******CH-02 : End********/
                        }
                        /******CH-01 : Ends********/
                        if( o.StageName=='Closed-Won' )
                        {
                            if( o.Type == 'Marketing Solution' && ConMap.get(c.id).Experiment_s__c != 'Active' )
                            {
                                c.Experiment_s__c = 'Closed-Won';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Technology Solution' && ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Active' )
                            {
                                c.Experiment_s_Other_Reason__c = 'Closed-Won';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Admin Solution' && ConMap.get(c.id).IAO_Advisor_Interest__c != 'Active' )
                            {
                                c.IAO_Advisor_Interest__c = 'Closed-Won';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Finance Solution' && ConMap.get(c.id).CFO_Solutions_Status__c != 'Active' )
                            {
                                c.CFO_Solutions_Status__c = 'Closed-Won';
                                ConUp.add(c);
                            }
                            /******CH-02 : Start********/
                            else if( o.Type == 'LPL Assurance' &&  ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Active')
                            {                               
                                c.Technology_Solutions_Subscription_Type__c = 'Closed-Won';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'M&A Solution-Premium Buyer Program' &&  ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Active')
                            {                               
                                c.Technology_Solutions_Lead_Source_Type__c = 'Closed-Won';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Resilience Plan' &&  ConMap.get(c.id).Resilience_Plan_Solutions_Status__c    != 'Active')
                            {                               
                                c.Resilience_Plan_Solutions_Status__c    = 'Closed-Won';
                                ConUp.add(c);
                            }
                            /******CH-02 : End********/
                        } 
                        
                        if( o.StageName=='Closed-Lost' )
                        {
                            if( o.Type == 'Marketing Solution'
                               && ((ConMap.get(c.id).Experiment_s__c != 'Active') && (ConMap.get(c.id).Experiment_s__c != 'Closed-Won') ) )                   
                            {
                                c.Experiment_s__c = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Technology Solution' 
                                    && ((ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Active') && (ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Closed-Won' )) )
                            {
                                c.Experiment_s_Other_Reason__c = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Admin Solution' 
                                    && ( (ConMap.get(c.id).IAO_Advisor_Interest__c != 'Active') && (ConMap.get(c.id).IAO_Advisor_Interest__c != 'Closed-Won')) )
                            {
                                c.IAO_Advisor_Interest__c = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            
                            else if( o.Type == 'Finance Solution' 
                                    && ((ConMap.get(c.id).CFO_Solutions_Status__c != 'Active') && (ConMap.get(c.id).CFO_Solutions_Status__c != 'Closed-Won')) )
                            {
                                c.CFO_Solutions_Status__c = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            /******CH-02 : Start********/
                            else if( o.Type == 'LPL Assurance' 
                                    &&  ((ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Active') && (ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Closed-Won')) )
                            {                               
                                c.Technology_Solutions_Subscription_Type__c = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'M&A Solution-Premium Buyer Program' 
                                    &&  ((ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Active') && (ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Closed-Won')) )
                            {                               
                                c.Technology_Solutions_Lead_Source_Type__c = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Resilience Plan' 
                                    &&  ((ConMap.get(c.id).Resilience_Plan_Solutions_Status__c   != 'Active') && (ConMap.get(c.id).Resilience_Plan_Solutions_Status__c   != 'Closed-Won')) )
                            {                               
                                c.Resilience_Plan_Solutions_Status__c    = 'Closed-Lost';
                                ConUp.add(c);
                            }
                            /******CH-02 : End********/
                        }
                    }
                }
            }
        }
        /******CH-01 : Added the Null check********/
        if(ConUp != null && ConUp.size() > 0 )
        {
            update ConUp;
        }
        //}
    }
    // BUS3--Update Business Solution status when opportunity stage is reversed
    public static void OpportunityCreateandUpdateReverse(List<Opportunity> oppList,Map<Id, Opportunity> newMap,Map<Id, Opportunity> oldMap)
    {
        /******CH-01 : Commented Boolean check********/
        //if( StaticFunction.runOnce() )
        //{
        Set<ID> OPPIDs = New Set<ID>();
        Set<ID> OldoPPIDs = New Set<ID>();
        Set<ID> ConIds = new Set<ID>();
        list<contact> ConUp = new list<contact>();
        map<id,contact> ConMap= new map<id,contact>();
        Map<Id, Id> contactIdOpportunityMap = new Map<Id, Id>();
        /******CH-01 : Added oppMap********/
        Map<Id, Opportunity> oppMap =  new Map<Id, Opportunity>();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        
        for(Opportunity o : oppList)
        {
            /*****CH-05: Added the oppOldMap and newMap Cndition*******/
            if( o.RecordTypeId == OppRecordTypeId && (oldMap.get(o.Id).Type != newMap.get(o.Id).Type || oldMap.get(o.Id).Stagename != newMap.get(o.Id).Stagename) )
            {
                //OPPIDs.add(O.ID);
                oppMap.put(o.id,o);
            }
        }
        
        if( oppMap.size()>0 )
        {
            /* for(OpportunityContactRole OCR :[select id,opportunity.Contact__c, ContactId,OpportunityId,opportunity.CreatedDate 
*                                   From OpportunityContactRole 
*                                   where OpportunityId in : OPPIDs 
*                                   ORDER BY opportunity.CreatedDate DESC])
* {
ConIds.add(OCR.opportunity.Contact__c);
if(!contactIdOpportunityMap.containsKey(OCR.opportunity.Contact__c))
{
contactIdOpportunityMap.put(OCR.opportunity.Contact__c,OCR.OpportunityId);
}
} 
*/
            for(opportunity o : oppMap.values())
            {
                ConIds.add(o.Contact__c);
                if( !contactIdOpportunityMap.containsKey(o.Contact__c) )
                {
                    contactIdOpportunityMap.put(o.Contact__c,o.id);
                }
            }
        }
        /******CH-01 : Start********/
        if(ConIds != null && ConIds.size() > 0)
        {
            List<Contact> conList = [SELECT id,lastname, Experiment_s__c,Experiment_s_Other_Reason__c,IAO_Advisor_Interest__c,CFO_Solutions_Status__c,Technology_Solutions_Subscription_Type__c,Resilience_Plan_Solutions_Status__c,Technology_Solutions_Lead_Source_Type__c
                                     FROM contact 
                                     WHERE id in : ConIds ];
            
            /*for(contact c : conList)
{
ConMap.put(c.id,c);
}*/
            /******CH-01 : End********/
            for(contact c : conList)
            {
                ConMap.put(c.id,c);
                if( contactIdOpportunityMap.containsKey(c.Id) )
                {
                    if( newMap.containsKey(contactIdOpportunityMap.get(c.Id)) )
                    {
                        opportunity o = newMap.get(contactIdOpportunityMap.get(c.Id));
                        if( ( oldMap.get(o.id).StageName == 'Closed-Won' || oldMap.get(o.id).StageName == 'Closed-Lost') 
                           && (o.StageName == 'Engaged opportunity' || o.StageName == 'Influenced opportunity'||o.StageName == 'Contract sent') )
                        {
                            if( o.Type == 'Marketing Solution' && ConMap.get(c.id).Experiment_s__c != 'Active' )
                            {
                                c.Experiment_s__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Technology Solution' && ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Active' )
                            {
                                c.Experiment_s_Other_Reason__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Admin Solution' && ConMap.get(c.id).IAO_Advisor_Interest__c != 'Active' )
                            {
                                c.IAO_Advisor_Interest__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Finance Solution' && ConMap.get(c.id).CFO_Solutions_Status__c != 'Active' )
                            {
                                c.CFO_Solutions_Status__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            /******CH-02 : Start********/
                            else if( o.Type == 'LPL Assurance' && ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Active')
                            {                               
                                c.Technology_Solutions_Subscription_Type__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'M&A Solution-Premium Buyer Program' && ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Active')
                            {                               
                                c.Technology_Solutions_Lead_Source_Type__c = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Resilience Plan' &&  ConMap.get(c.id).Resilience_Plan_Solutions_Status__c    != 'Active')
                            {                               
                                c.Resilience_Plan_Solutions_Status__c    = 'Sales Qualified lead';
                                ConUp.add(c);
                            }
                            /******CH-02 : End********/
                        }
                        /******CH-01 : Start********/
                        if( ( oldMap.get(o.id).StageName == 'Closed-Won' || oldMap.get(o.id).StageName == 'Closed-Lost') 
                           && (o.StageName == 'Qualification') )
                        {
                            if( o.Type == 'Marketing Solution' && ConMap.get(c.id).Experiment_s__c != 'Active' )
                            {
                                c.Experiment_s__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Technology Solution' && ConMap.get(c.id).Experiment_s_Other_Reason__c != 'Active' )
                            {
                                c.Experiment_s_Other_Reason__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Admin Solution' && ConMap.get(c.id).IAO_Advisor_Interest__c != 'Active' )
                            {
                                c.IAO_Advisor_Interest__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Finance Solution' && ConMap.get(c.id).CFO_Solutions_Status__c != 'Active' )
                            {
                                c.CFO_Solutions_Status__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }     
                            /******CH-02 : Start********/
                            else if( o.Type == 'LPL Assurance' && ConMap.get(c.id).Technology_Solutions_Subscription_Type__c != 'Active')
                            {                   
                                c.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'M&A Solution-Premium Buyer Program' && ConMap.get(c.id).Technology_Solutions_Lead_Source_Type__c != 'Active')
                            {           
                                c.Technology_Solutions_Lead_Source_Type__c = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            else if( o.Type == 'Resilience Plan' &&  ConMap.get(c.id).Resilience_Plan_Solutions_Status__c    != 'Active')
                            {               
                                c.Resilience_Plan_Solutions_Status__c    = 'Pre-Qualified lead';
                                ConUp.add(c);
                            }
                            /******CH-02 : End********/
                        }
                        /******CH-01 : End********/
                    }
                }
            }
        }
        /******CH-01 : Added the Null check********/
        if( ConUp.size() > 0 && ConUp != null)
        {
            update ConUp;
        }
        // }
    }
    // BUS8  Restrict from Creating Multiple Opportunities for an Opportunity Contact Role
    /* LBSFNS- Commented this block as part of LBS 07/2021 release */
    /*
    public static void restrictMultipleOpties (List<Opportunity> oppList)
    {
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        List<opportunity> newOpportunities = new List<Opportunity>();
        Map<String,ID> opportunityContactMap=new Map<String,ID>();
        set<Id> OppConIds = new set<Id>();
        for(opportunity Opty: oppList)
        {
            if( Opty.recordtypeid == OppRecordTypeId && Opty.Contact__c != null )
            {
                newOpportunities.add(Opty);
                OppConIds.add(Opty.Contact__c);
            }
        }
        for(OpportunityContactRole ocr : [SELECT id,opportunityID,Role,IsPrimary,contactid,opportunity.Type 
                                          FROM OpportunityContactRole 
                                          WHERE contactID in :OppConIds 
                                          AND ( Opportunity.StageName = 'Qualification' OR Opportunity.StageName = 'Engaged opportunity' OR Opportunity.StageName = 'Influenced opportunity' OR Opportunity.StageName = 'Contract sent') 
                                          AND (Opportunity.type = 'M&A Solution-Premium Buyer Program' OR Opportunity.type = 'LPL Assurance' OR Opportunity.type = 'Resilience Plan' OR Opportunity.type = 'Marketing Solution' OR Opportunity.type = 'Technology Solution' OR Opportunity.Type= 'Admin Solution' OR Opportunity.Type = 'Finance Solution') 
                                          AND Role = 'Business User'])
        {
            opportunityContactMap.put(ocr.contactid+ocr.opportunity.Type,ocr.opportunityID);
        }
        for(opportunity opp : newOpportunities)
        {
            if( opp.StageName == 'Engaged opportunity' 
               || opp.StageName == 'Influenced opportunity' 
               || opp.StageName == 'Contract sent' )
            {
                if( opportunityContactMap.containsKey(opp.contact__c+opp.Type) )
                {
                    //opp.addError('Open Opportunity exist for Product Type and Contact');
                }
            }
        }
    }*/   
    /**********************CH-03 Start***************************/        
    public static void updateOpportunityAccounts(List<Opportunity> oppList, Map<Id, Opportunity> oldOppMap) {
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        List<Opportunity> lbsOppList = new List<Opportunity>();
        Set<Id> contactIds = new Set<Id>();
        
        for(Opportunity op: oppList){
            if((oppRecordTypeId == op.RecordTypeId) && (op.Contact__c != oldOppMap.get(op.Id).Contact__c)){
                 contactIds.add(op.Contact__c);
                 lbsOppList.add(op);
            }
        }
        if(!contactIds.isEmpty()){
            Map<Id,Contact> contactAccMap = new Map<Id,Contact>([SELECT Id,AccountId FROM Contact WHERE Id IN: contactIds]);
            for(Opportunity op: lbsOppList){
                 op.AccountId = contactAccMap.get(op.Contact__c).AccountId;
            }
        }
    }
    /**********************CH-03 End*****************************/

    /*******************CH-04 Start******************************/
    public static void processPromoCode(List<Opportunity> oppList, Map<Id, Opportunity> oldOppMap){
        Id busSolRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        Set<Id> promoIds = new Set<Id>();
        Map<Id,Promo_Code__c> oppPromoCodeMap = new Map<Id,Promo_Code__c>();
        List<Opportunity> opList = new List<Opportunity>();
        List<Opportunity> opPromoPrdDelList = new List<Opportunity>();
        Map<Id,OpportunityLineItem> oppLineItemMap = new Map<Id,OpportunityLineItem>();
        OpportunityLineItem opProduct;
        List<OpportunityLineItem> opLineItemList = new List<OpportunityLineItem>();
        String promoProductName = System.Label.LBS_PROMOCODE_PRODUCT;
        OpportunityLineItem promoOpp;// = new OpportunityLineItem();
        Decimal totalAmt =0.0;  
        for(Opportunity op : oppList){
            //For recordtype check, promocode and opporutnity amount check 
            if(op.RecordTypeId == busSolRecordTypeId && op.IsClosed == false) {
                if(op.LBS_Promo_Code__c != null && op.Amount >0 &&
                  (op.LBS_Promo_Code__c != oldOppMap.get(op.Id).LBS_Promo_Code__c) ||
                   (op.Amount != oldOppMap.get(op.Id).Amount)){
                        promoIds.add(op.LBS_Promo_Code__c);
                        opList.add(op);
                    }
                    else if((op.LBS_Promo_Code__c != oldOppMap.get(op.Id).LBS_Promo_Code__c) && 
                             op.LBS_Promo_Code__c == null){
                                opPromoPrdDelList.add(op);    
                    }
            }
        }
        // delete 'opportunity product' if promo code is removed from Opporutnity
        if(!opPromoPrdDelList.isEmpty()){
            try{
                OpportunityLineItem opLineItem = [SELECT Id,OpportunityId,Product2Id, Product2.Name,
                                                         Product2.ProductCode,UnitPrice,ListPrice,TotalPrice 
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId IN :opPromoPrdDelList 
                                                      AND Product2Id = :promoProductName limit 1];
                delete opLineItem;
            }
            Catch(Exception e) {
                   
            }
        }
        if(!opList.isEmpty()){
            //Query Promo Code object records for discount %
            for(Promo_Code__c pc : [select id,name, Active__c,Expiration_date__c,Discount__c
                                  from Promo_Code__c where id in : promoIds AND Active__c = true]){
                oppPromoCodeMap.put(pc.Id,pc);      
            }
         
            //Query Promo Code Product to add to an Opportunity 
            Product2 promoProduct;
            try{
            promoProduct = [Select Id, ProductCode 
                                       From Product2 Where IsActive = true AND Id = :promoProductName
                                       limit 1];
            }
            Catch(Exception e) {
                
            }
      
            try{
                // Query ProductLineItem Records if any existed with Opportunity record
                for(OpportunityLineItem opLine: [SELECT Id,OpportunityId, Product2Id, Product2.Name,Product2.ProductCode,UnitPrice,ListPrice,TotalPrice 
                                                   FROM OpportunityLineItem Where OpportunityId IN :opList]) {
                    if(opLine.Product2Id != promoProductName){
                        totalAmt+= opLine.TotalPrice;
                    }
                    else{
                        promoOpp = opLine;
                    }                   
                }

            } 
            catch(Exception e){
            }
            for(Opportunity op : opList){
                Promo_Code__c pc =  oppPromoCodeMap.get(op.LBS_Promo_Code__c); // get Promo Code record for the Opportunity.
                if(pc != null){
                    if(promoOpp != null){
                        //updating existing Promo Code Opportunity Product
                        promoOpp.UnitPrice = -((totalAmt*pc.discount__c)/100);
                        promoOpp.LBS_Is_Discount_Applied__c = true;
                        opLineItemList.add(promoOpp);
                    }
                    else if(promoProduct !=null){
                        //creating a new OpportunityLineItem for the Promo Code product
                        opProduct = new OpportunityLineItem();
                        opProduct.OpportunityId = op.Id; 
                        opProduct.Product2Id = promoProduct.Id;
                        opProduct.Quantity = 1;
                        opProduct.UnitPrice = -((op.Amount*pc.discount__c)/100);
                        opProduct.LBS_Is_Discount_Applied__c = true;
                        opLineItemList.add(opProduct);
                        
                    }
              }
            }
        }
        
        //upsert the opportunity Products list.
        if(!opLineItemList.isEmpty()){
            try{
                LPL_TriggerOpp_Helper.runOnce = false;
                upsert opLineItemList;
            }
            catch(Exception e){
            }
        }
        
    }
   
   }
    /*********************CH-04 End***********************/