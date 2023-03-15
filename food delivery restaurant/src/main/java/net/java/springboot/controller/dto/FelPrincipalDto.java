package net.java.springboot.controller.dto;

public class FelPrincipalDto {

    private String nume;
    private String descriere;
    private Double pret;

    public FelPrincipalDto(){}

    public FelPrincipalDto(String nume, String descriere, Double pret) {
        this.nume = nume;
        this.descriere = descriere;
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

    public Double getPret() {
        return pret;
    }

    public void setPret(Double pret) {
        this.pret = pret;
    }
}
