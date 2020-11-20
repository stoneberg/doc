package com.stone.store.play.shop.service;

import com.stone.store.play.shop.domain.Cart;
import com.stone.store.play.shop.domain.CartProduct;
import com.stone.store.play.shop.domain.Product;
import com.stone.store.play.shop.payload.ShopReq;
import com.stone.store.play.shop.payload.ShopReq.AddCartDto;
import com.stone.store.play.shop.payload.ShopRes;
import com.stone.store.play.shop.payload.ShopRes.ProductDto;
import com.stone.store.play.shop.repository.CartQuerydslRepository;
import com.stone.store.play.shop.repository.CartRepository;
import com.stone.store.play.shop.repository.ProductRepository;
import com.stone.store.play.user.domain.User;
import com.stone.store.play.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

import static com.stone.store.play.shop.payload.ShopRes.*;

@RequiredArgsConstructor
@Service
public class ShopService {

    private static final String username = "stoneberg";
    private final ProductRepository productRepository;
    private final CartRepository cartRepository;
    private final UserRepository userRepository;
    private final CartQuerydslRepository cartQuerydslRepository;


    public List<ProductDto> getAllProducts() {
        List<Product> products = productRepository.findAll();
        return products.stream().map(ProductDto::new).collect(Collectors.toList());
    }

    public ProductDto getProduct(Long productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Not Found Such Id Product: " + productId));
        return ProductDto.builder().entity(product).build();
    }

    // add Product to Cart
    public Long addProductToCart(AddCartDto dto) {
        Long productId = dto.getProductId();
        Integer quantity = dto.getQuantity();

        // find login user
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("User not exists | username: " + username));

        // find login user's cart(user has only one cart in this demo)
        Cart cart = cartRepository.findByUser(user).orElseGet(() -> Cart.builder().user(user).build());

        // find product to add into cart
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not exists | id: " + productId));

        // create cart_product
        CartProduct cartProduct = CartProduct.createCartProduct(product, product.getPrice(), quantity);

        // add products to cart
        cart.addCartProduct(cartProduct);

        // save cart
        cartRepository.save(cart);

        return cart.getId();
    }

    public List<CartDto> getCartProducts() {
        // find login user
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("User not exists | username: " + username));

        return  cartQuerydslRepository.findCartByUser(user);
    }

}
