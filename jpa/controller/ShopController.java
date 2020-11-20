package com.stone.store.play.shop.controller;

import com.stone.store.play.shop.payload.ShopReq;
import com.stone.store.play.shop.payload.ShopReq.AddCartDto;
import com.stone.store.play.shop.service.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/shop")
public class ShopController {

    private final ShopService shopService;

    /**
     * 판매 상품 리스트 정보 조회
     * @return
     */
    @GetMapping(path ="/products")
    public ResponseEntity<?> getAllProducts() {
        return ResponseEntity.ok(shopService.getAllProducts());
    }

    /**
     * 판매 상품 조회
     * @param productId
     * @return
     */
    @GetMapping(path = "/products/{productId}")
    public ResponseEntity<?> getProduct(@PathVariable Long productId) {
        return ResponseEntity.ok(shopService.getProduct(productId));
    }

    /**
     * 장바구니 조회
     * @return
     */
    @GetMapping(path ="/cart")
    public ResponseEntity<?> getCartProducts() {
        return ResponseEntity.ok(shopService.getCartProducts());
    }

    /**
     * 장바구니 추가
     * @param dto
     * @return
     */
    @PostMapping(path ="/cart")
    public ResponseEntity<?> addProductToCart(@RequestBody AddCartDto dto) {
        return ResponseEntity.ok(shopService.addProductToCart(dto));
    }

}