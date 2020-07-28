public with sharing class EngagementLeadFlowControllre {
    
    @AuraEnabled
    public static void save(String fileAsBase64Blob){
        System.debug(fileAsBase64Blob);
        System.debug(Blob.valueOf(fileAsBase64Blob));
        Attachment attach1= new Attachment();
        attach1.ParentId = '0013E00001D93xrQAB';
        attach1.Name = 'Test Attachment for PDF';
        attach1.Body = EncodingUtil.base64Decode(fileAsBase64Blob);
        attach1.contentType = 'image/png';
	    	insert attach1;
    }
}
 