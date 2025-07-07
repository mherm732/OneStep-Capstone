package service;

import model.Goal;
import model.Status;
import model.User;
import repository.GoalRepository;
import repository.UserRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GoalService {
	
	@Autowired
	private GoalRepository goalRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	public Goal createGoal(UUID userId, Goal goal) {
		
		User user = userRepository.findById(userId).orElseThrow(() -> 
	       new RuntimeException("User not found"));
		
		System.out.println("Creating new goal...Processing...");
		
		Optional<Goal> existingGoal = goalRepository.findByTitle(goal.getTitle());
		if (existingGoal.isPresent()) {
			throw new RuntimeException("Goal already exists.");
		}
		
		
		Goal newGoal = new Goal();
		
		newGoal.setTitle(goal.getTitle());
		newGoal.setGoalDescription(goal.getGoalDescription());
		newGoal.setUser(user);
		
		
		return goalRepository.save(newGoal);
		
	}
	
	public List<Goal> getGoalsByUserId(UUID userId){
		return goalRepository.findByUser_UserId(userId);
	}
	
	public Goal updateGoal(UUID goalID, Goal goal) {

		Goal updatedGoal = goalRepository.findById(goalID).orElseThrow(() -> 
			new RuntimeException("Goal not found."));
	
		
		updatedGoal.setTitle(goal.getTitle());
		updatedGoal.setGoalDescription(goal.getGoalDescription());
		
		return goalRepository.save(updatedGoal);
	}
	
	
	public Goal markGoalAsCompleted(UUID goalID, Goal goal) {
		Goal completedGoal = goalRepository.findById(goalID).orElseThrow(() -> new RuntimeException("Goal not found."));
		completedGoal.setGoalStatus(Status.COMPLETED);
		return goalRepository.save(completedGoal);
	}
	
	public void deleteGoal(UUID goalID) {
		goalRepository.deleteById(goalID);
		
	}
}


