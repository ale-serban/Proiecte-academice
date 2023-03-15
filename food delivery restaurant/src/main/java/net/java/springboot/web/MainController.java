package net.java.springboot.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {
	
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	
	@GetMapping("/user")
	public String homeClient() {
		return "index";
	}

	@GetMapping("/admin")
	public String homeAdmin() {
		return "indexAdmin";
	}

	@GetMapping("")
	public String redirect() {
		return "redirect:/user/info/save";
	}
}
