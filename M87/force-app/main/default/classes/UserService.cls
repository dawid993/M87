public with sharing class UserService {

    private final UserRepository userRepository;

    public UserService(final UserRepository userRepository){
        this.userRepository = userRepository;
    }

    public List<OwnerSearchResult> searchOwnerByName(String searchName){       
        List<OwnerSearchResult> results = new List<OwnerSearchResult>();
        for(User currentUser : userRepository.searchUserByName(searchName)){
            results.add(new OwnerSearchResult(currentUser));
        }

        return results;
    }
}
