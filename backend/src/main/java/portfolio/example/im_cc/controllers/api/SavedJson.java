package portfolio.example.im_cc.controllers.api;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import tools.jackson.databind.ObjectMapper;

/**
 * Helpers for endpoints that store client JSON as-is and hand it back later. Saved content is
 * served with a fixed JSON content type, so a shared link can never be rendered as an HTML page.
 */
final class SavedJson {

    private SavedJson() {}

    static boolean isObject(ObjectMapper objectMapper, String data) {
        if (data == null || data.isBlank()) return false;
        try {
            return objectMapper.readTree(data).isObject();
        } catch (Exception e) {
            return false;
        }
    }

    static ResponseEntity<String> response(String data) {
        return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON).body(data);
    }
}
