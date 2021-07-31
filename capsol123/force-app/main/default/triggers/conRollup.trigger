trigger conRollup on Contact (before insert, before update,after insert, after update, 
                                        after delete, after undelete) {
     
    List<Contact> newConLst  = New List<Contact>();
    List<Contact> oldConLst  = New List<Contact>();
    List<Account> accList = New List<Account>();
    String detailWhereClause;
    
    Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
    detailWhereClause = 'RecordTypeID =' + conRecTypeId;
    ContTriggerHandler conHandler = new ContTriggerHandler();
    if(userinfo.getProfileId() == '00eU0000000meqRIAQ' && System.Label.SkipTrigger == 'TRUE')
    {
        system.debug('Skip Logic@@@@@');      
    } 
    else
    {
    
     if(Trigger.isBefore) 
        if(Trigger.isInsert || Trigger.isUpdate )
        {
            //system.debug('Inside after ins/upt - @@@@@'); 
           conHandler.zip3Assignment(Trigger.new);
       }
     
    try{
    if(Trigger.isAfter) {
      // modified objects whose parent records should be updated
     Contact[] objects = null;  

     if (Trigger.isDelete) {
        for(Contact con: Trigger.old){
            if(con.AccountId != Null && Con.RecordTypeId == conRecTypeId && con.Rep_Status__c == 'Active')
            oldConLst.add(con);
        }
         objects = oldConLst;
     } else {
        /*
            Handle any filtering required, specially on Trigger.isUpdate event. If the rolled up fields
            are not changed, then please make sure you skip the rollup operation.
            We are not adding that for sake of similicity of this illustration.
        */ 
        for(Contact con: Trigger.new){
        if(con.AccountId != Null ){
            if(trigger.isUpdate){
                if((con.GDC_Prior_12_mo__c != Null && con.GDC_Prior_12_mo__c != 0) && (Trigger.oldmap.get(con.id).GDC_Prior_12_mo__c  != con.GDC_Prior_12_mo__c) && Con.RecordTypeId == conRecTypeId && con.Rep_Status__c == 'Active')
                newConLst.add(con);
            }else if(trigger.isInsert){
            if((con.GDC_Prior_12_mo__c != Null && con.GDC_Prior_12_mo__c != 0) && Con.RecordTypeId == conRecTypeId && con.Rep_Status__c == 'Active')
            newConLst.add(con);
            }
           } 
        }
        objects = newConLst;
     }

     /*
      First step is to create a context for LREngine, by specifying parent and child objects and
      lookup relationship field name
     */
     LREngine.Context ctx = new LREngine.Context(Account.SobjectType, // parent object
                                            contact.SobjectType,  // child object
                                            Schema.SObjectType.contact.fields.AccountId, // relationship field name
                                            detailWhereClause
                                            );     
     /*
      Next, one can add multiple rollup fields on the above relationship. 
      Here specify 
       1. The field to aggregate in child object
       2. The field to which aggregated value will be saved in master/parent object
       3. The aggregate operation to be done i.e. SUM, AVG, COUNT, MIN/MAX
     */
     ctx.add(
            new LREngine.RollupSummaryField(
                                            Schema.SObjectType.Account.fields.GDC_Prior_12_Months__c,
                                            Schema.SObjectType.Contact.fields.GDC_Prior_12_mo__c,
                                            LREngine.RollupOperation.Sum 
                                         )); 
     /*ctx.add(
            new LREngine.RollupSummaryField(
                                            Schema.SObjectType.Account.fields.SLAExpirationDate__c,
                                               Schema.SObjectType.Opportunity.fields.CloseDate,
                                               LREngine.RollupOperation.Max
                                         ));      */                                 

     /* 
      Calling rollup method returns in memory master objects with aggregated values in them. 
      Please note these master records are not persisted back, so that client gets a chance 
      to post process them after rollup
      */ 
     Sobject[] masters = LREngine.rollUp(ctx, objects);  
     list<Account> acctList = new list<Account>();
     acctList = masters;
     For(Account acc: acctList ){
         if(acc.id != Null ){
             accList.add(acc);
         }
     }  
     
     // Persiste the changes in master
     if(!accList.isEmpty())
     update accList;
     
    }
    }catch(Exception e) {

   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Too many records.'));
    }
    
}
}