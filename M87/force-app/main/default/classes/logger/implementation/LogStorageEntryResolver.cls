public with sharing class LogStorageEntryResolver {
    public LogStorageEntry getLogStorageEntry(){
        return new CustomObjectLogStorageEntry();
    }
}
