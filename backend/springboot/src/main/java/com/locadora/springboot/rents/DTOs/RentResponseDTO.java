package com.locadora.springboot.rents.DTOs;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.locadora.springboot.books.models.BookModel;
import com.locadora.springboot.renters.models.RenterModel;
import com.locadora.springboot.rents.models.RentStatusEnum;
import lombok.Builder;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDate;

@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public record RentResponseDTO(
        int id,
        RenterModel renter,
        BookModel book,
        @JsonFormat(pattern = "yyyy-MM-dd") LocalDate deadLine,
        @JsonFormat(pattern = "yyyy-MM-dd") LocalDate devolutionDate,
        @JsonFormat(pattern = "yyyy-MM-dd") LocalDate rentDate,
        RentStatusEnum status
) {
}
