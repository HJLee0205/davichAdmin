package net.danvi.dmall.biz.ifapi.rsv.dto;
import lombok.Data;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : PreorderRegDTO.java
 * - 작성일        : 2018. 7. 2.
 * - 작성자        : CBK
 * - 설명          : 사전예약 정보 DB등록을 위한 DTO
 * </pre>
 */
@Data
public class PreorderRegDTO {

	/**
	 * ERP 사전예약 기획전 번호
	 */
	private String erpPrmtNo;

	/**
	 * 사전예약 접수 순번
	 */
	private int receiptSeq;

	/**
	 * 상품 순번
	 */
	private int itmSeq;
	
	/**
	 * 기획전 명
	 */
	private String prmtName;
	
	/**
	 * 기획전 시작일
	 */
	private String prmtSDate;
	
	/**
	 * 기획전 종료일
	 */
	private String prmtEDate;
	
	/**
	 * 고객명
	 */
	private String custName;
	
	/**
	 * 고객 휴대폰
	 */
	private String custHp;
	
	/**
	 * 고객 생일
	 */
	private String custBirthday;
	
	/**
	 * 개인정보 동의 여부
	 */
	private String custAgreeYn;
	
	/**
	 * 가맹점 코드
	 */
	private String strCode;
	
	/**
	 * 수령 요청 일자
	 */
	private String reqDate;
	
	/**
	 * ERP 상품 코드
	 */
	private String erpItmCode;
	
	/**
	 * 상품 정보 - sph
	 */
	private String sph;
	
	/**
	 * 상품정보 - cyl
	 */
	private String cyl;
	
	/**
	 * 상품정보 - bc
	 */
	private String bc;
	
	/**
	 * 상품정보 - axis
	 */
	private String axis;
	
	/**
	 * 주문 수량
	 */
	private Integer qty;
	
}
