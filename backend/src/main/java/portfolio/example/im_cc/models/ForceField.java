package portfolio.example.im_cc.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table
public class ForceField extends Inventory{
    @Column(columnDefinition = "text")
    private String protection;
    private Integer overload;

    @Column(columnDefinition = "text")
    private String special;

    public String getProtection() {
        return protection;
    }

    public void setProtection(String protection) {
        this.protection = protection;
    }

    public Integer getOverload() {
        return overload;
    }

    public void setOverload(Integer overload) {
        this.overload = overload;
    }

    public String getSpecial() {
        return special;
    }

    public void setSpecial(String special) {
        this.special = special;
    }
}
