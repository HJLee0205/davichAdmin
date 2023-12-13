package com.davichmall.ifapi.cmmn.constant;


/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.constant
 * - 파일명        : Constants.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 공통상수
 * </pre>
 */
public class Constants {
	
	/**
	 * 처리결과
	 */
	public final class RESULT {
		/** 성공 */
		public static final String SUCCESS = "1";
		/** 실패 */
		public static final String FAILURE = "2";
	}
	
	/**
	 * 서버 구분
	 */
	public final class SERVER_TYPE {
		/** 쇼핑몰 */
		public static final String SERVER_TYPE_MALL = "mall";
		/** 다비젼 */
		public static final String SERVER_TYPE_ERP = "erp";
	}
	
	/**
	 * 인터페이스id
	 */
	public final class IFID {
		/** 상품조회 */
		public static final String PRODUCT_SEARCH = "IF_PRD_001";
		/** 상품재고조회 */
		public static final String PRODUCT_STOCK = "IF_PRD_002";
		/** 상풐코드 매핑 등록 */
		public static final String PRODUCT_MAPPING_REG = "IF_PRD_003";
		/** 상품코드 매핑 삭제 */
		public static final String PRODUCT_MAPPING_DEL = "IF_PRD_004";
		/** 브랜드목록 검색 */
		public static final String BRAND_SEARCH = "IF_PRD_005";
		/** 상품분류 목록 조회 */
		public static final String ITM_KIND_SEARCH = "IF_PRD_006";
		/** 상품코드매핑 일괄 처리 */
		public static final String PRODUCT_MAPPING_BUNDLE = "IF_PRD_007";
		
		/** 매장수령상품 판매완료 **/
		public static final String OFF_RECV_COMPLT = "IF_SAL_001";
		/** 오프라인 구매내역 조회 */
		public static final String OFF_SAL_SEARCH = "IF_SAL_002";
		
		/** 오프라인 회원 조회 */
		public static final String OFF_MEM_SEARCH = "IF_MEM_001";
		/** 온라인 회원 조회 */
		public static final String ON_MEM_SEARCH = "IF_MEM_002";
		/** 온라인에서 회원통합 */
		public static final String MEM_COMBINE_FROM_MALL = "IF_MEM_003";
		/** 오프라인에서 회원통합 */
		public static final String MEM_COMBINE_FROM_ERP = "IF_MEM_004";
		/** 온라인에서 회원분리 */
		public static final String MEM_SEPARATE_FROM_MALL = "IF_MEM_005";
		/** 오프라인에서 회원분리 */
		public static final String MEM_SEPARATE_FROM_ERP = "IF_MEM_006";
		/** 오프라인 회원 등급을 쇼핑몰쪽에 갱신(매핑테이블) */
		public static final String MEM_OFF_LVL = "IF_MEM_007";
		/** 오프라인 보유 포인트 조회 */
		public static final String MEM_OFF_POINT_SEARCH = "IF_MEM_008";
		/** 오프라인 포인트 증감내역 조회 */
		public static final String MEM_OFF_POINT_HISTORY_SEARCH = "IF_MEM_009";
		/** 매장 비전체크 결과 조회(쇼핑몰에서) */
		public static final String STORE_VC_RESULT = "IF_MEM_010";
		/** 쇼핑몰 비젼체크 결과 조회(다비젼에서) */
		public static final String MALL_VC_RESULT = "IF_MEM_011";
		/** 매장 시력검사 정보 조회(쇼핑몰에서) */
		public static final String STORE_EYESIGHT_INFO = "IF_MEM_012";
		/** 쇼핑몰 시력검사 정보 조회(다비젼에서) */
		public static final String MALL_EYESIGHT_INFO = "IF_MEM_013";
		/** 처방전 이미지 URL조회 */
		public static final String PRESCRIPTION_URL = "IF_MEM_014";
		/** 온라인 포인트 조회 */
		public static final String MEM_ON_POINT_SEARCH = "IF_MEM_015";
		/** 온라인 포인트 사용 */
		public static final String MEM_ON_POINT_USE = "IF_MEM_016";
		/** 온라인 포인트 사용 취소 */
		public static final String MEM_ON_POINT_USE_CANCEL = "IF_MEM_017";
		/** 오프라인 포인트 사용 */
		public static final String MEM_OFF_POINT_USE = "IF_MEM_018";
		/** 오프라인 포인트 사용 취소 */
		public static final String MEM_OFF_POINT_USE_CANCEL = "IF_MEM_019";
		/** 온라인 카드번호 중복 체크(오프라인에 존재하는지 여부) */
		public static final String ON_CARD_NO_DUP_CHECK = "IF_MEM_020";
		/** 매장에서 쇼핑몰 회원가입 */
		public static final String MEMBER_JOIN_FROM_STORE = "IF_MEM_021";
		/** 앱로그인 일시 다비전 기록 */
		public static final String MEMBER_LOGIN_DATE_FROM_APP = "IF_MEM_022";
		
