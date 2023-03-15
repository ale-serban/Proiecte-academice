package net.java.springboot.model;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name =  "menu")
public class Meniu {

    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    private Long id;


    @OneToMany(fetch = FetchType.LAZY , cascade = {CascadeType.PERSIST , CascadeType.MERGE , CascadeType.DETACH , CascadeType.REFRESH})
    private List<FelPrincipal> felPrincipalList;

    @OneToMany(fetch = FetchType.LAZY , cascade = {CascadeType.PERSIST , CascadeType.MERGE , CascadeType.DETACH , CascadeType.REFRESH})
    private List<Bauturi> bauturi;

    @OneToMany(cascade = {CascadeType.PERSIST , CascadeType.MERGE , CascadeType.DETACH , CascadeType.REFRESH})
    private List<Desert> desert;



    public Meniu(){

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public List<FelPrincipal> getFelPrincipalList() {
        return felPrincipalList;
    }

    public void setFelPrincipalList(List<FelPrincipal> felPrincipalList) {
        this.felPrincipalList = felPrincipalList;
    }

    public List<Bauturi> getBauturi() {
        return bauturi;
    }

    public void setBauturi(List<Bauturi> bauturi) {
        this.bauturi = bauturi;
    }

    public List<Desert> getDesert() {
        return desert;
    }

    public void setDesert(List<Desert> desert) {
        this.desert = desert;
    }

    @Override
    public String toString() {
        return "Meniu{" +
                "id=" + id +
                ", felPrincipalList=" + felPrincipalList +
                ", bauturi=" + bauturi +
                ", desert=" + desert +
                '}';
    }
}
