package net.danvi.dmall.biz.ifapi.mem.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OffPointHistorySearchResDTO.java
 * - 작성일        : 2018. 5. 29.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 증감내역 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointHistorySearchResDTO extends BaseResDTO {

	/**
	 * 데이터 총 개수
	 */
	private int totalCnt = 0;
	/**
	 * 포인트 증감내역 리스트
	 */
	private List<PointHistoryDTO> dealList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
	 * - 파일명        : PointHistorySearchResDTO.java
	 * - 작성일        : 2018. 5. 29.
	 * - 작성자        : CBK
	 * - 설명          : 포인트 증감내역 DTO
	 * </pre>
	 */
	@Data
	public static class PointHistoryDTO {
		
		/**
		 * 거래일자
		 */
		private String dealDate;
		
		/**
		 * 거래 가맹점명
		 */
		private String strName;
		
		/**
		 * 취소구분 (정상/반품)
		 */
		private String cancType;
		
		/**
		 * 입력구분(누적/통합/소멸/변경/사용)
		 */
		private String inFlag;
		
		/**
		 * 구매금액
		 */
		private int salAmt;
		
		/**
		 * 발생포인트
		 */
		private int salPoint;
		
		/**
		 * 사용포인트
		 */
		private int usePoint;
		
		/**
		 * 보유포인트
		 */
		private int curPoint;
	}
}
