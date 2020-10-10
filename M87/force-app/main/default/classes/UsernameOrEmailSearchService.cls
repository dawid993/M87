public with sharing class UsernameOrEmailSearchService {
    private UserSelector userSelector;

    public UsernameOrEmailSearchService(UserSelector userSelector){
        this.userSelector = userSelector;
    }

    public UsernameAndEmailCountDTO searchForUsernameOrEmail(final String username, final String email){
        return performSearchAndReturnDTO(username, email);
    }    

    private UsernameAndEmailCountDTO performSearchAndReturnDTO(final String username, final String email){
        final UsernameAndEmailCountDTO dto = new UsernameAndEmailCountDTO();
        dto.searchedUsername = username;
        dto.searchedEmail = email;
        dto.usernameCount = userSelector.countUserByUsername(username);
        dto.emailCount = userSelector.countUserByEmail(email);

        return dto;
    }
}
