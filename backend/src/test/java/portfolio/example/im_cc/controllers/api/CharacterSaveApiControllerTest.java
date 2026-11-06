package portfolio.example.im_cc.controllers.api;

import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.characterwizard.CharacterSave;
import portfolio.example.im_cc.models.patron.PatronSave;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.characterwizard.CharacterSaveRepository;
import portfolio.example.im_cc.repositories.patron.PatronSaveRepository;
import tools.jackson.databind.json.JsonMapper;

import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class CharacterSaveApiControllerTest {

    private static final byte[] PNG = {(byte) 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 0};
    private static final byte[] SVG =
            "<svg xmlns=\"http://www.w3.org/2000/svg\"><script>alert(1)</script></svg>".getBytes(StandardCharsets.UTF_8);
    private static final Principal OWNER = () -> "owner@example.com";

    private final CharacterSaveRepository repo = mock(CharacterSaveRepository.class);
    private final AppUserRepository users = mock(AppUserRepository.class);
    private final PatronSaveRepository patrons = mock(PatronSaveRepository.class);
    private final MockMvc mvc = MockMvcBuilders.standaloneSetup(
            new CharacterSaveApiController(repo, users, JsonMapper.builder().build()),
            new PatronSaveApiController(patrons, JsonMapper.builder().build())).build();

    private CharacterSave ownedSave() {
        AppUser owner = new AppUser();
        owner.setId(1L);
        when(users.findByEmail("owner@example.com")).thenReturn(Optional.of(owner));
        CharacterSave cs = new CharacterSave();
        cs.setSaveCode("ABC234");
        cs.setOwner(owner);
        when(repo.findBySaveCode("ABC234")).thenReturn(Optional.of(cs));
        return cs;
    }

    @Test
    void saveRejectsBodiesThatAreNotJsonObjects() throws Exception {
        for (String body : new String[]{"<script>alert(1)</script>", "[1,2]", "\"text\""}) {
            mvc.perform(post("/api/character/save").contentType(MediaType.APPLICATION_JSON).content(body))
                    .andExpect(status().isBadRequest());
            mvc.perform(post("/api/patron/save").contentType(MediaType.APPLICATION_JSON).content(body))
                    .andExpect(status().isBadRequest());
        }
        verify(repo, never()).save(any());
        verify(patrons, never()).save(any());
    }

    @Test
    void saveAcceptsJsonObject() throws Exception {
        when(repo.findBySaveCode(anyString())).thenReturn(Optional.empty());

        mvc.perform(post("/api/character/save").contentType(MediaType.APPLICATION_JSON)
                        .content("{\"ccm\":{\"characterName\":\"Vex\"}}"))
                .andExpect(status().isOk());
        verify(repo).save(any(CharacterSave.class));
    }

    @Test
    void loadIsAlwaysJsonEvenWhenBrowserAsksForHtml() throws Exception {
        CharacterSave cs = new CharacterSave();
        cs.setData("<script>alert(1)</script>");
        when(repo.findBySaveCode("ABC234")).thenReturn(Optional.of(cs));
        PatronSave ps = new PatronSave();
        ps.setData("<script>alert(1)</script>");
        when(patrons.findBySaveCode("ABC234")).thenReturn(Optional.of(ps));

        for (String url : new String[]{"/api/character/load/abc234", "/api/patron/load/abc234"}) {
            mvc.perform(get(url).accept(MediaType.TEXT_HTML, MediaType.ALL))
                    .andExpect(status().isOk())
                    .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON));
        }
    }

    @Test
    void uploadRejectsSvgEvenWhenLabelledAsPng() throws Exception {
        CharacterSave cs = ownedSave();

        mvc.perform(multipart("/api/character/ABC234/image")
                        .file(new MockMultipartFile("file", "evil.png", "image/png", SVG))
                        .principal(OWNER))
                .andExpect(status().isBadRequest());
        verify(repo, never()).save(any());
        assertEquals(null, cs.getImageData());
    }

    @Test
    void uploadStoresTypeDetectedFromBytes() throws Exception {
        CharacterSave cs = ownedSave();

        mvc.perform(multipart("/api/character/ABC234/image")
                        .file(new MockMultipartFile("file", "photo.bin", "application/octet-stream", PNG))
                        .principal(OWNER))
                .andExpect(status().isOk());
        assertEquals("image/png", cs.getImageContentType());
    }

    @Test
    void storedSvgIsNoLongerServed() throws Exception {
        CharacterSave cs = new CharacterSave();
        cs.setImageData(SVG);
        cs.setImageContentType("image/svg+xml");
        when(repo.findBySaveCode("ABC234")).thenReturn(Optional.of(cs));

        mvc.perform(get("/api/character/ABC234/image")).andExpect(status().isNotFound());
    }

    @Test
    void imagesAreServedWithSandboxPolicy() throws Exception {
        CharacterSave cs = new CharacterSave();
        cs.setImageData(PNG);
        cs.setImageContentType("image/png");
        when(repo.findBySaveCode("ABC234")).thenReturn(Optional.of(cs));

        mvc.perform(get("/api/character/ABC234/image"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.IMAGE_PNG))
                .andExpect(header().string("Content-Security-Policy", "default-src 'none'; sandbox"));
    }
}
