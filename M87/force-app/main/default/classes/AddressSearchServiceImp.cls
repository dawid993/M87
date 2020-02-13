public with sharing class AddressSearchServiceImp implements AddressSearchService{
    private String postCode;
    private String city;
    private String street;
    
    public void setSearchingParams(String postCode,String city,String street){
        this.postCode = postCode;   
        this.city = city;
        this.street = street;
    }
    

    public Continuation createContinuationJob(){
        ContinuationSupplier supplier = new ContinuationSupplierImp();
        return supplier.setEndpoint(this.getEndpoint())
        .setMethod('GET').setTimeout(60)
        .authorize(new JWTAuthorization())
        .createContinuation();
    }

    private String getEndpoint(){
        String endpoint = '	https://lightningdevdb-dev-ed.my.salesforce.com/services/data/v47.0/query/?q=';
        String query = 'select id,name,City__c,House_number__c,PostCode__c,Province__c,Street__c FROM Address__c';
            
    
        String condition = ' WHERE';
        condition += String.isNotBlank(postCode) ? ' PostCode__c = \''+postCode+'\' OR' : '';
        condition += String.isNotBlank(city) ? ' City__c = \''+city+'\' OR' : '';
        condition += String.isNotBlank(street) ? ' Street__c  = \''+street+'\' OR' : '';
        condition = condition.removeEnd('OR');
        
        return endpoint+EncodingUtil.urlEncode(query+condition, 'UTF-8');
    }
}
