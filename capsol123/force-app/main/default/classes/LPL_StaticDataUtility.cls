/* 
* @Author      : Manila Agnihotri(Cognizant)
* @version     : 1.0
* @CreatedDate : Sept 21 ,2018
* Purpose      : To hold static values to be used in various implementation 
*/
public with sharing class LPL_StaticDataUtility {
    public static final String FLAG_CHECK_TRUE = 'true';
    public static final String FLAG_CHECK_FALSE = 'false';
    
    public static final String ACTIVITY_MARKETING_STATIONARY_ITEMS_APPROVAL = 'Marketing & Stationary Items Approval';
    public static final String ACTIVITY_SECONDARY_DOCUMENTS = 'Secondary Documents';
    public static final String ACTIVITY_CONFIRM_MANDATORY_TRAININGS_COMPLETE = 'Confirm Mandatory Trainings Complete';
    public static final String ACTIVITY_INSURANCE_AND_ANNUITY_APPOINTMENTS = 'Insurance and Annuity Appointments';
    public static final String ACTIVITY_LEARNING_CENTER_SETUP = 'Learning Center Setup';
    public static final String ACTIVITY_RAMP_DELIVER_REPAPERING_PLAN = 'Ramp: Deliver Repapering Plan';
    public static final String ACTIVITY_SUBMIT_TAT_REQUEST = 'Submit TAT Request';
    
    public static final String REQUEST_LICENSED_SALES_ASST = 'Licensed Sales Asst (LSA) (IS)';
    public static final String REQUEST_BRANCH_EMPLOYEE = 'Licensed Branch Employee';
    //public static final String REQUEST_LICENSED_ADMIN = 'Licensed Admin';
    public static final String REQUEST_LICENSED_ADMIN = 'Lic. Admin - Onsite/Offsite w/ Advisor';
    public static final String REQUEST_P_C_PARTNER = 'P&C Partner';
    public static final String REQUEST_PAAP = 'PAAP';
    public static final String REQUEST_PROGRAM_MANAGER = 'Program Manager';
    public static final String REQUEST_NLA = 'NLA';
    
    public static final String ACTIVITY_REGIONAL_MEETING = 'Regional Meeting';
    public static final String ACTIVITY_STUDY_GROUP = 'Study Group';
    public static final String ACTIVITY_VIRTUAL_STUDY_GROUP = 'Virtual Study Group';
    public static final String ACTIVITY_EOV = 'EOV';
    public static final String ACTIVITY_VIRTUAL_OFFICE_VISIT = 'Virtual Office Visit';
    public static final String ACTIVITY_FIELD_OFFICE_VISIT = 'Field Office Visit';
    public static final String ACTIVITY_MAIL = 'Mail';
    public static final String ACTIVITY_VOICEMAIL = 'Voicemail';
    public static final String ACTIVITY_EMAIL = 'Email';
    public static final String ACTIVITY_OTHER = 'Other';
    public static final String DEPARTMENT_BUSINESS_CONSULTING = 'Business Consulting';
    
    public static final String RECORD_TYPE_MASTER = 'Master';
    
    
    public static final String ACTIVITY_STATUS_0 = '0';
    public static final String ACTIVITY_STATUS_1 = '1';
    public static final String ACTIVITY_STATUS_2 = '2';
    public static final String ACTIVITY_STATUS_3 = '3';
    
    public static final String STATUS_NOT_STARTED = 'Not Started';
    public static final String STATUS_DEFERRED = 'Deferred';
    public static final String STATUS_SENT = 'Sent';
    public static final String STATUS_IN_PROGRESS = 'In Progress';
    public static final String STATUS_RECEIVED = 'Received';
    public static final String STATUS_REQUESTED = 'Requested';
    public static final String STATUS_SCHEDULED = 'Scheduled';
    public static final String STATUS_COMPLETED = 'Completed';
    
    public static final String RESPONSE_STATUS_SUCCESS = 'SUCCESS';
    public static final String RESPONSE_STATUS_ERROR = 'ERROR';
    public static final String RESPONSE_STATUS_SUCCESS_DESCRIPTION = 'Successfully Sent the Activity details';
    public static final String RESPONSE_STATUS_SUCCESS_DETAILS = 'Successfully Sent User details.';
    public static final String RESPONSE_STATUS_ERROR_INVALID_DESCRIPTION = 'Invalid caseSafeId.Please change and re try';
    public static final String RESPONSE_STATUS_ERROR_BLANK_ID = 'Input string, CaseSafeId is blank.';
    public static final String RESPONSE_STATUS_ERROR_BLANK_DESCRIPTION = 'Input string, email is blank';
    public static final String RESPONSE_STATUS_NO_DETAILS_DESCRIPTION = 'No User details found.';
    
    public static final String RESPONSE_STATUS_CODE_200 = '200';
    public static final String RESPONSE_STATUS_CODE_301 = '301';
    public static final String RESPONSE_STATUS_CODE_302 = '302';
    public static final String RESPONSE_STATUS_CODE_303 ='303';

}