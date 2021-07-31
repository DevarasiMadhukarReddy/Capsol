trigger atRiskLastModified on Contact (after update) 
{
    list<Contact> oldRecords = new list<Contact>();
    list<Contact> updatedRecords = new list<Contact>();
    
    oldRecords = trigger.old;
    updatedRecords = trigger.new;
    
    set<ID> cIDs = new set<ID>();
    for(Contact c : updatedRecords)
    {
        cIDs.add(c.id);
    }
    
    list<Contact> allUpdatedContacts = new list<Contact>
    ([select id, At_Risk_Last_Modified__c, At_Risk__c from Contact where Id in:cIDs]);
        
    list<Contact> toBeUpdated = new list<Contact>();
    
    Integer counter=0;
    for(Contact cNew : allUpdatedContacts)
    {
        Contact cOld = oldRecords.get(counter);
        if(cNew.At_Risk__c != cOld.At_Risk__c)
        {
            
            cNew.At_Risk_Last_Modified__c = datetime.now();
            toBeUpdated.add(cNew);
        }
        counter++;
    }
    
    if(toBeUpdated.size()>0)
    {
        update toBeUpdated;
    }
}