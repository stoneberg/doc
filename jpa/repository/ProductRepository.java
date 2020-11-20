package com.stone.store.play.shop.repository;

import com.stone.store.play.shop.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
}
