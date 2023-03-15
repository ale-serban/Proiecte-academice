package net.java.springboot.service;

import net.java.springboot.model.Desert;
import net.java.springboot.view.DesertRepository;
import net.java.springboot.controller.dto.DesertDto;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DesertServiceImpl implements  DesertService{

    private DesertRepository desertRepository;

    public DesertServiceImpl(DesertRepository desertRepository){
        this.desertRepository = desertRepository;
    }

    @Override
    public List<Desert> getAllDeserts() {

        return desertRepository.findAll();
    }

    @Override
    public Desert getDesert(Long id) {
        return desertRepository.getOne(id);
    }

    @Override
    public Desert save(DesertDto desertDto) {

        Desert desert = new Desert(desertDto.getNume() , desertDto.getPret() , desertDto.getDescriere());
        return desertRepository.save(desert);

    }

    @Override
    public void deleteDesert(Long id) {
        desertRepository.deleteById(id);
    }


}
