package com.expense.tracker.play.trans.domain;

import com.expense.tracker.play.common.audit.AuditorBaseEntity;
import com.expense.tracker.play.trans.payload.TransactionReq;
import com.expense.tracker.play.trans.payload.TransactionReq.CreateDto;
import com.expense.tracker.play.user.domain.User;
import lombok.*;

import javax.persistence.*;

@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "et_transactions")
public class Transaction extends AuditorBaseEntity<String> {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "amount", columnDefinition = "Decimal(10, 2) default '0.00'")
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

    // create transaction
    public static Transaction createTransaction(User user, Category category, CreateDto dto) {
        Transaction transaction = Transaction.builder()
                .user(user)
                .amount(dto.getAmount())
                .note(dto.getNote())
                .build();

        category.addTransaction(transaction);
        return transaction;
    }

    // update transaction
    public void updateTransaction(TransactionReq.UpdateDto dto) {
        this.amount = dto.getAmount();
        this.note = dto.getNote();
    }

}
