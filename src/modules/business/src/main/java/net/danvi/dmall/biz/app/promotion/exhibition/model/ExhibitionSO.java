package net.danvi.dmall.biz.app.promotion.exhibition.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 기획전 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ExhibitionSO extends BaseSearchVO<ExhibitionSO> {
    private int prmtNo;
    private String searchStartDate; // 검색시작일
    private String searchEndDate; // 검색종료일
    private String periodSelOption; // 기간검색 옵션 : 시작일/종료일
    private String prmtStatusCd; // 기획전상태
    private String[] prmtStatusCds;
    private String searchWords;
    private String goodsNo;
    private String[] goodsNoArr;
    private String goodsNos;

    private String ctgNoArr; /* goodsController에서 사용 */
    private int pageNoOri; // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)
    // 전시유형타입
    private String displayTypeCd;
    // 기획전 전시존 번호
    private String prmtDispzoneNo;
    // 기획전 전시존 이름
    private String prmtDispzoneNm;
    // 사용여부
    private String useYn;
    // 세일여부
    private String saleYn;
    /*
     * 2016.09.02. 사용하지 않는 빈. 일주일 후 삭제 예정
     * private int ctgNo;
     * private String searchTypeCd; //
     * private String prmtCndtCd;
     */

     private String prmtBrandNo; // 브랜드번호
     private String prmtDscrt; //기획전 설명글
     private String prmtMainExpsUseYn; //메인노출 사용여부
     private String ageCd;	//연령대

    private String[] goodsTypeCds;	//상품군
    private String goodsTypeCd;
    private String[] prmtTypeCds;	//유형
    private String[] prmtMainExpsUseYns;	//노출 여부

    private String goodsTypeCdSelectAll;
}
