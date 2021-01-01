public interface LogStorageEntry {
    List<Database.SaveResult> persist(List<Log__e> logs);
}
