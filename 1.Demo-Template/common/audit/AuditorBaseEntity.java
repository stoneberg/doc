package com.expense.tracker.play.common.audit;

import lombok.Getter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@Getter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class AuditorBaseEntity<U> {

	@CreatedBy
	@Column(name = "created_by")
	protected U createdBy;

	@LastModifiedBy
	@Column(name = "updated_by")
	protected U updatedBy;

	@CreatedDate
	@Column(updatable = false)
	protected LocalDateTime createdDate;

	@LastModifiedDate
	protected LocalDateTime updatedDate;

}
