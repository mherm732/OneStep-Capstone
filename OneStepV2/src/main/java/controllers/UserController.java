package controllers;


import model.User;
import service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
public class UserController {

	@Autowired
	private UserService userService;

	@GetMapping("/test")
	public ResponseEntity<String> test() {
		System.out.println(" TEST ENDPOINT REACHED");
		return ResponseEntity.ok("Test endpoint is public!");
	}

	@PostMapping("/register")
	public ResponseEntity<String> register(@RequestBody User user) {
		System.out.println("Register endpoint hit with username: " + user.getUserName());
		userService.register(user);
		return ResponseEntity.ok("User registered successfully.");
	}

	@PostMapping("/login")
	public ResponseEntity<String> login(@RequestBody User user) {
		boolean authenticated = userService.authenticate(user);
		if (authenticated) {
			return ResponseEntity.ok("Login successful for user: " + user.getUserName());
		} else {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
		}
	}
	
	@GetMapping("/by-username/{username}")
	public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
	    return ResponseEntity.ok(userService.findByUsername(username));
	}
}
