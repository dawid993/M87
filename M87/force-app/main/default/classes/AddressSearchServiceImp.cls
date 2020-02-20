public with sharing class AddressSearchServiceImp implements AddressSearchService,AddressSearchParametersStorage{
    private String postCode;
    private String city;
    private String street;
    private String houseNumber;

    private AddressSearchStrategy searchStrategy;
    
    public String getPostCode(){
        return postCode;
    }
    
    public String getCity(){
        return city;
    }

    public String getStreet(){
        return street;
    }

    public String getHouseNumber(){
        return houseNumber;
    }

    public void setFullSearchParameters(String postCode,String city,String street,String houseNumber){  
        clearPreviousParameters();      
        this.postCode = postCode;   
        this.city = city;
        this.street = street;
        this.houseNumber = houseNumber;
        this.searchStrategy = new AddreasSearchByFullParametersSearch();
    }  
    
    public void setSearchByPostCodeAndCityAndStreet(String postCode,String city,String street){
        clearPreviousParameters();  
        this.postCode = postCode;   
        this.city = city;
        this.street = street;
        this.searchStrategy = new AddreasSearchByPostCodeAndCityAndStreet();
    }

    public void setSearchByPostCodeOrStreet(String postCode,String cityOrStreet){
        clearPreviousParameters();
        this.postCode = postCode;   
        this.city = cityOrStreet;
        this.street = cityOrStreet;
        this.searchStrategy = new AddreasSearchByPostCodeAndCityOrStreet();
    }

    public void setSearchByPostCode(String postCode){
        clearPreviousParameters();
        this.postCode = postCode; 
        this.searchStrategy = new AddreasSearchByPostCode();
    }

    public Continuation createContinuationJob(){
        ContinuationSupplier supplier = new ContinuationSupplierImp();
        return supplier.setEndpoint(this.getEndpoint())
        .setMethod('GET').setTimeout(60)
        .authorize(new JWTAuthorization())
        .createContinuation();
    }

    private void clearPreviousParameters(){
        postCode = '';
        street = '';
        city = '';
        houseNumber = '';
        searchStrategy = null;
    }

    private String getEndpoint(){
        String endpoint = '	https://lightningdevdb-dev-ed.my.salesforce.com/services/data/v47.0/query/?q=';
        String query = 'select id,name,City__c,House_number__c,PostCode__c,Province__c,Street__c FROM Address__c';
            
    
        String condition = searchStrategy.generateConditionStatement(this);        
        return endpoint+EncodingUtil.urlEncode(query+' '+condition, 'UTF-8');
    }    

    public class AddreasSearchByPostCode implements AddressSearchStrategy{
        public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
            return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\'';
        }
    }

    public class AddreasSearchByPostCodeAndCityOrStreet implements AddressSearchStrategy{        
        public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
            return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\''
                    + ' AND (City__c = \''+ parametersStorage.getCity() + '\' OR Street__c = \''+ parametersStorage.getStreet()+'\')';
        }
    }

    public class AddreasSearchByPostCodeAndCityAndStreet implements AddressSearchStrategy{        
        public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
            return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\''
                    + ' AND City__c = \''+ parametersStorage.getCity() + '\' AND Street__c = \''+ parametersStorage.getStreet()+'\'';
        }
    }

    public class AddreasSearchByFullParametersSearch implements AddressSearchStrategy{        
        public String generateConditionStatement(AddressSearchParametersStorage parametersStorage){
            return 'WHERE PostCode__c = \''+ parametersStorage.getPostCode()+'\''
                    + ' AND City__c = \''+ parametersStorage.getCity() + '\' AND Street__c = \''+ parametersStorage.getStreet()+'\'' 
                    + ' AND House_Number__c = \''+parametersStorage.getHouseNumber() +'\'';
        }
    }
}
