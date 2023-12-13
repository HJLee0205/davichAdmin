package net.danvi.dmall.biz.ifapi.mem.dto;


import lombok.Data;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;

import java.util.List;

/**
 * 2023-06-05 210
 * 포인트 적립이나 취소 등 을 담아 파라메터로 던져줄 클래스
 * **/
@Data
public class MemberDPointCtVO {
    private String dType;//포인트 발생 이벤트 종 MemberDPointErpVO 여기 디파인참고
    private int subType;//이건 각 포인트 기능마다 서브 타입으로 함수 에서 처리하는 곳마다 다르게설정하면됨
    private long salDpoint;//발생 포인트

    private String cdCust;//erp 회원 번호
    private String memberCardNo;//회원몰카드번호
    private String strCode;//회원 가맹점 코드
    private Long memberNo;//회원 마켓 번호

    private String goodsNo;//상품 번호

    private long ordNo;//주문번호
    private String paymentWayCd;//결제수단코드 22신용카드 23가상계좌 그런거
    private long goodsSvmnAmt;//상품에 분배된 적립 포인트
    private long saleAmt;//상품 판매원 금액
    private long dcAmt;//할인금액
    private long goodsDmoneyUseAmt;//상품에 분배된 사용한 포인트가있다면 포인트
    private long dlvrAmt;//상품결제 당시 사용된 배송비
    private String[] ordDtlSeqArr;//특정 상품의 시퀀스번호

    private List<OrderGoodsPO> orderGoodsPOS;//적립,사용,취소 할 상품 PO
    private List<OrderGoodsVO> orderGoodsVOS;//적립,사용,취소 할 상품 VO
}
