package com.stone.store.play.shop.domain;

import com.stone.store.play.common.entity.BaseEntity;
import com.stone.store.play.user.domain.User;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;


@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "store_cart")
public class Cart extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL)
    private List<CartProduct> cartProducts = new ArrayList<>();

    @Builder
    public Cart(User user) {
        this.user = user;
    }

    // create Cart
//    public static Cart createCart(CartProduct... cartProducts) {
//        Cart cart = new Cart();
//        for (CartProduct cartProduct : cartProducts) {
//            cart.addCartProduct(cartProduct);
//        }
//        return cart;
//    }

    // utility method
    public void addCartProduct(CartProduct cartProduct) {
        this.cartProducts.add(cartProduct);
        if (cartProduct.getCart() != this) {
            cartProduct.setCart(this);
        }
    }

}
