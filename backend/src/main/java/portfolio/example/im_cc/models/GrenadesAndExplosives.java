package portfolio.example.im_cc.models;

import jakarta.persistence.*;

import java.util.List;

@Table
@Entity
public class GrenadesAndExplosives extends Inventory{
    @ManyToMany
    @JoinTable(
            name = "grenade_specializations",
            joinColumns = @JoinColumn(name = "grenade_id"),
            inverseJoinColumns = @JoinColumn(name = "specialization_id")
    )
    private List<Specialization> specializations;

    private Integer damage;  // nullable — у Choke/Smoke/Web damage нет

    @Column(columnDefinition = "text")
    private String special;  // traits

    @Column(columnDefinition = "text")
    private String description;

    public Integer getDamage() { return damage; }
    public void setDamage(Integer damage) { this.damage = damage; }

    public String getSpecial() { return special; }
    public void setSpecial(String special) { this.special = special; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Specialization> getSpecializations() {
        return specializations;
    }

    public void setSpecializations(List<Specialization> specializations) {
        this.specializations = specializations;
    }
}
