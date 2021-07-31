public class Opportunity_Utility{

public static void update_TotalAdvisoryAUM(Opportunity oppRec, List<Branch_Inst_Financial__c> listOfBIF){
/*
set<Id> Accid= new set<Id>();

for(Opportunity o:Lstopp){

if(!Isupdateval){
if(o.AccountId != null){
Accid.add(o.AccountId);
}
}else{

if((o.AccountId != null && o.Total_Advisory_AUM__c  == null) || (o.AccountId != null && o.AccountId != MapOpp.get(o.Id).AccountId)){
Accid.add(o.AccountId);
}

}
}

if(Accid.size()>0){*/

    Map<Id,Branch_Inst_Financial__c> mapBranch = new Map<Id,Branch_Inst_Financial__c>();
    
    for(Branch_Inst_Financial__c b:listOfBIF){
    //system.debug('b.name.contains()====='+b.name.contains('-OSJ'));
    //system.debug('b.name==='+b.name);
    if(b.name.contains('-OSJ')){
        if(b.Account__c != null){ // added null check condition by Sai Kethu
            mapBranch.put(b.Account__c,b);
        }
    }
    }
    
    if(mapBranch.size()>0){
    
    //for(Opportunity o:Lstopp){
        if(oppRec.AccountId != null){
            if(mapBranch.Containskey(oppRec.AccountId)){
                if(mapBranch.get(oppRec.AccountId).Account__c != null){ // added null check condition by Sai Kethu
                    if(oppRec.AccountId  == mapBranch.get(oppRec.AccountId).Account__c){
                        oppRec.Total_Advisory_AUM__c = mapBranch.get(oppRec.AccountId).Total_Advisory_AUM__c;
                    }
                }
            }
        }
    //}
}

//} 
}
}