package net.danvi.dmall.biz.ifapi.mem.dto;


import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 2023-06-01 210
 * DPoint ERP 페이징 조회를 위
 * **/

@Data
@EqualsAndHashCode(callSuper = false)
public class MemberDPointErpSO extends BaseSearchVO<MemberDPointErpSO> {
    private String cdCust;
    private String memberNo;
    private String stRegDttm;
    private String endRegDttm;
    private String goodsNo;//상품 번호
    private String ordNo;//주문번호
    private long ordSeq;//결제나 취소 같은 경우는 해당 상품의 주문 시퀀스가 있다 구분하기위해
}
