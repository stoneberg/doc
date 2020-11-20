package com.expense.tracker.play.trans.domain;

import com.expense.tracker.play.common.audit.AuditorBaseEntity;
import com.expense.tracker.play.trans.payload.CategoryReq.CreateDto;
import com.expense.tracker.play.trans.payload.CategoryReq.UpdateDto;
import com.expense.tracker.play.user.domain.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "et_categories")
public class Category extends AuditorBaseEntity<String> {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "category", cascade = CascadeType.ALL)
    private List<Transaction> transactions = new ArrayList<>();

    @Column(length = 20, nullable = false)
    private String title;

    @Column(length = 50, nullable = false)
    private String description;

    @Column(columnDefinition="Decimal(10, 2) default '0.00'")
    private Double totalExpense = 0.00;

    @Builder
    public Category(User user, String title, String description) {
        this.user = user;
        this.title = title;
        this.description = description;
    }

    // utility method
    public void addTransaction(Transaction transaction) {
        this.transactions.add(transaction);
        if (transaction.getCategory() != this) {
            transaction.setCategory(this);
        }
    }
    // create category
    public static Category createCategory(User user, CreateDto dto) {
        return Category.builder()
                .user(user)
                .title(dto.getTitle())
                .description(dto.getDescription())
                .build();
    }

    // update category
    public void updateCategory(UpdateDto dto) {
        this.title = dto.getTitle();
        this.description = dto.getDescription();
    }

    // update totalExpense
    public void updateTotalExpense(Double totalExpense) {
        this.totalExpense = totalExpense;
    }

}
