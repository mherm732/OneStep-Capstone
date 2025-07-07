package service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
		newStep.setStepOrder(step.getStepOrder());
	    newStep.setIsAiGenerated(step.getIsAiGenerated());
		newStep.setGoal(goal);
		
		
		return stepRepository.save(newStep);
	}

	public List<Step> getStepsByGoalId(UUID goalId) {
		return stepRepository.findByGoal_GoalId(goalId);
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

	
}
