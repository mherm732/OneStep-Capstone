package repository;

import model.User;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
	Optional<User> findByUserName(String userName);
	Boolean existsByUsername(String userName);
	Boolean existsByEmail(String email);
}
