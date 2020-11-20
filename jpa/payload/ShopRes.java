package com.stone.store.play.shop.payload;

import com.stone.store.play.shop.domain.Product;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class ShopRes {

    @Data
    public static class ProductDto {
        private Long id;
        private String title;
        private String description;
        private String image;
        private Float price;

        @Builder
        public ProductDto(Product entity) {
            this.id = entity.getId();
            this.title = entity.getTitle();
            this.description = entity.getDescription();
            this.image = entity.getImage();
            this.price = entity.getPrice();
        }

    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CartDto {
        private String title;
        private String description;
        private String image;
        private Float price;
        private Integer quantity;
    }

}
