package net.danvi.dmall.biz.ifapi.mem.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : StoreVCResultResDTO.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 매장 비젼체크 결과 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreVCResultResDTO extends BaseResDTO {
	
	/**
	 * 비젼체크 결과 목록
	 */
	private List<VCResultDTO> resultList;
	
	/**
	 * 비젼체크 결과에 따른 추천상품 목록
	 */
	private List<VCRecoGoodsDTO> recoGoodsList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
	 * - 파일명        : StoreVCResultResDTO.java
	 * - 작성일        : 2018. 6. 18.
	 * - 작성자        : CBK
	 * - 설명          : 비젼체크 결과
	 * </pre>
	 */
	@Data
	public static class VCResultDTO {
		/**
		 * 순번
		 */
		private Integer seq;
		
		/**
		 * 질문
		 */
		private String vcQ;
		
		/**
		 * 답변
		 */
		private String vcA;
		
		/**
		 * 구분코드 [안경:L 콘택트:C + 어린이:K 젊은이:Y 중년:O 기본:D + 기존:U 처음:N]
		 */
		private String visionRootCd;
	}
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
	 * - 파일명        : StoreVCResultResDTO.java
	 * - 작성일        : 2018. 6. 18.
	 * - 작성자        : CBK
	 * - 설명          : 비젼체크 결과에 따른 추천상품
	 * </pre>
	 */
	@Data
	public static class VCRecoGoodsDTO {
		/**
		 * 회사코드
		 */
		private String companyCode;
		
		/**
		 * 브랜드코드
		 */
		private String brandCode;
		
		/**
		 * 추천상품코드
		 */
		private String recoGoodsCode;
		
		/**
		 * 추천상품이름
		 */
		private String recoGoodsName;
	}
}
