package service;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import model.User;
import repository.UserRepository;

@Service 
public class UserService {
	
	@Autowired
	private UserRepository userRepository;

	public User register(User user) {
		System.out.println("Registering user in register()....");
		
		Optional<User> existingUser = userRepository.findByUsername(user.getusername()); 
		if (existingUser.isPresent()) {
			throw new RuntimeException("Username is already taken.");
		}
		
		User newUser = new User();
		newUser.setusername(user.getusername());
		newUser.setUserPassword(user.getUserPassword()); 
		newUser.setEmail(user.getEmail());
		newUser.setRegistrationDate(LocalDateTime.now());
		newUser.setLastLogin(LocalDateTime.now());

		User userSaved = userRepository.save(newUser);
		System.out.println("User saved with ID: " + userSaved.getUserId());
		return userSaved;
	}
	
	public boolean authenticate(User user) {
		Optional<User> existingUser = userRepository.findByUsername(user.getusername());
		if (existingUser.isPresent()) {
			return user.getUserPassword().equals(existingUser.get().getUserPassword());
		}
		return false;
	}

	public User findByUsername(String userName) {
	    return userRepository.findByUsername(userName).orElse(null);
	}
}
