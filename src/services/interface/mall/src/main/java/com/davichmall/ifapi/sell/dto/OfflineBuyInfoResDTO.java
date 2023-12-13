package com.davichmall.ifapi.sell.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;


/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.sell.dto
 * - 파일명        : OfflineBuyInfoResDTO.java
 * - 작성일        : 2018. 5. 16.
 * - 작성자        : CBK
 * - 설명          : 오프라인 매장 구매내역 조회를 위한 응답 DTO
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineBuyInfoResDTO extends BaseResDTO {

	/**
	 * 데이터 총 개수
	 */
	private int totalCnt;
	
	/**
	 * 구매 리스트
	 */
	private List<OfflineBuyInfoDTO> salList;

	/**
	 * 구매 상세 정보 DTO
	 */
	@Data
	public static class OfflineBuyInfoDTO {
		
		/**
		 * 구매일자
		 */
		private String salDate;
		
		/**
		 * 구매시간
		 */
		private String salTime;
		
		/**
		 * 매장명
		 */
		private String strName;
		
		/**
		 * 취소구분
		 */
		private String cancType;
		/**
		 * 상품명
		 */
		private String itmName;
		
		/**
		 * 수량
		 */
		private int qty;
		
		/**
		 * 판매단가
		 */
		private int sprc;
		
		/**
		 * 할인금액
		 */
		private int dcAmt;
		
		/**
		 * 총판매금액
		 */
		private int salAmt;
		
	}
	
}
