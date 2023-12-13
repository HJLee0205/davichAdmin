package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 22.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class CategoryPO extends EditorBasePO<CategoryPO> {
    // 카테고리 번호
    @NotNull(groups = { DeleteGroup.class, UpdateGroup.class })
    private String ctgNo;
    // 카테고리명
    private String ctgNm;
    // 카테고리 타입
    private String ctgType;
    // 카테고리 진열 유형 코드
    private String ctgExhbtionTypeCd;
    // 카테고리 전시 유형 코드
    private String ctgDispTypeCd;
    // 카테고리 전시 ZONE 번호
    private String ctgDispzoneNo;
    // 디폴트 이미지 경로
    private String dftFilePath;
    // 디폴트 이미지명
    private String dftFileName;
    // 마우스오버 이미지 경로
    private String moverFilePath;
    // 마우스오버 이미지명
    private String moverFileName;
    // 카테고리 이미지 경로
    private String ctgImgPath;
    // 카테고리 이미지명
    private String ctgImgNm;
    // 마우스오버 이미지 경로
    private String mouseoverImgPath;
    // 마우스오버 이미지 명
    private String mouseoverImgNm;
    // 카테고리 메인 내용
    private String content;
    // 카테고리 메인 내용 사용 여부
    private String ctgMainUseYn;
    // 등록 카테고리명
    private String[] insCtgNm;
    // 카테고리 레벨
    private String ctgLvl;
    // 상위 카테고리 번호
    private String upCtgNo;
    // 카테고리 정렬순번
    private String sortSeq;
    // 모바일 쇼핑몰 적용 여부
    private String mobileSpmallApplyYn;
    // 기존 카테고리 레벨
    private String orgCtgLvl;
    // 하위 카테고리 번호
    private String downCtgNo;
    // 변경 레벨값 계산
    private int calcLvl;

    /* 노출상품 관리 Start */
    // 전시 상품 노출 여부
    private String dispGoodsExpsYn;
    // 미전시 상품 노출 여부
    private String noDispGoodsExpsYn;
    // 판매중 상품 노출 여부
    private String salemediumGoodsExpsYn;
    // 판매대기 상품 노출 여부
    private String salestnbyGoodsExpsYn;
    // 품절 상품 선택 여부
    private String soldoutGoodsYn;
    // 품절 상품 노출 여부
    private String soldoutGoodsExpsYn;
    // 노출 상품 정렬 코드
    private String expsGoodsSortCd;
    // 상품 번호
    private String goodsNo;
    // 노출 상품 번호
    private String[] goodsNoArr;
    // 대표 카테고리 여부
    private String[] dlgtCtgYnArr;
    // 대표 카테고리 여부
    private String dlgtCtgYn;
    // 전시 여부
    private String[] dispYnArr;
    // 전시 여부
    private String dispYn;
    // 노출 우선 순위
    private String expsPriorRank;
    /* 노출상품 관리 End */

    // 하위 카테고리 번호 목록
    private List<Integer> childCtgNoList;
    // 전시존 번호 목록
    private List<String> dispNoList;

    // 카테고리 일련 번호
    private long ctgSerialNo;
    // 서브 페이지 카테고리 내비게이션 노출 여부
    private String navigExpsYn;

    // 디폴트 이미지 삭제여부
    private String dftDelYn;
    // 마우스오버 이미지 삭제여부
    private String moverDelYn;
    // 사용 여부
    private String useYn;
    // 메인 노출 여부
    private String mainExpsYn;
    // 메인 노출 순번
    private int mainExpsSeq;

    // 카테고리 수수료 율
    private int ctgCmsRate;

    // 하위 카테고리 동일 적용 여부
    private String subCtgCmsRateApplyYn;

    // 필터 적용 여부
    private String filterApplyYn;
    // 필터 유형코드
    private String goodsTypeCd;

    //베스트브랜드 사용여부
    private String bestBrandUseYn;
    //베스트브랜드 번호
    private String bestBrandNo;
    
    // 추천인 카테고리 수수료 율
    private int recomPvdRate;

    // 추천인 하위 카테고리 동일 적용 여부
    private String subCtgRecomPvdRateApplyYn;
    
    // 마켓포인트 지급 설정 구분 코드
    private String ctgSvmnGbCd;

    // 마켓포인트 지급 설정 금액 (1:율, 2:금액)
    private int ctgSvmnAmt;
    
    // 마켓포인트 지급 설정  하위 카테고리 동일 적용 여부
    private String subCtgSvmnApplyYn;
    
    // 마켓포인트 지급 사용 제한 
    private int ctgSvmnMaxUseRate;
    
    // 마켓포인트 사용 제한  하위 카테고리 동일 적용 여부
    private String subCtgMaxUseRateApplyYn;

    // 상품 컨텐츠 구분 코드
    private String goodsContsGbCd;

    // 전시상품 번호
    private String dispZoneGoods;

    // 목록배너 이미지명
    private String[] pcBannerImgNmArr;
    private String[] mobBannerImgNmArr;
}
