package software.afridek.invoflow.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import software.afridek.invoflow.model.Invoice;
import software.afridek.invoflow.model.Payment;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByInvoice(Invoice invoice);
}
