public with sharing class Branch_instprepop_controller {

private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String confirmationToken {get; set;}


    public Branch_instprepop_controller(ApexPages.StandardController controller) {
    
    retURL = ApexPages.currentPage().getParameters().get('retURL');
    rType = ApexPages.currentPage().getParameters().get('RecordType');
    cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
    ent = ApexPages.currentPage().getParameters().get('ent');
    confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
    saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
    

    }
    
    public PageReference redirect() {

    PageReference returnURL;
    Branch_Inst__c bi = Branch_Inst__c.getorgDefaults();
     returnURL = new PageReference('/'+bi.Object_Id__c+'/e');

    returnURL.getParameters().put('retURL', retURL);
    returnURL.getParameters().put('RecordType', rType);
    returnURL.getParameters().put('cancelURL', cancelURL);
    
    if(bi.Recordtype_Id__c == rType ){
      returnURL.getParameters().put('Name', 'Fortigent');
    }
  
    returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
    returnURL.getParameters().put('save_new_url', saveNewURL);
    returnURL.getParameters().put('nooverride', '1');
    returnURL.setRedirect(true);
    return returnURL;

}


}