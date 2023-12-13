package net.danvi.dmall.biz.app.seller.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

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
public class CalcVO extends BaseModel<CalcVO> {
    private String rowNum;
    private String calculateNo;
    private String calcPeriod;
    private String calculateStartdt;
    private String calculateEnddt;
    private String calculateDttm;
    private String sellerNo;
    private String sellerNm;
    private String paymentAmt;
    private String cmsTotal;
    private String calculateAmt;
    private String taxAmt;
    private String notaxAmt;
    private String dlvrAmt;
    private String deductAmt;
    private String taxSum;
    private String notaxSum;
    private String totalSum;
    
    private String calculateStatusCd;
    private String calculateStatusNm;
    private String confirmYn;
    private Long updrNo;
    
    
    
    

}
