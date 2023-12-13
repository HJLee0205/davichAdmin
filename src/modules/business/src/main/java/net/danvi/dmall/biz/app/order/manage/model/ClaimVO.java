package net.danvi.dmall.biz.app.order.manage.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 31.
 * 작성자     : dong
 * 설명       : 클레임
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ClaimVO extends BaseModel<OrderVO> {

    private ClaimInfoPO claimInfoPO;// 환불정보
    private List<ClaimGoodsVO> claimGoodsVO;// 환불상품정보
    private ClaimPayRefundVO claimPayRefundVO;// 결제환불정보
    private List<ClaimPayRefundVO> claimPayRefundList;// 결제환불정보

    private String claimNo;
    private String ordNo;
    private String ordDtlSeq;
    private String claimContentChk;
    private String goodsNm;
    private String itemNm;
    // 배송비
    private String realDlvrAmt;
}
