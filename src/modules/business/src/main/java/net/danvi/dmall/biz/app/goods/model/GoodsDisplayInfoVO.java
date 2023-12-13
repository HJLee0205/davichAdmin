package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdVO;
import dmall.framework.common.model.BaseSearchVO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;

import javax.validation.Valid;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : BO 상품 등록 초기 화면 구성 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsDisplayInfoVO extends BaseSearchVO<GoodsDisplayInfoVO> {
    // 상품 번호
    private String goodsNo;
    // 처리 성공여부
    private Boolean success;

    // 사이트 설정 상품상세 이미지 넓이
    private int goodsDefaultImgWidth;
    // 사이트 설정 상품상세 이미지 높이
    private int goodsDefaultImgHeight;
    // 사이트 설정 상품리스트 이미지 넓이
    private int goodsListImgWidth;
    // 사이트 설정 상품리스트 이미지 높이
    private int goodsListImgHeight;

    // 성인 인증 설정 여부 (성인 인증 수단이 설정되어 있으면 'Y', 성인 인증 수단이 없으면 'N')
    private String isAdultCertifyConfig;

    // 상품 고시정보 리스트(고시항목)
    private List<GoodsNotifyVO> notifyOptionList;
    // 상품 고시정보 값
    private List<GoodsNotifyVO> goodsNotifyItemList;
    // 브랜드 리스트
    private List<FilterVO> filterList;
    // 브랜드 리스트
    private List<BrandVO> brandList;
    // 아이콘 리스트
    private List<GoodsIconVO> goodsIconList;
    // HS코드 리스트
    private List<HscdVO> hscdList;
    // 최근등록 옵션 리스트
    private List<GoodsOptionVO> goodsOptionList;

    // 비전체크 군정보
    private List<VisionGunVO> gunList;
    
}
