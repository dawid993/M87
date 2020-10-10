public with sharing class UserBuilder {
    
    private User currentUser;

    public UserBuilder(){
        currentUser = new User();
    }

    public UserBuilder setFirstName(final String firstName){
        currentUser.Username = firstName;
        return this;
    }

    public UserBuilder setLastName(final String lastName){
        currentUser.lastName = lastName;
        return this;
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

    public UserBuilder setAlias(final String alias){
        currentUser.alias = alias;
        return this;
    }

    public UserBuilder setTimeZoneSidKey(final String timeZoneSidKey){
        currentUser.timeZoneSidKey = timeZoneSidKey;
        return this;
    }

    public UserBuilder setLocaleSidKey(final String localeSidKey){
        currentUser.localeSidKey = localeSidKey;
        return this;
    }

    public UserBuilder setEmailEncodingKey(final String emailEncodingKey){
        currentUser.emailEncodingKey = emailEncodingKey;
        return this;
    }

    public UserBuilder setLanguageLocaleKey(final String languageLocaleKey){
        currentUser.languageLocaleKey = languageLocaleKey;
        return this;
    }

    public User build(){
        User tempUser = currentUser;
        currentUser = new User();
        return tempUser;
    }
}
