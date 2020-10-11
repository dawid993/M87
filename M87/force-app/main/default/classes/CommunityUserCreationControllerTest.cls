@isTest
public with sharing class CommunityUserCreationControllerTest {  

    @TestSetup
    public static void initData(){    
        insert new List<User> {
            UserTestDataFactory.buildSystemAdminUserWithUsername(TestUtils.DEFAULT_TEST_USERNAME),
            UserTestDataFactory.buildSystemAdminUserWithEmail(TestUtils.DEFAULT_TEST_EMAIL)           
        };
    }

    @isTest    public static void shouldReturnResultWithDTO_username_found_email_found(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            ApexActionResult result = CommunityUserCreationController.searchForUsernameOrEmail(
                TestUtils.DEFAULT_TEST_USERNAME, TestUtils.DEFAULT_TEST_EMAIL
            );

            UsernameAndEmailCountDTO dtoResult = (UsernameAndEmailCountDTO) result.detailedResult;
            System.assertEquals(true, result.success);            
            System.assertEquals(1, dtoResult.emailCount);
            System.assertEquals(TestUtils.DEFAULT_TEST_EMAIL, dtoResult.searchedEmail);
            System.assertEquals(1, dtoResult.usernameCount);
            System.assertEquals(TestUtils.DEFAULT_TEST_USERNAME, dtoResult.searchedUsername);
        }
    }

    @isTest
     public static void shouldReturnResultWithUnsuccess(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            Modules.stubModule(new ModuleExceptionThrow());

            ApexActionResult result = CommunityUserCreationController.searchForUsernameOrEmail(
                TestUtils.DEFAULT_TEST_USERNAME, TestUtils.DEFAULT_TEST_EMAIL
            );

            System.assertEquals(false, result.success);            
        }
    }

    private class ModuleExceptionThrow extends Modules {
        public override UsernameOrEmailSearchService service_getUsernameOrEmailSearch(){
            return UsernameOrEmailSearchServiceStub.createStub();
        }
    }
    
}
