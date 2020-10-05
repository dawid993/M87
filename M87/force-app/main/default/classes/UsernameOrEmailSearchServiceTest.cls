@isTest
public with sharing class UsernameOrEmailSearchServiceTest {
    public static final String TEST_USERNAME = 'testUsername7565663asd@ttest.co.pl';

    public static final String TEST_EMAIL = 'testEmail7565663asd@ttest.co.pl';

    @TestSetup
    public static void initData(){
        insert new List<User> {
            UserTestDataFactory.buildSystemAdminUserWithUsername(TEST_USERNAME),
            UserTestDataFactory.buildSystemAdminUserWithEmail(TEST_EMAIL)
        };
    }

    @isTest
    public static void shouldReturnDtoWithFoundUsernameAndEmail(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            UsernameAndEmailCountDTO dto = 
                new UsernameOrEmailSearchService().searchForUsernameOrEmail(TEST_USERNAME, TEST_EMAIL);
            
            System.assertEquals(1, dto.usernameCount);
            System.assertEquals(1, dto.emailCount);
        }
    }
}
