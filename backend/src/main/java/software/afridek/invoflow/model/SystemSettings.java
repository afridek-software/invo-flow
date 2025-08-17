package software.afridek.invoflow.model;

import java.time.ZonedDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import software.afridek.invoflow.model.enums.TaxMode;

@Entity
@Table(name = "system_settings")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SystemSettings {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "company_name", nullable = false)
    private String companyName;
    
    @Column(name = "default_currency", nullable = false, length = 3)
    private String defaultCurrency;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "tax_mode", nullable = false)
    private TaxMode taxMode;
    
    @Column(name = "invoice_prefix", nullable = false)
    private String invoicePrefix;
    
    @ManyToOne
    @JoinColumn(name = "last_updated_by", nullable = false)
    private Admin lastUpdatedBy;
    
    @Column(name = "updated_at")
    private ZonedDateTime updatedAt = ZonedDateTime.now();
}
