@SuppressWarnings('PMD.AvoidGlobalModifier,PMD.ExcessiveParameterList,PMD.CyclomaticComplexity,PMD.ApexCRUDViolation')
/**
* @Name SMS_Utils
* @description Twilio SMS  Utilities class.
* @date    12/08/2022
* @author  Sudhakar Y
*/
global with Sharing class SMS_Utils {  
    
    /**
* @description : This is InvocableMethod method used in Flows to invoke APex action to send SMS
* @param List<smsRequest> : its custom wrapper class Contains (smsSettingsName, smsBody and recordID) variables
* @return List<smsResponse> : its custom wrapper class Contains
*/  
    @InvocableMethod(label='Send SMS' description='Send SMS to customer mobile number')
    global  static List<SMSResponse> getSMSRequests(List<smsRequest> smsRequestList) {        
        List<SMSResponse> smsResponseList = new List<SMSResponse>();
        List<TwilioSMSJSONRESPONSE> smsWrapperList = new List<TwilioSMSJSONRESPONSE>();
        for(smsRequest sms : smsRequestList)
        {
            system.debug('HI ++++'+sms);
            Twilio_SMS_Settings__mdt twilioSMSSetting = Twilio_SMS_Settings__mdt.getInstance(sms.smsSettingsName);
            if(string.isNotBlank(sms.smsSettingsName) && twilioSMSSetting!=NULL
               && twilioSMSSetting.Active__c){
                   
                   TwilioSMSJSONRESPONSE response= SendSMS(twilioSMSSetting.From__c,twilioSMSSetting.To__c, sms.smsBody.replaceAll('<[/a-zAZ0-9]*>',''));
                   
                   SMSResponse res= new SMSResponse();
                   res.Id=SMS.RecordId;  
                   
                   if(response!=NULL){
                       response.SobjectId =SMS.RecordId;
                       response.from_number =twilioSMSSetting.From__c;
                       smsWrapperList.add(response);
                       res.goldNotificationSend=true;                            
                   }
                   else{
                       res.goldNotificationSend=false;  
                   }
                   
                   smsResponseList.add(res);
               }
        }
        
        insertSMSlogs(smsWrapperList);       
        return smsResponseList;       
    }
    
    
    /**
* @description : This method is used to Send SMS
* @param Phone_From : Contains the sender phone number
* @param Phone_To : Contains recipient phone number
* @param Body : Contains SMS Body string
* @return TwilioSMSJSONRESPONSE
*/  
    public  static TwilioSMSJSONRESPONSE sendSMS(String phoneFrom, String phoneTo,  String body){
        try{
            String smsReqBody= 'Body=' + EncodingUtil.urlEncode(body, 'UTF-8')
                + '&From=' + EncodingUtil.urlEncode(phoneFrom, 'UTF-8')
                + '&To=' + EncodingUtil.urlEncode(phoneTo, 'UTF-8');
            
            Map<String, object> extraParams = new Map<String, object>{'RecordId' =>''};
                
                HttpResponse response=ServiceAPI.callService('twilio_SMS',smsReqBody,NULL);
            
            // if((response.getStatusCode() == 200) || (response.getStatusCode() == 201)){  
            return  (TwilioSMSJSONRESPONSE)System.JSON.deserialize(response.getBody(), TwilioSMSJSONRESPONSE.class);           
            
            // }
            // return NULL;
        }
        catch(Exception ex){
            customException.logException(ex);
            return NULL;
        }
        
    }
    
    /**
* @description : This method is used to Insert SMS logs into SMS History object 
* @param smsWrapperList : Contains List of ALL SMS response logs
* @return void
*/ 
    public  static void insertSMSlogs(List<TwilioSMSJSONRESPONSE> smsWrapperList){
        try{
            List<SMS_History__c> smsHistoryList = new List<SMS_History__c>();
            for(TwilioSMSJSONRESPONSE smsRec:smsWrapperList){
                SMS_History__c smsEntry= New SMS_History__c();
                if(smsRec.SobjectId.startsWith('001')){
                    smsEntry.Account__c=smsRec.SobjectId;   
                }/*else if(smsRec.SobjectId.startsWith('003')){
                    smsEntry.Contact__c=smsRec.SobjectId;   // To enable SMS History tracking for contact
                } */          
                smsEntry.Account_Sid__c=smsRec.account_sid;
                smsEntry.body__c=smsRec.body;
                smsEntry.Date_Created__c=smsRec.date_created;
                smsEntry.Date_Sent__c=smsRec.date_sent;
                smsEntry.Error_Code__c=smsRec.error_code;
                smsEntry.Error_Message__c=smsRec.error_message;
                smsEntry.from__c=smsRec.from_number;
                smsEntry.status__c=smsRec.status;
                smsEntry.To__c=smsRec.to;
                smsEntry.Date_Updated__c=smsRec.date_updated;
                smsEntry.SID__c=smsRec.sid;
                smsEntry.URI__c=smsRec.uri;
                smsHistoryList.add(smsEntry);
            }
            database.insert(smsHistoryList,false); // The partial insert is supported.
            // Loop save result and handle the error records if any.           
        }
        catch(Exception ex){
            customException.logException(ex);
        }
    }    
    
    /**
* @description : This is Wrapper class used in Flow to include all required params in input request
*/ 
    global  class SMSRequest {
        @InvocableVariable(Required=true)
        global  String smsSettingsName; // Custom metadata record name
        
        @InvocableVariable(Required=true)
        global  String recordId;  // sobject record Id     
        
        @InvocableVariable(required=true)
        global  String smsBody; //SMS Body
    }
    
    /**
* @description : This is Wrapper class used in Flow to send response
*/ 
    global  class SMSResponse {
        @InvocableVariable(Required=true)
        global  String id; // sobject record Id
        
        @InvocableVariable(Required=true)
        global  boolean goldNotificationSend; // Flag to identify the SMS status     
        
    }    
}