/*Batch class Name               : LPL_ProgramManagerOnEnterprise_batch 
Description                      : This one time batch populates the Enterprise's Program Manager field from the related Contacts.
Created By                       : Vaibhav Jain
Created Date                     : 7-Jan-2019
*/

global class LPL_ProgramManagerOnEnterprise_batch implements Database.Batchable<sObject> {
    
    Map<String,Account> accMap = new Map<String,Account>();
    public Map<String,List<Contact>> mapRelatedContacts = new Map<String,List<Contact>>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select id,program_manager__c,Name,program_manager__r.Name, (Select id,LastName,accountId,Rep_Status__c,Role__c,PM_Contact_Level__c,CreatedDate,Hire_Date__c from Contacts where Rep_Status__c = \'Active\' and (Role__c=\'Program Manager\' or Role__c=\'Financial Consultant/PM\') order by createdDate) from Account where RecordType.Name=\'IS - Institution\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        try{
            for(Account acc : accList){
                mapRelatedContacts.put(acc.Id,acc.Contacts);
                accMap.put(acc.Id, acc);
            }
            for(Account a:accList){
                DateTime conCreatedDateP = null;
                Date conHireDateP = null;
                DateTime conCreatedDateS = null;
                Date conHireDateS = null;
                if(a.contacts.size()>1){
                    for(Contact con:a.contacts){
                        if(con.Rep_Status__c == 'Active' && (con.Role__c=='Program Manager' || con.Role__c=='Financial Consultant/PM')){
                            if(con.PM_Contact_Level__c=='Primary PM Contact' || con.PM_Contact_Level__c=='Primary'){
                                if(String.valueOf(conCreatedDateP)==null){
                                    conCreatedDateP = con.CreatedDate;
                                    conHireDateP = con.Hire_Date__c;
                                    accMap.get(a.Id).program_Manager__c = con.Id;
                                }
                                else if (conCreatedDateP==con.CreatedDate){
                                    if(String.valueOf(conHireDateP)==null){
                                        conHireDateP = con.Hire_Date__c;
                                        accMap.get(a.Id).program_Manager__c = con.Id;
                                    }
                                    else if(conHireDateP>con.Hire_Date__c){
                                        conHireDateP = con.Hire_Date__c;
                                        accMap.get(a.Id).program_Manager__c = con.Id;
                                    }
                                }
                                else if (conCreatedDateP<con.CreatedDate)
                                    break;
                            }
                            else if((con.PM_Contact_Level__c=='Secondary PM Contact' || con.PM_Contact_Level__c=='Secondary') && conCreatedDateP == null){
                                if(String.valueOf(conCreatedDateS)==null){
                                    conCreatedDateS = con.CreatedDate;
                                    conHireDateS = con.Hire_Date__c;
                                    accMap.get(a.Id).program_Manager__c = con.Id;
                                }
                                else if (conCreatedDateS==con.CreatedDate){
                                    if(conHireDateS>con.Hire_Date__c){
                                        conHireDateS = con.Hire_Date__c;
                                        accMap.get(a.Id).program_Manager__c = con.Id;
                                    }
                                }
                            }
                            else if(conCreatedDateP==null && conCreatedDateS==null){
                                accMap.get(a.Id).program_Manager__c = con.Id;
                            }
                        }
                    }
                }
                else if(a.contacts.size()==1){
                    accMap.get(a.Id).program_Manager__c = a.contacts[0].Id;
                }
            }
            if(accMap.values().size()>0){
                update accMap.values();
            }
        }
        catch(Exception e){
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_ProgramManagerOnEnterprise_batch ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }
    }
    global void finish(Database.BatchableContext bc){}
}