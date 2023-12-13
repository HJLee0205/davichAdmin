package com.davichmall.ifapi.cpngc.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.dto
 * - 파일명        : OffCouponSearchReqDTO.java
 * - 작성일        : 2018. 6. 26.
 * - 작성자        : CBK
 * - 설명          : 오프라인 쿠폰 목록 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffCouponSearchReqDTO extends BaseReqDTO {

	/**
	 * 온라인 카드 번호
	 */
	private String onlineCardNo;
}
