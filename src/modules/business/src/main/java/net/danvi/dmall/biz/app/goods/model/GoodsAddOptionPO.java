package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import javax.validation.Valid;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 12.
 * 작성자     : kwt
 * 설명       : 상품 추가옵션 정보 Parameter Object 
 *              BO 상품등록 화면으로 부터 JSON형태로 추가옵션 등록정보를 받는다.
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsAddOptionPO extends BaseModel<GoodsAddOptionPO> {
    // 상품번호
    private String goodsNo;
    // 추가 옵션 번호
    private long addOptNo;
    // 추가 옵션 명
    @NotEmpty
    private String addOptNm;
    // 필수 여부
    private String requiredYn;
    // 추가옵션 등록, 수정 구분 (I:신규등록, U:수정항목)
    private String registFlag;
    // 추가옵션값 리스트
    @Valid
    private List<GoodsAddOptionDtlPO> addOptionValueList;
}
