package com.expense.tracker.play.trans.payload;

import com.expense.tracker.play.trans.domain.Transaction;
import lombok.Data;

public class TransactionReq {

    @Data
    public static class CreateDto {
        private Double amount;
        private String note;

        public Transaction toEntity() {
            return Transaction.builder()
                    .amount(amount)
                    .note(note)
                    .build();
        }

    }

    @Data
    public static class UpdateDto {
        private Double amount;
        private String note;
    }


}
