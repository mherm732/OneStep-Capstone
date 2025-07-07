package controllers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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
@RequestMapping("/steps")
public class StepController {
	
	@Autowired 
	private StepService stepService;
	
	@PostMapping("/create/{goalId}")
	public ResponseEntity<Step> createStep(@RequestBody Step step, @PathVariable UUID goalId){
		Step newStep = stepService.createStep(goalId, step);
		return ResponseEntity.ok(newStep);
	}
	
	@GetMapping("/{goalId}")
	public ResponseEntity<List<Step>> getStepsByGoal(@PathVariable UUID goalId){
		return ResponseEntity.ok(stepService.getStepsByGoalId(goalId));
	}
	
	@PutMapping("/update/{stepId}")
	public ResponseEntity<Step> updateStepById(@RequestBody Step step, @PathVariable UUID stepId) {
		Step updatedStep = stepService.updateStep(stepId, step);
		return ResponseEntity.ok(updatedStep);
	}
	
	@PutMapping("/update/mark-complete/{stepId}")
	public ResponseEntity<Step> markCompleteByStepId(@RequestBody Step step, @PathVariable UUID stepId){
		Step completedStep = stepService.markStepAsCompleted(stepId, step);
		return ResponseEntity.ok(completedStep);
	}
	
	@DeleteMapping("/delete/{stepId}")
	public ResponseEntity<String> deleteStepById(@PathVariable("stepId") UUID stepId){
		stepService.deleteStep(stepId);
		return ResponseEntity.ok("Step deleted.");
	}
	
 }
