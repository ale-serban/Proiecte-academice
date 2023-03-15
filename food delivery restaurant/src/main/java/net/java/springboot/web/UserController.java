package net.java.springboot.web;

import net.java.springboot.model.Cont;
import net.java.springboot.model.Transactions;
import net.java.springboot.model.User;
import net.java.springboot.service.ContService;
import net.java.springboot.service.TransactionsService;
import net.java.springboot.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class UserController {

    private UserService userService;
    private TransactionsService transactionsService;
    private ContService contService;

    public UserController(UserService userService ,  TransactionsService transactionsService , ContService contService)
    {
        this.userService=userService;
        this.transactionsService = transactionsService;
        this.contService = contService;
    }

    @GetMapping("/info")
    public String listUsers(Model model){

        model.addAttribute("users",userService.getAllUsers());


        List<Transactions> checkedTransactions = new ArrayList<>();

        List<Transactions> transactionsList = userService.getAllTransactions();
        List<Transactions> transactionsFiltered = new ArrayList<>();

            for(Transactions t : transactionsList)
                if (t.isApproved() == false)
                {
                    transactionsFiltered.add(t);
                }else
                    checkedTransactions.add(t);

        model.addAttribute("transactionsFiltered" , transactionsFiltered);
        model.addAttribute("transactions" , checkedTransactions);


        return "indexAdmin";
    }

    @PostMapping("/info/{id}")
    public String approveTransaction(@PathVariable Long id , @ModelAttribute("transaction")Transactions transaction , Model model){

        Transactions existingTransaction = transactionsService.getTransaction(id);
        existingTransaction.setApproved(true);

        Transactions updatedTransaction = transactionsService.updateTransaction(existingTransaction);

        Cont contSource = updatedTransaction.getCont();

        double lastSold = contSource.getSold();
        double transactionAmount = updatedTransaction.getAmount();

        lastSold-=transactionAmount;

        contSource.setSold(lastSold);

        contService.updateCont(contSource);

        //-------------------------- finaly cont source is updated correctly-------------

        String idDestinatie = updatedTransaction.getIdDestinatie();
        User userDestinatie = userService.getUser(idDestinatie);

        Cont contDestinatie = userDestinatie.getCont();

        lastSold = contDestinatie.getSold();

        lastSold += transactionAmount;

        contDestinatie.setSold(lastSold);

        contService.updateCont(contDestinatie);

        return "redirect:/admin/info";
    }

    @PostMapping("/delete/{id}")
    public String denyTransaction(@PathVariable Long id ,Model model){

        transactionsService.deleteTransaction(id);

        return "redirect:/admin/info";

    }



}
