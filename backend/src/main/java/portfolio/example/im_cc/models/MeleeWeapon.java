package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table
public class MeleeWeapon extends Inventory{
    @ManyToOne(fetch = jakarta.persistence.FetchType.LAZY)
    private Specialization specialization;

    @Column(columnDefinition = "text")
    private String damage;
    @Column(columnDefinition = "text")
    private String special;

    public Specialization getSpecialization() { return specialization; }
    public void setSpecialization(Specialization s) { this.specialization = s; }
    public String getDamage() { return damage; }
    public void setDamage(String damage) { this.damage = damage; }
    public String getSpecial() { return special; }
    public void setSpecial(String special) { this.special = special; }
}
