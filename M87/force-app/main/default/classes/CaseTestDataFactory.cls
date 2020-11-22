@isTest
public with sharing class CaseTestDataFactory {
    
    public static Case createDefaultEngagementCase(){
        return new CaseBuilder()
        .setRecordTypeId(RecordTypeRepository.CASE_ENGAGEMENT_RT_ID)
        .setPriority(CaseUtils.PRIORITY_HIGH)
        .setStatus(CaseUtils.PRIORITY_HIGH)
        .setSubject('Test')
        .build();
    }    

    public static Case createDefaultCase(){
        return new CaseBuilder()        
        .setPriority(CaseUtils.PRIORITY_HIGH)
        .setStatus(CaseUtils.PRIORITY_HIGH)
        .setSubject('Test')
        .build();
    }   

    public static Case createEngagementCase(String priority,String status, String subject){
        return new CaseBuilder()
        .setRecordTypeId(RecordTypeRepository.CASE_ENGAGEMENT_RT_ID)
        .setPriority(priority)
        .setStatus(status)
        .setSubject(subject)
        .build();
    }
}
