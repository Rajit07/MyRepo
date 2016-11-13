public class Pardot {

    public static void sendAutoReplyEmail (){
    	String api_key = getAPIKey();
        String url = 'https://pi.pardot.com/api/email/version/3/do/send/prospect_id/52786744?';
        String body = 'user_key='+ '8136f2d949f9faba51ea90b41f321cc1'
            		  +'&api_key=' +api_key 
            		  +'&campaign_id=42286'
            		 //+'&email_template_id=32834'
            		  +'&text_content=Hi %%first_name%%,' +
            			 'Testing with a test email'+
            			 'Thanks'+
            			 'Tester'
            		  +'&format=json'
        			  +'&name=API Testing'
        		      +'&subject=Test Email'
            		  +'&from_user_id=4766272';
		

        
        httpCallout(url, body);
    }
    
    /**
     * HTTP CALLOUTS
     * HttpRequest handler method
     */
    public static HttpResponse httpCallout(String url, String body){
        HttpRequest     request     = new HttpRequest();
        HttpResponse    response    = new HttpResponse();
        Http            http        = new Http();

        request.setEndPoint(url);
        request.setBody(body);
        request.setMethod('POST');

        /* Try to send the request */
        try {
            response = http.send(request);
            System.debug('::RESPONSE::'+response.getBody());
            return response;
        } catch(System.CalloutException e) {
            System.debug('ERROR: '+ e);
            return null;
        }
    }
    
    public static String getAPIKey (){
        String Connector_Email = EncodingUtil.urlEncode('rajit.nair@makepositive.com', 'UTF-8');
        String Connector_Password = EncodingUtil.urlEncode('MyPardot!1', 'UTF-8');
        String Connector_User_Key = EncodingUtil.urlEncode('8136f2d949f9faba51ea90b41f321cc1', 'UTF-8');

        String body = 'email='+Connector_Email
            +'&password='+Connector_Password
            +'&user_key='+Connector_User_Key;
        
        HttpRequest req = new HttpRequest();
    	HttpResponse response = new HttpResponse();
    	Http http = new Http();
    	req.setEndpoint('https://pi.pardot.com/api/login/version/3');
    	req.setMethod('POST');
    	req.setBody(body);
    	
    try {
        response = http.send(req);
        System.debug('Response Body' + response.getBody());
        
         /* Parse API Response */
        Dom.Document doc = new Dom.Document();
        doc.load(response.getBody());
        Dom.XMLNode root = doc.getRootElement();
        if(root.getName()=='rsp') {
            for(Dom.XMLNode node1: root.getChildElements()) {
                if(node1.getName()=='err') {
                    String err = root.getChildElement('err', null).getText();
                    String code = root.getChildElement('err', null).getAttribute('code', null);
                    System.debug('::API REQUEST ERROR:: '+code+' - '+err);
                    return err;
                }
                if(node1.getName()=='api_key') {
                    /* Store API in variable */
                    // TODO: Store API for 1 hour in Global__c
                    String api_key = root.getChildElement('api_key', null).getText();
                    system.debug( 'API KEY' + api_key);
                    return api_key;
                }
            }
        }
        
    } catch(System.CalloutException e) {
        System.debug('Callout error: '+ e);
        return e.getMessage();
    }
    return '';
}
}