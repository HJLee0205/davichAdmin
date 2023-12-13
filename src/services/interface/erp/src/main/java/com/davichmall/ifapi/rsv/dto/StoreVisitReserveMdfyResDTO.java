package com.davichmall.ifapi.rsv.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : StoreVisitReserveMdfyResDTO.java
 * - 작성일        : 2018. 6. 26.
 * - 작성자        : CBK
 * - 설명          : 매장 방문 예약 정보 수정 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreVisitReserveMdfyResDTO extends BaseResDTO {

	/**
	 * 변경된 쇼핑몰 방문 예약 번호
	 */
	@ExceptLog
	private String mallRsvNo;
}
