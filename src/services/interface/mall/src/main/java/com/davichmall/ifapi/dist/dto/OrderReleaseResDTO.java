package com.davichmall.ifapi.dist.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseReqDTO.OrderReleaseDtlDto;
import com.davichmall.ifapi.util.IFMessageUtil;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : OrderReleaseResDTO.java
 * - 작성일        : 2018. 6. 5.
 * - 작성자        : CBK
 * - 설명          : 출고처리 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OrderReleaseResDTO extends BaseResDTO {

	/**
	 * 실패 목록
	 */
	private List<ReleaseFailDTO> failList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : OrderReleaseResDTO.java
	 * - 작성일        : 2018. 8. 22.
	 * - 작성자        : CBK
	 * - 설명          : 출고 실패 데이터
	 * </pre>
	 */
	@Data
	public static class ReleaseFailDTO {
		
		public ReleaseFailDTO () {}
		public ReleaseFailDTO (OrderReleaseDtlDto reqDtlDto, String exCode) {
			super();
			this.ordDate = reqDtlDto.getOrdDate();
			this.strCode = reqDtlDto.getStrCode();
			this.ordSlip = reqDtlDto.getOrdSlip();
			this.ordSeq = reqDtlDto.getOrdSeq();
			this.reason = IFMessageUtil.getMessage(exCode);
		}

		/**
		 * 주문일자
		 */
		private String ordDate;
		
		/**
		 * 가맹점코드
		 */
		private String strCode;
		
		/**
		 * 전표번호
		 */
		private String ordSlip;
		
		/**
		 * 주문상세번호
		 */
		private String ordSeq;
		
		/**
		 * 실패 이유
		 */
		private String reason;
		
	}
}
