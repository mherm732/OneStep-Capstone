package controllers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import model.Step;
import service.StepService;

@RestController 
@RequestMapping("api/goals/steps")
public class StepController {
	
	@Autowired 
	private StepService stepService;
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/create/{goalId}")
	public ResponseEntity<?> createStep(@RequestBody Step step, @PathVariable UUID goalId, Authentication authentication){
		try {
			String email = authentication.getName();
			Step newStep = stepService.createStep(email, goalId, step);
			stepService.updateStepCountForGoal(goalId);
			System.out.println("User is creating a step: " + authentication.getName());
			return ResponseEntity.ok(newStep);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(
					"Failed to create step: " + e.getMessage());
		}
	}
	
	@GetMapping("/goal/{goalId}")
	public ResponseEntity<List<Step>> getStepsByGoal(@PathVariable UUID goalId){
		return ResponseEntity.ok(stepService.getStepsByGoalId(goalId));
	}
	
	@GetMapping("/{goalId}/current")
	public ResponseEntity<Step> getCurrentStep(@PathVariable UUID goalId, Authentication authentication) {
		String email = authentication.getName();
	    Step current = stepService.getCurrentStepForGoal(goalId, email); 
	    return ResponseEntity.ok(current);
	}

	@GetMapping("/completed")
	public ResponseEntity<List<Step>> getCompletedSteps() {
		return ResponseEntity.ok(stepService.getCompletedStepsForUser());
	}
	
	@PutMapping("/update/{stepId}")
	public ResponseEntity<Step> updateStepById(@RequestBody Step step, @PathVariable UUID stepId) {
		Step updatedStep = stepService.updateStep(stepId, step);
		return ResponseEntity.ok(updatedStep);
	}
	
	@PutMapping("/update/mark-complete/{stepId}")
	public ResponseEntity<Step> markCompleteByStepId(@PathVariable UUID stepId){
		Step completedStep = stepService.markStepAsCompleted(stepId);
		return ResponseEntity.ok(completedStep);
	}
	
	@PutMapping("/skip/{stepId}")
	public ResponseEntity<Step> skipCurrentStep(@PathVariable UUID stepId){
		Step skippedStep = stepService.markStepAsSkipped(stepId);
		return ResponseEntity.ok(skippedStep);
	}
	
	@DeleteMapping("/delete/{stepId}")
	public ResponseEntity<String> deleteStepById(@PathVariable("stepId") UUID stepId){
		UUID goalId = stepService.getGoalIdByStepId(stepId);
		stepService.deleteStep(stepId);
		stepService.updateStepCountForGoal(goalId);
		return ResponseEntity.ok("Step deleted.");
	}
	
 }
