package com.davichmall.ifapi.dist.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : OrderCancelReqDTO.java
 * - 작성일        : 2018. 6. 4.
 * - 작성자        : CBK
 * - 설명          : 주문/반품 취소 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OrderCancelReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 주문번호
	 */
	@ExceptLog
	private String orderNo;
	
	/**
	 * 쇼핑몰 반품 번호
	 */
	@ExceptLog
	private String claimNo;
	
	// 변환용 변수
	/**
	 * 다비젼 발주 KEY - 발주일자
	 */
	@ExceptLog
	private String ordDate;
	
	/**
	 * 다비젼 발주 KEY - 가맹점코드
	 */
	@ExceptLog
	private String strCode;
	
	/**
	 * 다비젼 발주 KEY - 전표번호
	 */
	@ExceptLog
	private String ordSlip;
}
