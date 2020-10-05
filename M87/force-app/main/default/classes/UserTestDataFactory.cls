@isTest
public with sharing class UserTestDataFactory {
    private static final String TEST_RUN_USERNAME = 'innerm87testrunUser15125313534@testing.co.pl';

    private static Id retrieveSystemAdministratorProfileId(){
        return new ProfileSelector().selectSystemAdministratorProfile().Id; 
    }

    public static User buildUserTestRun(){        
        return new UserBuilder()
        .setUsername(TEST_RUN_USERNAME)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }
    
    public static User buildSystemAdminUserWithUsername(final String username){
        return new UserBuilder()
        .setUsername(username)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }

    public static User buildSystemAdminUserWithEmail(final String email){
        return new UserBuilder()
        .setEmail(email)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }
}
