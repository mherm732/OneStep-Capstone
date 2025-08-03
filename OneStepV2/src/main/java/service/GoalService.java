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
		
		Optional<Goal> existingGoal = goalRepository.findByTitleAndUser_UserId(goal.getTitle(), user.getUserId());
		if (existingGoal.isPresent()) {
			throw new RuntimeException("Goal already exists.");
		}
		
		Goal newGoal = new Goal();
		
		newGoal.setTitle(goal.getTitle());
		newGoal.setGoalDescription(goal.getGoalDescription());
		newGoal.setUser(user);
		
		return goalRepository.save(newGoal);
		
	}
	
	public Optional<Goal> getGoalByGoalId(UUID goalId) {
		return goalRepository.findById(goalId);
	}
	
	public List<Goal> getGoalsByUserId(UUID userId){
		return goalRepository.findByUser_UserId(userId);
	}
	
	public List<Goal> getGoalsByEmail(String email) {
	    User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
	    return goalRepository.findByUser(user);
	}

	
	public Goal updateGoal(UUID goalID, Goal goal) {

		Goal updatedGoal = goalRepository.findById(goalID).orElseThrow(() -> 
			new RuntimeException("Goal not found."));
	
		
		updatedGoal.setTitle(goal.getTitle());
		updatedGoal.setGoalDescription(goal.getGoalDescription());
		
		return goalRepository.save(updatedGoal);
	}
	
	
	public Goal markGoalAsCompleted(UUID goalID) {
		Goal completedGoal = goalRepository.findById(goalID).orElseThrow(() -> new RuntimeException("Goal not found."));
		completedGoal.setGoalStatus(Status.COMPLETED);
		return goalRepository.save(completedGoal);
	}
	
	public void deleteGoal(UUID goalID) {
		goalRepository.deleteById(goalID);
		
	}

	public Goal createGoalForEmail(String email, Goal goal) {
		User user = userRepository.findByEmail(email).orElseThrow(() -> 
	       new RuntimeException("User not found"));
		
		System.out.println("Creating new goal...Processing...");
		
		Optional<Goal> existingGoal = goalRepository.findByTitleAndUser_UserId(goal.getTitle(), user.getUserId());
		if (existingGoal.isPresent()) {
			throw new RuntimeException("Goal already exists.");
		}
		
		Goal newGoal = new Goal();
		
		System.out.println("Making goal with title: " + goal.getTitle());
		newGoal.setTitle(goal.getTitle());
		System.out.println("Making goal with description " + goal.getGoalDescription());
		newGoal.setGoalDescription(goal.getGoalDescription());
		
		newGoal.setUser(user);
		
		System.out.println("New goal created: ");
		
		return goalRepository.save(newGoal);
	}

	public List<Goal> getCompletedGoalsForUser() {
		return goalRepository.findByGoalStatus(Status.COMPLETED);
	}

	public List<Goal> getInProgressGoalsForUser() {
		return goalRepository.findByGoalStatus(Status.IN_PROGRESS);
	}
}


