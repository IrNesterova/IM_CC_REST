package portfolio.example.im_cc.config;

import java.util.ArrayList;
import java.util.List;

/** The browser origins allowed to call the API with credentials (CORS) and to open the WebSocket. */
public final class AllowedOrigins {

    private static final List<String> LOCAL = List.of(
            "http://localhost:3000",
            "http://localhost:5173",
            "http://localhost",
            "http://localhost:80"
    );

    private AllowedOrigins() {}

    /** The local development origins plus FRONTEND_URL when it is set. */
    public static List<String> including(String frontendUrl) {
        List<String> origins = new ArrayList<>(LOCAL);
        if (frontendUrl != null && !frontendUrl.isBlank()) {
            origins.add(frontendUrl);
        }
        return origins;
    }
}
