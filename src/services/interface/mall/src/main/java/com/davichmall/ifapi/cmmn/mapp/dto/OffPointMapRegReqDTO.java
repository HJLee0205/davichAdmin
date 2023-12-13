package com.davichmall.ifapi.cmmn.mapp.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.dto
 * - 파일명        : OffPointMapRegReqDTO.java
 * - 작성일        : 2018. 7. 17.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 사용 매핑 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointMapRegReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 주문번호
	 */
	private String mallOrderNo;
	
	/**
	 * 쇼핑몰 발주구분 [1:주문, 2:반품]
	 */
	private String mallOrderType;
	
	/**
	 * ERP 포인트 로그 번호 - 영업일자
	 */
	private String erpDates;
	
	/**
	 * ERP 포인트 로그 번호 - 회원번호
	 */
	private String erpMemberNo;
	
	/**
	 * ERP 포인트 로그 번호 - 순번
	 */
	private List<String> erpSeqNo;
}
