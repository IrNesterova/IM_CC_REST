package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "faction_inventory_choice_group")
public class FactionChoiceGroup {
   @Id
   @GeneratedValue(strategy = GenerationType.IDENTITY)
   private Long id;

   @JsonIgnore
   @ManyToOne
   private Faction faction;

   private Integer choicesRequired;

   @Transient
   private List<ChoiceOption> options;
   @Transient
   private List<Inventory> inventoryChoices;
   @Transient
   private List<Talent> talentChoices;


    public Faction getFaction() {
        return faction;
    }

    public void setFaction(Faction faction) {
        this.faction = faction;
    }

    public Integer getChoicesRequired() {
        return choicesRequired;
    }

    public void setChoicesRequired(Integer choicesRequired) {
        this.choicesRequired = choicesRequired;
    }



    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public List<Inventory> getInventoryChoices() {
        return inventoryChoices;
    }

    public void setInventoryChoices(List<Inventory> inventoryChoices) {
        this.inventoryChoices = inventoryChoices;
    }

    public List<Talent> getTalentChoices() {
        return talentChoices;
    }

    public void setTalentChoices(List<Talent> talentChoices) {
        this.talentChoices = talentChoices;
    }

    public List<ChoiceOption> getOptions() {
        return options;
    }

    public void setOptions(List<ChoiceOption> options) {
        this.options = options;
    }
}
