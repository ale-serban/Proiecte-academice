package net.java.springboot.service;

import net.java.springboot.model.Cont;
import net.java.springboot.repository.ContRepository;
import org.springframework.stereotype.Service;

@Service
public class ContServiceImpl implements  ContService{

    private ContRepository contRepository;

    public ContServiceImpl(ContRepository contRepository){

        this.contRepository = contRepository;
    }


    @Override
    public Cont getCont(Long id) {
        return contRepository.getOne(id);
    }

    @Override
    public Cont updateCont(Cont cont) {
        return contRepository.save(cont);
    }
}
