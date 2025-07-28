package service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import model.Goal;
import model.Step;
import model.StepStatus;
import model.User;
import service.GoalService;
import repository.GoalRepository;
import repository.StepRepository;
import repository.UserRepository;

@Service 
public class StepService {
	
	@Autowired 
	private StepRepository stepRepository;
	
	@Autowired
	private GoalRepository goalRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	public Step createStep(String email, UUID goalId, Step step) {
		User user = userRepository.findByEmail(email).orElseThrow(() -> 
				 new RuntimeException("User not found"));
		 
		Goal goal = goalRepository.findById(goalId).orElseThrow(() -> 
	        new RuntimeException("Goal not found"));
	    
		System.out.println("Creating new step for user goal...Processing...");
		
		Optional<Step> existingStep = stepRepository.findByStepDescription(step.getStepDescription());
		
		if(existingStep.isPresent()) {
			throw new RuntimeException("Step already exists for goal.");
		}
		
		Step newStep = new Step();
		newStep.setStepDescription(step.getStepDescription());
		
		if(getStepsByGoalId(goalId).isEmpty()) {
			newStep.setStepOrder(step.getStepOrder());
		} else {
			List<Step> steps = getStepsByGoalId(goalId);
			newStep.setStepOrder(steps.size());
		}
		
		newStep.setIsAiGenerated(step.getIsAiGenerated());
		newStep.setDueDate(step.getDueDate());
		newStep.setGoal(goal);
		
		return stepRepository.save(newStep);
	}

	public List<Step> getStepsByGoalId(UUID goalId) {
		return stepRepository.findByGoal_GoalId(goalId);
	}
	
	public UUID getGoalIdByStepId(UUID stepId) {
	    Step step = stepRepository.findById(stepId)
	        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Step not found"));
	    return step.getGoal().getGoalId();
	}

	public Step getCurrentStepForGoal(UUID goalId, String userEmail) {
	    Goal goal = goalRepository.findById(goalId)
	        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Goal not found"));

	    if (!goal.getUser().getEmail().equals(userEmail)) {
	        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied to this goal");
	    }

	    List<Step> steps = getStepsByGoalId(goalId);

	    if (steps.isEmpty()) {
	        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No steps found for this goal");
	    }

	    for (Step step : steps) {
	        if (step.getStatus() == StepStatus.IN_PROGRESS || step.getStatus() == StepStatus.PENDING) {
	            return step;
	        }
	     
	    }
	    throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No active steps found for this goal");
	}

	public Step updateStep(UUID stepId, Step step) {
		Step updatedStep = stepRepository.findById(stepId).orElseThrow(() -> 
			new RuntimeException("Step not found."));
		
		updatedStep.setStepDescription(step.getStepDescription());
		updatedStep.setDueDate(step.getDueDate());
		updatedStep.setStepOrder(step.getStepOrder());
		 
		return stepRepository.save(updatedStep);
	}
	
	public void updateStepCountForGoal(UUID goalId) {
	    List<Step> steps = stepRepository.findByGoal_GoalId(goalId);
	    
	    Goal goal = goalRepository.findById(goalId)
	        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Goal not found"));

	    goal.setTotalSteps(steps.size());

	    goalRepository.save(goal);
	}

	public Step markStepAsCompleted(UUID stepId) {
		Step completedStep = stepRepository.findById(stepId).orElseThrow(() -> 
				new RuntimeException("Step not found."));
		completedStep.setStatus(StepStatus.COMPLETED);
		completedStep.setDateCompleted(LocalDateTime.now());
		
		return stepRepository.save(completedStep);
	}

	public Step markStepAsSkipped(UUID stepId) {
		Step skippedStep = stepRepository.findById(stepId).orElseThrow(() -> 
				new RuntimeException("Step not found"));
		skippedStep.setStatus(StepStatus.SKIPPED);
		skippedStep.setDateCompleted(LocalDateTime.now());
		return stepRepository.save(skippedStep);
	}

	
	public void deleteStep(UUID stepId) {
		stepRepository.deleteById(stepId);
	}
	
	public void deleteAllStepsByGoalId(UUID goalId) {
	    List<Step> steps = stepRepository.findByGoal_GoalId(goalId);
	    stepRepository.deleteAll(steps);
	}
	
	public int getNextStepOrder(Goal goal) {
		return goal.getTotalSteps() + 1;
	}

	public List<Step> getCompletedStepsForUser() {
		return stepRepository.findByStatus(StepStatus.COMPLETED);
	}
}
