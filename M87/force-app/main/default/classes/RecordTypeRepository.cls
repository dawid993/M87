public with sharing class RecordTypeRepository {
    private static final String CASE_ENGAGEMENT_RT_NAME = 'Engagement';    

    public static final ID CASE_ENGAGEMENT_RT_ID = 
        Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(CASE_ENGAGEMENT_RT_NAME).getRecordTypeId();
}
