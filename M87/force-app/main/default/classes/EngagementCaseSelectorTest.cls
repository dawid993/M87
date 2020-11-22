@isTest
public with sharing class EngagementCaseSelectorTest {
    
    @TestSetup
    public static void initData(){
        insert CaseTestDataFactory.createDefaultEngagementCase();
    }

    @isTest
    public static void shouldRetrieveEngagementCase(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            insert CaseTestDataFactory.createDefaultEngagementCase();
            System.assertEquals(1, new EngagementCaseSelector().retrieveEngagementCases(UserInfo.getUserId()).size());
        }
    }
}
