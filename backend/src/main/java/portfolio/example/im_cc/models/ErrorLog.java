package portfolio.example.im_cc.models;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

@Entity
@Table(name = "error_log")
public class ErrorLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 16)
    private String source; // BACKEND | FRONTEND

    @Column(name = "error_type", length = 255)
    private String errorType;

    @Column(columnDefinition = "text")
    private String message;

    @Column(name = "stack_trace", columnDefinition = "text")
    private String stackTrace;

    @Column(length = 1000)
    private String url;

    @Column(name = "user_id")
    private Long userId;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    public ErrorLog() {}

    public ErrorLog(String source, String errorType, String message, String stackTrace, String url, Long userId) {
        this.source = source;
        this.errorType = errorType;
        this.message = message;
        this.stackTrace = stackTrace;
        this.url = url;
        this.userId = userId;
    }

    public Long getId() { return id; }
    public String getSource() { return source; }
    public String getErrorType() { return errorType; }
    public String getMessage() { return message; }
    public String getStackTrace() { return stackTrace; }
    public String getUrl() { return url; }
    public Long getUserId() { return userId; }
    public Instant getCreatedAt() { return createdAt; }
}
