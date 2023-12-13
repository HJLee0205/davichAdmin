package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : StoreSearchReqDTO.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 가맹점 목록 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreSearchReqDTO extends BaseReqDTO {
	
	/**
	 * 가맹점 이름
	 */
	private String strName;
	
	/**
	 * 시도 코드
	 */
	private String sidoCode;
	
	/**
	 * 구군 코드
	 */
	private String gugunCode;
	
	/**
	 * 매장수령 가능여부
	 */
	private String recvAllowYn;
	
	/**
	 * 보청기 취급여부
	 */
	private String hearingAidYn;
	
	/**
	 * 다비전코드
	 */
	private String erpItmCode;
	private String [] arrErpItmCode;
	
	/**
	 * 가맹점 코드 목록
	 */
	private String strCodeList;

	/**
	 * 페이지번호 (zero-base)
	 */
	private Integer pageNo = 0;
	
	/**
	 * 페이지당 표시할 데이터 개수
	 */
	private Integer cntPerPage = 10;
}
