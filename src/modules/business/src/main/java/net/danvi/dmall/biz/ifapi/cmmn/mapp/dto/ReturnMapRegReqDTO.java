package net.danvi.dmall.biz.ifapi.cmmn.mapp.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn.mapp.dto
 * - 파일명        : ReturnMapRegReqDTO.java
 * - 작성일        : 2018. 8. 9.
 * - 작성자        : CBK
 * - 설명          : 반품 번호 매핑 정보 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReturnMapRegReqDTO extends BaseReqDTO {

	/**
	 * 반품 번호 매핑 목록
	 */
	private List<ReturnMapDTO> mapList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn.mapp.dto
	 * - 파일명        : ReturnMapRegReqDTO.java
	 * - 작성일        : 2018. 8. 9.
	 * - 작성자        : CBK
	 * - 설명          : 반품번호 매핑 DTP
	 * </pre>
	 */
	@Data
	public static class ReturnMapDTO {
		/**
		 * 쇼핑몰 반품 번호
		 */
		private String mallClaimNo;
		
		/**
		 * 쇼핑몰 주문번호
		 */
		private String mallOrderNo;
		
		/**
		 * 쇼핑몰 주문 상세 번호
		 */
		private String mallOrderDtlNo;
		
		/**
		 * ERP주문번호 - 발주일자
		 */
		private String erpOrdDate;
		
		/**
		 * ERP주문번호 - 가맹점코드
		 */
		private String erpStrCode;
		
		/**
		 * ERP주문번호 - 전표번호
		 */
		private String erpOrdSlip;
		
		/**
		 * ERP 주문상세번호
		 */
		private String erpOrderDtlNo;
		
		/**
		 * ERP 주문상세 추가옵션번호
		 */
		private String erpOrderAddNo;
		
	}
}
