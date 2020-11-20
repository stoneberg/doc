package com.expense.tracker.play.trans.payload;

import com.expense.tracker.play.trans.domain.Category;
import lombok.Data;

public class CategoryReq {

    @Data
    public static class CreateDto {
        private String title;
        private String description;

        public Category toEntity() {
            return Category.builder()
                    .title(title)
                    .description(description)
                    .build();
        }

    }

    @Data
    public static class UpdateDto {
        private String title;
        private String description;
    }
}
