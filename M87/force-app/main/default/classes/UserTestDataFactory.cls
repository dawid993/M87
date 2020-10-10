@isTest
public with sharing class UserTestDataFactory {
    private static final String TEST_RUN_USERNAME = 'innerm87testrunUser15125313534@testing.co.pl';
    private static final String TEST_USERNAME = 'innerm87testrUser9347917312311124342334@testing.co.pl';
    private static final String EMAIL_ENCODING_KEY = 'UTF-8';
    private static final String TIME_ZONE_SID_KEY = 'GMT'; 
    private static final String LOCALE_SID_KEY = 'pl_PL';
    private static final String LANGUAGE_LOCALE_KEY = 'en_US';

    private static Id retrieveSystemAdministratorProfileId(){
        return new ProfileSelector().selectSystemAdministratorProfile().Id; 
    }

    private static UserBuilder applyDefault(){
        return new UserBuilder()
        .setFirstName('Test')
        .setLastName('Test')
        .setProfileId(retrieveSystemAdministratorProfileId())
        .setUsername(TEST_USERNAME)
        .setAlias(TEST_USERNAME.substring(0,8))
        .setEmail(TEST_USERNAME)
        .setEmailEncodingKey(EMAIL_ENCODING_KEY)
        .setTimeZoneSidKey(TIME_ZONE_SID_KEY)
        .setLanguageLocaleKey(LANGUAGE_LOCALE_KEY)
        .setLocaleSidKey(LOCALE_SID_KEY);        
    }

    public static User buildUserTestRun(){        
        return applyDefault()
        .setUsername(TEST_RUN_USERNAME)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }
    
    public static User buildSystemAdminUserWithUsername(final String username){
        return applyDefault()
        .setUsername(username)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }

    public static User buildSystemAdminUserWithEmail(final String email){
        return applyDefault()
        .setEmail(email)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }

    public static User buildSystemAdminUserWithEmailAndUsername(final String email, final String username){
        return applyDefault()
        .setEmail(email)
        .setUsername(username)
        .setProfileId(retrieveSystemAdministratorProfileId())
        .build();
    }
}
