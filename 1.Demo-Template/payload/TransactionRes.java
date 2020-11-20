package com.expense.tracker.play.trans.payload;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class TransactionRes {

    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    @Data
    public static class FindDto {
        private Long id;
        private Double amount;
        private String note;
        private UserDto user;
    }

    @AllArgsConstructor
    @NoArgsConstructor
    @Data
    public static class UserDto {
        private String username;
        private String email;
    }

}
