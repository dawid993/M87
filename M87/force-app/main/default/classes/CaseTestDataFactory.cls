@isTest
public with sharing class CaseTestDataFactory {
    
    public static Case createEngagementCase(){
        return new CaseBuilder()
        .setRecordTypeId(RecordTypeRepository.CASE_ENGAGEMENT_RT_ID)
        .setPriority('High')
        .setStatus('In Progress')
        .setSubject('Test')
        .build();
    }
}
