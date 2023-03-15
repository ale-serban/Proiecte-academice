package net.java.springboot.service;

import net.java.springboot.model.User;
import net.java.springboot.controller.dto.UserRegistrationDto;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService{
	User save(UserRegistrationDto registrationDto);
	List<User> getAllUsers();
	User getUser(String email);
	User update(User user);

	void deleteUser(Long id);

}
