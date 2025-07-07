package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class Step {
	
	@Id
	@GeneratedValue 
	@org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.CHAR)
	@Column(name = "stepId", nullable = false, unique = true, columnDefinition = "CHAR(36)")
	private UUID stepId;
	
	private String stepDescription;
	private LocalDateTime dateCreated;

	@Column(name = "dateCompleted", nullable = true)
	private LocalDateTime dateCompleted;

	@Column(name = "dueDate", nullable = true)
	private LocalDateTime dueDate;
	
    private Boolean isAiGenerated;
    private int stepOrder;
	
	@Enumerated(EnumType.STRING)
	private StepStatus status;
	
	@ManyToOne
	@JoinColumn(name = "goalId", nullable = false)
	private Goal goal;
	
	public Step() {
		this.dateCreated = LocalDateTime.now();
	    this.status = StepStatus.PENDING;
	}
	
	public Step(String stepDescription, LocalDateTime dateCreated, Boolean isAiGenerated, int order, StepStatus status) {
		
		this.stepDescription = stepDescription;
		this.dateCreated = dateCreated; 
		this.isAiGenerated = isAiGenerated;
		this.stepOrder = order;
		this.status = status;
	}
	
	public void setStepDescription(String stepDescription) {
		this.stepDescription = stepDescription;
	}
	
	public String getStepDescription() {
		return stepDescription;
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
	
	public LocalDateTime getDateCompleted() {
		return dateCompleted;
	}
	
	public void setDueDate(LocalDateTime dueDate) { 
		this.dueDate = dueDate;
	}
	
	public LocalDateTime getDueDate() {
		return dueDate;
	}
	
	public void setIsAiGenerated(Boolean isAiGenerated) {
		this.isAiGenerated = isAiGenerated;
	}
	
	public Boolean getIsAiGenerated() {
		return isAiGenerated;
	}
	
	public void setStepOrder(int order) {
		this.stepOrder = order;
	}
	
	public int getStepOrder() {
		return stepOrder;
	}
	
	public void setStatus(StepStatus status) {
		this.status = status;
	}
	
	public StepStatus getStatus() {
		return status;
	}
	
	public void setGoal(Goal goal) {
		this.goal = goal;
	}
	
	@Override
	public String toString() {
		return "----------Step----------" + "\n" +
				"Step Id: " + stepId + "\n" +
				"Step Description: " + stepDescription + "\n" + 
				"Date Created: " + dateCreated + "\n" + 
				"Date Completed: " + dateCompleted + "\n" + 
				"Due Date: " + dueDate + "\n" +
				"Is Ai Generated? : " + isAiGenerated + "\n" + 
				"Step order: " + stepOrder + "\n" + 
				"Status: " + status + "\n" +
				"--------------------------";
	}
}
