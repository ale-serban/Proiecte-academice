package net.java.springboot.model;

import javax.persistence.*;

@Entity
@Table(name = "felprincipal")
public class FelPrincipal {

    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nume")
    private String nume;

    @Column(name = "pret")
    private Double pret;

    @Column(name = "descrirere")
    private String descrirere;

    @Column(name = "cantitateComandata")
    private int cantitateComandata;

    @ManyToOne(fetch = FetchType.LAZY , cascade = {CascadeType.PERSIST , CascadeType.MERGE , CascadeType.DETACH , CascadeType.REFRESH})
    @JoinColumn(name = "meniu_id")
    private Meniu meniu;


    public FelPrincipal(String nume, Double pret, String descrirere) {
        this.nume = nume;
        this.pret = pret;
        this.descrirere = descrirere;
        this.cantitateComandata = 0;
    }

    public FelPrincipal() {

    }

    @Override
    public String toString() {
        return "FelPrincipal{" +
                "id=" + id +
                ", nume='" + nume + '\'' +
                ", pret=" + pret +
                ", descrirere='" + descrirere + '\'' +
                '}';
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNume() {
        return nume;
    }

    public void setNume(String nume) {
        this.nume = nume;
    }

    public Double getPret() {
        return pret;
    }

    public void setPret(Double pret) {
        this.pret = pret;
    }

    public String getDescrirere() {
        return descrirere;
    }

    public void setDescrirere(String descrirere) {
        this.descrirere = descrirere;
    }


    public int getCantitateComandata() {
        return cantitateComandata;
    }

    public void setCantitateComandata(int cantitateComandata) {
        this.cantitateComandata = cantitateComandata;
    }

    public Meniu getMeniu() {
        return meniu;
    }

    public void setMeniu(Meniu meniu) {
        this.meniu = meniu;
    }
}
