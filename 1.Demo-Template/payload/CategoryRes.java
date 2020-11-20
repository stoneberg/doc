package com.expense.tracker.play.trans.payload;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

public class CategoryRes {

    @AllArgsConstructor
    @NoArgsConstructor
    @Data
    public static class FindDto {
        private Long id;
        private String title;
        private String description;
        private Double totalExpense;
        private UserDto user;
        private List<TransactionDto> transactions = new ArrayList<>();
    }

    @AllArgsConstructor
    @NoArgsConstructor
    @Data
    public static class UserDto {
        private String username;
        private String email;
    }

    @AllArgsConstructor
    @NoArgsConstructor
    @Data
    public static class TransactionDto {
        private Long id;
        private Double amount;
        private String note;
        private UserDto user;
    }
}
