package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

import java.io.Serializable;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CategoryVO extends EditorBaseVO<CategoryVO> implements Serializable {
    private static final long serialVersionUID = -5690380754596710758L;

    /* 카테고리 리스트 조회(트리구조) start */
    // 카테고리 번호
    private String id;
    // 부모 카테고리 번호
    private String parent;
    // 카테고리명
    private String text;
    /* 카테고리 리스트 조회(트리구조) end */

    // 카테고리 전시 ZONE 번호
    private String ctgDispzoneNo;
    // 카테고리레벨
    private String ctgLvl;
    // 상위카테고리 번호
    private String upCtgNo;
    // 카테고리번호
    private String ctgNo;
    // 카테고리명
    private String ctgNm;
    // 카테고리 타입
    private String ctgType;
    // 카테고리 진열 유형 코드
    private String ctgExhbtionTypeCd;
    // 카테고리 이미지 경로
    private String ctgImgPath;
    // 카테고리 이미지명
    private String ctgImgNm;
    // 마우스오버 이미지 경로
    private String mouseoverImgPath;
    // 마우스오버 이미지 명
    private String mouseoverImgNm;
    // 카테고리 전시 유형 코드
    private String ctgDispTypeCd;
    // 카테고리 등록 상품 수
    private String ctgGoodsCnt;
    // 카테고리 판매중 상품 수
    private String ctgSalesGoodsCnt;
    // 카테고리 명 이미지 가로 크기
    private String ctgNmImgWidth;
    // 카테고리 명 이미지 세로 크기
    private String ctgNmImgHeight;
    // 마우스오버 이미지 가로 크기
    private String mouseoverImgWidth;
    // 마우스오버 이미지 세로 크기
    private String mouseoverImgHeight;
    // 카테고리 메인 내용
    private String content;
    // 카테고리 메인 사용 여부
    private String ctgMainUseYn;
    // 카테고리 타입,  M:필수 카테고리
    private String ctgRequire;

    /* 노출상품 관리 Start */
    // 전시 상품 노출 여부
    private String dispGoodsExpsYn;
    // 미전시 상품 노출 여부
    private String noDispGoodsExpsYn;
    // 판매중 상품 노출 여부
    private String salemediumGoodsExpsYn;
    // 판매대기 상품 노출 여부
    private String salestnbyGoodsExpsYn;
    // 품절 상품 노출 여부
    private String soldoutGoodsExpsYn;
    // 노출 상품 정렬 코드
    private String expsGoodsSortCd;
    // 상품 번호
    private String goodsNo;
    // 상품 이미지 경로
    private String imgPath;
    // 상품 이미지 명
    private String imgNm;
    // 상품 명
    private String goodsNm;
    // 상품 판매 상태 코드
    private String goodsSaleStatusCd;
    // 상품 판매 상태 명
    private String goodsSaleStatusNm;
    // 전시 여부
    private String dispYn;
    // 전시 여부 명
    private String dispNm;
    // 대표카테고리 여부
    private String dlgtCtgYn;
    // 노출 순서
    private String expsPriorRank;
    // 상품가격
    private long salePrice;
    // 할인전가격
    private long customerPrice;
    // 상품 구매횟수
    private String buyCnt;
    /* 노출상품 관리 End */

    // 삭제 여부
    private String delYn;
    // 사용 여부
    private String useYn;
    // 메인 노출 여부
    private String mainExpsYn;
    // 메인 노출 순번
    private String mainExpsSeq;
    // 서브 페이지 카테고리 내비게이션 노출 여부
    private String navigExpsYn;

    // 카테고리 수수료 율
    private int ctgCmsRate;

    // 추천인 수수료 율
    private int recomPvdRate;
    
    // 마켓포인트 지급 구분 코드 (1:율, 2:금액)
    private String ctgSvmnGbCd;
    // 마켓포인트 지급 금액
    private int ctgSvmnAmt;
    
    // 마켓포인트 사용 제한 
    private int ctgSvmnMaxUseRate;
    
    // 필터 적용 여부
    private String filterApplyYn;
    // 필터 유형코드
    private String goodsTypeCd;
    //베스트브랜드 사용여부
    private String bestBrandUseYn;
    //베스트브랜드 번호
    private String bestBrandNo;
    
    //배너 카테고리 조회용
    private String dtlNm;
    private String dtlCd;

    // 상품 컨텐츠 구분 코드
    private String goodsContsGbCd;
    
    private String brandNm;
    //카테고리 최종레벨
    private String maxLvl;

    // 전시상품
    private List<GoodsVO> dispGoodsList;
    // 배너 이미지
    private List<CtgImgPO> imgList;
}
