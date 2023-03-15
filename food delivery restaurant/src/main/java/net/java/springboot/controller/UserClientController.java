package net.java.springboot.controller;

import net.java.springboot.model.*;
import net.java.springboot.service.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserClientController {

    private UserService userService;
    private BauturiService bauturiService;
    private DesertService desertService;
    private FelPrincipalService felPrincipalService;
    private MeniuService meniuService;


    public UserClientController(UserService userService , BauturiService bauturiService , DesertService desertService , FelPrincipalService felPrincipalService , MeniuService meniuService){

        this.userService = userService;
        this.bauturiService = bauturiService;
        this.desertService = desertService;
        this.felPrincipalService = felPrincipalService;
        this.meniuService = meniuService;

    }

    @GetMapping("/info")
    public String getInfo(Model model) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        model.addAttribute("allBauturi", bauturiService.getAllDrinks());
        model.addAttribute("allDeserts", desertService.getAllDeserts());
        model.addAttribute("allFelPrincipal" , felPrincipalService.getAllFeluriPrincipale());


        User currentUser = userService.getUser(currentPrincipalName);
        Meniu meniu = currentUser.getMeniu();

        List<Bauturi> bauturiAdaugate = meniu.getBauturi();
        List<Desert> desertChecked = meniu.getDesert();
        List<FelPrincipal> felPrincipalChecked = meniu.getFelPrincipalList();

        double amount = 0.0f;

        for(Bauturi b : bauturiAdaugate){
            amount+= b.getPret();
        }

        for(Desert d : desertChecked){
            amount+= d.getPret();
        }
        for(FelPrincipal fp : felPrincipalChecked){
            amount+= fp.getPret();
        }


        model.addAttribute("checkedDrinks" , bauturiAdaugate);
        model.addAttribute("checkedDeserts" , desertChecked);
        model.addAttribute("checkedFelPrincipal" , felPrincipalChecked);
        model.addAttribute("amount", amount);

        return "index";
    }

    @PostMapping ("/info/sendStuff")
    public String addDesert(Model model) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);

        Meniu  meniuCurent = user.getMeniu();

        meniuCurent.setDesert(new ArrayList<>());
        meniuCurent.setBauturi(new ArrayList<>());
        meniuCurent.setFelPrincipalList(new ArrayList<>());

        userService.update(user);

        return "redirect:/user/info?success";
    }

    @PostMapping("/info/add/drink/{id}")
    public String addDrink(@PathVariable Long id , @ModelAttribute("drink")Bauturi drink , Model model) {

        Bauturi bauturaSelectata = bauturiService.getDrink(id);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);
        Meniu usersMenu = user.getMeniu();

        List<Bauturi> bauturiList = usersMenu.getBauturi();

        if (!bauturiList.contains(bauturaSelectata))
        {
            bauturiList.add(bauturaSelectata);
        }else
        {
          //  Long lastId = bauturaSelectata.getId();
          //  bauturaSelectata.setId(lastId+1);
        }


        userService.update(user);

        return "redirect:/user/info?success";
        }


    @PostMapping("/info/add/desert/{id}")
    public String addDesert(@PathVariable Long id , @ModelAttribute("desert")Desert desert , Model model) {

        Desert desertSelectat = desertService.getDesert(id);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);
        Meniu usersMenu = user.getMeniu();

        List<Desert> desertList = usersMenu.getDesert();

        if (!desertList.contains(desertSelectat)) {

            desertList.add(desertSelectat);

        }

        userService.update(user);

        return "redirect:/user/info?success";
    }

    @PostMapping("/info/add/food/{id}")
    public String addFood(@PathVariable Long id , @ModelAttribute("food")FelPrincipal food , Model model) {

        FelPrincipal felPrincipalSelectat = felPrincipalService.getOne(id);

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);
        Meniu usersMenu = user.getMeniu();

        List<FelPrincipal> felPrincipalList = usersMenu.getFelPrincipalList();

        if (! felPrincipalList.contains(felPrincipalSelectat)) {
            felPrincipalList.add(felPrincipalSelectat);
        }

        userService.update(user);

        return "redirect:/user/info?success";
    }


    //-------------------------Delete Requests:

    @PostMapping("/info/delete/drink/{id}")
    public String deleteDrink(@PathVariable Long id , @ModelAttribute("drink")Bauturi drink , Model model) {

        Bauturi bauturaSelectata = bauturiService.getDrink(id);

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);
        Meniu usersMenu = user.getMeniu();

        List<Bauturi> bauturiList = usersMenu.getBauturi();

        if (bauturiList.contains(bauturaSelectata))
        {
            bauturiList.remove(bauturaSelectata);

        }else
        {
            //  Long lastId = bauturaSelectata.getId();
            //  bauturaSelectata.setId(lastId+1);
        }


        userService.update(user);

        return "redirect:/user/info?success";
    }


    @PostMapping("/info/delete/desert/{id}")
    public String deleteDesert(@PathVariable Long id , @ModelAttribute("desert")Desert desert , Model model) {

        Desert desertSelectat = desertService.getDesert(id);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);
        Meniu usersMenu = user.getMeniu();

        List<Desert> desertList = usersMenu.getDesert();

        if (desertList.contains(desertSelectat)) {
            desertList.remove(desertSelectat);
        }

        userService.update(user);

        return "redirect:/user/info?success";
    }

    @PostMapping("/info/delete/food/{id}")
    public String deleteFood(@PathVariable Long id , @ModelAttribute("food")FelPrincipal food , Model model) {

        FelPrincipal felPrincipalSelectat = felPrincipalService.getOne(id);

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        User user = userService.getUser(currentPrincipalName);
        Meniu usersMenu = user.getMeniu();

        List<FelPrincipal> felPrincipalList = usersMenu.getFelPrincipalList();

        if(felPrincipalList.contains(felPrincipalSelectat)) {

            felPrincipalList.remove(felPrincipalSelectat);


        }

        userService.update(user);

        return "redirect:/user/info?success";
    }



    }
