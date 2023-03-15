package net.java.springboot.view;

import net.java.springboot.model.FelPrincipal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FelPrincipalRepository extends JpaRepository<FelPrincipal, Long> {
}
