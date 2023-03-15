package net.java.springboot.service;

import net.java.springboot.model.Bauturi;
import net.java.springboot.view.BauturiRepository;
import net.java.springboot.controller.dto.BauturiDto;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class BauturiServiceImpl implements BauturiService{

    private BauturiRepository bauturiRepository;

    public BauturiServiceImpl(BauturiRepository bauturiRepository){
        this.bauturiRepository = bauturiRepository;
    }
    @Override
    public List<Bauturi> getAllDrinks() {
        return bauturiRepository.findAll();
    }

    @Override
    public Bauturi getDrink(Long id) {
        return bauturiRepository.getOne(id);
    }

    @Override
    public Bauturi save(BauturiDto bauturiDto) {

        Bauturi bauturi = new Bauturi( bauturiDto.getNume() , bauturiDto.getPret() , bauturiDto.isContineAlcool() , bauturiDto.getDescriere());
        return bauturiRepository.save(bauturi);
    }

    @Override
    public void deleteDrink(Long id) {
        bauturiRepository.deleteById(id);
    }


}
