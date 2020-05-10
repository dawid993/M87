public with sharing class AddressSearchByPostCodeAndCityOrStreet implements AddressSearchStrategy{        
    public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
        return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\''
            + ' AND (City__c = \''+ parametersStorage.getCity() 
            + '\' OR Street__c = \''+ parametersStorage.getStreet()+'\')';
    }
}