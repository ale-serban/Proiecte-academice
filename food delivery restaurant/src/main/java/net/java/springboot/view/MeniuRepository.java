package net.java.springboot.view;

import net.java.springboot.model.Meniu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MeniuRepository extends JpaRepository<Meniu, Long> {


}
