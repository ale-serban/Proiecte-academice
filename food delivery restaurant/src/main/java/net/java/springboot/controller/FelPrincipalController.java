package net.java.springboot.controller;

import net.java.springboot.service.FelPrincipalService;
import net.java.springboot.controller.dto.FelPrincipalDto;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/felPrincipal")
public class FelPrincipalController {

    private FelPrincipalService felPrincipalService;

    public FelPrincipalController( FelPrincipalService felPrincipalService){
        this.felPrincipalService = felPrincipalService;
    }

    @ModelAttribute("felPrincipal")
    public FelPrincipalDto saveFelPrincipal() {
        return new FelPrincipalDto();
    }

    @GetMapping
    public String showRegistrationForm() {
        return "felPrincipal";
    }

    @PostMapping
    public String registerUserAccount(@ModelAttribute("felPrincipal") FelPrincipalDto felPrincipalDto) {

        felPrincipalService.save(felPrincipalDto);
        return "redirect:/admin/info";
    }


}
