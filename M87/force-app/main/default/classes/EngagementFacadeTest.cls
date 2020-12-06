@isTest
public with sharing class EngagementFacadeTest {
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
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            final List<Case> engagementCases = service.retrieveEngagementCasesByOwnerId(runningUser.Id);
            System.assertEquals(6, engagementCases.size(),'List should have 6 elements.');
        }
    }

    @IsTest
    public static void shouldRetrieveLowPriorityEngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
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

            System.assertEquals(2, engagementCases.size(), 'List should have 2 elements.');
        }
    }

    @isTest
    public static void shouldRetrievemediumPrioritytoDoStatusEngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
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

            System.assertEquals(2, engagementCases.size(),'List should have 2 elements.');
        }
    }

    @IsTest
    public static void shouldRetrieveHighPriorityEngagementCase(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
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

            System.assertEquals(1, engagementCases.size(),'List should have 1 element.');
        }
    }

    @IsTest
    public static void shouldRetrieveHighPriorityEngagementCaseWithSubject(){        
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final Case highPrioCase = retrieveCaseBySubject(SUBJECT_4);
            Test.setFixedSearchResults(new List<Id>{ highPrioCase.Id });
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            
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

            System.assertEquals(1, engagementCases.size(),'List should have 1 element');
        }
    }

    @IsTest
    public static void shouldNotRetrieveAnyEngagementCaseWithSubject(){        
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final Case highPrioCase = retrieveCaseBySubject(SUBJECT_4);
            Test.setFixedSearchResults(new List<Id>{ highPrioCase.Id });
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            
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

            System.assertEquals(0, engagementCases.size(),'List should be empty.');
        }
    }

    private static Case retrieveCaseBySubject(String subject){
        return [SELECT Id,Status FROM Case WHERE subject = :subject LIMIT 1];
    }

    @IsTest
    public static void shouldThrowExceptionBecauseSearchParametersAreBlank(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            Boolean exceptionThrown = false;

            try{
                service.retrieveEngagementCases(null);
            }catch(IllegalArgumentException ex){
                exceptionThrown = true;
            }

            System.assertEquals(true, exceptionThrown,'Exception should be thrown.');
        }
    }

    @IsTest
    public static void shouldThrowExceptionBecauseSearchParametersAreInvalid(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            Boolean exceptionThrown = false;

            try{
                service.retrieveEngagementCases(new SearchEngagementCaseOptionsBuilder().build());
            }catch(IllegalArgumentException ex){
                exceptionThrown = true;
            }

            System.assertEquals(true, exceptionThrown,'Exception should be thrown.');
        }
    }

    @IsTest
    public static void shouldUpdateCaseStatus(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            final Case testCase = retrieveCaseBySubject(SUBJECT_4);
            final String prevStatus = testCase.Status;

            service.updateEngagementCaseStatus(testCase.Id, CaseUtils.STATUS_TO_DO);

            final Case updatedCase = retrieveCaseById(testCase.Id);
            System.assertEquals(CaseUtils.STATUS_TO_DO, updatedCase.Status,'Status should be \'To Do\'');
            System.assertNotEquals(prevStatus, updatedCase.Status,'Previous status should be different than current one.');
        }
    }

    private static Case retrieveCaseById(Id caseId){
        return [SELECT Id,Status FROM Case WHERE Id = :caseId LIMIT 1];
    }

    @isTest
    public static void shouldThrowExceptionWhenUpdateBecauseInvalidCaseStatus(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            final Case testCase = retrieveCaseBySubject(SUBJECT_4);
            final String prevStatus = testCase.Status;
            Boolean exceptionThrown = false;

            try{
                service.updateEngagementCaseStatus(testCase.Id, 'FAKE_STATUS');
            }catch(IllegalArgumentException ex){
                exceptionThrown = true;
            }           

            System.assertEquals(true,exceptionThrown,'Exception should be thrown.');           
        }
    }

    @isTest
    public static void shouldCreateLeadWithDetails(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            Lead lead = 
            service.createLead(LeadTestDataFactory.createEngagementLeadDTO_withLeadDetails());

            System.assertNotEquals(null, lead.Id, 'Lead id should not be null.');
            Lead savedLead = service.getEngagementLead(lead.Id);
            System.assertNotEquals(null, savedLead,'Record should not be null.');            
            System.assertEquals(lead.Email.toLowerCase(), savedLead.Email.toLowerCase(),'Emails should equal.');
            System.assertEquals(lead.Status, savedLead.Status,'Statuses should be equal.');
            System.assertEquals(lead.Industry, savedLead.Industry, 'Industries should be equal.');
        }
    }

    @isTest
    public static void shouldCreateLeadWithDetailsCommunityUser(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            Lead lead = 
            service.createLead(LeadTestDataFactory.createEngagementLeadDTO_leadDetails_commUser());

            System.assertNotEquals(null, lead.Id, 'Lead id should not be null.');

            Lead savedLead = service.getEngagementLead(lead.Id);
            System.assertNotEquals(null, savedLead, 'Lead should not be null.');   
            
            List<CommunityUser__c> commUsers = service.getCommunityUsersForEngagementLead(savedLead);
            System.assertNotEquals(0, commUsers.size(), 'List should not be empty.');            
        }
    }

    @isTest
    public static void shouldCreateLeadWithDetailsCommunityUserAttachment(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();
            Lead lead = 
                service.createLead(LeadTestDataFactory.createEngagementLeadDTO_leadDetails_commUser_file());

            System.assertNotEquals(null, lead.Id, 'Lead id should not be null.');

            Lead savedLead = service.getEngagementLead(lead.Id);
            System.assertNotEquals(null, savedLead, 'Lead should not be null.');   
            
            List<CommunityUser__c> commUsers = service.getCommunityUsersForEngagementLead(savedLead);
            System.assertNotEquals(0, commUsers.size(), 'List should not be empty.');  
            System.assertNotEquals(0, getAttachments(savedLead.Id).size(), 'List should not be empty.');          
        }
    }

    @isTest
    public static void shouldThrowExceptionWhenDTOEmpty(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            Boolean dtoEmptyExceptionThrown = false;
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();

            try{
                service.createLead(null);
            }catch(IllegalArgumentException ex){
                dtoEmptyExceptionThrown = true;
            }

            System.assertEquals(true, dtoEmptyExceptionThrown, 'Exception should be thrown.');
        }               
    }

    @isTest
    public static void shouldThrowExceptionWhenLeadDetailsEmpty(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            Boolean leadDetailsEmptyExceptionThrown = false;
            final EngagementFacade service = Modules.instance().facade_getEngagementFacade();

            try{
                service.createLead(new EngagementLeadDTO());
            }catch(IllegalArgumentException ex){
                leadDetailsEmptyExceptionThrown = true;
            }

            System.assertEquals(true, leadDetailsEmptyExceptionThrown, 'Exception should be thrown.');
        }               
    }

    private static List<Attachment> getAttachments(Id parentId){
        return [SELECT Id FROM Attachment WHERE ParentId = :parentId];
    }
}
