package software.afridek.invoflow.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import software.afridek.invoflow.model.Admin;
import software.afridek.invoflow.model.User;
import software.afridek.invoflow.model.enums.AdminLevel;

@Repository
public interface AdminRepository extends JpaRepository<Admin, Long> {
    Optional<Admin> findByUser(User user);
    List<Admin> findByAdminLevel(AdminLevel adminLevel);
}
