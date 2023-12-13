package com.davichmall.ifapi.cpngc.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.dto
 * - 파일명        : GiftCardCheckReqDTO.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 상품권 사용가능 여부 체크 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class GiftCardCheckReqDTO extends BaseReqDTO {
	
	/**
	 * 상품권 번호
	 */
	private String giftCardNo;

}
