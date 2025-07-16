package controllers;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

import dto.LoginRequest;
import dto.SignupRequest;
import dto.JwtResponse;
import model.User;
import repository.UserRepository;
import security.JwtUtils;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

	 @Autowired AuthenticationManager authenticationManager;
	 @Autowired UserRepository userRepository;
	 @Autowired PasswordEncoder encoder;
	 @Autowired JwtUtils jwtUtils;

	  @PostMapping("/login")
	  public ResponseEntity<?> authenticateUser(@RequestBody LoginRequest loginRequest) {
	    Authentication authentication = authenticationManager.authenticate(
	      new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));
	    SecurityContextHolder.getContext().setAuthentication(authentication);
	    String jwt = jwtUtils.generateJwtToken(authentication);

	    return ResponseEntity.ok(new JwtResponse(jwt));
	  }

	  @PostMapping("/register")
	  public ResponseEntity<?> registerUser(@RequestBody SignupRequest signUpRequest) {
	    if (userRepository.existsByUsername(signUpRequest.getUsername())) {
	      return ResponseEntity.badRequest().body("Username already taken");
	    }

	    if (userRepository.existsByEmail(signUpRequest.getEmail())) {
	      return ResponseEntity.badRequest().body("Email already in use");
	    }

	    User user = new User();
	    user.setUserName(signUpRequest.getUsername());
	    user.setUserEmail(signUpRequest.getEmail());
	    user.setUserPassword(encoder.encode(signUpRequest.getPassword()));
	    userRepository.save(user);

	    return ResponseEntity.ok("User registered successfully!");
	  }
}

