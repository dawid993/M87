public with sharing class AddressSearchByPostCode implements AddressSearchStrategy{
    public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
        return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\'';
    }
}