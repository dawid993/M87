@isTest
public with sharing class EngagementCaseSelectorTest {
    
    @TestSetup
    public static void initData(){
        insert CaseTestDataFactory.createEngagementCase();
    }

    @isTest
    public static void shouldRetrieveEngagementCase(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            insert CaseTestDataFactory.createEngagementCase();
            System.assertEquals(1, new EngagementCaseSelector().retrieveEngagementCases(UserInfo.getUserId()).size());
        }
    }
}
