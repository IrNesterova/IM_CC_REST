package portfolio.example.im_cc.messaging;

import java.io.Serializable;

public record BugReportMessage(
        String description,
        String pageUrl,
        String name,
        String title
) implements Serializable {}