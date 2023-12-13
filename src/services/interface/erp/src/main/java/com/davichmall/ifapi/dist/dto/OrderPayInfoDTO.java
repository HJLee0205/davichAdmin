package com.davichmall.ifapi.dist.dto;

import java.util.ArrayList;
import java.util.List;

import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.CouponInfoDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.OrderDetailDTO;

import lombok.Data;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : OrderPayInfoDTO.java
 * - 작성일        : 2018. 6. 4.
 * - 작성자        : CBK
 * - 설명          : 결제정보 등록을 위한 DTO
 * </pre>
 */
@Data
public class OrderPayInfoDTO {
	
	public OrderPayInfoDTO() {}
	public OrderPayInfoDTO(OrderDetailDTO ordDtlDto, List<CouponInfoDTO> couponList) {
		this.dates = ordDtlDto.getOrdDate();
		this.strCode = ordDtlDto.getStrCode();
		this.ordSlip = ordDtlDto.getOrdSlip();
		this.ordSeq = ordDtlDto.getErpOrdDtlSeq();
		this.ordAddNo = ordDtlDto.getErpOrdAddNo();
		
		this.payAmt = ordDtlDto.getSprc() * ordDtlDto.getQty();
		if(ordDtlDto.getSvmnUseAmt() != null) this.addMileageUseAmt(ordDtlDto.getSvmnUseAmt());
		if(ordDtlDto.getOffPointUseAmt() != null) this.addOffMileageUseAmt(ordDtlDto.getOffPointUseAmt());
		
		if(couponList != null) {
			for(CouponInfoDTO cpn : couponList) {
				if(ordDtlDto.getOrdDtlSeq().equals(cpn.getOrdDtlSeq())) {
					CouponUseDTO cpnDto = new CouponUseDTO();
					cpnDto.setDcCode(cpn.getDcCode());
					cpnDto.setDcName(cpn.getDcName());
					cpnDto.setDcAmt(cpn.getDcAmt());
					this.addCoupon(cpnDto);
				}
			}
		}
	}

	/**
	 * 일자
	 */
	private String dates;
	
	/**
	 * 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 전표번호 (발주전표번호)
	 */
	private String ordSlip;
	
	/**
	 * 발주순번 (주문상세의 순번)
	 */
	private String ordSeq;
	
	/**
	 * 추가옵션인 경우 001부터 증가. 추가옵션이 아닌 경우 000
	 */
	private String ordAddNo;
	
	/**
	 * 순번
	 */
	private String seqNo;
	
	/**
	 * 취소구분  [0:정상, 2:반품]
	 */
	private String cancType;
	
	/**
	 * 지불수단
	 */
	private String payType;
	
	/**
	 * 지불수단명
	 */
	private String payName;
	
	/**
	 * 지불일
	 */
	private String inDates;
	
	/**
	 * 지불금액
	 */
	private int payAmt;

	// 계산 / 값 설정을 위한 변수
	/**
	 * 적립금 사용 금액 - 적립금 사용금액 계산을 위한 변수
	 */
	private int mileageUseAmt;
	
	/**
	 * 오프라인 적립금 사용 금액
	 */
	private int offMileageUseAmt;
	
	/**
	 * 할인코드 (쿠폰구분코드 같은...)
	 */
	private String dcCode;
	
	/**
	 * 할인명
	 */
	private String dcName;
	
	/**
	 * 사용 쿠폰 목록
	 */
	private List<CouponUseDTO> couponUseList = new ArrayList<>();
	
	/**
	 * 적립금 사용금액 추가 설정 (적립금 사용금액에 금액을 더해주고, 결제 금액에서 해당 금액을 제외한다.)
	 */
	public void addMileageUseAmt(int mileageUseAmt) {
		this.mileageUseAmt += mileageUseAmt;
		this.payAmt -= mileageUseAmt;
	}
	/**
	 * 오프라인 적립금 사용금액 추가 설정 (적립금 사용금액에 금액을 더해주고, 결제 금액에서 해당 금액을 제외한다.)
	 */
	public void addOffMileageUseAmt(int offMileageUseAmt) {
		this.offMileageUseAmt += offMileageUseAmt;
		this.payAmt -= offMileageUseAmt;
	}
	
	/**
	 * 사용 쿠폰 추가
	 */
	public void addCoupon(CouponUseDTO couponUseDto) {
		this.couponUseList.add(couponUseDto);
		this.payAmt -= couponUseDto.getDcAmt();
	}
	/**
	 * 사용 쿠폰 제거
	 */
	public void removeCoupon(CouponUseDTO couponUseDto) {
		this.couponUseList.remove(couponUseDto);
		this.payAmt += couponUseDto.getDcAmt();
	}
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : OrderPayInfoDTO.java
	 * - 작성일        : 2018. 8. 16.
	 * - 작성자        : CBK
	 * - 설명          : 사용 쿠폰 목록 DTO
	 * </pre>
	 */
	@Data
	public static class CouponUseDTO {
		/**
		 * 할인 코드
		 */
		private String dcCode;
		
		/**
		 * 할인 명
		 */
		private String dcName;
		
		/**
		 * 할인 금액
		 */
		private Integer dcAmt;
	}
	
	// 환불시 우선순위 (실결제 > 온라인 적립금 > 오프라인 적립금 > 쿠폰)
	public int getRefundPriority() {
		if(Constants.PAY_WAY.MILEAGE_CD.equals(this.getPayType())) {
			// 온라인 적립금
			return 2;
		} else if(Constants.PAY_WAY.OFF_MILEAGE_CD.equals(this.getPayType())) {
			// 오프라인 포인트
			return 3;
		} else if(Constants.PAY_WAY.DISCOUNT_CD.equals(this.getPayType())) {
			// 쿠폰
			return 4;
		} else {
			// 실결제
			return 1;
		}
	}
	
	
}
