package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OffPointUseDTO.java
 * - 작성일        : 2018. 7. 17.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 사용/취소 데이터 저장용 DTO
 * </pre>
 */
@Data
public class OffPointUseDTO {
	
	public OffPointUseDTO() {}
	public OffPointUseDTO(OffPointUseReqDTO dto) {
		this.setDates(dto.getOrderDate());
		this.setCdCust(dto.getCdCust());
		this.setCancType("0");	// 취소구분 :정상
	}

	/**
	 * 영업일자
	 */
	private String dates;
	
	/**
	 * 회원코드
	 */
	private String cdCust;
	
	/**
	 * 순번
	 */
	private String seqNo;
	
	/**
	 * 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 포인트 사용 가맹점 코드
	 */
	private String strCodeTo;
	
	/**
	 * 거래번호 (영업일자,가맹점코드, 포인트사용가맹점 코드 별로 000001부터)
	 */
	private String trxnNo;
	
	/**
	 * 취소구분 (0:정상, 2:반품)
	 */
	private String cancType;
	
	/**
	 * 사용포인트
	 */
	private Integer usePointAmt;
}
