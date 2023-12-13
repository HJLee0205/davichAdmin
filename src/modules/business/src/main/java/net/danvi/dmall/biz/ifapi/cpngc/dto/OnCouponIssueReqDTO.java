package net.danvi.dmall.biz.ifapi.cpngc.dto;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cpngc.dto
 * - 파일명        : OnCouponIssueReqDTO.java
 * - 작성일        : 2018. 7. 11.
 * - 작성자        : CBK
 * - 설명          : 온라인 쿠폰 발급 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnCouponIssueReqDTO extends BaseReqDTO {

	/**
	 * 다비젼 회원 코드
	 */
	private String cdCust;
	
	/**
	 * 쿠폰 금액
	 */
	private Integer cpnAmt;
	
	/**
	 * 쿠폰 사용을 위한 최소 결제 금액
	 */
	private Integer cpnUseMinPayAmt;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 회원 번호
	 */
	@ExceptLog
	private String memNo;
	
	// DB 저장을 위한 변수
	/**
	 * 쿠폰 번호(쿠폰 종류 번호)
	 */
	@ExceptLog
	private String couponNo;
	
	/**
	 * 회원쿠폰번호 (쿠폰 고유 번호)
	 */
	@ExceptLog
	private String memberCpNo;
	
	/**
	 * 등록자
	 */
	@ExceptLog(force=true)
	private Long regrNo;
	
	/**
	 * 사이트번호
	 */
	@ExceptLog(force=true)
	private Long siteNo;
}
