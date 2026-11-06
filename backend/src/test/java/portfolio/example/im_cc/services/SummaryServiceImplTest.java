package portfolio.example.im_cc.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import portfolio.example.im_cc.models.characterwizard.*;
import portfolio.example.im_cc.repositories.characterwizard.*;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class SummaryServiceImplTest {

    private final SummaryServiceImpl service = new SummaryServiceImpl();

    @BeforeEach
    void injectMocks() throws IllegalAccessException {
        // Every repository field gets a Mockito mock: empty lists and Optional.empty() unless stubbed.
        for (Field f : SummaryServiceImpl.class.getDeclaredFields()) {
            if (f.getType().getSimpleName().endsWith("Repository")) {
                f.setAccessible(true);
                f.set(service, mock(f.getType()));
            }
        }
    }

    @SuppressWarnings("unchecked")
    private <T> T repo(Class<T> type) throws IllegalAccessException {
        for (Field f : SummaryServiceImpl.class.getDeclaredFields()) {
            if (f.getType() == type) {
                f.setAccessible(true);
                return (T) f.get(service);
            }
        }
        throw new IllegalArgumentException(type.getSimpleName());
    }

    private static Faction faction(long id, String name) {
        Faction f = new Faction();
        f.setId(id);
        f.setName(name);
        return f;
    }

    private static CharacterCreationModel ccm() {
        CharacterCreationModel ccm = new CharacterCreationModel();
        ccm.setCharacteristics(new HashMap<>(Map.of("WS", "35", "INT", "40")));
        ccm.setCharacterName("Vex");
        return ccm;
    }

    @Test
    void unknownFactionAndRoleStillBuildTheRestOfTheSheet() {
        CharacterCreationModel ccm = ccm();
        ccm.setFactionId(151L);   // e.g. an id from before the factions were renumbered
        ccm.setRoleId(999L);

        CharacterSheetDTO sheet = assertDoesNotThrow(() -> service.build(ccm));

        assertNull(sheet.getFactionName());
        assertNull(sheet.getRoleName());
        assertEquals("Vex", sheet.getCharacterName());
        assertEquals("40", sheet.getCharacteristics().get("INT"));
    }

    @Test
    void nullChoiceMapsDoNotCrash() throws IllegalAccessException {
        Faction admin = faction(1, "ADEPTUS ADMINISTRATUM");
        when(repo(FactionRepository.class).findById(1L)).thenReturn(Optional.of(admin));
        Role role = new Role();
        role.setId(5L);
        when(repo(RoleRepository.class).findById(5L)).thenReturn(Optional.of(role));
        RoleChoiceGroup group = new RoleChoiceGroup();
        group.setId(50L);
        when(repo(RoleChoiceGroupRepository.class).findByRole(role)).thenReturn(List.of(group));

        CharacterCreationModel ccm = ccm();
        ccm.setFactionId(1L);
        ccm.setRoleId(5L);
        ccm.setFactionChoices(null);
        ccm.setRoleChoices(null);

        assertDoesNotThrow(() -> service.build(ccm));
    }

    @Test
    void choicesFromAnotherFactionAreIgnored() throws IllegalAccessException {
        Faction admin = faction(1, "ADEPTUS ADMINISTRATUM");
        Faction telepathica = faction(2, "ADEPTUS ASTRA TELEPATHICA");
        when(repo(FactionRepository.class).findById(1L)).thenReturn(Optional.of(admin));

        FactionChoiceGroup telepathicaGroup = new FactionChoiceGroup();
        telepathicaGroup.setId(20L);
        telepathicaGroup.setFaction(telepathica);
        when(repo(FactionChoiceGroupRepository.class).findById(20L)).thenReturn(Optional.of(telepathicaGroup));
        Talent psyker = new Talent();
        psyker.setName("PSYKER");
        FactionTalentChoice option = new FactionTalentChoice();
        option.setFactionChoiceGroup(telepathicaGroup);
        option.setTalent(psyker);
        option.setOption_id(1L);
        when(repo(FactionTalentChoiceRepository.class).findByFactionChoiceGroup(any())).thenReturn(List.of(option));

        CharacterCreationModel ccm = ccm();
        ccm.setFactionId(1L);   // Administratum now, but the browser still holds a Telepathica choice
        ccm.setFactionChoices(new HashMap<>(Map.of(20L, List.of(1L))));

        CharacterSheetDTO sheet = service.build(ccm);

        assertEquals("ADEPTUS ADMINISTRATUM", sheet.getFactionName());
        assertFalse(sheet.getTalents().contains("PSYKER"));
    }
}
