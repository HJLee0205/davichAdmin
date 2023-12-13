package com.davichmall.ifapi.dist.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : OrderRegReqDTO.java
 * - 작성일        : 2018. 5. 30.
 * - 작성자        : CBK
 * - 설명          : 발주/반품등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OrderRegReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 반품 번호(반품인 경우에만 존재)
	 */
	@ExceptLog
	private String claimNo;
	
	/**
	 * 쇼핑몰 원주문 번호(교환인 경우만 존재)
	 */
	@ExceptLog
	private String orgOrderNo;
	
	/**
	 * 쇼핑몰 주문번호
	 */
	private String orderNo;

	/**
	 * 주문(반품)일자
	 */
	private String orderDate;
	
	/**
	 * 결제일자
	 */
	private String payDate;
	
	/**
	 * 배송지 구분(1:자택, 2:매장)
	 */
	private String destType;
	
	/**
	 * 배송가맹점 코드
	 */
	private String delivStrCode;
	
	/**
	 * 주소1
	 */
	private String address1;
	
	/**
	 * 주소2
	 */
	private String address2;
	
	/**
	 * 우편번호
	 */
	private String zipCode;
	
	/**
	 * 수신자명
	 */
	private String receiverName;
	
	/**
	 * 수신자 휴대폰번호
	 */
	private String receiverHp;
	
	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 비고
	 */
	private String bigo;
	
	/**
	 * 배송비
	 */
	private Integer dlvrAmt;
	
	/**
	 * 주문상세 리스트
	 */
	private List<OrderDetailDTO> ordDtlList;
	
	/**
	 * 결제 리스트
	 */
	private List<PayInfoDTO> payList;
	
	/**
	 * 사용 쿠폰 리스트
	 */
	private List<CouponInfoDTO> couponList;
	
	
	// 변환용 변수
	/**
	 * 다비젼 발주 KEY - 발주일자
	 */
	@ExceptLog
	private String ordDate;
	
	/**
	 * 다비젼 발주 KEY - 가맹점코드
	 */
	@ExceptLog
	private String strCode;
	
	/**
	 * 다비젼 발주 KEY - 전표번호
	 */
	@ExceptLog
	private String ordSlip;

	/**
	 * 다비젼 venCode
	 */
	@ExceptLog
	private String venCode;
	
	/**
	 * 다비젼 회원번호
	 */
	@ExceptLog
	private String cdCust;
	
	/**
	 * 반품시 원 주문번호
	 */
	@ExceptLog
	private String orgOrdDate;
	@ExceptLog
	private String orgStrCode;
	@ExceptLog
	private String orgOrdSlip;
	
	/**
	 * 주문자 정보
	 */
	@ExceptLog
	private String orderName;	
	@ExceptLog
	private String orderHp;
	
	// 시스템에서 설정하는 변수 (DB저장용)
	/**
	 * 배송루트 (다비치상품 직접수령:1, 다비치상품 매장수령:2, 셀러상품 매장수령:3)
	 */
	@ExceptLog(force=true)
	private String ordRute;
	
	/**
	 * 발주구분[통합(192), 0:정상발주, 1:반품발주]
	 */
	@ExceptLog(force=true)
	private String gubun;
	
	/**
	 * 발주전표번호 [일자(6)+가맹점코드(4)+전표번호(10)]
	 */
	@ExceptLog(force=true)
	private String ordSlipNo;
	
	/**
	 * 입출고 여부 [Y/N]
	 */
	@ExceptLog(force=true)
	private String inoutYn;
	
	/**
	 * 정산 반영 여부 [Y/N]
	 */
	@ExceptLog(force=true)
	private String chargeYn;
	
	/**
	 * 반품/교환으로 인한 재발주인 경우 재발주사유 (DR:다비치반품, OR:다른셀러상품반품, EX:교환)
	 */
	@ExceptLog(force=true)
	private String reorderReason;

	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : OrderRegReqDTO.java
	 * - 작성일        : 2018. 5. 30.
	 * - 작성자        : CBK
	 * - 설명          : 주문상세(상품) 정보 DTO
	 * </pre>
	 */
	@Data
	public static class OrderDetailDTO {
		
		/**
		 * 쇼핑몰 원주문 상세 번호(교환인 경우만 존재)
		 */
		@ExceptLog
		private String orgOrdDtlSeq;
		
		/**
		 * 쇼핑몰 반품완료 로 인한 남은 상품 재발주시 교환된 상품은 주문번호가 다름.
		 */
		@ExceptLog
		private String orderNo;
		
		/**
		 * 쇼핑몰 주문상세번호
		 */
		private String ordDtlSeq;
		
		/**
		 * 쇼핑몰 상품번호
		 */
		private String goodsNo;
		
		/**
		 * 쇼핑몰 단품코드
		 */
		private String itmCode;
		
		/**
		 * 추가옵션번호
		 */
		private String addOptYn;
		
		
		/**
		 * 상품명
		 */
		private String goodsNm;
		
		/**
		 * 기본옵션명
		 */
		private String optNm;
		
		/**
		 * 면과세 [0:면세, 1:과세, 2:영세] -> 쇼핑몰에서는 2:영세는 사용하지 않음.
		 */
		private String tax;
		
		/**
		 * 주문수량
		 */
		private int qty;
		
		/**
		 * 공금가
		 */
		private int wprc;
		
		/**
		 * 판매가
		 */
		private int sprc;
		
		/**
		 * 적립금(D-Money) 사용금액
		 */
		private Integer svmnUseAmt;
		
		/**
		 * 오프라인 포인트 사용 금액
		 */
		private Integer offPointUseAmt;
		
		/**
		 * 반품사유
		 */
		private String retSayu;
		
		/**
		 * 매장입고가능 여부 [Y/N]
		 */
		@ExceptLog
		private String strIpYn;
		
		
		// 변환용 변수
		/**
		 * ERP 주문상세번호
		 */
		@ExceptLog
		private String erpOrdDtlSeq;

		/**
		 * ERP 상품코드
		 */
		@ExceptLog
		private String erpItmCode;
		
		// DB저장을 위한 변수
		/**
		 * 다비젼 발주 KEY - 발주일자
		 */
		@ExceptLog(force=true)
		private String ordDate;
		
		/**
		 * 다비젼 발주 KEY - 가맹점코드
		 */
		@ExceptLog(force=true)
		private String strCode;
		
		/**
		 * 다비젼 발주 KEY - 전표번호
		 */
		@ExceptLog(force=true)
		private String ordSlip;
		
		@ExceptLog(force=true)
		private String returnStatus;
		
		/**
		 * 추가옵션인 경우 001부터 증가. 추가옵션이 아닌 경우 000
		 */
		@ExceptLog
		private String erpOrdAddNo;
		
		// 반품 등록시 참조를 위한 원 발주번호 
		@ExceptLog
		private String orgOrdDate;
		@ExceptLog
		private String orgStrCode;
		@ExceptLog
		private String orgOrdSlip;
		@ExceptLog
		private String orgOrdSeq;
		@ExceptLog
		private String orgOrdAddNo;
		@ExceptLog
		private String ordRute;
		
	}
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : OrderRegReqDTO.java
	 * - 작성일        : 2018. 6. 4.
	 * - 작성자        : CBK
	 * - 설명          : 결제 정보 DTO
	 * </pre>
	 */
	@Data
	public static class PayInfoDTO {
		
		/**
		 * 결제수단코드
		 */
		private String payWayCd;
		
		/**
		 * 결제수단명
		 */
		private String payWayNm;
		
		/**
		 * 결제금액
		 */
		private int payAmt;
	}
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : OrderRegReqDTO.java
	 * - 작성일        : 2018. 8. 16.
	 * - 작성자        : CBK
	 * - 설명          : 사용 쿠폰 목록
	 * </pre>
	 */
	@Data
	public static class CouponInfoDTO {
		/**
		 * 주문 상세 번호
		 */
		private String ordDtlSeq;
		
		/**
		 * 할인 금액
		 */
		private Integer dcAmt;
		
		/**
		 * 할인코드(쿠폰혜택 코드)
		 */
		private String dcCode;
		
		/**
		 * 할인내역(쿠폰혜택 이름)
		 */
		private String dcName;
	}
}
