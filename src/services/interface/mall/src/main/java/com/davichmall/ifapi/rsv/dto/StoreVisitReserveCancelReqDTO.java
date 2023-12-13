package com.davichmall.ifapi.rsv.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : StoreVisitReserveCancelReqDTO.java
 * - 작성일        : 2018. 6. 22.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 방문예약 취소 요청 DTO (쇼핑몰/다비젼 겸용)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreVisitReserveCancelReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 방문 예약 번호
	 */
	private String mallRsvNo;
	
	// DB 처리용 변수
	/**
	 * 수정자번호
	 */
	@ExceptLog(force=true)
	private String updrNo;
}
