package com.stone.store.play.shop.domain;

import com.stone.store.play.common.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "store_products")
public class Product extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100, nullable = false)
    private String title;

    @Column(length = 500, nullable = false)
    private String description;

    @Column(length = 500, nullable = false)
    private String image;

    @Column(columnDefinition = "Decimal(10,1) default '0.0'")
    private Float price;

}
