package com.expense.tracker.play.trans.mapper;

import com.expense.tracker.play.config.MapStructMapperConfig;
import com.expense.tracker.play.trans.domain.Category;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

import static com.expense.tracker.play.trans.payload.CategoryRes.FindDto;

@Mapper(config = MapStructMapperConfig.class)
public interface CategoryMapper {

    // 한군데서만 ignore 선안해주면 된다. 즉 아래 메서드에서는 추가 선언을 안해도 자동으로 적용된다.
    // @Mapping(target = "transactions", ignore = true)
    FindDto toFindDto(Category category);

    // 여기에서도 위와 같이 ignore 선언을 하면 에러가 발생한다.
    List<FindDto> toFindDtos(List<Category> categories);
}
