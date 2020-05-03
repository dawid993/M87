public with sharing class UserServiceImp implements UserService {
    public List<OwnerSearchResult> searchOwnerByName(String searchName){
        UserSelector userSelector = (UserSelector) Application.Selector.newInstance(User.sObjectType);
        List<OwnerSearchResult> results = new List<OwnerSearchResult>();
        for(User currentUser : userSelector.searchUserByName(searchName)){
            results.add(new OwnerSearchResult(currentUser));
        }

        return results;
    }
}
