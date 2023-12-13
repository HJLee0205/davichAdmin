package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : StoreVCResultReqDTO.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 매장 비젼체크 결과 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreVCResultReqDTO extends BaseReqDTO {
	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	// 변환용 변수
	/**
	 * 다비젼 회원번호
	 */
	@ExceptLog
	private String cdCust;
}
