package portfolio.example.im_cc.models;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table
public class Armour extends Inventory {

    @Enumerated(EnumType.STRING)
    @ElementCollection
    @CollectionTable(name = "armour_locations", joinColumns = @JoinColumn(name = "armour_id"))
    @Column(name = "location")
    private List<ArmorLocation> locationsCovered;

    private Integer weightWorn;

    @Column(columnDefinition = "text")
    private String special;

    private Integer armorPoints;

    public List<ArmorLocation> getLocationsCovered() { return locationsCovered; }
    public void setLocationsCovered(List<ArmorLocation> locationsCovered) { this.locationsCovered = locationsCovered; }

    public Integer getWeightWorn() { return weightWorn; }
    public void setWeightWorn(Integer weightWorn) { this.weightWorn = weightWorn; }

    public String getSpecial() { return special; }
    public void setSpecial(String special) { this.special = special; }

    public Integer getArmorPoints() { return armorPoints; }
    public void setArmorPoints(Integer armorPoints) { this.armorPoints = armorPoints; }
}
