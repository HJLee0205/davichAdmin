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
 * - 파일명        : StoreVisitReserveRegReqDTO.java
 * - 작성일        : 2018. 6. 22.
 * - 작성자        : CBK
 * - 설명          : 매장 방문예약 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreVisitReserveRegReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 회원 번호
	 */
	private String memNo;
	
	/**
	 * 예약일자 YYYYMMDD
	 */
	private String rsvDate;
	
	/**
	 * 예약시간 HHMM
	 */
	private String rsvTime;
	
	/**
	 * 예약 매장 코드
	 */
	private String strCode;
	
	/**
	 * 고객이름
	 */
	private String memName;
	
	/**
	 * 휴대폰
	 */
	private String telNo;
	
	/**
	 * 고객메모
	 */
	private String memo;
	
	/**
	 * 방문목적
	 */
	private String purpose;
	
	/**
	 * 쇼핑몰 예약 번호
	 */
	private String mallRsvNo;
	
	/**
	 * 검사필요여부
	 */
	private String checkupYn;

	/**
	 * 이벤트 유입 구분
	 */
	private String eventGubun;
	
	/**
	 * 예약 상품 목록
	 */
	private List<ReservePrdDTO> rsvPrdList;
	
	// 데이터 변환용 변수
	/**
	 * 다비젼 회원코드
	 */
	@ExceptLog
	private String cdCust;
	
	// DB등록용 변수
	/**
	 * 방문예약 순번
	 */
	@ExceptLog(force=true)
	private int seqNo;
	
	/**
	 * 휴대폰 뒷자리 (4)
	 */
	private String telNoH;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
	 * - 파일명        : StoreVisitReserveRegReqDTO.java
	 * - 작성일        : 2018. 8. 3.
	 * - 작성자        : CBK
	 * - 설명          : 예약상품 정보 DTO
	 * </pre>
	 */
	@Data
	public static class ReservePrdDTO {
		
		/**
		 * 쇼핑몰 단품코드
		 */
		private String itmCode;
		
		/**
		 * 예약 수량
		 */
		private Integer qty;
		
		/**
		 * 메모
		 */
		private String memo;
		
		// 변환용 변수
		/**
		 * ERP 상품코드
		 */
		@ExceptLog
		private String erpItmCode;

		/**
		 * ERP 상품코드 추가
		 */
		@ExceptLog
		private String erpItmCodeAdd;
		
		// DB 처리용 변수
		/**
		 * 방문예약일자 (부모KEY)
		 */
		@ExceptLog(force=true)
		private String rsvDate;
		
		/**
		 * 방문예약 순번 (부모KEY)
		 */
		@ExceptLog(force=true)
		private int seqNo;
		
		/**
		 * 예약 상품 순번
		 */
		@ExceptLog(force=true)
		private int seq;
	}

}
