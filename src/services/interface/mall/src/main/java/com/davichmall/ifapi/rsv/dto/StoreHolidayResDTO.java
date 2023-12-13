package com.davichmall.ifapi.rsv.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : StoreHolidayResDTO.java
 * - 작성일        : 2018. 7. 27.
 * - 작성자        : CBK
 * - 설명          : 매장 휴일 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreHolidayResDTO extends BaseResDTO {

	/**
	 * 휴일 목록
	 */
	private List<String> holidayList;
}
