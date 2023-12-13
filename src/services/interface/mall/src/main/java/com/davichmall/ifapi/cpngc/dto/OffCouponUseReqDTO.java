package com.davichmall.ifapi.cpngc.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.dto
 * - 파일명        : OffCouponUseReqDTO.java
 * - 작성일        : 2018. 6. 26.
 * - 작성자        : CBK
 * - 설명          : 오프라인 쿠폰 사용/취소 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffCouponUseReqDTO extends BaseReqDTO {

	/**
	 * 쿠폰 번호
	 */
	private String cpnNo;
	
	// DB 처리용 변수
	/**
	 * 수정자
	 */
	private String updrNo;
	
	// 시스템 설정 변수
	/**
	 * 사용 플래그 (Y:사용, N:취소)
	 */
	private String useFlg;
}
