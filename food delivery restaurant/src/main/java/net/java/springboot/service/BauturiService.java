package net.java.springboot.service;

import net.java.springboot.model.Bauturi;
import net.java.springboot.controller.dto.BauturiDto;

import java.util.List;

public interface BauturiService {


    //User save(UserRegistrationDto registrationDto);
    List<Bauturi>  getAllDrinks();
    Bauturi getDrink(Long id);
    Bauturi save(BauturiDto bauturiDto);
    void deleteDrink(Long id);

}
