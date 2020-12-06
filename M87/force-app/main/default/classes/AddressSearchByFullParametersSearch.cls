public with sharing class AddressSearchByFullParametersSearch implements AddressSearchStrategy {   
    private final AddressSearchParametersStorageImp parameters;

    public AddressSearchByFullParametersSearch(final AddressSearchParametersStorageImp parameters){
        this.parameters = parameters;
    }     
    public String generateConditionStatement(){
        return 'WHERE PostCode__c = \'' + String.escapeSingleQuotes(parameters.getPostCode()) +'\''
                + ' AND City__c = \'' + String.escapeSingleQuotes(parameters.getCity()) + '\''
                + ' AND Street__c = \'' +  String.escapeSingleQuotes(parameters.getStreet()) + '\'' 
                + ' AND House_Number__c = \'' + String.escapeSingleQuotes(parameters.getHouseNumber()) +'\'';
    }
} 