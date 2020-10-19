@isTest
public class EngagementServiceImpTest {
    
    @isTest
    public static void shouldRetrieveEngagementCase(){  
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            EngagementServiceImp engagementService = Modules.instance().service_getEngagementService(); 
            List<Case> cases = engagementService.retrieveEngagementCases(UserInfo.getUserId());  
            System.assertEquals(0, cases.size());
        }
    }

   
}
