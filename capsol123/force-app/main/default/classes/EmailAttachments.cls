public class EmailAttachments{
    public Id currentId {get; set;}
    // public List<Loan_Application__c> currentreocrdid {get; set; }
    public wrapLoanApplication getLoanApplication() {
        
        system.debug('currentId-->'+currentId);
        
        List<Task> t = [SELECT what.type,WhatId FROM Task WHERE whatid = :currentId Limit 1] ;
        system.debug('result t-->'+t);
        if(!t.isEmpty()) 
        {
               if(t[0].what.type == 'Loan_Application__c') {
                list<Loan_Application__c> result = [Select Id,Name,Preparer_Name__c,Assigned_Recruiter__r.firstname,Assigned_Recruiter__r.lastname,LoanAppAuto__c, (Select Id, Name from Attachments),(Select Id, title from notes) FROM Loan_Application__c Where id =:t[0].WhatId LIMIT 1];
                system.debug('result-->'+result);
                list<Attachment> lstAtt=[Select Id, Name from Attachment where ParentId =:currentId];
                list<note> lstNote =[Select Id, title from note where ParentId =:currentId];
                // if(!result.isEmpty() && !lstAtt.isEmpty() && !lstNote.isEmpty()){
                if(!result.isEmpty()){
                    wrapLoanApplication wrapLA =  new wrapLoanApplication();
                    if( !lstAtt.isEmpty()){
                        Attachment temp = result[0].Attachments[0];
                        String linkId =  String.valueOf(temp.Id);
                        wrapLA.linkForAttachment = linkId;
                    }
                    if(!lstNote.isEmpty()){
                        note temp1=result[0].notes[0];
                        String linkId1 =  String.valueOf(temp1.Id);
                        
                        wrapLA.linkFornote = linkId1;
                    }
                    
                    wrapLA.preparerName = result[0].Preparer_Name__c;
                    wrapLA.assignedRecuiter = result[0].Assigned_Recruiter__r.firstname + ' '+result[0].Assigned_Recruiter__r.lastname;
                    wrapLA.loanAppAuto = result[0].LoanAppAuto__c;
                    
                    return wrapLA;
                } 
            }
           
        }
        return new wrapLoanApplication('','','','','');
    }
        
    public class wrapLoanApplication {
        public string linkForAttachment {get; set;}
        public string linkFornote{get;set;}
        public string preparerName {get; set;}
        public string assignedRecuiter {get; set;}
        public string loanAppAuto {get; set;}
        
        public wrapLoanApplication(){}
        public wrapLoanApplication(String linkForAttachment,String linkFornote,String preparerName,String assignedRecuiter,String loanAppAuto) {
            this.linkForAttachment = linkForAttachment;
            this.linkFornote = linkFornote;
            this.preparerName = preparerName;
            this.assignedRecuiter = assignedRecuiter;
            this.loanAppAuto = loanAppAuto;
            
        }
    }
    
}