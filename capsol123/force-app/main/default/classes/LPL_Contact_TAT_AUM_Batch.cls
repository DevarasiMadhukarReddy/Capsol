global class LPL_Contact_TAT_AUM_Batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String Query = 'Select Id from Contact';
        
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        
        List<Opportunity> oppList =[select Id, Expected_AUM__c,TAT_GDC__C,Contact__c,accountId from Opportunity where Contact__c In: scope and (Expected_AUM__c>0 OR TAT_GDC__C>0)];
        Decimal tat=0.0;
        Decimal aum=0.0;
        Id contactID;
        Map<ID,Decimal> aumOnContactID= new Map<ID,Decimal>();
        Map<ID,Decimal> tatOnContactID= new Map<ID,Decimal>(); 
        for(Opportunity obj:oppList)  {
            if(obj.Contact__c!=contactID)
            {
                
                tat=0.0;
                aum=0.0;
            }
            
            if(obj.TAT_GDC__C!=Null ) {
                
                tat=tat+obj.TAT_GDC__C;
                
                
            }
            
            if(obj.Expected_AUM__c!=Null) {
                
                aum=aum+obj.Expected_AUM__c; 
                
            }
            contactID=obj.Contact__c;
            tatOnContactID.put(obj.Contact__c, tat);
            aumOnContactID.put(obj.Contact__c, aum);
            
        } 
        List<Contact> contactList= [Select Approved_Expected_AUM__c, Approved_TAT_Revenue__c, Id from Contact where Id IN:tatOnContactID.keySet()];
        List<Contact> newContactList=new List<Contact>();
        Decimal newTat=0.0;
        Decimal newAum=0.0;
        
        for(Contact conObj:contactList) {
            
            newTat=tatOnContactID.get(conObj.Id);
            
            newAum=aumOnContactID.get(conObj.Id);
            
            conObj.Approved_TAT_Revenue__c=newTat;
            conObj.Approved_Expected_AUM__c=newAum;
            conObj.Updated_TAT_and_AUM__c=true; 
            Datetime d=Datetime.now();
            conObj.Last_Updated__c=d;
            newContactList.add(conObj);
        }
        
        update newContactList;
        
    }
    
    global void finish(Database.BatchableContext BC){
        if (!Test.isRunningTest())
        {
        Database.executeBatch(new LPL_Opportunity_TAT_GDC_AUM_Batch(), 1);
        }
    }
    
}