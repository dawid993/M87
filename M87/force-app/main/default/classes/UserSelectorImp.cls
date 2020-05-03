public with sharing class UserSelectorImp extends fflib_SObjectSelector implements UserSelector{
    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            User.ID,                    
            User.Name                 
        };
    }
    
    public List<User> searchUserByName(String name){
        String condition = 'NAME LIKE \'%'+name+'%\'';
        return Database.query(
            newQueryFactory()
            .setCondition(condition)
            .toSOQL()
        );
    }
}
