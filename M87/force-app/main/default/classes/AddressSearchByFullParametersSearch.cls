public with sharing class AddressSearchByFullParametersSearch implements AddressSearchStrategy{        
    public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
        return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\''
                + ' AND City__c = \''+ parametersStorage.getCity() 
                + '\' AND Street__c = \''+ parametersStorage.getStreet()+'\'' 
                + ' AND House_Number__c = \''+parametersStorage.getHouseNumber() +'\'';
    }
} 