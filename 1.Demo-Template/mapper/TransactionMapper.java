package com.expense.tracker.play.trans.mapper;

import com.expense.tracker.play.config.MapStructMapperConfig;
import com.expense.tracker.play.trans.domain.Transaction;
import com.expense.tracker.play.trans.payload.TransactionRes.FindDto;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(config = MapStructMapperConfig.class)
public interface TransactionMapper {

    FindDto toFindDto(Transaction transaction);

    List<FindDto> toFindDtos(List<Transaction> transactions);

}
