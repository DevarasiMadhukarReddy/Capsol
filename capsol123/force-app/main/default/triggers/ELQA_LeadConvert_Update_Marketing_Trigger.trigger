trigger ELQA_LeadConvert_Update_Marketing_Trigger on Lead (after update) 
{
    Lead oldLead = null;
    if (trigger.isUpdate)
    {
         for (Lead objLead : Trigger.new)
        {
            if ((objLead.RecordTypeId == '012U0000000ZS3F' ||    //  IS BD Lead Record Type
                 objLead.RecordTypeId == '012U0000000Z4MJ' ||    //  Discovery Database Lead Record Type
                 objLead.RecordTypeId == '012U0000000Z3wC'     //  Create New Lead Record Type

      

                )       
            && objLead.IsConverted == true)  
            {
                oldLead = Trigger.oldMap.get(objLead.Id);
                
                if(oldLead.IsConverted == false && objLead.IsConverted == true)
                {
                    ELOQUA__Marketing_Activity__c[] objMarketing = [select id, ELOQUA__Lead__c, ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c
                                                      where ELOQUA__Lead__c = :objLead.Id];
                    if(objMarketing.size() > 0)
                    {
                      for(ELOQUA__Marketing_Activity__c obj: objMarketing)
                      {
                        obj.ELOQUA__Contact__c = objLead.ConvertedContactId;
                      }
                        update objMarketing; 
                    }
                }
            }
        } 
    }
}