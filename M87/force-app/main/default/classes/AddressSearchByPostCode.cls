public with sharing class AddressSearchByPostCode implements AddressSearchStrategy{
    private final AddressSearchParametersStorageImp parameters;

    public AddressSearchByPostCode(final AddressSearchParametersStorageImp parameters){
        this.parameters = parameters;
    }
    
    public String generateConditionStatement(){
        return 'WHERE PostCode__c = \''+ String.escapeSingleQuotes(parameters.getPostCode())+'\'';
    }
}