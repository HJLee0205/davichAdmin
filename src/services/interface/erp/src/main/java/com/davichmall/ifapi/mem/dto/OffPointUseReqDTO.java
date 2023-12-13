package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OffPointUseReqDTO.java
 * - 작성일        : 2018. 7. 18.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 사용 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointUseReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 사용 오프라인 포인트 금액
	 */
	private Integer useOffPointAmt;
	
	/**
	 * 쇼핑몰 주문 번호
	 */
	private String orderNo;
	
	/**
	 * 쇼핑몰 주문 일자(포인트 사용일자) [YYYYMMDD]
	 */
	private String orderDate;
	
	// 변환용 변수
	/**
	 * ERP 회원코드
	 */
	@ExceptLog
	private String cdCust;
	
}
