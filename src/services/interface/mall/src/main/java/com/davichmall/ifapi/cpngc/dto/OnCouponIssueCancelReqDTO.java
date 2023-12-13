package com.davichmall.ifapi.cpngc.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.dto
 * - 파일명        : OnCouponIssueCancelReqDTO.java
 * - 작성일        : 2018. 7. 11.
 * - 작성자        : CBK
 * - 설명          : 온라인 쿠폰 발급 취소 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnCouponIssueCancelReqDTO extends BaseReqDTO {

	/**
	 * 다비젼 회원 코드
	 */
	private String cdCust;
	
	/**
	 * 쇼핑몰 쿠폰 번호
	 */
	private String cpnNo;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 회원 번호
	 */
	@ExceptLog
	private String memNo;
}
