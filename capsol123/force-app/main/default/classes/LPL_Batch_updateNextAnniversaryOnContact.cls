/*Batch class Name               : LPL_Batch_updateNextAnniversaryOnContact 
Description                      : This batch class is checking the qualifying Contacts and updating the Next Anniversary Date field 5 years after the Hire Date.
Created By                       : Utkarsh Topre
Created Date                     : 27-June-2018
CH01 - Modified code to send mails for Non-Club level Contacts 21 days before their 20,25,30,35,40,45,50th Anniversary
*/
global class LPL_Batch_updateNextAnniversaryOnContact implements Database.Batchable<sObject> {
    
    ID laConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId(); 
    Date today = system.today();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Getting qualify Contacts
        String query='Select Id, RecordTypeId, Hire_Date__c,Club_Level__c, Next_Anniversary_Date__c from Contact where Hire_Date__c!=null AND (Next_Anniversary_Date__c =Null OR Next_Anniversary_Date__c < today) AND RecordTypeId =: laConRecordTypeId';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Contact> conList) {
       try {  
            Date temporarynextanniverserydate;
            List<Contact> updateCon = new List<Contact>();
            for(Contact con: conList){
                
                temporarynextanniverserydate = con.Hire_Date__c;
                if(con.Club_Level__c=='Executive Council' || con.Club_Level__c=='Freedom Club' || con.Club_Level__c=='Patriots Club' || con.Club_Level__c=='Chairmans Council' || con.Club_Level__c=='Chairmans Club'|| con.Club_Level__c=='Directors Club'){
                    integer index=1;
                    while(index>=1 && (temporarynextanniverserydate < system.today() || con.Next_Anniversary_Date__c == null)){
                        temporarynextanniverserydate = Date.newInstance(temporarynextanniverserydate.year()+5, temporarynextanniverserydate.month(), temporarynextanniverserydate.Day());
                        if(system.today()>= temporarynextanniverserydate){
                            index++;
                        }
                        else{
                            index = 0;
                        }
                        con.Next_Anniversary_Date__c = temporarynextanniverserydate;
                    }
                    con.Reset_Anniversary_Email_System__c = false;
                    
                    updateCon.add(con);
                }
                else{
                    Integer numberDaysDue = temporarynextanniverserydate.daysBetween(system.today());
                    system.debug('****'+numberDaysDue);
                    if((con.Next_Anniversary_Date__c==null || con.Next_Anniversary_Date__c < system.today()) &&
                       ((numberDaysDue +21) == 7305  || (numberDaysDue +21) == 9131 ||
                        (numberDaysDue +21) == 10957 || (numberDaysDue +21) == 12783 ||
                        (numberDaysDue +21) == 14610 || (numberDaysDue +21) == 16436 ||
                        (numberDaysDue +21) == 18262)){
                            con.Next_Anniversary_Date__c =  Date.newInstance(System.today().year(), System.today().month(), System.today().Day()+21);
                        } 
                    con.Reset_Anniversary_Email_System__c = false;
                    
                    updateCon.add(con);
                }
            }
            if(!updateCon.isEmpty() && updateCon.size() >0){
                update updateCon;
            }
        }
        catch(exception e) {
            LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_updateNextAnniversaryOnContact ','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());
        }  
    }
    global void finish(Database.BatchableContext BC){
    }
}