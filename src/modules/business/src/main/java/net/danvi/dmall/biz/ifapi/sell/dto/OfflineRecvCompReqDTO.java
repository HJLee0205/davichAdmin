package net.danvi.dmall.biz.ifapi.sell.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.sell.dto
 * - 파일명        : OfflineRecvCompReqDTO.java
 * - 작성일        : 2018. 5. 16.
 * - 작성자        : CBK
 * - 설명          : 매장수령 상품 수령완료 처리(고객판매완료)를 위한 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineRecvCompReqDTO extends BaseReqDTO {

	/**
	 * ERP 주문번호 - 발주일자
	 */
	private String ordDate;
	
	/**
	 * ERP 주문번호 - 가맹점코드
	 */
	private String strCode;
	
	/**
	 * ERP 주문번호 - 전표번호
	 */
	private String ordSlip;
	
	/**
	 * ERP 주분상세 리스트
	 */
	private List<String> ordSeq;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 주문번호(ERP주문번호에 매핑된 쇼핑몰 주문번호)
	 */
	@ExceptLog
	private String mallOrderNo;
	
	/**
	 * 쇼핑몰 주문상세 번호
	 */
	@ExceptLog
	private List<String> mallOrdDtlSeq;
	
	
}
