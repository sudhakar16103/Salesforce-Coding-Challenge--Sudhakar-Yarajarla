@isTest 
public class SMSQuickActionControllerTest {
    
    @isTest 
    public static void unitTestMethodPostiveSMSQuickActionController() {
        // Twilio_SMS_Settings__mdt supportTier = [SELECT Id, DeveloperName from Twilio_SMS_Settings__mdt where DeveloperName ='Account' LIMIT 1];
        Service_Setting__mdt twilioSMS = [SELECT Id, DeveloperName from Service_Setting__mdt where DeveloperName ='twilio_SMS' LIMIT 1];
        Account acc = AccountTestDataFactory.createAccount(true);
        acc.Phone='12345678';
        update acc;
        Map<String,String> returnMap = SMSQuickActionController.getPhoneNumbers('Account', acc.Id) ;
        system.assertEquals(returnMap.get('phone(12345678)'), '12345678','Phone number is wrong');// Validating the test result expected and actual values
        string returnResponse=  SMSQuickActionController.sendSMS('Account', '+447093376690', 'Test SMS', acc.Id);
        system.assertNotEquals(returnResponse, '','Response Not received');
        
    }
    
    @isTest 
    public static void unitTestMethodNegativeSMSQuickActionController() {        
        
        Twilio_SMS_Settings__mdt supportTier = [SELECT Id, DeveloperName from Twilio_SMS_Settings__mdt where DeveloperName ='Account' LIMIT 1];
        Service_Setting__mdt twilioSMS = [SELECT Id, DeveloperName from Service_Setting__mdt where DeveloperName ='twilio_SMS' LIMIT 1];
        Account acc = AccountTestDataFactory.createAccount(true);
        SMSQuickActionController.getPhoneNumbers('Account_NULL', acc.Id);        
        
        String json=		'{'+
            '  "account_sid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",'+
            '  "api_version": "2010-04-01",'+
            '  "body": "Hi there",'+
            '  "date_created": "Thu, 30 Jul 2015 20:12:31 +0000",'+
            '  "date_sent": "Thu, 30 Jul 2015 20:12:33 +0000",'+
            '  "date_updated": "Thu, 30 Jul 2015 20:12:33 +0000",'+
            '  "direction": "outbound-api",'+
            '  "error_code": null,'+
            '  "error_message": null,'+
            '  "from": "+15017122661",'+
            '  "messaging_service_sid": "MGXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",'+
            '  "num_media": "0",'+
            '  "num_segments": "1",'+
            '  "price": null,'+
            '  "price_unit": null,'+
            '  "sid": "SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",'+
            '  "status": "sent",'+
            '  "subresource_uris": {'+
            '    "media": "/2010-04-01/Accounts/ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Messages/SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Media.json"'+
            '  },'+
            '  "to": "+15558675310",'+
            '  "uri": "/2010-04-01/Accounts/ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Messages/SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.json"'+
            '}					';
        
        Test.setMock(HttpCalloutMock.class, new HTTPMockServices(json,200)); // dummy response setting up using mock services
        test.startTest(); // Used to reset the limits
        String returnResponse= SMSQuickActionController.sendSMS('Account', '+447093376690', 'Test SMS', acc.Id);
        test.stopTest();
        system.assertNotEquals(returnResponse, '','Response Not received');
    }
    
    
    @isTest 
    public static void myUnitTest22() {
        Twilio_SMS_Settings__mdt supportTier = [SELECT Id, DeveloperName from Twilio_SMS_Settings__mdt where DeveloperName ='CEO_GOLD_ACCOUNT_SMS' LIMIT 1];
        // Service_Setting__mdt twilio_SMS = [SELECT Id, DeveloperName from Service_Setting__mdt where DeveloperName ='CEO_GOLD_ACCOUNT_SMS' LIMIT 1];
        Account acc = AccountTestDataFactory.createAccount(true);
        SMS_Utils.SMSRequest request= new SMS_Utils.SMSRequest();
        request.RecordId=acc.Id;
        request.smsBody='Test SMS';
        request.smsSettingsName='CEO_GOLD_ACCOUNT_SMS';
        LIST<SMS_Utils.SMSRequest> smsRequestList= new LIST<SMS_Utils.SMSRequest>();
        smsRequestList.add(request);        
        
        String json=		'{'+
            '  "account_sid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",'+
            '  "api_version": "2010-04-01",'+
            '  "body": "Hi there",'+
            '  "date_created": "Thu, 30 Jul 2015 20:12:31 +0000",'+
            '  "date_sent": "Thu, 30 Jul 2015 20:12:33 +0000",'+
            '  "date_updated": "Thu, 30 Jul 2015 20:12:33 +0000",'+
            '  "direction": "outbound-api",'+
            '  "error_code": null,'+
            '  "error_message": null,'+
            '  "from": "+15017122661",'+
            '  "messaging_service_sid": "MGXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",'+
            '  "num_media": "0",'+
            '  "num_segments": "1",'+
            '  "price": null,'+
            '  "price_unit": null,'+
            '  "sid": "SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",'+
            '  "status": "sent",'+
            '  "subresource_uris": {'+
            '    "media": "/2010-04-01/Accounts/ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Messages/SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Media.json"'+
            '  },'+
            '  "to": "+15558675310",'+
            '  "uri": "/2010-04-01/Accounts/ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Messages/SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.json"'+
            '}					';
        
        Test.setMock(HttpCalloutMock.class, new HTTPMockServices(json,200)); //dummy response setting up using mock services
        
        test.startTest(); // Used to reset the limits
        LIST<SMS_Utils.SMSResponse> smsResponse= new LIST<SMS_Utils.SMSResponse>();        
        smsResponse = SMS_Utils.getSMSRequests(smsRequestList);
        test.stopTest();        
        system.assertEquals(smsRequestList[0].RecordId, smsResponse[0].Id,'Account Ids not matching');   // Validating the test result expected and actual values.
    }
    
    
    
}