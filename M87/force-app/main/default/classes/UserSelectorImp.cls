public with sharing class UserSelectorImp extends fflib_SObjectSelector{
    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            User.ID,                    
            User.Name                 
        };
    }    
}
