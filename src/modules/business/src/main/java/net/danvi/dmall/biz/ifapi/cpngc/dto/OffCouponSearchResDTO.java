package net.danvi.dmall.biz.ifapi.cpngc.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cpngc.dto
 * - 파일명        : OffCouponSearchReqDTO.java
 * - 작성일        : 2018. 6. 26.
 * - 작성자        : CBK
 * - 설명          : 오프라인 쿠폰 목록 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffCouponSearchResDTO extends BaseResDTO {

	/**
	 * 쿠폰 목록
	 */
	private List<OffCouponDTO> cpnList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.cpngc.dto
	 * - 파일명        : OffCouponSearchResDTO.java
	 * - 작성일        : 2018. 6. 26.
	 * - 작성자        : CBK
	 * - 설명          : 오프라인 쿠폰 정보 DTO
	 * </pre>
	 */
	@Data
	public static class OffCouponDTO {

		/**
		 * 회원 쿠폰 번호
		 */
		private String memberCpNo;

		/**
		 * 쿠폰 원본 번호
		 */
		private String cpnOrgNo;

		/**
		 * 쿠폰명
		 */
		private String cpnNm;

		/**
		 * 쿠폰설명
		 */
		private String cpnDscrt;

		/**
		 * 최소사용금액
		 */
		private String cpnUseLimitAmt;

		/**
		 * 쿠폰 발급 번호
		 */
		private String cpnNo;
		
		/**
		 * 쿠폰 금액
		 */
		private Integer cpnAmt;
		
		/**
		 * 쿠폰 만료일
		 */
		private String cpnEndDate;

		/**
		 * 혜택 코드 01(율),02(금액)
		 */
		private String couponBnfCd;

		/**
		 * 혜택 명
		 */
		private String couponBnfNm;

		/**
		 * 혜택 값
		 */
		private String couponBnfValue;


	}
}