		/** 쇼핑몰 고객 연말정산 조회 */
		public static final String MEMBER_YEAR_END_TAX_LIST = "IF_MEM_023";
		/** 쇼핑몰 고객 연말정산 조회 (PRINT) */
		public static final String MEMBER_YEAR_END_TAX_PRINT = "IF_MEM_024";
		/** 쇼핑몰 고객 연말정산 자동신고 */
		public static final String MEMBER_YEAR_END_TAX_AUTO = "IF_MEM_025";
		
		/** 온라인 회원 몰카드 번호로 조회 */
		public static final String ON_MEM_CARD_SEARCH = "IF_MEM_026";
		
		/** 발주등록 */
		public static final String ORDER_REG = "IF_ORD_001";
		/** 발주취소 */
		public static final String ORDER_CANCEL = "IF_ORD_002";
		/** 출고 */
		public static final String ORDER_RELEASE = "IF_ORD_003";
		/** 배송완료(매장) */
		public static final String STORE_DLVR_CMPLT = "IF_ORD_004";
		/**반품등록 (집) */
		public static final String MALL_RETURN_REG = "IF_ORD_005";
		/** 반품확정(쇼) */
		public static final String MALL_RETURN_CONFIRM = "IF_ORD_006";
		/** 반품확정(물) */
		public static final String DIST_CENTER_RETURN_CONFIRM = "IF_ORD_007";
		/** 구매확정 */
		public static final String PURCHASE_CONFIRM = "IF_ORD_008";
		/** 반품상세팝업 URL조회 */
		public static final String RETURN_POP_URL = "IF_ORD_009";
		/** 반품취소 */
		public static final String RETURN_CANCEL = "IF_ORD_010";
		/** 환불완료 */
		public static final String REFUND_CMPLT = "IF_ORD_011";
		/** 교환완료 */
		public static final String EXCHANGE_CMPLT = "IF_ORD_012";
		/** 반품신청사유팝업URL */
		public static final String RETURN_REASON_POP_URL = "IF_ORD_013";
		
		/** (온라인에서 발급한) 오프라인 쿠폰 목록 조회 */
		public static final String OFF_COUPON_LIST_SEARCH = "IF_CPN_001";
		/** (온라인에서 발급한) 오프라인 쿠폰 사용 처리 */
		public static final String OFF_COUPON_USE = "IF_CPN_002";
		/** (온라인에서 발급한) 오프라인 쿠폰 사용 취소 처리 */
		public static final String OFF_COUPON_USE_CANCEL = "IF_CPN_003";
		/** 상품권 사용가능여부 체크 */
		public static final String GIFT_CARD_CHECK = "IF_CPN_004";
		/** 상품권 사용 */
		public static final String GIFT_CARD_USE = "IF_CPN_005";
		/** 상품권 사용 취소 */
		public static final String GIFT_CARD_CANCEL = "IF_CPN_006";
		/** 온라인 쿠폰 발급 */
		public static final String ISSUE_ON_COUPON = "IF_CPN_007";
		/** 온라인 쿠폰 발급 취소 */
		public static final String CANCEL_ON_COUPON_ISSUE = "IF_CPN_008";
		
		/** 매장혼잡도 조회 */
		public static final String STORE_CHAOTIC_SEARCH = "IF_RSV_001";
		/** 방문예약 등록 */
		public static final String STORE_VISIT_RESERVE_REG = "IF_RSV_002";
		/** 방문예약 취소(쇼핑몰에서) */
		public static final String STORE_VISIT_RESERVE_CANCEL_FROM_MALL = "IF_RSV_003";
		/** 방문예약 취소(매장에서) */
		public static final String STORE_VISIT_RESERVE_CANCEL_FROM_ERP = "IF_RSV_004";
		/** 방문예약 수정(매장에서) */
		public static final String STORE_VISIT_RESERVE_MDFY_FROM_ERP = "IF_RSV_005";
		/** 가맹점 목록 조회 */
		public static final String STORE_LIST_SEARCH = "IF_RSV_006";
		/** 가맹점 상세 조회 */
		public static final String STORE_DEATIL_INFO = "IF_RSV_007";
		/** 방문예약 상품 목록 조회 */
		public static final String RESERVE_PRODUCT_SEARCH = "IF_RSV_008";
		/** 방문예약 주문 목록 조회 */
		public static final String RESERVE_ORDER_SEARCH = "IF_RSV_009";
		/** 사전예약 기획전 등록 */
		public static final String PREORDER_PROMOTION_REG = "IF_RSV_010";
		/** 사전예약 주문 등록 */
		public static final String PREORDER_REG = "IF_RSV_011";
		/** 사전예약 기획전 수정 */
		public static final String PREORDER_PROMOTION_MOD = "IF_RSV_012";
		/** 가맹점휴일조회 */
		public static final String STORE_HOLIDAY_SEARCH = "IF_RSV_013";
		/** 방문예약 수정(쇼핑몰에서) */
		public static final String STORE_VISIT_RESERVE_MDFY_FROM_MALL = "IF_RSV_014";
		
