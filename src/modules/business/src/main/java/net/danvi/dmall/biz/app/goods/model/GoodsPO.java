package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 상품 정보 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsPO extends BaseModel<GoodsPO> {
    // 상품 번호
    @NotNull(groups = { DeleteGroup.class, UpdateGroup.class })
    private String goodsNo;
    // 상품 판매 상태 코드
    private String goodsSaleStatusCd;
    // 판매 가격
    private long salePrice;
    // 재고 수량
    private Long stockQtt;
    // 공급 가격
    private long supplyPrice;
    // item 번호
    private String itemNo;
    // 전시 여부
    private String dispYn;
    // 삭제 여부
    private String delYn;
    // 판매 여부
    private String saleYn;
    // 품절시 삭제 여부
    private String soldOutDeleteYn;
    // 예상 배송 소요일
    private Long dlvrExpectDays;
    // 배송 설정 코드
    private String dlvrSetCd;
    // 상품별 배송비
    private String goodseachDlvrc;
    // 상품별 조건부 배송비
    private String goodseachcndtaddDlvrc;
    // 무료배송 최소 금액
    private String freeDlvrMinAmt;
    // 포장 최대 단위
    private String packMaxUnit;
    // 포장 단위 배송비
    private String packUnitDlvrc;
    // 이벤트 안내문
    private String eventWords;
    // 택배 배송
    private String couriDlvrApplyYn;
    // 직접 수령
    private String directRecptApplyYn;
    // 상품 판매 시작일
    private String saleStartDt;
    // 상품 판매 종료일
    private String saleEndDt;
    // 무한 판매 여부
    private String saleForeverYn;
    // 상품 아이콘 번호
    private String iconNo;
    // 상품 아이콘
    private String goodsIcon;
    // 판매승인 여부
    private String aprvYn;
    // 상품명
    private String goodsNm;
    // 판매가 적용 시작일
    private String dcStartDttm;
    // 판매가 적용 종료일
    private String dcEndDttm;
    // 판매가 무제한 적용 여부
    private String dcPriceApplyAlwaysYn;
}
