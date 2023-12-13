package net.danvi.dmall.biz.app.goods.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBasePO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 상세 정보 설정 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsDetailPO extends EditorBasePO<GoodsDetailPO> {
    // 단품 번호
    private String itemNo;
    // 모뎔 명
    private String modelNm;
    // 판매 여부
    private String saleYn;
    // 상품 추가 정보 사용 여부
    private String goodsAddInfoUseYn;
    // 모바일 전시 여부
    private String mobileDispYn;
    // 추가 옵션 사용 여부
    private String addOptUseYn;
    // 다중 옵션 여부
    private String multiOptYn;
    // 고시 번호
    private String notifyNo;
    // 고시 정보 (이전)
    private String prevGoodsNotifyNo;
    // 서비스 구분 코드
    private String svcGbCd;
    // 상품 내용
    private String content;
    // 상품 내용 (모바일)
    private String mobileContent;
    // 원산지
    private String habitat;
    // 제조사
    private String mmft;
    // 모바일용 추가 2016-08-18 - 모바일 여부
    private String mobileModeYn;
    // 옵션 생성, 변경 FLAG ("C"- 옵션 새로 생성, "U"-옵션 불러오기)
    private String changeFlag;
    // 상품번호
    private String goodsNo;
    // 상품명
    private String goodsNm;
    // 요약상품명
    private String smrGoodsNm;
    // 입고예정일정
    private String inwareScdSch;
    // 간단설명(흥보문구)
    private String prWords;
    // 판매상태
    private String goodsSaleStatusCd;

    // 예약전용여부
    private String rsvOnlyYn;
    // 증정상품여부
    private String preGoodsYn;
    // 스템프적립
    private String stampYn;

    // 재입고알림 사용여부
    private String reinwareApplyYn;
    // 예약구매여부
    private String rsvBuyYn;
    // 전시상태
    private String dispYn;
    // 과세/비과세 (1:과세, 2:비과세)
    private String taxGbCd;
    // 성인상품
    private String adultCertifyYn;
    // 브랜드
    private String brandNo;
    // 브랜드
    private String brandNm;

    // 판매자
    private String sellerNo;

    // 반품가능 여부
    private String returnPsbYn;
    // 최소구매수량 제한여부
    private String minOrdLimitYn;
    // 최소구매수량
    private String minOrdQtt;
    // 최대구매수량 제한여부
    private String maxOrdLimitYn;
    // 최대 구매수량
    private String maxOrdQtt;
    // 마켓포인트설정 기본마켓포인트 사용여부
    private String goodsSvmnPolicyUseYn;
    // 개별마켓포인트
    private String goodsSvmnAmt;
    
    // 마켓포인트설정 기본마켓포인트 정책
    private String goodsSvmnPolicyCd;
    private String goodsSvmnGbCd;
    
    private String goodsSvmnMaxUsePolicyCd;
    private long goodsSvmnMaxUseRate;
    
    // 개별마켓포인트 (추천인)
    private String recomPvdRate;
    // 개별마켓포인트 (추천인) 정책
    private String recomPvdPolicyCd;
    // 수출입상품코드
    private String hscode;
    // SEO 검색용 태그
    private String seoSearchWord;
    // 원가
    private Long cost;
    // 소비자가격 (단일 옵션)
    private Long customerPrice;
    // 공급 가격 (단일 옵션)
    private Long supplyPrice;
    // 별도 공급가 적용 여부
    private String sepSupplyPriceYn;
    // 재고 다비전 연동 여부
    private String applyDavisionStockYn;
    // 판매 가격 (단일 옵션)
    private Long salePrice;
    // 재고 수량 (단일 옵션)
    private Long stockQtt;
    // 판매 수량 (단일 옵션)
    private Long saleQtt;
    // 판매 시작 일자
    private String saleStartDt;
    // 판매 종료 일자
    private String saleEndDt;
    // 배송 설정 코드
    private String dlvrSetCd;
    // 배송 예상 소요일
    private String dlvrExpectDays;
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
    // 택배 배송 적용 여부
    private String couriDlvrApplyYn;
    // 직접 수령 적용 여부
    private String directRecptApplyYn;
    // 배송 결제 방식 코드
    private String dlvrPaymentKindCd;
    // 거래 제한 조건
    private String txLimitCndt;
    // 관련상품 적용유형 코드
    private String relateGoodsApplyTypeCd;
    // 관련상품 조건 선택 카테고리1
    private String relectsSelCtg1;
    // 관련상품 조건 선택 카테고리2
    private String relectsSelCtg2;
    // 관련상품 조건 선택 카테고리3
    private String relectsSelCtg3;
    // 관련상품 조건 선택 카테고리4
    private String relectsSelCtg4;
    // 관련상품 조건 선택 카테고리
    private String relateGoodsApplyCtg;
    // 관련상품 조건 판매가격 시작
    private String relateGoodsSalePriceStart;
    // 관련상품 조건 판매가격 종료
    private String relateGoodsSalePriceEnd;
    // 관련상품 조건 판매상태 코드
    private String relateGoodsSaleStatusCd;
    // 관련상품 조건 진열상태 코드
    private String relateGoodsDispStatusCd;
    // 관련상품 조건 정렬기준 코드
    private String relateGoodsAutoExpsSortCd;
    // 유투브 동영상 소스
    private String videoSourcePath;
    // 메세지 처리용
    private String message;
    // 전시 이미지 경로 Type A
    private String dispImgPathTypeA;
    // 전시 이미지 명 Type A
    private String dispImgNmTypeA;
    // 전시 이미지 임시 파일 경로 Type A
    private String dispTempFileNameTypeA;
    // 전시 이미지 사이즈 Type A
    private String dispImgFileSizeTypeA;
    // 전시 이미지 경로 Type B
    private String dispImgPathTypeB;
    // 전시 이미지 명 Type B
    private String dispImgNmTypeB;
    // 전시 이미지 임시 파일 경로 Type B
    private String dispTempFileNameTypeB;
    // 전시 이미지 사이즈 Type B
    private String dispImgFileSizeTypeB;
    // 전시 이미지 경로 Type C
    private String dispImgPathTypeC;
    // 전시 이미지 명 Type C
    private String dispImgNmTypeC;
    // 전시 이미지 임시 파일 경로 Type C
    private String dispTempFileNameTypeC;
    // 전시 이미지 사이즈 Type C
    private String dispImgFileSizeTypeC;
    // 전시 이미지 경로 Type D
    private String dispImgPathTypeD;
    // 전시 이미지 명 Type D
    private String dispImgNmTypeD;
    // 전시 이미지 임시 파일 경로 Type D
    private String dispTempFileNameTypeD;
    // 전시 이미지 사이즈 Type D
    private String dispImgFileSizeTypeD;
    // 전시 이미지 경로 Type E
    private String dispImgPathTypeE;
    // 전시 이미지 명 Type E
    private String dispImgNmTypeE;
    // 전시 이미지 임시 파일 경로 Type E
    private String dispTempFileNameTypeE;
    // 전시 이미지 사이즈 Type E
    private String dispImgFileSizeTypeE;

    // 전시 이미지 경로 Type F
    private String dispImgPathTypeF;
    // 전시 이미지 명 Type F
    private String dispImgNmTypeF;
    // 전시 이미지 임시 파일 경로 Type F
    private String dispTempFileNameTypeF;
    // 전시 이미지 사이즈 Type F
    private String dispImgFileSizeTypeF;

    // 전시 이미지 경로 Type G
    private String dispImgPathTypeG;
    // 전시 이미지 명 Type G
    private String dispImgNmTypeG;
    // 전시 이미지 임시 파일 경로 Type G
    private String dispTempFileNameTypeG;
    // 전시 이미지 사이즈 Type G
    private String dispImgFileSizeTypeG;

    // 전시 이미지 경로 Type S
    private String dispImgPathTypeS;
    // 전시 이미지 명 Type S
    private String dispImgNmTypeS;
    // 전시 이미지 임시 파일 경로 Type S
    private String dispTempFileNameTypeS;
    // 전시 이미지 사이즈 Type S
    private String dispImgFileSizeTypeS;

    // 전시 이미지 경로 Type M
    private String dispImgPathTypeM;
    // 전시 이미지 명 Type M
    private String dispImgNmTypeM;
    // 전시 이미지 임시 파일 경로 Type M
    private String dispTempFileNameTypeM;
    // 전시 이미지 사이즈 Type M
    private String dispImgFileSizeTypeM;
    
    // 전시 이미지 경로 Type O
    private String dispImgPathTypeO;
    // 전시 이미지 명 Type O
    private String dispImgNmTypeO;
    // 전시 이미지 임시 파일 경로 Type O
    private String dispTempFileNameTypeO;
    // 전시 이미지 사이즈 Type O
    private String dispImgFileSizeTypeO;
    
    // 전시 이미지 경로 Type P
    private String dispImgPathTypeP;
    // 전시 이미지 명 Type P
    private String dispImgNmTypeP;
    // 전시 이미지 임시 파일 경로 Type P
    private String dispTempFileNameTypeP;
    // 전시 이미지 사이즈 Type P
    private String dispImgFileSizeTypeP;

    public GoodsDetailPO() {
        this.goodsCtgList = new ArrayList<>();
        this.goodsAddOptionList = new ArrayList<>();
        this.goodsItemList = new ArrayList<>();
        this.goodsIconList = new ArrayList<>();
        this.optionList = new ArrayList<>();
        this.goodsNotifyList = new ArrayList<>();
        this.goodsImageSetList = new ArrayList<>();
        this.relateGoodsList = new ArrayList<>();
    }

    // 선택된 카테고리
    @Valid
    private List<GoodsCtgPO> goodsCtgList;

    public List<GoodsCtgPO> getGoodsCtgList() {
        return goodsCtgList;
    }

    // 선택된 아이콘
    @Valid
    private List<GoodsIconPO> goodsIconList;

    public List<GoodsIconPO> getGoodsIconList() {
        return goodsIconList;
    }

    // 상품 단품 정보
    @Valid
    private List<GoodsItemPO> goodsItemList;

    public List<GoodsItemPO> getGoodsItemList() {
        return goodsItemList;
    }

    // 옵션 정보
    @Valid
    private List<GoodsOptionPO> optionList;

    public List<GoodsOptionPO> getOptionList() {
        return optionList;
    }

    // 추가옵션 정보
    @Valid
    private List<GoodsAddOptionPO> goodsAddOptionList;

    public List<GoodsAddOptionPO> getGoodsAddOptionList() {
        return goodsAddOptionList;
    }

    // 상품 고시 정보
    @Valid
    private List<GoodsNotifyPO> goodsNotifyList;

    public List<GoodsNotifyPO> getGoodsNotifyList() {
        return goodsNotifyList;
    }

    // 이미지 정보
    @Valid
    private List<GoodsImageSetPO> goodsImageSetList;

    public List<GoodsImageSetPO> getGoodsImageSetList() {
        return goodsImageSetList;
    }

    // 착용샷 이미지 정보
    @Valid
    private List<WearImageSetPO> goodsWearImageSetList;

    public List<WearImageSetPO> getWearImageSetList() {
        return goodsWearImageSetList;
    }

    // 착용샷 정보
    @Valid
    private List<WearImageDtlPO> goodsWearInfoList;

    public List<WearImageDtlPO> getWearInfoList() {
        return goodsWearInfoList;
    }

    // 관련상품 정보(직접선정의 경우)
    @Valid
    private List<GoodsRelateGoodsPO> relateGoodsList;

    public List<GoodsRelateGoodsPO> getRelateGoodsList() {
        return relateGoodsList;
    }

    // 쿠폰 조회용 카테고리 배열 String
    private String couponCtgNoArr;
    // JSON STRING
    private String jsonStr;
    // 화면 처리용
    private String undefined;
    // 카테고리 3
    private String ctgNm3;
    // 카테고리 4
    private String ctgNm4;
    // 품절시 삭제 여부
    private String soldOutDeleteYn;


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
    //선글라스사이즈코드
    private String sunglassSizeCd;
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
    //안경렌즈용도코드
    private String glassUsageCd;
    //안경렌즈색상코드
    private String glassColorCd;
    //안경렌즈초점코드
    private String glassFocusCd;
    //안경렌즈제조사코드
    private String glassMmftCd;
    //안경렌즈두께코드
    private String glassThickCd;
    //안경렌즈설계코드
    private String glassDesignCd;
    //안경렌즈기능코드
    private String glassFunctionCd;
    //콘택트렌즈색상코드
    private String contactColorCd;
    //콘택트렌즈착용주기코드
    private String contactCycleCd;
    //콘택트렌즈재질코드
    private String contactMaterialCd;
    //콘택트렌즈초점코드
    private String contactFocusCd;
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
    // 가상착장여부
    private String virtOutingYn;
    // 다비젼 상품코드
    private String erpItmCode;
    // 단품 리스트(가격이나 재고 변동이 없는 경우 다비젼상품코드 세팅)
    private List<GoodsItemPO> goodsItemErpItmCodeList;

    // 비전체크 군정보
    @Valid
    private List<VisionGunVO> gunList;

    // 상품 컨텐츠 구분 코드
    private String goodsContsGbCd;

    // 네이버 쇼핑 연동 여부
    private String naverLinkYn;

    // 사방넷 연동 여부
    private String sbnLinkYn;

    // 판매 시작 일자 (단일)
    private String dcStartDttm;
    // 판매 종료 일자 (단일)
    private String dcEndDttm;
    // 판매기간 무제한 여부 (단일)
    private String dcPriceApplyAlwaysYn;

    // 스마트 피팅 가능 여부
    private String smfUseYn;
    // 웹 발주 여부
    private String mallOrderYn;
    // 신상품 여부
    private String newGoodsYn;
    // 일반 상품 여부
    private String normalYn;
    // 아이콘 사용 여부
    private String iconUseYn;
    // 스템프 타입 코드 01:10P, 02:20P, 03:30P
    private String goodsStampTypeCd;
    // 상품 판매기간 무제한 여부
    private String saleForeverYn;
    // 관리자 메모
    private String sellerMemo;
    // 이벤트 글
    private String eventWords;
    // 할인율 변경 날짜
    private String goodsDcChangeDttm;


    // 얼굴 PD
    private String facePd;
    // 얼굴 너비
    private String faceWidth;
    // 얼굴형
    private String faceShape;
    // 안경테 사이즈
    private String glassesSize;
    // face code size
    private String fdSize;
    // face code shape
    private String fdShape;
    // face code tone
    private String fdTone;
    // face code style
    private String fdStyle;
    // eye code shape
    private String edShape;
    // eye code size
    private String edSize;
    // eye code style
    private String edStyle;
    // eye code color
    private String edColor;

    // 얼굴 PD
    private String fullSize;
    // 브릿지 길이
    private String bridgeSize;
    // 가로 길이
    private String horizontalLensSize;
    // 세로 길이
    private String verticalLensSize;
    // 다리 길이
    private String templeSize;

    // 아이콘 번호
    private String goodsIcon;
    
    // 선택된 사은품 정보
    @Valid
    private List<GoodsFreebieGoodsPO> freebieGoodsList;

    public List<GoodsFreebieGoodsPO> getFreebieGoodsList() {
        return freebieGoodsList;
    }

    // 선택된 필터
    @Valid
    private List<GoodsFilterPO> goodsFilterList;

    public List<GoodsFilterPO> getGoodsFilterList() {
        return goodsFilterList;
    }
}
