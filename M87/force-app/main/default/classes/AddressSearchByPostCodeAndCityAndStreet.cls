public with sharing class AddressSearchByPostCodeAndCityAndStreet implements AddressSearchStrategy{  
    private final AddressSearchParametersStorageImp parameters;

    public AddressSearchByPostCodeAndCityAndStreet(final AddressSearchParametersStorageImp parameters){
        this.parameters = parameters;
    }
    
    public String generateConditionStatement(){
        return 'WHERE PostCode__c = \''+ String.escapeSingleQuotes(parameters.getPostCode()) +'\''
            + ' AND City__c = \''+ String.escapeSingleQuotes(parameters.getCity()) + '\''
            + ' AND Street__c = \''+ parameters.getStreet()+'\'';
    }
}