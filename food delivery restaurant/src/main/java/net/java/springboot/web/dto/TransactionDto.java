package net.java.springboot.web.dto;

public class TransactionDto {

    private String idSursa;
    private String idDestinatie;
    private double amount;
    private boolean approved;

    public TransactionDto() {
    }

    public TransactionDto(String idSursa, String idDestinatie, double amount) {
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

    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    @Override
    public String toString() {
        return "TransactionDto{" +
                "idSursa='" + idSursa + '\'' +
                ", idDestinatie='" + idDestinatie + '\'' +
                ", amount=" + amount +
                ", approved=" + approved +
                '}';
    }
}
