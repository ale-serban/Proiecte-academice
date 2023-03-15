package net.java.springboot.service;

import net.java.springboot.model.Cont;

public interface ContService {

     Cont getCont(Long id);
     Cont updateCont(Cont cont);

}
