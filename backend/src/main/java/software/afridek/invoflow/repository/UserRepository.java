package software.afridek.invoflow.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import software.afridek.invoflow.model.User;
import software.afridek.invoflow.model.enums.UserType;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    List<User> findByActiveTrue();

    boolean existsByEmail(String email);

    List<User> findByUserType(UserType userType);

}
