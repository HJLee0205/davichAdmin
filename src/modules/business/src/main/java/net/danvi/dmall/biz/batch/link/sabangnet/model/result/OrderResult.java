package net.danvi.dmall.biz.batch.link.sabangnet.model.result;

import lombok.Data;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방네 연계 주문 수집을 위한 클래스
 * </pre>
 */
@Data
public class OrderResult extends SabangnetData {
    private static final long serialVersionUID = 8961385435153944959L;

    private String ifSno;
    private String ifNo;
    private String ifId;
    private Long siteNo;

    private String idx;
    private String orderId;
    private String ordNo;
    private String mallId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mallUserId;
    private String orderStatus;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String userName;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String userTel;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String userCel;
    private String userEmail;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiveTel;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiveCel;
    private String delvMsg;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiveName;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiveZipcode;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiveAddr;
    private String totalCost;
    private String payCost;
    private String orderDate;
    private String pProductName;
    private String pSkuValue;
    private String saleCost;
    private String saleCnt;
    private String deliveryMethodStr;
    private String delvCost;
    private String compaynyGoodsCd;
    private String orderGubun;
    private String copyIdx;
    private String regDate;
    private String ordConfirmDate;
    private String rtnDt;
    private String chngDt;
    private String deliveryConfirmDate;
    private String cancelDt;
    private String deliveryId;
    private String invoiceNo;

    private Long regrNo;
    private Long updrNo;

}
