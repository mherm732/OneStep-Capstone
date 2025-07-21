package model;

import java.time.LocalDateTime;
import java.util.UUID;


import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;


@Entity 
@Table(name = "user")
public class User {
	
	@Id 
	@GeneratedValue
	@org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.CHAR)
	@Column(name = "userId", nullable = false, updatable = false, columnDefinition = "CHAR(36)")
	private UUID userId; 
	
	@NotBlank
	@Size(max = 50)
	@Email
	@Column(name = "email", nullable = false, unique = true, length = 255)
	private String email;
	
	@NotBlank
	@Size(max = 20)
	@Column(name = "username", nullable = false, unique = true, length = 255)
	private String username; 
	
	@NotBlank
	@Size(max = 120)
	@Column(name = "userPassword", nullable = false, unique = true, length = 255)
	private String userPassword; 
	
	@Column(name = "registrationDate")
	private LocalDateTime registrationDate;
	@Column(name = "lastLogin")
	private LocalDateTime lastLogin;
	
	public User() {
		registrationDate = LocalDateTime.now();
		lastLogin = LocalDateTime.now();
	}
	
	public User(UUID userId, String email, String username, String userPassword, LocalDateTime registrationDate, LocalDateTime lastLogin) {
		this.userId = userId;
		this.email = email;
		this.username = username; 
		this.userPassword = userPassword;
		this.registrationDate = registrationDate;
		this.lastLogin = lastLogin;
	}
	
	public void setUserId(UUID userId) {
		this.userId = userId; 
	}
	
	public UUID getUserId() {
		return userId;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setusername(String username) {
		this.username = username;
	}
	
	public String getusername() {
		return username;
	}
	
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	
	public String getUserPassword() {
		return userPassword;
	}
	
	public void setRegistrationDate(LocalDateTime registrationDate) {
		this.registrationDate = registrationDate;
	}
	
	public LocalDateTime getRegistrationDate() {
		return registrationDate;
	}
	
	public void setLastLogin(LocalDateTime lastLogin) {
		this.lastLogin = lastLogin;
	}
	
	public LocalDateTime getLastLogin() {
		return lastLogin;
	}
	
	@Override
	public String toString() {
		return "--------User---------" + "\n" +
				"User Id: " + userId + "\n" +
				"User Email: " + email + "\n" + 
				"username: " + username + "\n" + 
				"User password: " + userPassword + "\n" + 
				"Registration date: " + registrationDate + "\n" +
				"Last login: " + lastLogin + "\n" +
				"----------------------";
	}
	
}
