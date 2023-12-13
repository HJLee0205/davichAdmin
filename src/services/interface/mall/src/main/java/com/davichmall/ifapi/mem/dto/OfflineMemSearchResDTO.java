package com.davichmall.ifapi.mem.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OfflineMemSearchResDTO.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 오프라인 회원 조회시 사용하는 응답 DTO (온라인->오프라인 조회시)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineMemSearchResDTO extends BaseResDTO {

	/**
	 * 회원정보 목록
	 */
	private List<OfflineMemInfo> custList;
	 
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.mem.dto
	 * - 파일명        : OfflineMemSearchResDTO.java
	 * - 작성일        : 2018. 5. 24.
	 * - 작성자        : CBK
	 * - 설명          : 오프라인 회원 조회시 사용되는 회원정보 DTO
	 * </pre>
	 */
	@Data
	public static class OfflineMemInfo {
		/**
		 * 다비젼 회원코드
		 */
		private String cdCust;
		
		/**
		 * 다비젼 회원 이름
		 */
		private String nmCust;
		
		/**
		 * 다비젼 회원 등급
		 */
		private String lvl;
		
		/**
		 * 오프라인 카드번호
		 */
		private String offlineCardNo;
		
		/**
		 * 통합회원 여부
		 */
		private String combineYn;
		
		/**
		 * 최근 방문 매장 명
		 */
		private String recentStrName;
	}
}
