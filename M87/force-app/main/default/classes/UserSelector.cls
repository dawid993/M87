public interface UserSelector {
    List<User> searchUserByName(String name);
    Integer countUserByUsername(String username);
    Integer countUserByEmail(String email);
}
