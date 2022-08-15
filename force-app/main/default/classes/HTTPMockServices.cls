/**
* HttpCalloutMock Class for Test Coverage
* @date    14/08/2022
* @author  Sudhakar Y
*/
public class HTTPMockServices implements HttpCalloutMock  {
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    String jsonResponse;
    Integer httpCode;
    
    public HTTPMockServices(String json, Integer code) {
        this.jsonResponse=json;
        this.httpCode=code;
    }
    
    public HTTPResponse respond(HTTPRequest req) 
    {        
        // Create the response 
        // return the response based on request endpoint URL and details
        HttpResponse res = new HttpResponse(); 
        res.setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_JSON); 
        res.setBody(jsonResponse); 
        res.setStatusCode(this.httpCode); 
        return res; 
    } 
}