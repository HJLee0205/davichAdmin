package net.danvi.dmall.biz.ifapi.rsv.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : PreorderRegReqDTO.java
 * - 작성일        : 2018. 7. 2.
 * - 작성자        : CBK
 * - 설명          : 사전예약 주문 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PreorderRegReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 기획전 번호
	 */
	private String prmtNo;
	
	/**
	 * 기획전 명
	 */
	private String prmtName;
	
	/**
	 * 기획전 시작일
	 */
	private String prmtSDate;
	
	/**
	 * 기획전 종료일
	 */
	private String prmtEDate;
	
	/**
	 * 고객명
	 */
	private String custName;
	
	/**
	 * 고객 휴대폰
	 */
	private String custHp;
	
	/**
	 * 고객 생일
	 */
	private String custBirthday;
	
	/**
	 * 개인정보 동의 여부
	 */
	private String custAgreeYn;
	
	/**
	 * 가맹점 코드
	 */
	private String strCode;
	
	/**
	 * 수령 요청 일자
	 */
	private String reqDate;
	
	/**
	 * 주문 상품 목록
	 */
	private List<PreorderProductDTO> prdList;
	
	// 변환용 변수
	/**
	 * ERP 사전예약 기획전 번호
	 */
	@ExceptLog
	private String erpPrmtNo;

	// DB 저장용 변수
	/**
	 * 사전예약 접수 순번
	 */
	@ExceptLog(force=true)
	private int receiptSeq;
	
	// 사전예약 주문 상품 DTO
	@Data
	public static class PreorderProductDTO {
		
		/**
		 * 쇼핑몰 상품코드
		 */
		private String itmCode;
		
		/**
		 * 주문 수량
		 */
		private Integer qty;
		
		// 변환용 변수
		/**
		 * ERP 상품 코드
		 */
		@ExceptLog
		private String erpItmCode;
		
		// DB 저장용 변수
		/**
		 * 상품 순번
		 */
		@ExceptLog(force=true)
		private int itmSeq;
	}
}
