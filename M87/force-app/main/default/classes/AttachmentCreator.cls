public with sharing class AttachmentCreator {

    private static final String IMAGE_PNG = 'image/png';
    private Attachment attach;

    public AttachmentCreator(String attachmentName,String attachmentBody){
        attach = new Attachment();
        attach.Name = attachmentName;
        attach.Body = EncodingUtil.base64Decode(attachmentBody);
        attach.contentType = IMAGE_PNG;
    }

    public Attachment getAttachment(){
        return attach;
    }
}
