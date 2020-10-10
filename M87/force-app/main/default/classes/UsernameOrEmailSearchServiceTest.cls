@isTest
public with sharing class UsernameOrEmailSearchServiceTest {  

    public static final String DEFAULT_TEST_USERNAME_2 = 'testUsername78u9789789asd@ttest.co.pl';

    @TestSetup
    public static void initData(){
        insert new List<User> {
            UserTestDataFactory.buildSystemAdminUserWithUsername(TestUtils.DEFAULT_TEST_USERNAME),
            UserTestDataFactory.buildSystemAdminUserWithEmail(TestUtils.DEFAULT_TEST_EMAIL)           
        };
    }

    @isTest
    public static void shouldReturnDtoWithFoundUsernameAndEmail(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            UsernameAndEmailCountDTO dto = 
                new UsernameOrEmailSearchService(new UserSelectorImp())
                .searchForUsernameOrEmail(TestUtils.DEFAULT_TEST_USERNAME, TestUtils.DEFAULT_TEST_EMAIL);
            
            System.assertEquals(1, dto.usernameCount);
            System.assertEquals(1, dto.emailCount);
        }
    }

    @isTest
    public static void shouldReturnDtoWithFoundUsernameAndNotFoundEmail(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            UsernameAndEmailCountDTO dto = 
                new UsernameOrEmailSearchService(new UserSelectorImp()).searchForUsernameOrEmail(
                    TestUtils.DEFAULT_TEST_USERNAME,
                    'fakeEmail124124@fakes.email.co.pl'
                );
            
            System.assertEquals(1, dto.usernameCount);
            System.assertEquals(0, dto.emailCount);
        }
    }

    @isTest
    public static void shouldReturnDtoWithNotFoundUsernameAndFoundEmail(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            UsernameAndEmailCountDTO dto = 
                new UsernameOrEmailSearchService(new UserSelectorImp()).searchForUsernameOrEmail(
                    'fakeusername@usernameisFake12414.com.pl',
                    TestUtils.DEFAULT_TEST_EMAIL
                );
            
            System.assertEquals(0, dto.usernameCount);
            System.assertEquals(1, dto.emailCount);
        }
    }

    @isTest
    public static void shouldReturnDtoWithNotFoundUsernameAndEmail(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            UsernameAndEmailCountDTO dto = 
                new UsernameOrEmailSearchService(new UserSelectorImp()).searchForUsernameOrEmail(
                    'fakeusername@usernameisFake214124.com.pl',
                    'fakeemail@emailIsFake412412.com.pl'
                );
            
            System.assertEquals(0, dto.usernameCount);
            System.assertEquals(0, dto.emailCount);
        }
    }

    @isTest
    public static void shouldReturnDtoWithFoundUsernameAndFoundEmailTwice(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            insert UserTestDataFactory.buildSystemAdminUserWithEmailAndUsername(
                TestUtils.DEFAULT_TEST_EMAIL,
                DEFAULT_TEST_USERNAME_2
            );

            UsernameAndEmailCountDTO dto = 
                new UsernameOrEmailSearchService(new UserSelectorImp()).searchForUsernameOrEmail(
                    TestUtils.DEFAULT_TEST_USERNAME,TestUtils.DEFAULT_TEST_EMAIL                  
                );
            
            System.assertEquals(1, dto.usernameCount);
            System.assertEquals(2, dto.emailCount);
        }
    }
}
