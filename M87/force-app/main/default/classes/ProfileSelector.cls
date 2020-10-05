public with sharing class ProfileSelector {
    public static final String SYSTEM_ADMINISTRATOR_PROFILE_NAME = 'System Administrator';

    public Profile selectSystemAdministratorProfile(){
        return [SELECT Id FROM Profile WHERE Name = :SYSTEM_ADMINISTRATOR_PROFILE_NAME LIMIT 1];
    }
}
