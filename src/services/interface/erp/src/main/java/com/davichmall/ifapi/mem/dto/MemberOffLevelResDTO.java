package com.davichmall.ifapi.mem.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MemberOffLevelResDTO.java
 * - 작성일        : 2018. 6. 21.
 * - 작성자        : CBK
 * - 설명          : 다비젼 회원 등급을 쇼핑몰에 갱신 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MemberOffLevelResDTO extends BaseResDTO {

	/**
	 * 다비젼 회원 등급 리스트
	 */
	@ExceptLog(force=true)
	private List<MemberOffLevelDTO> offLevelList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.mem.dto
	 * - 파일명        : MemberOffLevelResDTO.java
	 * - 작성일        : 2018. 6. 21.
	 * - 작성자        : CBK
	 * - 설명          : 다비젼 회원 등급 DTO
	 * </pre>
	 */
	@Data
	public static class MemberOffLevelDTO {
		/**
		 * 다비젼 회원 코드
		 */
		private String cdCust;
		
		/**
		 * 다비젼 회원 등급
		 */
		private String lvl;
	}
}
