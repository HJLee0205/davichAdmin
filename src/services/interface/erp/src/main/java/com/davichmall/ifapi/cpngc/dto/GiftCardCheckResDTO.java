package com.davichmall.ifapi.cpngc.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.dto
 * - 파일명        : GiftCardCheckResDTO.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 상품권 사용가능 여부 체크 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class GiftCardCheckResDTO extends BaseResDTO {

	/**
	 * 상품권 번호
	 */
	private String giftCardNo;
	
	/**
	 * 상품권 금액
	 */
	private Integer giftCardAmt;
	
	/**
	 * 사용여부
	 */
	private String useYn;
}
