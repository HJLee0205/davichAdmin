package com.davichmall.ifapi.dist.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : ReturnPopUrlReqDTO.java
 * - 작성일        : 2018. 8. 13.
 * - 작성자        : CBK
 * - 설명          : 반품 팝업 URL 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReturnPopUrlReqDTO extends BaseReqDTO {

	/**
	 * ERP 주문 키 - 주문일자
	 */
	private String ordDate;
	
	/**
	 * ERP 주문 키 - 가맹점코드
	 */
	private String strCode;
	
	/**
	 * ERP 주문 키 - 전표번호
	 */
	private String ordSlip;
	
	/**
	 * ERP 주문 키 - 주문상세번호
	 */
	private String ordSeq;
	
	/**
	 * ERP 주문 키 - 주문상세 추가구매번호
	 */
	private String ordAddNo;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 반품번호
	 */
	@ExceptLog
	private String mallClaimNo;
	
	/**
	 * 쇼핑몰 주문 번호
	 */
	@ExceptLog
	private String mallOrderNo;
	
	/**
	 * 쇼핑몰 주문 상세 번호
	 */
	@ExceptLog
	private String mallOrderDtlNo;
}
