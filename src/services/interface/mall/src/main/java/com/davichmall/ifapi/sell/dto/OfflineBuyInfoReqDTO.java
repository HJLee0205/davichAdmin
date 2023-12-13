package com.davichmall.ifapi.sell.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.sell.dto
 * - 파일명        : OfflineBuyInfoReqDTO.java
 * - 작성일        : 2018. 5. 16.
 * - 작성자        : CBK
 * - 설명          : 오프라인 매장 구매내역 조회를 위한 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineBuyInfoReqDTO extends BaseReqDTO {

	/**
	 * 검색조건 - 검색시작일 (통합회원의 오프라인 구매내역 조회시)
	 */
	private String fromDate;
	
	/**
	 * 검색조건 - 검색종료일 (통합회원의 오프라인 구매내역 조회시)
	 */
	private String toDate;
	
	/**
	 * 검색조건 - 쇼핑몰 회원번호 (통합회원의 오프라인 구매내역 조회시)
	 */
	private String memNo;
	
	/**
	 * ERP 회원번호 (쇼핑몰 회원번호에 매핑된 ERP회원번호)
	 */
	private String erpMemNo;

	/**
	 * 페이지번호 (zero-base)
	 */
	private Integer pageNo = 0;
	
	/**
	 * 페이지당 표시할 데이터 개수
	 */
	private Integer cntPerPage = 10;
	
	public void setPageNo(Integer pageNo) {
		if(pageNo == null) pageNo = 0;
		this.pageNo = pageNo;
	}

	public void setCntPerPage(Integer cntPerPage) {
		if(cntPerPage == null) cntPerPage = 10;
		this.cntPerPage = cntPerPage;
	}
	
}
