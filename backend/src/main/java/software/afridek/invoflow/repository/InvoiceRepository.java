package software.afridek.invoflow.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import software.afridek.invoflow.model.Client;
import software.afridek.invoflow.model.Invoice;
import software.afridek.invoflow.model.enums.InvoiceStatus;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    List<Invoice> findByClient(Client client);
    List<Invoice> findByStatus(InvoiceStatus status);
    List<Invoice> findByIssueDateBetween(LocalDate startDate, LocalDate endDate);
    boolean existsByInvoiceNumber(String invoiceNumber);
}
