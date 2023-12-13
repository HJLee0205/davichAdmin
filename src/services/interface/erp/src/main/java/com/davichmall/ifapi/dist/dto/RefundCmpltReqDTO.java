package com.davichmall.ifapi.dist.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : RefundCmpltReqDTO.java
 * - 작성일        : 2018. 9. 5.
 * - 작성자        : CBK
 * - 설명          : 환불 완료 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class RefundCmpltReqDTO extends BaseReqDTO {

	private String claimNo;
	private String orderNo;
	private String payDate;
	private Integer dlvrAmt;
	private List<RefundItemDTO> ordDtlList;
	
	// 변환용 변수
	private String ordDate;
	private String strCode;
	private String ordSlip;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : RefundCmpltReqDTO.java
	 * - 작성일        : 2018. 9. 5.
	 * - 작성자        : CBK
	 * - 설명          : 반품 주문 상세 정보
	 * </pre>
	 */
	@Data
	public static class RefundItemDTO {
		private String orderDtlSeq;
		
		// 변환용 변수
		private String ordSeq;
		private String ordAddNo;
	}
}
