package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OnPointUseReqDTO.java
 * - 작성일        : 2018. 7. 16.
 * - 작성자        : CBK
 * - 설명          : 온라인 포인트 사용 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnPointUseReqDTO extends BaseReqDTO {

	/**
	 * 다비젼 회원코드
	 */
	private String cdCust;
	
	/**
	 * 사용 온라인 포인트 금액
	 */
	private Integer useMallPointAmt;
	
	/**
	 * 다비젼 판매 KEY - 거래일자 [YYYYMMDD]
	 */
	private String dates;
	
	/**
	 * 다비젼 판매 KEY - 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 다비젼 판매 KEY - 포스번호
	 */
	private String posNo;
	
	/**
	 * 다비젼 판매 KEY - TR번호
	 */
	private String trxnNo;
	
	/**
	 * 가맹점명
	 */
	private String strName;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 회원번호
	 */
	@ExceptLog
	private String memNo;
	
	// 편의를 위한 method
	/**
	 * 쇼핑몰 저장을 위한 ERP주문번호
	 */
	public String getErpOrdNo() {
		return this.getDates() + this.getStrCode() + this.getPosNo() + this.getTrxnNo();
	}
}
