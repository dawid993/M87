public with sharing class AddressSearchByPostCodeAndCityOrStreet implements AddressSearchStrategy{
    private final AddressSearchParametersStorageImp parameters;

    public AddressSearchByPostCodeAndCityOrStreet(final AddressSearchParametersStorageImp parameters){
        this.parameters = parameters;
    }

    public String generateConditionStatement(){
        return 'WHERE PostCode__c = \''+ String.escapeSingleQuotes(parameters.getPostCode()) +'\''
            + ' AND (City__c = \''+ String.escapeSingleQuotes(parameters.getCity()) + '\'' 
            + ' OR Street__c = \''+ String.escapeSingleQuotes(parameters.getStreet())+'\')';
    }
}