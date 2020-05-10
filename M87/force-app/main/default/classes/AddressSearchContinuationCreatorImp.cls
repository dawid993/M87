public with sharing class AddressSearchContinuationCreatorImp implements AddressSearchContinuationCreator{
    public Continuation createContinuation(
        AddressSearchParametersStorage parameterStorage,
        AddressSearchStrategy strategy
    ){
        
        ContinuationSupplier supplier =
            (ContinuationSupplier) Application.Service.newInstance(ContinuationSupplier.class);
        
        try{
            return supplier.setEndpoint(this.getEndpoint()+generateQuery(parameterStorage, strategy))           
                .setMethod('GET').setTimeout(60)
                .authorize(new JWTAuthorization())
                .createContinuation();
        }catch(Exception ex){
            throw new CreateContinuationException('Cannot create continuation',ex);
        }        
    }

    private String getEndpoint(){
        return 'https://lightningdevdb-dev-ed.my.salesforce.com/services/data/v47.0/query/?q=';        
    }

    private String generateQuery(AddressSearchParametersStorage parameterStorage,AddressSearchStrategy strategy){
        String query = 'select id,name,City__c,House_number__c,PostCode__c,Province__c,Street__c FROM Address__c';
        String condition = strategy.generateConditionStatement(parameterStorage);  
        return EncodingUtil.urlEncode(query+' '+condition, 'UTF-8');        
    }

}
