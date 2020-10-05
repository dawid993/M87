public with sharing class UserBuilder {
    
    private User currentUser;

    public UserBuilder(){
        currentUser = new User();
    }

    public UserBuilder setUsername(final String username){
        currentUser.Username = username;
        return this;
    }

    public UserBuilder setEmail(final String email){
        currentUser.Email = email;
        return this;
    }

    public UserBuilder setProfileId(final Id profileId){
        currentUser.ProfileId = profileId;
        return this;
    }

    public User build(){
        User tempUser = currentUser;
        currentUser = new User();
        return tempUser;
    }
}
