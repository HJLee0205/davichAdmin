package com.davichmall.ifapi.visit.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit.dto
 * - 파일명        : VisitInfoRegReqDTO.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 매장 방문 정보 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class VisitInfoRegReqDTO extends BaseReqDTO {

	/**
	 * 고객방문일자 (YYYYMMDD)
	 */
	private String dates;
	
	/**
	 * 방문 매장 코드
	 */
	private String strCode;
	
	/**
	 * 방문 시각(HH24MISS)
	 */
	private String visitTime;
	
	/**
	 * 고객이름
	 */
	private String custName;
	
	/**
	 * 고객 휴대폰
	 */
	private String hp;
	
	/**
	 * 고객 연령
	 */
	private Integer age;
	
	/**
	 * 방문 목적
	 */
	private String purpose;
	
	/**
	 * 예약 여부 [Y/N]
	 */
	private String bookYn;
	
	/**
	 * 예약 시각 (HH24MISS)
	 */
	private String bookTime;
}
