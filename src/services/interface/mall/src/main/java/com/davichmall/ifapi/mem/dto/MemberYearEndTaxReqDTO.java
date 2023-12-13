package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MemberYearEndTaxReqDTO.java
 * - 작성일        : 2018. 12. 10.
 * - 작성자        : khy
 * - 설명          : 연말정손 조회 DTO(쇼핑몰,다비젼 공용)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MemberYearEndTaxReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 다비젼 회원번호
	 */
	private String cdCust;
	
	
	/**
	 * 다비젼 매장코드
	 */
	private String strCode;
	
	
	/**
	 * 다비젼 년도
	 */
	private String yyyy;
	
	/**
	 * 주민번호
	 */
	private String resNo;
	
	/**
	 * 비콘아이디
	 */
	private String beaconId;
	
	// DB 저장을 위한 변수
	/**
	 * 수정자
	 */
	@ExceptLog(force=true)
	private String updrNo;
	
	/**
	 * 사이트번호
	 */
	@ExceptLog(force=true)
	private String siteNo;

}
