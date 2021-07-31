public Class Mergecontactcontroller{
    public Contact con;
    public Id conid {get; set;}
    public String URL;
    public List<contact> conList {get;set;}
    public Set<contact> conset = new Set<contact>();
    public List<contact> consetdisplay {get;set;}
    
    public Mergecontactcontroller(ApexPages.StandardController controller){ 
        conid = ApexPages.currentPage().getParameters().get('id');    
        URL = ApexPages.currentPage().getUrl();
        con = [select id,accountid,Phone,Uniquekey__c,UniqueKeyMobile__c,FirstName,Lastname,Mobilephone,Data_Link2__DDL_RepID__c,Email from contact where id =:ApexPages.currentPage().getParameters().get('id')];
        consetdisplay =new List<contact>();
        if(con.id != null){
            if(con.Data_Link2__DDL_RepID__c!=null){
                conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where (Data_Link2__DDL_RepID__c = :con.Data_Link2__DDL_RepID__c) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id];
                conset.addall(conList);
            }
            
            if(con.Email!=null){
                conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where ((Email =: con.Email AND Email != null) AND (Data_Link2__DDL_RepID__c = :con.Data_Link2__DDL_RepID__c) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id)];
                conset.addall(conList);
                if(con.Data_Link2__DDL_RepID__c==null){
                    conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where ((Email =: con.Email AND Email != null) AND (Data_Link2__DDL_RepID__c != null) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id)];
                    conset.addall(conList);
                }
                else if(con.Data_Link2__DDL_RepID__c!=null){
                    conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where ((Email =: con.Email AND Email != null) AND (Data_Link2__DDL_RepID__c = null) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id)];
                    conset.addall(conList);
                }
            }
            if(con.LastName!=null)
            {
                conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where (((FirstName =:con.FirstName and Lastname =:con.LastName AND AccountID=: con.AccountID and Phone=:con.phone) OR (FirstName =:con.FirstName and Lastname =:con.LastName AND AccountID=: con.AccountID and Mobilephone=:con.Mobilephone)) and (Data_Link2__DDL_RepID__c =:con.Data_Link2__DDL_RepID__c) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id)];
                conset.addall(conList);
                if(con.Data_Link2__DDL_RepID__c==null)
                {
                    conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where (((FirstName =:con.FirstName and Lastname =:con.LastName AND AccountID=: con.AccountID and Phone=:con.phone) OR (FirstName =:con.FirstName and Lastname =:con.LastName AND AccountID=: con.AccountID and Mobilephone=:con.Mobilephone)) AND (Data_Link2__DDL_RepID__c != null) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id)];
                    conset.addall(conList);}
                else if(con.Data_Link2__DDL_RepID__c!=null)
                {
                    conList = [select id,RecordType.Name,FirstName,Lastname,Account.name,Phone,Uniquekey__c,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email from Contact where (((FirstName =:con.FirstName and Lastname =:con.LastName AND AccountID=: con.AccountID and Phone=:con.phone) OR (FirstName =:con.FirstName and Lastname =:con.LastName AND AccountID=: con.AccountID and Mobilephone=:con.Mobilephone)) AND (Data_Link2__DDL_RepID__c = null) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect') AND ID != : con.id)];
                    conset.addall(conList);
                }
            }
          
            consetdisplay.addall(conset);                                                                                                                                                                        
            if(conset.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'This Contact has no duplicates'));
            }
        }
    }
    public List<Contact> retConList(){
    return consetdisplay;
    }
    public boolean testBoolCheck {get {{if (conset.size()==0) return true; return false;}} set;}
    
    public PageReference Navigate() {
    List<Contact> conList = retConList();
    Set<String> ids = new Set<String>();
    for(Contact c:conList){
        ids.add(c.Id);
    }
    String conIds = con.Id;
    for(String s:ids){
        conIds = conIds+','+s;
    }
    
    System.debug('Ids are '+conIds);
        PageReference pageRef = new PageReference('/apex/MergecontactpageVF');
        pageref.getParameters().put('recordID',conid);
        pageref.getParameters().put('listOfCon',String.valueOf(conIds));
        pageref.setRedirect(true);
        return pageRef ;
    }
}