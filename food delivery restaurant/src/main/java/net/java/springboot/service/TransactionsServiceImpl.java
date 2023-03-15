package net.java.springboot.service;

import net.java.springboot.model.Transactions;
import net.java.springboot.repository.TransactionsRepository;
import net.java.springboot.repository.UserRepository;
import net.java.springboot.web.dto.TransactionDto;
import org.springframework.stereotype.Service;

@Service
public class TransactionsServiceImpl implements TransactionsService{

    private TransactionsRepository transactionsRepository;

    public TransactionsServiceImpl(TransactionsRepository transactionsRepository){

        this.transactionsRepository = transactionsRepository;
    }


    @Override
    public Transactions getTransaction(Long id) {

        return transactionsRepository.getOne(id);

    }

    @Override
    public Transactions updateTransaction(Transactions transactions) {
       return  transactionsRepository.save(transactions);
    }

    @Override
    public Transactions saveTransaction(TransactionDto transactionDto) {

        Transactions transactions = new Transactions( transactionDto.getIdSursa() , transactionDto.getIdDestinatie() , transactionDto.getAmount());

        return transactionsRepository.save(transactions);
    }

    @Override
    public void deleteTransaction(Long id) {

        transactionsRepository.deleteById(id);

    }
}
