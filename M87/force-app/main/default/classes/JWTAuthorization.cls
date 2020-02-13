public with sharing class JWTAuthorization implements Authorization {
    private static final String JWTConfName = 'Address_fks';

    public void authorize(HttpRequest request){
        JWTAuthorization__mdt config = retrieveJWTSettings();
        if(config == null){
            throw new AuthorizationException('Configuration for JWT cannot be found.');            
        }

        Auth.JWS jws = generateJWS(config);
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(config.Endpoint__c, jws);        
        String accessToken = bearer.getAccessToken();
        request.setHeader('Authorization', 'Bearer '+accessToken);
    }

    private JWTAuthorization__mdt retrieveJWTSettings(){
        return [SELECT MasterLabel,DeveloperName,Audience__c,CertName__c,Endpoint__c,Issuer__c,Subject__c 
            FROM JWTAuthorization__mdt WHERE DeveloperName = :JWTConfName LIMIT 1];
    }

    private Auth.JWS generateJWS(JWTAuthorization__mdt config){
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub(config.Subject__c); 
        jwt.setAud(config.Audience__c); 
        jwt.setIss(config.Issuer__c);
        return new Auth.JWS(jwt,config.CertName__c);
    }
}