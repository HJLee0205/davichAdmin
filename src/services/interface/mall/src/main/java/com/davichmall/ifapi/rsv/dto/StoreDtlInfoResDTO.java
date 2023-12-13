package com.davichmall.ifapi.rsv.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : StoreDtlInfoResDTO.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 가맹점 상세 정보 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreDtlInfoResDTO extends BaseResDTO {

	/**
	 * 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 가맹점이름
	 */
	private String strName;
	
	/**
	 * 내용
	 */
	private String cont;
	
	/**
	 * 매장수령/방문예약 가능여부
	 */
	private String recvAllowYn;
	
	/**
	 * 보청기 취급여부
	 */
	private String hearingAidYn;
	
	/**
	 * 매장주소
	 */
	private String addr1;
	
	/**
	 * 매장주소 상세
	 */
	private String addr2;

	/**
	 * 전화번호
	 */
	private String telNo;
	
	/**
	 * 제휴업체
	 */
	private String venName;
}
