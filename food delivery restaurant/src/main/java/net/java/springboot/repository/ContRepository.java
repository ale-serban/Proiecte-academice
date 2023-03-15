package net.java.springboot.repository;

import net.java.springboot.model.Cont;
import net.java.springboot.model.Transactions;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContRepository extends JpaRepository<Cont, Long> {

}
