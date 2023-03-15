package net.java.springboot.controller;

import net.java.springboot.service.BauturiService;
import net.java.springboot.controller.dto.BauturiDto;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/drinks")
public class DrinksController {

    private BauturiService bauturiService;

    public DrinksController(BauturiService bauturiService){
        this.bauturiService = bauturiService;
    }

    @ModelAttribute("drinks")
    public BauturiDto bauturiSave() {
        return new BauturiDto();
    }

    @GetMapping
    public String showRegistrationForm() {
        return "drinks";
    }

    @PostMapping
    public String registerUserAccount(@ModelAttribute("drinks") BauturiDto bauturiDto) {

        bauturiService.save(bauturiDto);

        return "redirect:/admin/info";
    }


}
