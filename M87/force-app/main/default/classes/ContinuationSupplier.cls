public interface ContinuationSupplier {
    ContinuationSupplier authorize(Authorization authorization);
    ContinuationSupplier setMethod(String method);
    ContinuationSupplier setEndpoint(String endpoint);
    ContinuationSupplier setTimeout(Integer timeout);
    ContinuationSupplier setBody(String body);    
    ContinuationSupplier setHeaders(Map<String,String> headers);
    Continuation createContinuation();   

}