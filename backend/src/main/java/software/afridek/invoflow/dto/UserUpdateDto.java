package software.afridek.invoflow.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.constraints.Email;
import lombok.Data;

@Data
public class UserUpdateDto {

    @Email(message = "Valid email is required")
    private String email;

    @JsonProperty("first_name")
    private String firstName;

    @JsonProperty("last_name")
    private String lastName;

    @JsonProperty("is_active")
    private Boolean isActive;

    private String role;
}