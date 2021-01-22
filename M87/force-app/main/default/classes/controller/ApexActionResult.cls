public class ApexActionResult {
    
    @AuraEnabled 
    public Boolean success;

    @AuraEnabled   
    public Object detailedResult;

    private ApexActionResult(Boolean success, Object detailedResult){
        this.success = success;
        this.detailedResult = detailedResult;
    }

    public static ApexActionResult success(){
        return new ApexActionResult(true,null);
    }
    
    public static ApexActionResult success(Object detailedResult){
        return new ApexActionResult(true,detailedResult);
    }

    public static ApexActionResult fail(Object detailedResult){
        return new ApexActionResult(false,detailedResult); 
    }
}
