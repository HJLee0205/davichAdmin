package net.danvi.dmall.biz.ifapi.dist.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.dist.dto
 * - 파일명        : StoreDlvrCmpltReqDTO.java
 * - 작성일        : 2018. 6. 5.
 * - 작성자        : CBK
 * - 설명          : 매장 배송완료 처리 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreDlvrCmpltReqDTO extends BaseReqDTO {

	/**
	 * 주문일자
	 */
	private String ordDate;
	
	/**
	 * 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 전표번호
	 */
	private String ordSlip;
	
	/**
	 * 주문상세 번호 리스트
	 */
	private List<String> ordSeq;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 주문번호
	 */
	@ExceptLog
	private String mallOrderNo;
	
	/**
	 * 쇼핑몰 주문 상세 번호 리스트
	 */
	@ExceptLog
	private List<String> mallOrdDtlSeq;
	
}
