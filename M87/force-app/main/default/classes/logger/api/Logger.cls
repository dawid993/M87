public interface Logger {
    void log(Exception ex);
    void log(Exception ex, Id recordId);
    void log(Log eventLog);
    void log(Log eventLog, LogSeverity severity);
    void log(String message);
    void log(String message, LogSeverity severity);
    void log(String message, LogSeverity severity, Id recordId);
    void publish();
}
