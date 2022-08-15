@SuppressWarnings('PMD.ExcessiveParameterList') // Used to suppress PMD warnings when APEX PMD is run for code analysis
/**
* @Name SMSQuickActionController
* @description  SMSQuickActionController class used in LWC(sendSMS).
* @date    13/08/2022
* @author  Sudhakar Y
*/
public with Sharing class SMSQuickActionController {
    /**
* @description : This method is used to get all Phone number fields and data on any sobject record
* @param sobjectName : Contains the sObject API name
* @param recordId : Contains salesforce record ID
* @return options in Map of Map<String,String>
*/
    @AuraEnabled(cacheable=true)
    Public static Map<String,String> getPhoneNumbers(String sobjectName, Id recordId){ 
        try{
            system.debug('sobjectName+'+sobjectName);
            Map<String, String> phoneFieldMap = new Map<String, String>();
            List<String> phoneFields=new List<String>();
            SObjectType sObjectSchema = Schema.getGlobalDescribe().get(sobjectName);
            Map<String,Schema.SObjectField> metaDataFields = sObjectSchema.getDescribe().fields.getMap();
            system.debug(''+metaDataFields);
            for(string res : metaDataFields.keyset()) {
                Schema.DescribeFieldResult desribeResult = metaDataFields.get(res).getDescribe();
                if(desribeResult.getType().Name()=='PHONE'){
                    phoneFields.add(res);  
                }
            }
                        
            sobject record= Database.query(String.escapeSingleQuotes('SELECT '+String.join(phoneFields, ', ')+' FROM '+sobjectName +' where Id=:recordId Limit 1'));
            for(String field:phoneFields){
                system.debug('field++'+record.get(field)); 
                // options.add(new SelectOption(field+'('+record.get(field)+')',(string)record.get(field)));
                string labelString=field+'('+record.get(field)+')';
                phoneFieldMap.put(labelString,(string)record.get(field)); 
            }
            system.debug('phoneFields@@@@'+phoneFieldMap);   
            return phoneFieldMap ; 
        }
        catch(Exception ex){
            return NULL;            
        }
        
    }
    
    
    /**
* @description : This method is used to Send SMS from LWC Component
* @param serviceName : Contains the Service Settings metadata data type record name
* @param Send_To : Contains Send to Phone number
* @param body : Contains SMS Body
* @param recordId : Contains salesforce record ID
* @return string SMS response
*/
    @AuraEnabled 
    Public static string sendSMS(String serviceName, string sendTo, String body,Id recordId){        
        try{
            List<TwilioSMSJSONRESPONSE> smsWrapperList = new List<TwilioSMSJSONRESPONSE>();
            Twilio_SMS_Settings__mdt twilioSMSSetting = Twilio_SMS_Settings__mdt.getInstance(serviceName);
            system.debug('££'+twilioSMSSetting);
            if(twilioSMSSetting!=NULL && twilioSMSSetting.Active__c){
                TwilioSMSJSONRESPONSE response= SMS_Utils.SendSMS(twilioSMSSetting.From__c,sendTo,body);
                system.debug('RESPONSE+'+response);
                response.SobjectId =recordId;
                response.from_number =twilioSMSSetting.From__c;
                smsWrapperList.add(response);
                SMS_Utils.insertSMSlogs(smsWrapperList);
                system.debug('RESPONSE+++'+response);
                return JSON.serialize(response); 
            }
            return NULL;
        }
        catch(Exception ex){
            return NULL;            
        }
    }
}