package com.davichmall.ifapi.rsv.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : StoreVisitReserveMdfyReqDTO.java
 * - 작성일        : 2018. 6. 26.
 * - 작성자        : CBK
 * - 설명          : 매장 방문 예약 정보 수정 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreVisitReserveMdfyReqDTO extends BaseReqDTO {

	/**
	 * 수정할 쇼핑몰 방문 번호 (원 데이터)
	 */
	private String mallRsvNo;
	
	/**
	 * 변경 날짜 (YYYYMMDD) - 매장에서 변경시
	 */
	@ExceptLog
	private String rsvDate;
	
	/**
	 * 변경 시간 (HHMI) - 매장에서 변경시
	 */
	@ExceptLog
	private String rsvTime;
	
	/**
	 * 방문목적 - 쇼핑몰에서 변경시
	 */
	@ExceptLog
	private String purpose;
	
	// DB 저장용 변수
	/**
	 * 쇼핑몰 방문번호
	 */
	@ExceptLog(force=true)
	private String rsvNo;
	
	/**
	 * 등록자
	 */
	@ExceptLog(force=true)
	private String regrNo;
}
