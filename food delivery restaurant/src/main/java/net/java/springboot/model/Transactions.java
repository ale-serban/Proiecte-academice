package net.java.springboot.model;

import javax.persistence.*;

@Entity
@Table(name = "transactions")
public class Transactions {

    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    private Long id;

    @Column(name = "idcontSursa")
    private String idSursa;

    @Column(name  = "idcontDestinatie")
    private String idDestinatie;

    @Column(name = "suma")
    private double amount;

    @Column(name = "status")
    private boolean approved;

    @ManyToOne( fetch = FetchType.LAZY , cascade = {CascadeType.PERSIST , CascadeType.MERGE , CascadeType.DETACH , CascadeType.REFRESH })
    @JoinColumn(name = "cont_id")
    private Cont cont;

    public Transactions() {
    }

    public Transactions(String idSursa, String idDestinatie, double amount) {
        this.idSursa = idSursa;
        this.idDestinatie = idDestinatie;
        this.amount = amount;
        this.approved = false;
    }



    public String getIdSursa() {
        return idSursa;
    }

    public void setIdSursa(String idSursa) {
        this.idSursa = idSursa;
    }

    public String getIdDestinatie() {
        return idDestinatie;
    }

    public void setIdDestinatie(String idDestinatie) {
        this.idDestinatie = idDestinatie;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Long getId() {
        return id;
    }

    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;

    }

    public void setId(Long id) {
        this.id = id;
    }

    public Cont getCont() {
        return cont;
    }

    public void setCont(Cont cont) {
        this.cont = cont;
    }

    @Override
    public String toString() {
        return "Transactions{" +
                "id=" + id +
                ", idSursa='" + idSursa + '\'' +
                ", idDestinatie='" + idDestinatie + '\'' +
                ", amount=" + amount +
                ", approved=" + approved +
                '}';
    }
}
