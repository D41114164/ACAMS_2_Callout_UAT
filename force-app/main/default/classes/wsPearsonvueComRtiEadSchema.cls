//Generated by wsdl2apex

public class wsPearsonvueComRtiEadSchema {
    public class eadRequestType {
        public String clientCandidateID;
        public Integer examAuthorizationCount;
        public String examSeriesCode;
        //public wsPearsonvueComRtiEadSchema.modulesType modules;
        //public String isAllModulesAuthorized;
        public String eligibilityApptDateFirst;
        public String eligibilityApptDateLast;
        public String lastUpdate;
        //  public wsPearsonvueComRtiEadSchema.customFieldsType customFields;
        public wsPearsonvueComRtiEadSchema.clientAccommodationsType clientAccommodations;
        public Integer clientID;
        public String authorizationTransactionType;
        public Integer authorizationID;
        public String clientAuthorizationID;
        private String[] clientCandidateID_type_info = new String[]{
                'clientCandidateID', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] examAuthorizationCount_type_info = new String[]{
                'examAuthorizationCount', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '1', 'false'
        };
        private String[] examSeriesCode_type_info = new String[]{
                'examSeriesCode', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] modules_type_info = new String[]{
                'modules', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '1', 'false'
        };
        private String[] isAllModulesAuthorized_type_info = new String[]{
                'isAllModulesAuthorized', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] eligibilityApptDateFirst_type_info = new String[]{
                'eligibilityApptDateFirst', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] eligibilityApptDateLast_type_info = new String[]{
                'eligibilityApptDateLast', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] lastUpdate_type_info = new String[]{
                'lastUpdate', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] customFields_type_info = new String[]{
                'customFields', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '1', 'false'
        };
        private String[] clientAccommodations_type_info = new String[]{
                'clientAccommodations', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '1', 'false'
        };
        private String[] clientID_att_info = new String[]{
                'clientID'
        };
        private String[] authorizationTransactionType_att_info = new String[]{
                'authorizationTransactionType'
        };
        private String[] authorizationID_att_info = new String[]{
                'authorizationID'
        };
        private String[] clientAuthorizationID_att_info = new String[]{
                'clientAuthorizationID'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
                'clientCandidateID', 'examAuthorizationCount', 'examSeriesCode', 'eligibilityApptDateFirst', 'eligibilityApptDateLast', 'lastUpdate', 'clientAccommodations'
        };
    }
    public class customFieldsType {
        public wsPearsonvueComRtiEadSchema.fieldType[] customField;
        private String[] customField_type_info = new String[]{
                'customField', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '-1', 'false'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
                'customField'
        };
    }
    public class moduleType {
        public String moduleName;
        private String[] moduleName_att_info = new String[]{
                'moduleName'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
        };
    }
    public class modulesType {
        public wsPearsonvueComRtiEadSchema.moduleType[] module;
        public String isAllModulesAuthorized;
        public Integer useModuleSequence;
        private String[] module_type_info = new String[]{
                'module', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '-1', 'false'
        };
        private String[] isAllModulesAuthorized_type_info = new String[]{
                'isAllModulesAuthorized', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] useModuleSequence_att_info = new String[]{
                'useModuleSequence'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
                'module', 'isAllModulesAuthorized'
        };
    }
    public class clientAccommodationType {
        public String accommodationCode;
        private String[] accommodationCode_att_info = new String[]{
                'accommodationCode'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
        };
    }
    public class clientAccommodationsType {
        public wsPearsonvueComRtiEadSchema.clientAccommodationType[] clientAccommodation;
        private String[] clientAccommodation_type_info = new String[]{
                'clientAccommodation', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '-1', 'false'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
                'clientAccommodation'
        };
    }
    public class fieldType {
        public String screen;
        public String fieldName;
        private String[] screen_att_info = new String[]{
                'screen'
        };
        private String[] fieldName_att_info = new String[]{
                'fieldName'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
        };
    }
    public class eadResponseType {
        public String clientCandidateID;
        public String status;
        public String message;
        public String date_x;
        public Integer authorizationID;
        public String clientAuthorizationID;
        private String[] clientCandidateID_type_info = new String[]{
                'clientCandidateID', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] status_type_info = new String[]{
                'status', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] message_type_info = new String[]{
                'message', 'http://ws.pearsonvue.com/rti/ead/schema', null, '0', '1', 'false'
        };
        private String[] date_x_type_info = new String[]{
                'date', 'http://ws.pearsonvue.com/rti/ead/schema', null, '1', '1', 'false'
        };
        private String[] authorizationID_att_info = new String[]{
                'authorizationID'
        };
        private String[] clientAuthorizationID_att_info = new String[]{
                'clientAuthorizationID'
        };
        private String[] apex_schema_type_info = new String[]{
                'http://ws.pearsonvue.com/rti/ead/schema', 'false', 'false'
        };
        private String[] field_order_type_info = new String[]{
                'clientCandidateID', 'status', 'message', 'date_x'
        };
    }
}