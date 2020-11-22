@IsTest
public with sharing class EngagementCaseServiceTest {
    private static final String SUBJECT_1 = 'shfbbduyyu213gudas';
    private static final String SUBJECT_2 = 'czxasdasdttgxsdasd';
    private static final String SUBJECT_3 = 'hfghsbxbsdg3425gsd';
    private static final String SUBJECT_4 = 'xcvxcvdasgf622r377';
    private static final String SUBJECT_5 = 'lhgjf146asf3123vks';
    private static final String SUBJECT_6 = 'cxzhuifhuhai542h3is';

    @TestSetup
    public static void initData(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            insert new List<Case> {
                CaseTestDataFactory.createEngagementCase(
                    CaseUtils.PRIORITY_MEDIUM,
                    CaseUtils.STATUS_TO_DO,
                    SUBJECT_1
                ),

                CaseTestDataFactory.createEngagementCase(
                    CaseUtils.PRIORITY_MEDIUM,
                    CaseUtils.STATUS_TO_DO,
                    SUBJECT_2
                ),

                CaseTestDataFactory.createEngagementCase(
                    CaseUtils.PRIORITY_LOW,
                    CaseUtils.STATUS_DONE_SUCCESS,
                    SUBJECT_3
                ),

                CaseTestDataFactory.createEngagementCase(
                    CaseUtils.PRIORITY_HIGH,
                    CaseUtils.STATUS_DONE_FAILURE,
                    SUBJECT_4
                ),

                CaseTestDataFactory.createEngagementCase(
                    CaseUtils.PRIORITY_LOW,
                    CaseUtils.STATUS_IN_PROGRES,
                    SUBJECT_5
                ),

                CaseTestDataFactory.createEngagementCase(
                    CaseUtils.PRIORITY_MEDIUM,
                    CaseUtils.STATUS_IN_PROGRES,
                    SUBJECT_6
                )                
            };            
        }
    }       
    

    @IsTest
    public static void shouldRetrieveEngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final User runningUser = UserTestDataFactory.getTestRunUser();
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            final List<Case> engagementCases = service.retrieveEngagementCasesByOwnerId(runningUser.Id);
            System.assertEquals(6, engagementCases.size());
        }
    }

    @IsTest
    public static void shouldRetrieveLowPriorityEngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            final List<Case> engagementCases = service.retrieveEngagementCases(
                new SearchEngagementCaseOptionsBuilder()
                .addPriorities(new List<String>{
                    CaseUtils.PRIORITY_LOW
                })
                .addStatuses(new List<String>{
                    CaseUtils.STATUS_IN_PROGRES,
                    CaseUtils.STATUS_DONE_SUCCESS
                })
                .addOwners(new List<String>{
                    SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
                })
                .build()
            );

            System.assertEquals(2, engagementCases.size());
        }
    }

    @IsTest
    public static void shouldRetrieve_mediumPriority_toDoStatus_EngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            final List<Case> engagementCases = service.retrieveEngagementCases(
                new SearchEngagementCaseOptionsBuilder()
                .addPriorities(new List<String>{
                    CaseUtils.PRIORITY_MEDIUM
                })
                .addStatuses(new List<String>{                  
                    CaseUtils.STATUS_TO_DO
                })
                .addOwners(new List<String>{
                    SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
                })
                .build()
            );

            System.assertEquals(2, engagementCases.size());
        }
    }

    @IsTest
    public static void shouldRetrieveHighPriorityEngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            final List<Case> engagementCases = service.retrieveEngagementCases(
                new SearchEngagementCaseOptionsBuilder()
                .addPriorities(new List<String>{
                    CaseUtils.PRIORITY_HIGH
                })
                .addStatuses(new List<String>{                  
                    CaseUtils.STATUS_TO_DO,
                    CaseUtils.STATUS_IN_PROGRES,
                    CaseUtils.STATUS_DONE_SUCCESS,
                    CaseUtils.STATUS_DONE_FAILURE
                })
                .addOwners(new List<String>{
                    SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
                })
                .build()
            );

            System.assertEquals(1, engagementCases.size());
        }
    }

    @IsTest
    public static void shouldRetrieveHighPriorityEngagementCaseWithSubject(){        
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final Case highPrioCase = retrieveCaseBySubject(SUBJECT_4);
            Test.setFixedSearchResults(new List<Id>{ highPrioCase.Id });
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            
            final List<Case> engagementCases = service.retrieveEngagementCases(
                new SearchEngagementCaseOptionsBuilder()
                .addPriorities(new List<String>{
                    CaseUtils.PRIORITY_HIGH
                })
                .addStatuses(new List<String>{                  
                    CaseUtils.STATUS_TO_DO,
                    CaseUtils.STATUS_IN_PROGRES,
                    CaseUtils.STATUS_DONE_SUCCESS,
                    CaseUtils.STATUS_DONE_FAILURE
                })
                .addOwners(new List<String>{
                    SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
                })
                .setPhrase(SUBJECT_4)
                .build()
            );

            System.assertEquals(1, engagementCases.size());
        }
    }

    @IsTest
    public static void shouldNotRetrieveAnyEngagementCaseWithSubject(){        
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final Case highPrioCase = retrieveCaseBySubject(SUBJECT_4);
            Test.setFixedSearchResults(new List<Id>{ highPrioCase.Id });
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            
            final List<Case> engagementCases = service.retrieveEngagementCases(
                new SearchEngagementCaseOptionsBuilder()
                .addPriorities(new List<String>{
                    CaseUtils.PRIORITY_LOW
                })
                .addStatuses(new List<String>{                  
                    CaseUtils.STATUS_TO_DO                   
                })
                .addOwners(new List<String>{
                    SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
                })
                .setPhrase(SUBJECT_4)
                .build()
            );

            System.assertEquals(0, engagementCases.size());
        }
    }

    private static Case retrieveCaseBySubject(String subject){
        return [SELECT Id,Status FROM Case WHERE subject = :subject LIMIT 1];
    }

    @IsTest
    public static void shouldThrowExceptionBecauseSearchParametersAreBlank(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            Boolean exceptionThrown = false;

            try{
                service.retrieveEngagementCases(null);
            }catch(IllegalArgumentException ex){
                exceptionThrown = true;
            }

            System.assertEquals(true, exceptionThrown);
        }
    }

    @IsTest
    public static void shouldThrowExceptionBecauseSearchParametersAreInvalid(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            Boolean exceptionThrown = false;

            try{
                service.retrieveEngagementCases(new SearchEngagementCaseOptionsBuilder().build());
            }catch(IllegalArgumentException ex){
                exceptionThrown = true;
            }

            System.assertEquals(true, exceptionThrown);
        }
    }

    @IsTest
    public static void shouldUpdateCaseStatus(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            final Case testCase = retrieveCaseBySubject(SUBJECT_4);
            final String prevStatus = testCase.Status;

            service.updateEngagementCaseStatus(testCase.Id, CaseUtils.STATUS_TO_DO);

            final Case updatedCase = retrieveCaseById(testCase.Id);
            System.assertEquals(CaseUtils.STATUS_TO_DO, updatedCase.Status);
            System.assertNotEquals(prevStatus, updatedCase.Status);
        }
    }

    private static Case retrieveCaseById(Id caseId){
        return [SELECT Id,Status FROM Case WHERE Id = :caseId LIMIT 1];
    }

    @IsTest
    public static void shouldThrowExceptionWhenUpdateBecauseInvalidCaseStatus(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
            final Case testCase = retrieveCaseBySubject(SUBJECT_4);
            final String prevStatus = testCase.Status;
            Boolean exceptionThrown = false;

            try{
                service.updateEngagementCaseStatus(testCase.Id, 'FAKE_STATUS');
            }catch(IllegalArgumentException ex){
                exceptionThrown = true;
            }           

            System.assertEquals(true,exceptionThrown);           
        }
    }
}
