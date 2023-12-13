package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 상품 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsVO extends BaseModel<GoodsVO> {
    // 상품 번호
    private String goodsNo;
    // 판매자 번호
    private String sellerNo;
    // 판매자 명
    private String sellerNm;
    // 상품 명
    private String goodsNm;
    // 브랜드
    private String brand;
    // 브랜드 번호
    private String brandNo;
    // 브랜드 명
    private String brandNm;
    // 요약상품명
    private String smrGoodsNm;
    // 상품 흥보 문구
    private String prWords;
    // 판매 율
    private String saleRate;
    // 태그 이미지
    private String tagImg;
    // 단품 번호
    private String itemNo;
    // 단품 명
    private String itemNm;
    // 상품 이미지 02
    private String goodsImg02;
    // 상품 이미지 03
    private String goodsImg03;
    // 상품 이미지 04
    private String goodsImg04;
    // 상품 이미지 05
    private String goodsImg05;
    // 상품 이미지 06
    private String goodsImg06;
    //상품목록 썸네일 2번째 이미지
    private String goodsThumImg;
    // 상품 전시 이미지 A
    private String goodsDispImgA;
    // 상품 전시 이미지 B
    private String goodsDispImgB;
    // 상품 전시 이미지 C
    private String goodsDispImgC;
    // 상품 전시 이미지 D
    private String goodsDispImgD;
    // 상품 전시 이미지 E
    private String goodsDispImgE;
    // 상품 전시 이미지 F
    private String goodsDispImgF;
    // 상품 전시 이미지 G
    private String goodsDispImgG;
    // 상품 전시 이미지 S
    private String goodsDispImgS;
    // 상품 전시 이미지 M
    private String goodsDispImgM;
    // 속성 1
    private String attr1;
    // 속성 2
    private String attr2;
    // 속성 3
    private String attr3;
    // 속성 4
    private String attr4;
    // 이미지 경로
    private String imgPath;
    // 110 * 110 상품 프리뷰 이미지
    private String goodsImg01;
    // 단품 품절 여부
    private String itemSoldoutYn;
    // 단품 품절 여부 명
    private String itemSoldoutYnNm;
    // 배송비 설정 코드
    private String dlvrSetCd;
    // 배송비 설정 명
    private String dlvrSetNm;
    // 세금 구분 코드
    private String taxGbCd;
    // 세금 구분 코드 명
    private String taxGbNm;
    // 등록 일자
    private String regDate;
    // 수정 일자
    private String updDate;
    // 속성 버젼
    private int attrVer;
    // 소비자 가격
    private long customerPrice;
    // 판매 가격
    private long salePrice;
    // 판매 가격 (콤마)
    private String commaSalePrice;
    // 공급 가격
    private long supplyPrice;
    // 별도 공급가 적용 여부
    private String sepSupplyPriceYn;
    // 수수료율
    private String commisionRate;
    // 상품별 배송비
    private long goodseachDlvrc;
    // 프로모션 할인율
    private long prmtDcValue;

    // 프로모션 할인 구분 코드
    private String prmtDcGbCd;
    // 프로모션 유형 코드
    private String prmtTypeCd;
    // 상품 판매 상태 코드
    private String goodsSaleStatusCd;
    // 상품 판매 상태 코드 명
    private String goodsSaleStatusNm;
    // 전시 여부
    private String dispYn;
    // 판매 여부
    private String saleYn;
    // 재고 수량
    private int stockQtt;
    // 가용 재고 수량
    private int availStockQtt;
    // 카테고리 정보
    private String ctgArr;
    // 카테고리 수수료율
    private String ctgCmsRateArr;
    // 대표카테고리 여부
    private String dlgtCtgArr;
    // 카테고리명 정보
    private String ctgName;
    // 행번호
    private int rownum;

    private String sortNum;

    // 상품 수정 모드 여부 (상품 등록의 경우 'N' 상품 수정의 경우 'Y')
    private String editModeYn;
    // 카테고리 목록
    private List<String> categoryList;
    // 선택 상품 목록
    private List<String> selectedGoods;
    // tg삭제 여부
    private String tgDelYn;
    // ti삭제 여부
    private String tiDelYn;
    // 사이트 전시 순번
    private String siteDispSeq;
    // 전시 순번
    private String dispSeq;
    // 전시 타이틀
    private String dispTitle;
    // 전시 명
    private String dispNm;
    // 사용 여부
    private String useYn;
    // 전시 유형 코드
    private String dispTypeCd;
    // 우선 순위
    private Long priorRank;
    // 아이콘 이미지 정보
    private String iconImgs;
    // 상품 마켓포인트
    private String goodsSvmnAmt;
    // 기본 마켓포인트여부
    private String goodsSvmnPolicyUseYn;
    // 상품 점수
    private String goodsScore;
    // 상품 리뷰 개수
    private String accmGoodslettCnt;
    // 장바구니 설정 개수
    private String basketSetCnt;
    // 관심 상품 설정 개수
    private String favgoodsSetCnt;
    // 상품 조회수
    private String goodsInqCnt;
    // 카테고리 전시 존 번호
    private String ctgDispzoneNo;
    // 카테고리 전시 전시 유형 코드
    private String ctgDispDispTypeCd;
    // 카테고리 번호
    private String ctgNo;
    // 대표 카테고리 여부
    private String dlgtCtgYn;
    // 노출 우선 순위
    private String expsPriorRank;
    // 삭제 여부
    private String delYn;
    // 성인 인증 여부
    private String adultCertifyYn;
    // 제한 개수
    private String limitCnt;
    // 전시 노출 유형 코드
    private String dispExhbtionTypeCd;
    // 전시 이미지 경로
    private String dispImgPath;
    // 전시 이미지 명
    private String dispImgNm;
    // 전시 정보
    private List<DisplayGoodsVO> displayArr;
    // 전시 상품 정보
    private List<DisplayGoodsVO> displayGoodsArr;
    // SEO 검색용 태그
    private String seoSearchWord;
    // 관련 상품 번호
    private String relateGoodsNo;
    // 관련 상품 이미지(리스트 썸네일)
    private String relateGoodsImg;
    // 서로등록 설정 여부
    private String eachRegSetYn;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;

    //상품유형코드
    private String goodsTypeCd;
    //안경테모양코드
    private String frameShapeCd;
    //안경테재질코드
    private String frameMaterialCd;
    //안경테사이즈코드
    private String frameSizeCd;
    //안경테색상코드
    private String frameColorCd;
    //선글라스모양코드
    private String sunglassShapeCd;
    //선글라스재질코드
    private String sunglassMaterialCd;
    //선글라스색상코드
    private String sunglassColorCd;
    //안구컬러(상단)
    private String sunglassEyeTopColorCd;
    //안구컬러(메탈전체)
    private String sunglassEyeMetalColorCd;
    //다리컬러(다리메탈)
    private String sunglassTempleMetalColorCd;
    //다리컬러(홈선에폭시)
    private String sunglassTempleEpoxyColorCd;
    //팁컬러
    private String sunglassTipColorCd;
    //렌즈컬러
    private String sunglassLensColorCd;
    // 선글라스사이즈코드
    private String sunglassSizeCd;
    //안경렌즈용도코드
    private String glassUsageCd;
    //안경렌즈색상코드
    private String glassColorCd;
    //안경렌즈초점코드
    private String glassFocusCd;
    //안경렌즈기능코드
    private String glassFunctionCd;
    //안경렌즈제조사
    private String glassMmftCd;
    //안경렌즈두께
    private String glassThickCd;
    //안경렌즈설계
    private String glassDesignCd;
    //콘택트렌즈색상코드
    private String contactColorCd;
    //콘택트렌즈착용주기코드
    private String contactCycleCd;
    //콘택트렌즈사이즈코드
    private String contactSizeCd;
    //콘택트렌즈가격코드
    private String contactPriceCd;
    //콘택트렌즈증상코드
    private String contactStatusCd;
    //보청기형태코드
    private String aidShapeCd;
    //보청기난청유형코드
    private String aidLosstypeCd;
    //보청기난청정도코드
    private String aidLossdegreeCd;
    //기획전 전시 존 번호
    private String prmtDispzoneNo;
    //기획전 전시 존 이름
    private String dispzoneNm;
    //기획전 전시유형코드
    private String prmtDispDispTypeCd;
    //예약전용여부
    private String rsvOnlyYn;
    // 증정상품여부
    private String preGoodsYn;
    // 스템프적립
    private String stampYn;
    //메인 전시 영역 구분
	private String mainAreaGbCd;
	//메인 전시 영역 이름
	private String mainAreaGbNm; 
	//메인 전시 마지막 다음순번
	private long nextSiteDispSeq;
	
	//판매자 수수료율
	private int sellerCmsRate;

    private String mallItmCode;
    private String erpItmCode;
    private String mallGoodsNo;
    
    //추가
    private String detailLink;
    //첫구매 특가
    private int firstBuySpcPrice;

    //쿠폰적용가격
    private String couponApplyAmt;
    //쿠폰할인가격
    private String couponDcAmt;
    //쿠폰할인율
    private String couponDcRate;
    //쿠폰적용값
    private String couponDcValue;
    //쿠폰적용구분 코드 (01:율/02:원)
    private String couponBnfCd;

    private String couponBnfValue;

    private String couponBnfTxt;

    private String couponAvlInfo;
    // filter 리스트
    private List<FilterVO> filterList;
    // 상품 정보 업데이트 시간
    private String changeDttm;
    // 상품 정보 업데이트 내용
    private String goodsInfoChangeLog;

    private String multiOptYn;
    private long cost;
}
