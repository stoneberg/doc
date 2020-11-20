package com.stone.store.play.shop.repository;

import com.stone.store.play.shop.domain.Cart;
import com.stone.store.play.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CartRepository extends JpaRepository<Cart, Long> {
    Optional<Cart> findByUser(User user);
}
