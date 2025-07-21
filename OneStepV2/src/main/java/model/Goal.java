package model;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;

@Entity
public class Goal {
	
	@Id
	@GeneratedValue
	@org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.CHAR)
	@Column(name = "goalId", nullable = false, unique = true, columnDefinition = "CHAR(36)")
	private UUID goalId;
	
	private String title; 
	
	@JsonProperty("goalDescription")
	private String goalDescription;
	
	private LocalDateTime dateCreated;
	
	@Column(name = "dateCompleted", nullable = true)
	private LocalDateTime dateCompleted;
	
	private int totalSteps = 0;
	private int stepsCompleted = 0;
	
    @Enumerated(EnumType.STRING)
	private Status goalStatus;
    
    @ManyToOne
    @JoinColumn(name = "userId", nullable = false)
    private User user;
	
	public Goal() {
		this.dateCreated = LocalDateTime.now();
		this.goalStatus = Status.IN_PROGRESS;
	}
	
	/*public Goal(String title, LocalDateTime dateCreated, LocalDateTime dateCompleted, int totalSteps, int stepsCompleted, Status goalStatus) {
	
		this.title = title;
		//this.goalDescription = goalDescription;
		this.dateCreated = dateCreated;
		dateCompleted = null;
		this.totalSteps = totalSteps;
		this.stepsCompleted = stepsCompleted;
		this.goalStatus = goalStatus;
	}*/
	
	public UUID getGoalId() {
		return goalId;
	}
	
	public void setGoalId(UUID goalId) {
		this.goalId = goalId;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return title;
	}
	

	@JsonProperty("goalDescription")
	public void setGoalDescription(String goalDescription) {
		this.goalDescription = goalDescription;
	}
	
	@JsonProperty("goalDescription")
	public String getGoalDescription() {
		return goalDescription;
	}
	
	public void setDateCreated(LocalDateTime dateCreated) {
		this.dateCreated = dateCreated;
	}
	
	public LocalDateTime getDateCreated() {
		return dateCreated;
	}
	
	public void setDateCompleted(LocalDateTime dateCompleted) {
		this.dateCompleted = dateCompleted;
	}
	
	public void setTotalSteps(int totalSteps) {
		this.totalSteps = totalSteps;
	}
	
	public int getTotalSteps() {
		return totalSteps;
	}
	
	public void setStepsCompleted(int stepsCompleted) {
		this.stepsCompleted = stepsCompleted;
	}
	
	public int getStepsCompleted() {
		return stepsCompleted;
	}
	
	public void setGoalStatus(Status goalStatus) {
		this.goalStatus = goalStatus;
	}
	
	public Status getGoalStatus() {
		return goalStatus;
	}
	
	public User getUser() {
		return user;
	}
	
	public void setUser(User user) {
		this.user = user;
	}
	
	@Override 
	public String toString() {
		return ("-------Goal-------\n") +
				"Goal ID: " + goalId + "\n" +
				"Title: " + title + "\n" + 
				"Goal Description: " + goalDescription + "\n" +
				"Date Created: " + dateCreated + "\n" +
				"Date Completed: " + dateCompleted + "\n" +
				"Goal Status: " + goalStatus + "\n" + 
				"---------------------";
		
	}

	
}
