package net.java.springboot.service;

import net.java.springboot.model.Desert;
import net.java.springboot.controller.dto.DesertDto;

import java.util.List;

public interface DesertService {

     List<Desert> getAllDeserts();
     Desert getDesert(Long id);
     Desert save(DesertDto desertDto);
     void deleteDesert(Long id);
}
