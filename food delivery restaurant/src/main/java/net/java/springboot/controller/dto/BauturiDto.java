package net.java.springboot.controller.dto;

public class BauturiDto {

    private String nume;
    private String descriere;
    private boolean contineAlcool;
    private Double pret;


    public BauturiDto(){}

    public BauturiDto(String nume, String descriere, boolean contineAlcool, Double pret) {
        this.nume = nume;
        this.descriere = descriere;
        this.contineAlcool = contineAlcool;
        this.pret = pret;
    }

    public String getNume() {
        return nume;
    }

    public void setNume(String nume) {
        this.nume = nume;
    }

    public String getDescriere() {
        return descriere;
    }

    public void setDescriere(String descriere) {
        this.descriere = descriere;
    }

    public boolean isContineAlcool() {
        return contineAlcool;
    }

    public void setContineAlcool(boolean contineAlcool) {
        this.contineAlcool = contineAlcool;
    }

    public Double getPret() {
        return pret;
    }

    public void setPret(Double pret) {
        this.pret = pret;
    }

    @Override
    public String toString() {
        return "BauturiDto{" +
                "nume='" + nume + '\'' +
                ", descriere='" + descriere + '\'' +
                ", contineAlcool=" + contineAlcool +
                ", pret=" + pret +
                '}';
    }


}