		/** 키오스크 로그인정보 확인 */
		public static final String CHECK_KIOSK_LOGIN = "IF_VST_001";
		/** 매장방문정보 등록 */
		public static final String VISIT_INFO_REG = "IF_VST_002";
		/** 방문 고객 상태 수정 (키오스크에서 수정)*/
		public static final String VISIT_STATUS_MOD_FROM_KIOSK = "IF_VST_003";
		/** 방문 고객 상태 수정(다비젼에서 수정) */
		public static final String VISIT_STATUS_MOD_FROM_ERP = "IF_VST_004";
		
		/** 비콘조회 */
		public static final String BEACON_SEARCH = "IF_BCN_001";
		
	}
	
	/**
	 * 쇼핑몰에서 사용하는 SITE_NO
	 */
	public static final Long SITE_NO = new Long(1);
	
	/**
	 * 인터페이스에더 등록/수정시 등록/수정자 번호
	 */
	public static final Long IF_REGR_NO = new Long(9999);
	
	/**
	 * 발주구분
	 */
	public final class ORDER_GUBUN {
		/** 정상발주 */
		public static final String ORDER = "0";
		/** 반품발주 */
		public static final String RETURN = "1";
	}
	
	/**
	 * 배송루트
	 */
	public final class ORD_RUTE {
		/** 다비치상품 직접수령 */
		public static final String DIRECT_RECV = "1";
		/** 다비치상품 매장수령 */
		public static final String STORE_RECV = "2";
		/** 셀러상품 매장수령 */
		public static final String STORE_SELLER_RECV = "3";
	}
	
	/**
	 * 취소구분(결제)
	 */
	public final class CANC_TYPE {
		/** 정상 */
		public static final String NORMAL = "0";
		/** 반품 */
		public static final String RETURN = "2";
	}
	
	/**
	 * 결제수단
	 */
	public final class PAY_WAY {
		/** 적립금 - 코드 */
		public static final String MILEAGE_CD = "01";
		/** 적립금 - 이름 */
		public static final String MILEAGE_NM = "적립금";
		/** 오프라인 적립금 - 코드 */
		public static final String OFF_MILEAGE_CD = "02";
		/** 오프라인 적립금 - 이름 */
		public static final String OFF_MILEAGE_NM = "다비치적립금";
		/** 할인 - 코드 */
		public static final String DISCOUNT_CD = "00";
		/** 할인 -이름 */
		public static final String DISCOUNT_NM = "할인";
	}
	
	/**
	 * 주문 매핑 테이블 쇼핑몰 발주구분
	 */
	public final class ORDER_MAP_ORDER_TYPE {
		/** 주문 */
		public static final String ORDER = "1";
		/** 반품 */
		public static final String RETURN = "2";
	}
	
	/**
	 * 다비젼 반품 상태
	 */
	public final class RETURN_STATUS {
		/** 반품요청 */
		public static final String RETURN_REQ = "1";
		/** 반품확정 */
		public static final String RETURN_CONFIRM = "2";
	}
	
	/**
	 * 상품권 사용/취소플래그
	 */
	public final class GIFT_CARD_USE_FLG {
		/**
		 * 사용
		 */
		public static final String USE = "0";
		/**
		 * 취소
		 */
		public static final String CANCEL = "1";
	}

	/**
	 * 메시지 발송 성공 결과 코드
	 */
	public static final String ERP_SMS_SEND_RESULT_SUCCESS = "0";
	
	/**
	 * 재발주 사유 (mall_order_h.reorder_reason)
	 */
	public final class REORDER_REASON {
		/**
		 * 다비치 상품 반품
		 */
		public static final String DAVICH_RETURN = "DR";
		
		/**
		 * 다른 셀러 상품 반푼
		 */
		public static final String OTHER_RETURN = "OR";
		
		/**
		 * 교환
		 */
		public static final String EXCHANGE = "EX";
	}
}
