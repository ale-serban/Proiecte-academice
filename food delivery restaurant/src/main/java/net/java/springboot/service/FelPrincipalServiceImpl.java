package net.java.springboot.service;

import net.java.springboot.model.FelPrincipal;
import net.java.springboot.view.FelPrincipalRepository;
import net.java.springboot.controller.dto.FelPrincipalDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FelPrincipalServiceImpl implements FelPrincipalService{

    private FelPrincipalRepository felPrincipalRepository;

    public FelPrincipalServiceImpl(FelPrincipalRepository felPrincipalRepository){
        this.felPrincipalRepository = felPrincipalRepository;
    }


    @Override
    public List<FelPrincipal> getAllFeluriPrincipale() {
       return felPrincipalRepository.findAll();

    }

    @Override
    public FelPrincipal getOne(Long id) {
        return felPrincipalRepository.getOne(id);
    }

    @Override
    public FelPrincipal save(FelPrincipalDto felPrincipalDto) {
        FelPrincipal felPrincipal = new FelPrincipal(felPrincipalDto.getNume() , felPrincipalDto.getPret() , felPrincipalDto.getDescriere());
        return felPrincipalRepository.save(felPrincipal);

    }

    @Override
    public void deleteFelPrincipal(Long id) {
        felPrincipalRepository.deleteById(id);

    }
}
