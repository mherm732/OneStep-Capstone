package repository;

import model.Goal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GoalRepository extends JpaRepository<Goal, UUID> {
	
	Optional<Goal> findById(UUID goalId);
	Optional<Goal> findByTitle(String title);
	List<Goal> findByUser_UserId(UUID userId);

}


