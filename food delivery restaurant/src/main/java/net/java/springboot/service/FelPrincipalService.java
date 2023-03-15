package net.java.springboot.service;

import net.java.springboot.model.FelPrincipal;
import net.java.springboot.controller.dto.FelPrincipalDto;

import java.util.List;

public interface FelPrincipalService {

    List<FelPrincipal> getAllFeluriPrincipale();
    FelPrincipal getOne(Long id);
    FelPrincipal save(FelPrincipalDto felPrincipalDto);
    void deleteFelPrincipal(Long id);
}
