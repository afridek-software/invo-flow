package software.afridek.invoflow.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import software.afridek.invoflow.model.Client;
import software.afridek.invoflow.model.User;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {
    Optional<Client> findByUser(User user);
    Optional<Client> findByCompanyName(String companyName);
}
