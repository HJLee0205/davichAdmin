package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : AppMemberLoginReqDTO.java
 * - 작성일        : 2018. 11. 28.
 * - 작성자        : dong
 * - 설명          : 앱로그인 일시 다비전 기록 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class AppMemberLoginReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;

	/**
	 * ERP 회원코드
	 */
	@ExceptLog
	private String cdCust;


}
