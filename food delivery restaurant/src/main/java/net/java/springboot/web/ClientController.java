package net.java.springboot.web;

import net.java.springboot.model.Cont;
import net.java.springboot.model.Transactions;
import net.java.springboot.model.User;
import net.java.springboot.service.ContService;
import net.java.springboot.service.TransactionsService;
import net.java.springboot.service.UserService;
import net.java.springboot.web.dto.TransactionDto;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/user")
public class ClientController {

    private UserService userService;
    private TransactionsService transactionsService;
    private ContService contService;

    public ClientController (UserService userService , TransactionsService transactionsService , ContService contService){
        this.userService = userService;
        this.transactionsService = transactionsService;
        this.contService = contService;

    }

    @GetMapping("/info")
    public String getInfo(Model model){

        model.addAttribute("amount",userService.getAmount("as@gmail.com"));
        model.addAttribute("allTransactions"  , userService.getTransactions("as@gmail.com"));
        return "index";
    }

    @GetMapping("/info/save")
    public String something(Model model){

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        //System.out.println(currentPrincipalName);

        model.addAttribute("amount",userService.getAmount(currentPrincipalName));
        model.addAttribute("allTransactions"  , userService.getTransactions(currentPrincipalName));

        Transactions transaction = new Transactions();

        model.addAttribute("transaction" , transaction);

        return "index";
    }


    @PostMapping("/info/save")
    public String saveInfo(@ModelAttribute("transaction")TransactionDto transactionDto){

        //System.out.println("Transaction: "+ transactionDto.toString() + "was saved");

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();

        transactionDto.setIdSursa(currentPrincipalName);

        User source = userService.getUser(currentPrincipalName);

        Transactions transaction = transactionsService.saveTransaction(transactionDto);

        Cont contSource = source.getCont();

        transaction.setCont(contSource);

        contSource.addTransaction(transaction);

        transactionsService.updateTransaction(transaction);

        contService.updateCont(contSource);

        return "redirect:/user/info/save?success";
    }




}
