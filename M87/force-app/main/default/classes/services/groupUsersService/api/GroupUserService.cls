public interface GroupUserService {
    List<User> retrieveUsersFromGroup(Group targetGroup);
    List<User> retrieveUsersFromErrorNotifyGroup();
}
