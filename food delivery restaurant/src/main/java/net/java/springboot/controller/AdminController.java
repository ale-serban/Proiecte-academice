package net.java.springboot.controller;

import net.java.springboot.service.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private UserService userService;
    private BauturiService bauturiService;
    private DesertService desertService;
    private FelPrincipalService felPrincipalService;
    private MeniuService meniuService;

    public AdminController(UserService userService , BauturiService bauturiService , DesertService desertService , FelPrincipalService felPrincipalService , MeniuService meniuService){

        this.userService = userService;
        this.bauturiService = bauturiService;
        this.desertService = desertService;
        this.felPrincipalService = felPrincipalService;
        this.meniuService = meniuService;

    }

    @GetMapping("/info")
    public String getInfo(Model model)
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        model.addAttribute("allBauturi", bauturiService.getAllDrinks());
        model.addAttribute("allDeserts", desertService.getAllDeserts());
        model.addAttribute("allFelPrincipal" , felPrincipalService.getAllFeluriPrincipale());


        return "indexAdmin";
    }

    @PostMapping("/drink/delete/{id}")
    public String deleteDrink(@PathVariable Long id , Model model){

        bauturiService.deleteDrink(id);
        return "redirect:/admin/info";

    }

    @PostMapping("/desert/delete/{id}")
    public String deleteDesert(@PathVariable Long id , Model model){

        desertService.deleteDesert(id);
        return "redirect:/admin/info";

    }

    @PostMapping("/felPrincipal/delete/{id}")
    public String deleteFelPrincipal(@PathVariable Long id , Model model){

        felPrincipalService.deleteFelPrincipal(id);
        return "redirect:/admin/info";

    }

}
