package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OffPointHistorySearchReqDTO.java
 * - 작성일        : 2018. 5. 29.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 증감내역 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointHistorySearchReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 검색조건 - 기간 From
	 */
	private String searchFrom;
	
	/**
	 * 검색조건 - 기간 To
	 */
	private String searchTo;
	
	/**
	 * 거래구분 [1:적립, 2:사용]
	 */
	private String dealType;

	/**
	 * 페이지번호 (zero-base)
	 */
	private Integer pageNo = 0;
	
	/**
	 * 페이지당 표시할 데이터 개수
	 */
	private Integer cntPerPage = 10;
	
	
	// 변환용 변수
	/**
	 * 다비젼 회원번호
	 */
	@ExceptLog
	private String cdCust;
}
