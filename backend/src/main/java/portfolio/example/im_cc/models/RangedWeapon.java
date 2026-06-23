package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table
public class RangedWeapon extends Inventory {
    @ManyToOne(fetch = jakarta.persistence.FetchType.LAZY)
    private Specialization specialization;

    private Integer damage;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "text")
    private Range range;

    private Integer magSize;

    @Column(columnDefinition = "text")
    private String special;  // traits строкой пока

    // геттеры/сеттеры
    public Specialization getSpecialization() { return specialization; }
    public void setSpecialization(Specialization s) { this.specialization = s; }

    public Integer getDamage() { return damage; }
    public void setDamage(Integer damage) { this.damage = damage; }


    public Integer getMagSize() { return magSize; }
    public void setMagSize(Integer magSize) { this.magSize = magSize; }


    public String getSpecial() { return special; }
    public void setSpecial(String special) { this.special = special; }

    public Range getRange() {
        return range;
    }
    public Integer getMagCost() {
        return getCost() != null ? getCost() / 10 : null;
    }
    public void setRange(Range range) {
        this.range = range;
    }
}