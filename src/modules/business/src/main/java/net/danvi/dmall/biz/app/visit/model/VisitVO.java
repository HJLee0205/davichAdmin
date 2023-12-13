package net.danvi.dmall.biz.app.visit.model;

import java.util.Date;

import org.springframework.http.ResponseEntity;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 11.
 * 작성자     : khy
 * 설명       : 방문예약내역
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisitVO extends BaseModel<VisitVO> {
    private String rownum;

    /*방문예약*/
    private String rsvNo;
    private String storeNo;
    private String storeNm;
    private Long memberNo;
    
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    
    private Date rsvDate;
    private String rsvTime;
    private String reqMatr;
    private String visitPurposeCd;
    private String visitPurposeNm;
    private String cancelYn;
    private String strVisitDate;
    private String checkupYn;
    
    private Integer ordCnt;
    
    /*방문예약 - 예약상품목록 */
    private Integer rsvDtlSeq;
    private String rsvGb;
    private String ordNo;
    private String ordAcceptDttm;
    private Integer ordDtlSeq;
    private String goodsNo;
    private String goodsNm;
    private String itemNo;
    private String itemNm;
    private Integer ordQtt;
    private Long saleAmt;
    private Long dcAmt;
    private String imgPath;
    
    /*방문예약 - 추가옵션목록 */
    private Integer addOptNo;
    private String addOptNm;
    private Integer addOptDtlSeq;
    private Long addOptAmt;
    private String addOptAmtChgCd;
    private Long addOptBuyQtt;
    private String addOptYn;
    
    private String strRsvDate;
    
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String email;
    
    
    /**
	 * 업체 순번
	 */
	private String seqNo;
	
	/**
	 * 업체명
	 */
	private String venName;
	
	/**
	 * 제휴 혜택
	 */
	private String cont;
	
	/**
	 * 할인율
	 */
	private String dcRate;
	
	/**
	 * 제휴사 이미지
	 */
	private byte[] logoImage;
	
	/**
	 * 제휴사 이미지명
	 */
	private String logoImageName;
	
	/**
	 * 제휴사 URL
	 */
	private String venUrl;


	private String noMemberNm;
    private String noMemberMobile;
    
}
