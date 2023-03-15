package net.java.springboot.service;

import net.java.springboot.model.Transactions;
import net.java.springboot.web.dto.TransactionDto;

public interface TransactionsService {

    Transactions getTransaction(Long id);
    Transactions updateTransaction(Transactions transactions);
    Transactions saveTransaction(TransactionDto transactionDto);
    void deleteTransaction(Long id);
}
