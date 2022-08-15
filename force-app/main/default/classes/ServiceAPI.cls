/**
* Utilities class for API calls.
*Common class handling HTTP calls.
* @date    12/08/2022
* @author  Sudhakar Y
*/

public with Sharing class ServiceAPI {  
    
    
    /**
* @description : This method is used to invoke the HTTP Requests
* @param serviceName : Contains the Service Settings name
* @param body : Contains API Request Body data
* @param extraParams : Contains all the extra params required for this service call
* @return HttpResponse
*/
    public static HttpResponse callService(String serviceName, String body,  Map<string, Object> extraParams) {
        try {
            
            Service_Setting__mdt service = Service_Setting__mdt.getInstance(serviceName);
            if(service==NULL){
                throw new CustomException('Service Not Found');
            }
            
            String endPoint = 'callout:' + service.Named_Credential__c;
            endPoint += service.Resource__c;          
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod(service.Method__c);
            
            if(service.Timeout__c!=null){
                request.setTimeout((Integer) service.Timeout__c);  
            } 
            
            if(body!=null){
                request.setBody(body);  
            }
            
            // set headers in request and exception            
            List<String> headers = service.RequestHeaderKeys__c.split(',');
            List<String> headerValues = service.Request_Header_Values__c.split(',');
            Integer i = 0;
            for(String s: headers){
                request.setHeader(s, headerValues[i]);
                i++;
            }
            
            System.debug('request ++'+request.getBody());
            HttpResponse response = http.send(request);
            System.debug('response ++'+response.getBody()); 
            // if((response.getStatusCode() == 200) || (response.getStatusCode() == 201)) {                
            return response;
            // }            
            
        } catch(Exception e){
            system.debug('Line '+e.getLineNumber());
            customException.LogException(e);
            //log error
            return null;
            
        }
    }
    
}