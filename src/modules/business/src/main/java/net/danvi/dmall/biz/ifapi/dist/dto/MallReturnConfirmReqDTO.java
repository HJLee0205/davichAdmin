package net.danvi.dmall.biz.ifapi.dist.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.dist.dto
 * - 파일명        : ReturnConfirmReqDTO.java
 * - 작성일        : 2018. 6. 11.
 * - 작성자        : CBK
 * - 설명          : 반품확정 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MallReturnConfirmReqDTO extends BaseReqDTO {

	/**
	 * 반품 요청 리스트
	 */
	private List<ClaimInfoDTO> claimList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.dist.dto
	 * - 파일명        : MallReturnConfirmReqDTO.java
	 * - 작성일        : 2018. 8. 10.
	 * - 작성자        : CBK
	 * - 설명          : 반품 정보 DTO
	 * </pre>
	 */
	@Data
	public static class ClaimInfoDTO {
		/**
		 * 쇼핑몰 반품번호
		 */
		private String claimNo;
		
		/**
		 * 쇼핑몰 주문번호
		 */
		private String orderNo;
		
		/**
		 * 쇼핑몰 주문 상세 번호
		 */
		private String ordDtlSeq;
		
		// 변환용 변수 (ERP)
		/**
		 * 주문일자
		 */
		@ExceptLog
		private String ordDate;
		
		/**
		 * 가맹점코드
		 */
		@ExceptLog
		private String strCode;
		
		/**
		 * 전표번호
		 */
		@ExceptLog
		private String ordSlip;

		/**
		 * 주문 상세 번호
		 */
		@ExceptLog
		private String ordSeq;
		
		/**
		 *  추가구매번호
		 */
		@ExceptLog
		private String ordAddNo;
		
		// DB 저장용변수
		/**
		 * 상태코드
		 */
		@ExceptLog(force=true)
		private String status;
		
	}
}
