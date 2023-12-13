package com.davichmall.ifapi.mem.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchResDTO.OfflineMemInfo;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MemberYearEndTaxResDTO.java
 * - 작성일        : 2018. 12. 10.
 * - 작성자        : khy
 * - 설명          : 회원통합 응답 DTO(쇼핑몰,다비젼 공용)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MemberYearEndTaxResDTO extends BaseResDTO {
	

	/**
	 * 연말정산 내역
	 */
	private List<YearEndTaxInfo> yearEndTaxList;
	 
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.mem.dto
	 * - 파일명        : OfflineMemSearchResDTO.java
	 * - 작성일        : 2018. 12. 10.
	 * - 작성자        : khy
	 * - 설명          : 쇼핑몰 고객 연말정산 목록 DTO
	 * </pre>
	 */
	@Data
	public static class YearEndTaxInfo {
		/**
		 * 다비젼 회원코드
		 */
		private String cdCust;
		
		/**
		 * 다비젼 회원 이름
		 */
		private String nmCust;
		
		/**
		 * 다비젼 매장코드
		 */
		private String strCode;
		
		
		/**
		 * 다비젼 매장명
		 */
		private String strName;
		
		/**
		 * 구매년도
		 */
		private String dates;
		
		/**
		 * ERP 사업자등록번호
		 */
		private String busiNo;

		/**
		 * ERP 상호
		 */
		private String strLname;
		
		/**
		 * ERP 대표자
		 */
		private String ownName;
		
		/**
		 * ERP 업태
		 */
		private String nmBtype;
		
		/**
		 * ERP 종목
		 */
		private String nmBitem;
		
		/**
		 * ERP 전화번호
		 */
		private String telNo;

		/**
		 * ERP 소재지
		 */
		private String addr;
				
		/**
		 * ERP 현금
		 */
		private Long cashAmt;
		
		/**
		 * ERP 카드
		 */
		private Long cardAmt;

		/**
		 * ERP 합계
		 */
		private Long total;
		
	}
	

	

}
