/**
* LPL_UserDetailService.cls
* Description  : This is webservice for AEM to provide User details as part of Microsite project. 
* 
* @Author      : Manila Agnihotri(Cognizant)
* @version     : 1.0
* @CreatedDate : Sept 28 ,2018
*/


global class LPL_UserDetailService { 
    global class USER_DETAIL{
        webservice String Name;
        webservice String RoleCode;
        webservice String Email; 
        webservice String Phone;
        webservice String MobilePhone;
        webservice String ImageURL;
    }
    
    global class STATUS{
        webservice String StatusConditionDescription;
        webservice String StatusCode;
        webservice String StatusName;
        webservice String StatusDescription;      
        webservice String GUID;      
    }
    
    global class MESSAGE{ 
        webservice STATUS STATUS;       
        webservice List<USER_DETAIL> USER_DETAIL;      
    }
    
    global class result{
        webservice MESSAGE MESSAGE;
    }
    
    /*webservice static result sendUserDetails(String oppCaseId) {
        result res= new result();
        res = LPL_UserDetailServiceExtension.getResponse(oppCaseId);
        return res;
    }*/
    
    webservice static result getResponse(String oppCaseId) {
        result res = new result();
        res.MESSAGE = new MESSAGE();
        res.MESSAGE.STATUS = new STATUS();
        List<User> userList = new List<User>();
        Set<Id> userIdSet = new Set<Id>();
        Map<Id,String> userRoleMap = new Map<Id,String>();
        if(!String.isBlank(oppCaseId)){
            List<Opportunity> ooptyList = [SELECT Id,Integration_Manager__c,Regional_Transition_Partner__c,Project_Manager__c,Investment_Transition_Consultant__c,
                                           Transition_Support_Partners__c,Transition_Support_Partner_Secondary__c,Regional_Transition_Partner__r.Name,
                                           Project_Manager__r.Name,Investment_Transition_Consultant__r.Name,Transition_Support_Partners__r.Name,
                                           Transition_Support_Partner_Secondary__r.Name from opportunity where Id =: oppCaseId];
            if(ooptyList.size()>0){    
                if(!String.isBlank(String.valueOf(ooptyList[0].Integration_Manager__c))){
                    userIdSet.add(ooptyList[0].Integration_Manager__c);
                    if(userRoleMap.containsKey(ooptyList[0].Integration_Manager__c)){
                        String roleMapVal = userRoleMap.get(ooptyList[0].Integration_Manager__c)+',OC';
                        userRoleMap.put(ooptyList[0].Integration_Manager__c,roleMapVal);
                    }else{
                        userRoleMap.put(ooptyList[0].Integration_Manager__c,'OC');
                    }
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Project_Manager__c))){
                    if(ooptyList[0].Project_Manager__r.Name != 'LPL Financial'){
                        userIdSet.add(ooptyList[0].Project_Manager__c);
                        if(userRoleMap.containsKey(ooptyList[0].Project_Manager__c)){
                            String roleMapVal = userRoleMap.get(ooptyList[0].Project_Manager__c)+',PM';
                            userRoleMap.put(ooptyList[0].Project_Manager__c,roleMapVal);
                        }else{
                            userRoleMap.put(ooptyList[0].Project_Manager__c,'PM');
                        }
                    }
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Investment_Transition_Consultant__c ))){
                    if(ooptyList[0].Investment_Transition_Consultant__r.Name != 'LPL Financial'){
                    userIdSet.add(ooptyList[0].Investment_Transition_Consultant__c);
                    if(userRoleMap.containsKey(ooptyList[0].Investment_Transition_Consultant__c)){
                        String roleMapVal = userRoleMap.get(ooptyList[0].Investment_Transition_Consultant__c)+',ITP';
                        userRoleMap.put(ooptyList[0].Investment_Transition_Consultant__c,roleMapVal);
                    }else{
                        userRoleMap.put(ooptyList[0].Investment_Transition_Consultant__c,'ITP');
                    }
                    }
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Regional_Transition_Partner__c ))){
                    if(ooptyList[0].Regional_Transition_Partner__r.Name != 'LPL Financial'){
                    userIdSet.add(ooptyList[0].Regional_Transition_Partner__c);
                    if(userRoleMap.containsKey(ooptyList[0].Regional_Transition_Partner__c)){
                        String roleMapVal = userRoleMap.get(ooptyList[0].Regional_Transition_Partner__c)+',RTP';
                        userRoleMap.put(ooptyList[0].Regional_Transition_Partner__c,roleMapVal);
                    }else{
                        userRoleMap.put(ooptyList[0].Regional_Transition_Partner__c,'RTP');
                    }
                    }
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Transition_Support_Partners__c))){
                    if(ooptyList[0].Transition_Support_Partners__r.Name != 'LPL Financial'){
                    userIdSet.add(ooptyList[0].Transition_Support_Partners__c);
                    if(userRoleMap.containsKey(ooptyList[0].Transition_Support_Partners__c)){
                        String roleMapVal = userRoleMap.get(ooptyList[0].Transition_Support_Partners__c)+',TSP';
                        userRoleMap.put(ooptyList[0].Transition_Support_Partners__c,roleMapVal);
                    }else{
                        userRoleMap.put(ooptyList[0].Transition_Support_Partners__c,'TSP');
                    }
                    }
                }
                
                if(!String.isBlank(String.valueOf(ooptyList[0].Transition_Support_Partner_Secondary__c ))){
                    if(ooptyList[0].Transition_Support_Partner_Secondary__r.Name != 'LPL Financial'){
                        userIdSet.add(ooptyList[0].Transition_Support_Partner_Secondary__c);
                        if(userRoleMap.containsKey(ooptyList[0].Transition_Support_Partner_Secondary__c)){
                            String roleMapVal = userRoleMap.get(ooptyList[0].Transition_Support_Partner_Secondary__c)+',TSPS';
                            userRoleMap.put(ooptyList[0].Transition_Support_Partner_Secondary__c,roleMapVal);
                        }else{
                            userRoleMap.put(ooptyList[0].Transition_Support_Partner_Secondary__c,'TSPS');
                        }
                    }
                }
                if(userIdSet.size()>0){
                    userList = [SELECT id,Name,Email,Phone,MobilePhone,Photo__c from User where id in :userIdSet];
                    if(userList.size()>0){
                        res.MESSAGE.USER_DETAIL = new List<USER_DETAIL>();
                        for(User u : userList){
                            String [] roleArray = userRoleMap.get(u.id).split(',');
                            if(roleArray.size()>0){
                                for(Integer i=0;i<roleArray.size();i++){
                                    USER_DETAIL userDetail = new USER_DETAIL();
                                    userDetail.Name = u.Name;
                                    userDetail.Email = u.Email;
                                    userDetail.Phone = u.Phone;
                                    userDetail.MobilePhone = u.MobilePhone;
                                    userDetail.RoleCode = roleArray[i];
                                    if(u.Photo__c!= null){
                                        String firstSubString = u.Photo__c.substringBetween('<img', 'img>');
                                        String secondSubString = firstSubString.substringBetween('src="', '"');
                                        Integer serveletPos = secondSubString.indexOf('servlet');
                                        String relativePath = secondSubString.substring(serveletPos);
                                        String ImagePath= relativePath.replace('amp;', '');
                                        userDetail.ImageURL = Label.LPL_UserImageBaseURL +ImagePath;
                                    }
                                    res.MESSAGE.USER_DETAIL.add(userDetail);
                                }
                            }
                        }
                    }
                    res.MESSAGE.STATUS.StatusName= LPL_StaticDataUtility.RESPONSE_STATUS_SUCCESS;
                    res.MESSAGE.STATUS.StatusConditionDescription='';
                    res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_200;
                    res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_SUCCESS_DETAILS;
                    res.MESSAGE.STATUS.GUID = oppCaseId +' '+ String.valueOf(System.now());
                }
                else{
                    generateErrorLog(oppCaseId,LPL_StaticDataUtility.RESPONSE_STATUS_NO_DETAILS_DESCRIPTION);
                    res.MESSAGE.STATUS.StatusName= LPL_StaticDataUtility.RESPONSE_STATUS_ERROR;
                    res.MESSAGE.STATUS.StatusConditionDescription='';
                    res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_303;
                    res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_NO_DETAILS_DESCRIPTION;
                    res.MESSAGE.STATUS.GUID = oppCaseId  +' '+  String.valueOf(System.now());
                }
            }
            else{
                generateErrorLog(oppCaseId,LPL_StaticDataUtility.RESPONSE_STATUS_ERROR_INVALID_DESCRIPTION);
                res.MESSAGE.STATUS.StatusName = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR;
                res.MESSAGE.STATUS.StatusConditionDescription ='';
                res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_302;
                res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR_INVALID_DESCRIPTION;
                res.MESSAGE.STATUS.GUID = oppCaseId +' '+  String.valueOf(System.now());
            }
        }
        else{
            generateErrorLog('',LPL_StaticDataUtility.RESPONSE_STATUS_ERROR_BLANK_ID);
            res.MESSAGE.STATUS.StatusName = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR;
            res.MESSAGE.STATUS.StatusConditionDescription ='';
            res.MESSAGE.STATUS.StatusCode = LPL_StaticDataUtility.RESPONSE_STATUS_CODE_301;
            res.MESSAGE.STATUS.StatusDescription = LPL_StaticDataUtility.RESPONSE_STATUS_ERROR_BLANK_ID;
            res.MESSAGE.STATUS.GUID = String.valueOf(System.now());
        }
        return res;
    }
    
    @future
    public static void generateErrorLog(String oppId,String responseDetail){   
        ServiceErrors__c servError = new ServiceErrors__c();
        servError.Name= 'LPL_UserDetailService.getResponse()';
        if(oppId !=null && oppId != ''){
            servError.GUID__c = oppId +' '+ String.valueOf(System.now());
        }else{
            servError.GUID__c = String.valueOf(System.now());
        }
        servError.Request__c=oppId;
        servError.Response__c = responseDetail;
        insert servError;
    }
    
}