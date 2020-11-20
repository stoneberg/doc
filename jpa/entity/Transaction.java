package com.expense.tracker.play.trans.domain;

import com.expense.tracker.play.common.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "et_transactions")
public class Transaction extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name="amount", columnDefinition="Decimal(10, 2) default '0.00'")
    private Double amount;

    @Column(length = 50, nullable = false)
    private String note;

    // utility method
    public void setCategory(Category category) {
        this.category = category;
        if (!category.getTransactions().contains(this)) {
            category.getTransactions().add(this);
        }
    }

}
