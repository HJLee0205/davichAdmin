package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MallEyesightInfoReqDTO.java
 * - 작성일        : 2018. 7. 3.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 시력정보 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MallEyesightInfoReqDTO extends BaseReqDTO {

	/**
	 * 다비젼 회원 코드
	 */
	private String cdCust;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 회원 번호
	 */
	@ExceptLog
	private String memNo;
}
