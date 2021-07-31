Trigger ContactSumTrigger on Contact (after delete, after insert, after undelete, 
after update) {

   /**  Contact[] cons;
    if (Trigger.isDelete) 
        cons = Trigger.old;
    else
        cons = Trigger.new;

    // get list of accounts
    Set<ID> acctIds = new Set<ID>();
    for (Contact con : cons) {
    
           
            acctIds.add(con.AccountId);
    }
    
   Map<ID, Contact> contactsForAccounts = new Map<ID, Contact>([select Id
                                                            ,AccountId
                                                            from Contact
                                                            where AccountId in :acctIds ] );

    Map<ID, Account> acctsToUpdate = new Map<ID, Account>([select Id
                                                                 ,Number_of_Contacts__c
                                                                  from Account
                                                                  where Id in :acctIds ] );
                                                                 
    for (Account acct : acctsToUpdate.values()) {
        Set<ID> conIds = new Set<ID>();
        for (Contact con : acct.Contacts) {
            if (con.AccountId == acct.Id)
                conIds.add(con.Id);
        }
        if (acct.Number_of_Contacts__c != conIds.size())
            acct.Number_of_Contacts__c = conIds.size();
    }
    
    
    
    for (acctsToUpdate ar : [SELECT AccountId AcctId, Count(id) ContactCount 
                               FROM Contact 
                               WHERE AccountId in: acctIds 
                               GROUP BY AccountId]){
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId'); //---> handy trick for updates, set the id and update
        a.Number_of_Contacts__c = (Integer) ar.get('ContactCount');
        acctsToUpdate.add(a);
    }

    update acctsToUpdate.values();*/
    
    
    set<id>accid=new set<id>();

    list<contact>contactlist=new list<contact>();
    list<contact>listcon=new list<contact>();
    list<account>acclist=new list<account>();
    list<account>listacc=new list<account>();
    map<id,integer>mapCount=new map<id,integer>();


    if(trigger.isinsert||trigger.isupdate )                              //insert   con
    {
        for(contact con:trigger.new)
        {
            accid.add(con.accountid);
        }    
    }

    if (trigger.isdelete)                          //delete  con
    {
        for(contact con:trigger.old)
        {
            accid.add(con.accountid);
        }
    }

    acclist=[SELECT id,name FROM account WHERE id in:accid limit 50000];
    contactlist=[SELECT id,name,accountid FROM contact WHERE accountid in:accid and Account.name!='Business Development Opportunity' limit 50000];
    
    for(account acc:acclist){
        listcon.clear();
        for(contact c:contactlist){
            if(c.accountid==acc.id){
                listcon.add(c);
                mapCount.put(c.accountid,listcon.size());
            }
        }
    }

    if(acclist.size()>0){
    
        for(Account a:acclist)
        {
            if(mapCount.get(a.id)==null)
                a.Number_of_Contacts__c =0;
                
                else
                
                a.Number_of_Contacts__c =mapCount.get(a.id);
                listacc.add(a);
            }
        }
    
    
    if(listacc.size()>0)
    
        update listacc;
    
    }