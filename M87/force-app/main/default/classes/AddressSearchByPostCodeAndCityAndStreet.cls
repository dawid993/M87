public with sharing class AddressSearchByPostCodeAndCityAndStreet implements AddressSearchStrategy{        
    public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
        return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode() +'\''
                + ' AND City__c = \''+ parametersStorage.getCity() 
                + '\' AND Street__c = \''+ parametersStorage.getStreet()+'\'';
    }
}