package service;

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
import repository.GoalRepository;
import repository.StepRepository;

@Service 
public class StepService {
	
	@Autowired 
	private StepRepository stepRepository;
	
	@Autowired
	private GoalRepository goalRepository;
	
	public Step createStep(UUID goalId, Step step) {
		 Goal goal = goalRepository.findById(goalId).orElseThrow(() -> 
	        new RuntimeException("Goal not found"));
	    
		System.out.println("Creating new step...Processing...");
		
		Optional<Step> existingStep = stepRepository.findByStepDescription(step.getStepDescription());
		
		if(existingStep.isPresent()) {
			throw new RuntimeException("Step already exists.");
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
		newStep.setGoal(goal);
		
		
		return stepRepository.save(newStep);
	}

	public List<Step> getStepsByGoalId(UUID goalId) {
		return stepRepository.findByGoal_GoalId(goalId);
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

	    steps.sort(Comparator.comparingInt(Step::getStepOrder));

	    for (Step step : steps) {
	        if (step.getStatus() != StepStatus.COMPLETED) {
	            return step;
	        }
	    }

	    return steps.get(steps.size() - 1);
	}

	
	public Step updateStep(UUID stepId, Step step) {
		Step updatedStep = stepRepository.findById(stepId).orElseThrow(() -> 
			new RuntimeException("Step not found."));
		
		updatedStep.setStepDescription(step.getStepDescription());
		updatedStep.setDueDate(step.getDueDate());
		updatedStep.setStepOrder(step.getStepOrder());
		 
		return stepRepository.save(updatedStep);
	}
	

	public Step markStepAsCompleted(UUID stepId, Step step) {
		Step completedStep = stepRepository.findById(stepId).orElseThrow(() -> 
				new RuntimeException("Step not found."));
		completedStep.setStatus(StepStatus.COMPLETED);
		return stepRepository.save(completedStep);
		
	}

	public void deleteStep(UUID stepId) {
		stepRepository.deleteById(stepId);
	}
	
	public void deleteAllStepsByGoalId(UUID goalId) {
	    List<Step> steps = stepRepository.findByGoal_GoalId(goalId);
	    stepRepository.deleteAll(steps);
	}

	public Step markStepAsSkipped(UUID stepId, Step step) {
		Step skippedStep = stepRepository.findById(stepId).orElseThrow(() -> 
				new RuntimeException("Step not found"));
		skippedStep.setStatus(StepStatus.SKIPPED);
		return stepRepository.save(skippedStep);
	}

	
}
