package com.davichmall.ifapi.cpngc.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.dto
 * - 파일명        : GiftCardUseReqDTO.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 상품권 사용/취소 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class GiftCardUseReqDTO extends BaseReqDTO {

	/**
	 * 상품권 번호
	 */
	private String giftCardNo;
	
	// DB 처리를 위한 변수
	/**
	 * 순번
	 */
	private Integer seq;
	
	/**
	 * 사용/취소 가맹점 코드
	 */
	private String strCode;
	
	/**
	 * 사용여부
	 */
	private String useYn;
	
	/**
	 * 사용/취소 플래그
	 */
	private String useFlg;
}
