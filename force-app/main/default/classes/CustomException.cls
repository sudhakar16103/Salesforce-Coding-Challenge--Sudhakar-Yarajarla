@SuppressWarnings('PMD.ApexCRUDViolation')
/**
* @Name CustomException
* @description  Custom exception class to log the all exceptions in system log object.
* @date    13/08/2022
* @author  Sudhakar Y
*/

public with Sharing class CustomException extends Exception{
    /**
* @description : This method is used to log exception record in system log object
* @param Exception : Contains the Service Settings name
* @return void
*/   
    public static void logException(Exception e)
    {
        LogException(e,'');
    }
    
    /**
* @description : This method is used to log exception record in system log object
* @param Exception : Contains the Service Settings name
* @param relatedToId : Contains API Request Body data
* @return void
*/
    
    public static void logException(Exception e,string relatedToId)
    {
        try
        {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');          
            
            
            //Log information in System_Log object
            System_Log__c exc = new System_Log__c();
            exc.Related_Record_Id__c=relatedToId;
            exc.Stack_Trace__c = e.getMessage();
            exc.Reference__c = e.getTypeName();
            exc.Response_Code__c = e.getLineNumber();
            exc.Service_Name__c = e.getStackTraceString();
            exc.Method__c=methodName;
            exc.Class__c=className;
            database.insert(exc); 
            // Loop save result and handle the error records if any.
        }catch(Exception ex){
            system.debug(''+ex.getCause()); 
        }
                  
    } 
}