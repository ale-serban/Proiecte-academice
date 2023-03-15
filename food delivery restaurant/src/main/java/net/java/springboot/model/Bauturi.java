package net.java.springboot.model;

import javax.persistence.*;

@Entity
@Table(name = "bauturi")
public class Bauturi {

    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nume")
    private String nume;

    @Column(name = "descrirere")
    private String descrirere;

    @Column(name = "continealcool")
    private boolean contineAlcool;

    @Column(name = "pret")
    private Double pret;

    @Column(name = "cantitateComandata")
    private int cantitateComandata;

    @ManyToOne(fetch = FetchType.LAZY ,  cascade = {CascadeType.PERSIST , CascadeType.MERGE , CascadeType.DETACH , CascadeType.REFRESH})
    @JoinColumn(name = "meniu_id")
    private Meniu meniu;


    public Bauturi(){

    }

    public Bauturi(String nume, Double pret , boolean contineAlcool , String descrirere) {
        this.nume = nume;
        this.pret = pret;
        this.contineAlcool = contineAlcool;
        this.descrirere = descrirere;
        this.cantitateComandata = 0;
    }

    @Override
    public String toString() {
        return "Bauturi{" +
                "id=" + id +
                ", nume='" + nume + '\'' +
                ", pret=" + pret +
                ", contineAlcool=" + contineAlcool +
                '}';
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

    public boolean isContineAlcool() {
        return contineAlcool;
    }

    public void setContineAlcool(boolean contineAlcool) {
        this.contineAlcool = contineAlcool;
    }

    public String getDescrirere() {
        return descrirere;
    }

    public void setDescrirere(String descrirere) {
        this.descrirere = descrirere;
    }
}
