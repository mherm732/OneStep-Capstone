package model;

import java.time.LocalDateTime;
import java.util.UUID;


import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Table;


@Entity 
@Table(name = "user")
public class User {
	
	@Id 
	@GeneratedValue
	@org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.CHAR)
	@Column(name = "userId", nullable = false, updatable = false, columnDefinition = "CHAR(36)")
	private UUID userId; 
	
	@Column(name = "userEmail", nullable = false, unique = true, length = 255)
	private String userEmail;
	@Column(name = "userName", nullable = false, unique = true, length = 255)
	private String userName; 
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
	
	public User(UUID userId, String userEmail, String userName, String userPassword, LocalDateTime registrationDate, LocalDateTime lastLogin) {
		this.userId = userId;
		this.userEmail = userEmail;
		this.userName = userName; 
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
	
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	
	public String getUserEmail() {
		return userEmail;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getUserName() {
		return userName;
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
				"User Email: " + userEmail + "\n" + 
				"Username: " + userName + "\n" + 
				"User password: " + userPassword + "\n" + 
				"Registration date: " + registrationDate + "\n" +
				"Last login: " + lastLogin + "\n" +
				"----------------------";
	}
	
}
