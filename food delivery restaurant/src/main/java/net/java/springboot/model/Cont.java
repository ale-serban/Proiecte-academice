package net.java.springboot.model;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "cont")
public class Cont {


    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    private Long id;


    @Column(name = "sold")
    private double sold;

    @OneToMany(mappedBy = "cont" , fetch = FetchType.LAZY , cascade = CascadeType.ALL)
    private List<Transactions> transactionsList;

    public Cont(double sold, List<Transactions> transactionsList) {
        this.sold = sold;
        this.transactionsList = transactionsList;
    }

    public void addTransaction(Transactions transaction){

        this.transactionsList.add(transaction);

    }

    public Cont() {

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public double getSold() {
        return sold;
    }

    public void setSold(double sold) {
        this.sold = sold;
    }

    public List<Transactions> getTransactionsList() {
        return transactionsList;
    }

    public void setTransactionsList(List<Transactions> transactionsList) {
        this.transactionsList = transactionsList;
    }

    @Override
    public String toString() {
        return "Cont{" +
                "id=" + id +
                ", sold=" + sold +
                ", transactionsList=" + transactionsList.toString() +
                '}';
    }
}
