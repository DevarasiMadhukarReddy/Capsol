//Generated by wsdl2apex

public class lplComBtsLplsiebeladapterserviceSrre {
    public class SRResponseType {
        public lplComBtsLplsiebeladapterserviceSrre.ResponseHeaderType responseMessageHeader;
        public lplComBtsLplsiebeladapterserviceSrre.ContactType[] Contact;
        private String[] responseMessageHeader_type_info = new String[]{'responseMessageHeader','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] Contact_type_info = new String[]{'Contact','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'responseMessageHeader','Contact'};
    }
    public class ServiceRequestType {
        public String TaskOriginator;
        public String Area;
        public String SubArea;
        public String Detail;
        public String Description;
        public String Status;
        public String CreatedBy;
        public String Owner;
        public String SRNumber;
        public String SRCreated;
        public String OwnerFirstName;
        public String OwnerLastName;
        public String Closeddate;
        public String Priority;
        private String[] TaskOriginator_type_info = new String[]{'TaskOriginator','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] Area_type_info = new String[]{'Area','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] SubArea_type_info = new String[]{'SubArea','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] Detail_type_info = new String[]{'Detail','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] CreatedBy_type_info = new String[]{'CreatedBy','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] Owner_type_info = new String[]{'Owner','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] SRNumber_type_info = new String[]{'SRNumber','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] SRCreated_type_info = new String[]{'SRCreated','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] OwnerFirstName_type_info = new String[]{'OwnerFirstName','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] OwnerLastName_type_info = new String[]{'OwnerLastName','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] Closeddate_type_info = new String[]{'Closeddate','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] Priority_type_info = new String[]{'Priority','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'TaskOriginator','Area','SubArea','Detail','Description','Status','CreatedBy','Owner','SRNumber','SRCreated','OwnerFirstName','OwnerLastName','Closeddate','Priority'};
    }
    public class FaultType {
        public String errorCode;
        public String errorMessage;
        public String correctionMessage;
        private String[] errorCode_type_info = new String[]{'errorCode','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] correctionMessage_type_info = new String[]{'correctionMessage','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'errorCode','errorMessage','correctionMessage'};
    }
    public class ServiceRequestsType {
        public lplComBtsLplsiebeladapterserviceSrre.ServiceRequestType[] ServiceRequest;
        private String[] ServiceRequest_type_info = new String[]{'ServiceRequest','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'ServiceRequest'};
    }
    public class ContactType {
        public lplComBtsLplsiebeladapterserviceSrre.ServiceRequestsType ServiceRequests;
        private String[] ServiceRequests_type_info = new String[]{'ServiceRequests','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'ServiceRequests'};
    }
    public class ResponseHeaderType {
        public String transactionId;
        public DateTime timeStamp;
        public String success;
        public lplComBtsLplsiebeladapterserviceSrre.FaultType fault;
        private String[] transactionId_type_info = new String[]{'transactionId','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] timeStamp_type_info = new String[]{'timeStamp','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'1','1','false'};
        private String[] fault_type_info = new String[]{'fault','http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRResponse/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'transactionId','timeStamp','success','fault'};
    }
    public class SRRequestType {
        public lplComBtsLplsiebeladapterserviceSrre.RequestHeaderType requestMessageHeader;
        public String repID;
        private String[] requestMessageHeader_type_info = new String[]{'requestMessageHeader','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] repID_type_info = new String[]{'repID','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'requestMessageHeader','repID'};
    }
    public class RequestHeaderType {
        public String securityToken;
        public String organization;
        public String transactionId;
        public DateTime timeStamp;
        public String sourceSystem;
        public String hostName;
        public String userId;
        private String[] securityToken_type_info = new String[]{'securityToken','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] organization_type_info = new String[]{'organization','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] transactionId_type_info = new String[]{'transactionId','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] timeStamp_type_info = new String[]{'timeStamp','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] sourceSystem_type_info = new String[]{'sourceSystem','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] hostName_type_info = new String[]{'hostName','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'1','1','false'};
        private String[] userId_type_info = new String[]{'userId','http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://lpl.com/BTS/LPLSiebelAdapterService/SRRequest/2015/04','false','false'};
        private String[] field_order_type_info = new String[]{'securityToken','organization','transactionId','timeStamp','sourceSystem','hostName','userId'};
    }
}