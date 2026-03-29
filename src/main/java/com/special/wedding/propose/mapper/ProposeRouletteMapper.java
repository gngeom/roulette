package com.special.wedding.propose.mapper;

import com.special.wedding.propose.dto.ProposeRouletteRow;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ProposeRouletteMapper {

	int countActiveUserByUid(@Param("uid") String uid);

	ProposeRouletteRow selectProposeByUid(@Param("uid") String uid);
}
