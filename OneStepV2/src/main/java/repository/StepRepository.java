package repository;

import model.Goal;
import model.Step;
import model.StepStatus;

import org.springframework.data.jpa.repository.JpaRepository;


import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface StepRepository extends JpaRepository<Step, UUID> {
    List<Step> findByGoal_GoalId(UUID goalId);
    Optional<Step> findByStepDescription(String stepDescription);
	List<Step> findByStatus(StepStatus status);
}