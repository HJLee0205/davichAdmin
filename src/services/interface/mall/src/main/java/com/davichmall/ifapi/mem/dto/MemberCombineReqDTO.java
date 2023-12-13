package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MemberCombineReqDTO.java
 * - 작성일        : 2018. 5. 25.
 * - 작성자        : CBK
 * - 설명          : 회원통합 요청 DTO(쇼핑몰,다비젼 공용)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MemberCombineReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 다비젼 회원번호
	 */
	private String cdCust;
	
	/**
	 * 온라인카드번호 (쇼핑몰에서 통합시)
	 */
	private String onlineCardNo;
	
	/**
	 * 다비젼 회원 등급
	 */
	private String lvl;
	
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
	
	/**
	 * 통합회원구분코드
	 */
	@ExceptLog(force=true)
	private String combineGbCd;
	

}
