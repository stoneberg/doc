package com.stone.store.play.shop.payload;

import lombok.Data;

public class ShopReq {

    @Data
    public static class AddCartDto {
        private Long productId;
        private Integer quantity;
    }
}
