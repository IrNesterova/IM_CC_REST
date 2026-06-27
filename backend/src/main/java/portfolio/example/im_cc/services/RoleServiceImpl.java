package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.*;
import portfolio.example.im_cc.repositories.*;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    RoleRepository roleRepository;
    @Autowired
    RoleInventoryRepository roleInventoryRepository;
    @Autowired
    RoleChoiceGroupRepository roleChoiceGroupRepository;
    @Autowired
    RoleTalentChoiceGroupRepository roleTalentChoiceGroupRepository;
    @Autowired
    RoleInventoryChoiceGroupRepository roleInventoryChoiceGroupRepository;
    @Autowired
    RoleSkillChoiceGroupRepository roleSkillChoiceGroupRepository;
    @Autowired
    RoleSpecializationChoiceGroupRepository roleSpecializationChoiceGroupRepository;
    @Autowired
    portfolio.example.im_cc.repositories.SkillSpecializationsRepository skillSpecializationsRepository;

    @Override
    public List<Role> getAllRolesWithAdds() {

        List<Role> roles =
                roleRepository.findAll(
                        Sort.by(Sort.Direction.ASC, "id")
                );

        Map<Long, Role> roleMap = roles.stream().collect(Collectors.toMap(Role::getId, role -> role));
        roles.forEach(f -> {

            f.setInventoryList(new ArrayList<>());
            f.setChoiceGroups(new ArrayList<>());
        });

        roleInventoryRepository.findByRoleIn(roles)
                .stream().distinct()
                .forEach(fi -> roleMap.get(fi.getRole().getId())
                        .getInventoryList().add(fi.getInventory()));

        List<RoleChoiceGroup> allGroups = roleChoiceGroupRepository.findByRoleIn(roles)
                .stream().distinct().collect(Collectors.toList());
        allGroups.forEach(g ->{
            g.setTalentOptions(new ArrayList<>());
            g.setSkillOptions(new ArrayList<>());
            g.setInventoryOptions(new ArrayList<>());
            g.setSpecializationOptions(new ArrayList<>());
            roleMap.get(g.getRole().getId()).getChoiceGroups().add(g);
        });
        Map<Long, RoleChoiceGroup> groupMap = allGroups.stream()
                .collect(Collectors.toMap(RoleChoiceGroup::getId, g -> g));

        roleTalentChoiceGroupRepository.findByRoleChoiceGroupIn(allGroups)
                .forEach(tc -> groupMap.get(tc.getRoleChoiceGroup().getId())
                        .getTalentOptions().add(tc.getTalent()));
        roleSkillChoiceGroupRepository.findByRoleChoiceGroupIn(allGroups)
                .forEach(sc -> groupMap.get(sc.getRoleChoiceGroup().getId())
                        .getSkillOptions().add(sc.getSkill()));
        roleSpecializationChoiceGroupRepository.findByRoleChoiceGroupIn(allGroups)
                .forEach(sc -> groupMap.get(sc.getRoleChoiceGroup().getId())
                        .getSpecializationOptions().add(sc.getSpecialization()));
        roleInventoryChoiceGroupRepository.findByRoleChoiceGroupIn(allGroups)
                .forEach(ic -> groupMap.get(ic.getRoleChoiceGroup().getId())
                        .getInventoryOptions().add(ic.getInventory()));

        // ── Build specsBySkill for SPECIALIZATION groups ──────────────
        // The template groups specs under their parent Skill, so we need
        // Skill → [Specialization…] trees for every SPECIALIZATION group.
        List<RoleChoiceGroup> specGroups = allGroups.stream()
                .filter(g -> g.getChoiceType() == ChoiceType.SPECIALIZATION)
                .collect(Collectors.toList());

        if (!specGroups.isEmpty()) {
            List<Specialization> allSpecs = specGroups.stream()
                    .flatMap(g -> g.getSpecializationOptions().stream())
                    .distinct()
                    .collect(Collectors.toList());

            if (!allSpecs.isEmpty()) {
                // spec.id → parent Skill (one query for all)
                Map<Long, Skill> specIdToSkill = new HashMap<>();
                skillSpecializationsRepository.findBySpecializationIn(allSpecs)
                        .forEach(ss -> specIdToSkill.put(
                                ss.getSpecialization().getId(), ss.getSkill()));

                specGroups.forEach(g -> {
                    // LinkedHashMap preserves order and deduplicates by skill id
                    Map<Long, Skill> skillByIdMap = new LinkedHashMap<>();
                    g.getSpecializationOptions().forEach(spec -> {
                        Skill parentSkill = specIdToSkill.get(spec.getId());
                        if (parentSkill == null) return;
                        Skill sk = skillByIdMap.computeIfAbsent(parentSkill.getId(), id -> {
                            Skill s = new Skill();
                            s.setId(parentSkill.getId());
                            s.setName(parentSkill.getName());
                            s.setSpecializationList(new ArrayList<>());
                            return s;
                        });
                        sk.getSpecializationList().add(spec);
                    });
                    g.setSpecsBySkill(new ArrayList<>(skillByIdMap.values()));
                });
            }
        }

        return roles;
    }
}