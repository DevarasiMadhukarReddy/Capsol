/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Batch Class for LPL_Account_to_Contact_Update_batch                 Manila Agnihotri                    27 APRIL 2018
                to Schedule the batch on daily basis to update Accunt 
                Sell_Against_Details__c field value on Contact 
                Sell_Against_Details__c field.                                 

*/

global class LPL_Account_to_Contact_Update_batch implements Database.Batchable<sObject>, Database.Stateful {
    
    List<Account> acc = new List<Account>();
    global list<Contact> Conlist = new list<Contact>();
    global set<Contact> ConSet ;
    Global List<Account> tempAcc = new List<Account>();
    Global Set<ID> Accid=new Set<ID>();
    Map<ID,List<Contact>> Acccon;
    Global Map<id, account> upAcc = new map<id,account>();
    Global Id accRT1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Broker Dealer Firm (Discovery)').getRecordTypeId();
    Global Id ConProspect= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        for(Account a: [Select ID, Name, Sell_Against_Details__c,Field_Insert_Updated__c from Account where ((RecordTypeId =: accRT1) AND (Field_Insert_Updated__c=true))])
        {
            Accid.add(a.id);
            tempAcc.add(a);
        }
        String query='Select Id, RecordType.Name, Sell_Against_Details__c,AccountId from contact where AccountId=:Accid And RecordTypeId =:ConProspect';
        return database.getQueryLocator(query);    
    }
    global void execute(Database.BatchableContext BC,List<Contact> conUpdateList)
    {   
         ConSet = new set<Contact>();
         Conlist = new List<Contact>();
         Acccon = new  Map<ID,List<Contact>>();
        for(Contact c: conUpdateList)
        {          
                if(Acccon.containsKey(c.accountid))                    
                    Acccon.get(c.accountid).add(c);                
                else
                    Acccon.put(c.accountid, new List<Contact>{c}) ;                            
        }
        for(Account acc1 : tempAcc){            
                for(Contact con: Acccon.get(acc1.id)){
                    con.Sell_Against_Details__c= acc1.Sell_Against_Details__c ;
                    ConSet.add(con);
                }
            acc1.Field_Insert_Updated__c = false;
             upAcc.put(acc1.id,acc1);
            
        }
        if(conSet.size() > 0)
            Conlist.addAll(conSet);
                database.update(Conlist, false);
        
    }
    global void finish(Database.BatchableContext BC){
         if(upAcc.size() > 0)
         {  
             update upAcc.values();
         }
        
    }
}