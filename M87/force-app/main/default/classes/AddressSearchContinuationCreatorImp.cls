public with sharing class AddressSearchContinuationCreatorImp {
    public Continuation createContinuation(AddressSearchStrategy strategy){
        
        try{
            return new ContinuationSupplierImp().setEndpoint(this.getEndpoint()+generateQuery(strategy))           
                .setMethod('GET').setTimeout(60)
                .authorize(new JWTAuthorization())
                .createContinuation();
        }catch(Exception ex){
            throw new Exceptions.CreateContinuationException('Cannot create continuation',ex);
        }        
    }

    private String getEndpoint(){
        return 'https://lightningdevdb-dev-ed.my.salesforce.com/services/data/v47.0/query/?q=';        
    }

    private String generateQuery(AddressSearchStrategy strategy){
        String query = 'select id,name,City__c,House_number__c,PostCode__c,Province__c,Street__c FROM Address__c';
        String condition = strategy.generateConditionStatement();  
        return EncodingUtil.urlEncode(query+' '+condition, 'UTF-8');        
    }

}
