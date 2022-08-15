@SuppressWarnings('PMD.variablenamingconventions,PMD.ExcessivePublicCount ') // Used to suppress PMD warnings when APEX PMD is run for code analysis

/**
* @Name TwilioSMSJSONRESPONSE
* @description  Twilio SMS Response wrapper class for deserialize json to wrapper class.
* @date    13/08/2022
* @author  Sudhakar Y
*/
public with sharing class TwilioSMSJSONRESPONSE {    
    public String to{get;set;}
    // public String num_media{get;set;}
    public String date_created{get;set;}
    public String account_sid{get;set;}
    public String status{get;set;}
    public String uri{get;set;}
    public String sid{get;set;}
    public String error_message{get;set;}
    public String date_sent{get;set;}
    //public String price{get;set;}
    // public String messaging_service_sid{get;set;}
    public String date_updated{get;set;}
    public String error_code{get;set;}
    public String from_number{get;set;}
    // public String price_unit{get;set;}
    // public String direction{get;set;}
    // public String api_version{get;set;}
    // public String num_segments{get;set;}
    //public subresource_uris subresource_uris{get;set;}
    public String body{get;set;}
    public String SobjectId{get;set;}
    public String message{get;set;}
    public String more_info{get;set;}
    
    // public class subresource_uris{
    //    public String media{get;set;}
    //}
}