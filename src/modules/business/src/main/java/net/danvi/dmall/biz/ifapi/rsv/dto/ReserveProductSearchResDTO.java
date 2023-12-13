package net.danvi.dmall.biz.ifapi.rsv.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : ReserveProductSearchResDTO.java
 * - 작성일        : 2018. 6. 29.
 * - 작성자        : CBK
 * - 설명          : 방문예약 상품 목록 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReserveProductSearchResDTO extends BaseResDTO {

	/**
	 * 상품 목록
	 */
	private List<ReserveProductDTO> prdList;
	
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
	 * - 파일명        : ReserveProductSearchResDTO.java
	 * - 작성일        : 2018. 6. 29.
	 * - 작성자        : CBK
	 * - 설명          : 방문예약 상품 DTO
	 * </pre>
	 */
	@Data
	public static class ReserveProductDTO {
		
		/**
		 * 쇼핑몰 상품명
		 */
		private String mallPrdNm;
		
		/**
		 * 쇼핑몰 상품 옵션명(일반옵션 or 추가옵션)
		 */
		private String mallPrdOptNm;
		
		/**
		 * 다비젼 상품코드
		 */
		private String itmCode;
		
		// 조회용 변수
		/**
		 * 쇼핑몰 단품코드
		 */
		private String mallItmCode;
		
		/**
		 * 추가옵션 여부
		 */
		private String addOptYn;
	}
}
