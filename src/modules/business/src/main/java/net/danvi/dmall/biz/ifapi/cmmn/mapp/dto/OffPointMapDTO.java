package net.danvi.dmall.biz.ifapi.cmmn.mapp.dto;

import java.util.List;

import lombok.Data;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn.mapp.dto
 * - 파일명        : OffPointMapDTO.java
 * - 작성일        : 2018. 7. 17.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 - ERP 오프라인 포인트 사용정보 매핑 검색조건/결과용 DTO
 * </pre>
 */
@Data
public class OffPointMapDTO {

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
	 * ERP 포인트 로그 번호 - 순번 (조회용)
	 */
	private List<String> erpSeqNoList;
	
	/**
	 * ERP 포인트 로그 번호 - 순번 (저장용)
	 */
	private String erpSeqNo;
	
	/**
	 * 삭제여부
	 */
//	private String delYn;
}
