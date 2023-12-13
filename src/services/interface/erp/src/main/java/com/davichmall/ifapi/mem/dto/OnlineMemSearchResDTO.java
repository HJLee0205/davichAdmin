package com.davichmall.ifapi.mem.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OnlineMemSearchResDTO.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 온라인 회원 조회시 사용하는 응답 DTO (오프라인->온라인 조회시)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnlineMemSearchResDTO extends BaseResDTO {

	/**
	 * 회원정보 목록
	 */
	 private List<OnlineMemInfo> memList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.mem.dto
	 * - 파일명        : OnlineMemSearchResDTO.java
	 * - 작성일        : 2018. 5. 24.
	 * - 작성자        : CBK
	 * - 설명          : 온라인 회원 조회시 사용되는 회원정보 DTO
	 * </pre>
	 */
	@Data
	public static class OnlineMemInfo {
		/**
		 * 쇼핑몰 회원번호
		 */
		private String memNo;
		
		/**
		 * 쇼핑몰 사용자 ID
		 */
		private String mallUserId;
		
		/**
		 * 쇼핑몰 사용자 이름
		 */
		private String memName;
		
		/**
		 * 쇼핑몰 사용자 휴대폰번호
		 */
		private String hp;
		
		/**
		 * 전화번호
		 */
		private String tel;
		
		/**
		 * 성별 [M/F]
		 */
		private String gender;
		
		/**
		 * 생년월일
		 */
		private String birthDay;
		
		/**
		 * 우편번호
		 */
		private String postNo;
		
		/**
		 * 주소(도로명주소)
		 */
		private String address1;
		
		/**
		 * 상세주소
		 */
		private String address2;
		
		/**
		 * 온라인 카드 번호
		 */
		private String onlineCardNo;
		
		/**
		 * 회원 통합 여부
		 */
		private String combineYn;
		
		/**
		 * 다비젼고객코드
		 */
		private String cdCust;
	}
}
