package com.stone.store.play.shop.repository;

import com.querydsl.core.types.Projections;
import com.stone.store.play.common.querydsl.Querydsl4RepositorySupport;
import com.stone.store.play.shop.domain.Cart;
import com.stone.store.play.shop.payload.ShopRes.CartDto;
import com.stone.store.play.user.domain.User;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.stone.store.play.shop.domain.QCart.cart;
import static com.stone.store.play.shop.domain.QCartProduct.cartProduct;

@Repository
public class CartQuerydslRepository extends Querydsl4RepositorySupport {

    public CartQuerydslRepository() {
        super(Cart.class);
    }

    public List<CartDto> findCartByUser(User user) {
        return select(Projections.fields(CartDto.class,
                    cartProduct.product.id.as("productId"),
                    cartProduct.product.title,
                    cartProduct.product.image,
                    cartProduct.product.description,
                    cartProduct.price,
                    cartProduct.quantity.sum().as("quantity")
                ))
                .from(cart)
                .leftJoin(cart.cartProducts, cartProduct)
                .where(cart.user.eq(user))
                .groupBy(
                    cartProduct.product.id,
                    cartProduct.product.title,
                    cartProduct.product.image,
                    cartProduct.product.description,
                    cartProduct.price
                )
                .fetch();
    }

}
