public with sharing class AddressSearchServiceImp {  
    private final AddressSearchStrategy searchStrategy;   
    
    public AddressSearchServiceImp(final AddressSearchStrategy searchStrategy){
        this.searchStrategy = searchStrategy;       
    }

    public Continuation createContinuationJob(){            
        return new AddressSearchContinuationCreatorImp().createContinuation(searchStrategy);
    }    
    
    public List<AddressStructure> parseResponseAndReturnAddresses(String jsonResponse){
        try{
            return String.isBlank(jsonResponse)
                ? new List<AddressStructure>()
                : parseResponse(jsonResponse);  
        }catch(Exception ex){
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return new List<AddressStructure>();
        }       
    }

    private List<AddressStructure> parseResponse(String jsonResponse){
        AddressParser parser = (AddressParser) Application.Service.newInstance(AddressParser.class);
        return parser.parseAddresses(jsonResponse);
    }
}
