public with sharing class UserRepository extends Repository{
    public override List<Schema.SObjectField> getFields() {
        return new List<Schema.SObjectField> {
            User.ID,                    
            User.Name                 
        };
    }

    public override String getSObjectName(){
        return 'User';
    }

    public List<User> searchUserByName(String name){
        String condition = ' NAME LIKE \'%'+String.escapeSingleQuotes(name)+'%\'';
        return Database.query(createBaseQuery()+condition);
    }

    public Integer countUserByUsername(String username){
        return [SELECT Count() FROM User WHERE Username = :username];
    }

    public Integer countUserByEmail(String email){
        return [SELECT Count() FROM User WHERE Email = :email];
    }    
}
