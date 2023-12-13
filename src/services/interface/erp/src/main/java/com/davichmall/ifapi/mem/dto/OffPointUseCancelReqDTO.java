package com.davichmall.ifapi.mem.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OffPointUseCancelReqDTO.java
 * - 작성일        : 2018. 7. 18.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 사용 취소 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointUseCancelReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 쇼핑몰 주문번호
	 */
	private String orderNo;
	
	/**
	 * 쇼핑몰 취소일자 [YYYYMMDD]
	 */
	private String orderDate;
	
	// 변환용 변수
	/**
	 * ERP 포인트 로그 번호 - 영업일자
	 */
	@ExceptLog
	private String orgDates;
	
	/**
	 * ERP 포인트 로그 번호 - 회원번호
	 */
	@ExceptLog
	private String orgCdCust;
	
	/**
	 * ERP 포인트 로그 번호 - 순번
	 */
	@ExceptLog
	private List<String> orgSeqNo;
	
	
//	// DB 처리용 변수
//	/**
//	 * 오프라인 포인트 사용 로그 순번
//	 */
//	@ExceptLog
//	private String seqNo;
}
