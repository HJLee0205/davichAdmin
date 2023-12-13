package net.danvi.dmall.biz.app.order.reservation.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2023. 7. 3.
 * 작성자     : slims
 * 설명       : 예약정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ReservationExcelVO extends BaseModel<ReservationExcelVO> {

    private String rownum;
    private String sortNum;

    /*방문예약*/
    private String rsvNo;
    private String storeNo;
    private String storeNm;
    private Long memberNo;

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;

    private String rsvDate;
    private String rsvTime;
    private String reqMatr;
    private String visitPurposeCd;
    private String visitPurposeNm;
    private String visitStatusCdNm;
    private String cancelYn;
    private String strVisitDate;
    private String checkupYn;
    private String managerMemo;
    private String visitYn;
    private Integer ordCnt;

    /** 주문자 ID */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
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
    private String saleAmt;
    private String dcAmt;
    private String imgPath;
    private String sellerNm;
    private String pamentAmt;
    private String ordrNm;
    private String ctgName;
    private String goodsTypeCd;

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

    private String rsvNoO;
    private String rsvDateO;
    private String rsvTimeO;
    private String cancelYnO;
    private String storeNmO;
    private String visitYnO;

    private String visitStatusCd;
    private String visitStatusNm;
    private String rsvDttm;
    private String salePrice;
    private String supplyPrice;
    private String vstrNm;
    private String goodsTypeCdNm;
    private String buyYn;

    private String payAmt;
    private String cancelPossible;
    // 처리타입 (D:예약취소 / U:수정)
    private String prcType;

}
