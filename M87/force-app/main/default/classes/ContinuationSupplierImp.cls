public with sharing class ContinuationSupplierImp implements ContinuationSupplier {
    private final HttpRequest request;
    private Integer timeout;

    public ContinuationSupplierImp() {
        request = new HttpRequest();
    }

    public ContinuationSupplier authorize(Authorization authorization){
        if(authorization != null){
            authorization.authorize(request);
        }

        return this;
    }

    public ContinuationSupplier setMethod(String method){
        request.setMethod(method);
        return this;
    }

    public ContinuationSupplier setEndpoint(String endpoint){
        request.setEndpoint(endpoint);
        return this;
    }

    public ContinuationSupplier setTimeout(Integer timeout){
        this.timeout = timeout;
        return this;
    }

    public ContinuationSupplier setBody(String body){
        this.setBody(body);
        return this;
    }
    
    public ContinuationSupplier setHeaders(Map<String,String> headers){
        for(String header : headers.keySet()){
            request.setHeader(header, headers.get(header));
        }
        return this;        
    }   

    public Continuation createContinuation(){
        Continuation con = new Continuation(timeout);        
        con.addHttpRequest(request);

        return con;
    }
}