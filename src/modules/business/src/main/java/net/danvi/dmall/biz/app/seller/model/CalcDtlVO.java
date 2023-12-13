package net.danvi.dmall.biz.app.seller.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CalcDtlVO extends BaseModel<CalcDtlVO> {
    private String rowNum;
    private String rwn;
    private String calculateNo;
    private String calculateDtlNo;
    private String calculateStndrdDt;
    private String ordrNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    private String ordDttm;
    private String ordNo;
    private String ordDtlSeq;
    private String ordGoodsNo;
    private String goodsNm;
    private String dlvrAmt;
    private String paymentAmt;
    private String sellerCmsRate;
    private String integrationPointUseAmt;
    private String moneyUseAmt;
    private String moneyAccuAmt;
    private String moneyRecomAccuAmt;
    private String dMoneyUseAmt;
    private String dMoneyAccuAmt;
    private String dMoneyRecomAccuAmt;
    private String cpDcAmt;
    private String memberGradeDcGbCd;
    private String memberGradeDcValue;
    private String memberGradeDcAmt;
    private String prmtDcGbCd;
    private String prmtDcValue;
    private String prmtDcAmt;
    private String dcAmt;
    private String ltPvdAmt;
    private String courierNm;
    private String invoiceNo;
    private String calculateGb;
    private String purchaseAmt;
    private String saleChannel;
    private String ordQtt;
    private String paymentWayCd;
    private String calculateDttm;
    private String calculateStartdt;
    private String calculateEnddt;
    private String calculateStatusCd;
    private String sellerNo;
    private String sellerNm;
    private String storeNo;
    private String storeNm;
    private String paymentCmpltDttm;
    private String paymentWayNm;
    private String paymentPgCd;
    private String paymentPgNm;

    private String saleAmt;
    private String supplyAmt;
    private String commIncomeAmt;
    private String cpApplyAmt;
    
}
