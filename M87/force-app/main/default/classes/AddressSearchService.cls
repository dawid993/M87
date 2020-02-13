public interface AddressSearchService extends Continuable{
    void setSearchingParams(String postCode,String city,String street);
    Continuation createContinuationJob();
}