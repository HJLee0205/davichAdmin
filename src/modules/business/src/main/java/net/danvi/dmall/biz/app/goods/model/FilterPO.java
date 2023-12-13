package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.EditorBasePO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : filter 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class FilterPO extends EditorBasePO<FilterPO> {
    // filter 번호
    @NotNull(groups = { DeleteGroup.class, UpdateGroup.class })
    private String FilterNo;
    // filter명
    private String filterNm;
    // filter 설명
    private String filterDscrt;
    // filter 이미지 사용 여부
    private String filterImgUseYn;
    // filter 이미지 경로
    private String filterImgPath;
    // filter 이미지명
    private String filterImgNm;
    // 디폴트 이미지 경로
    private String dftFilePath;
    // 디폴트 이미지명
    private String dftFileName;
    // filter 메뉴 타입
    private String filterMenuType;
    // filter 하위 메뉴 타입
    private String filterType;
    // 등록 카테고리명
    private String[] insFilterNm;
    // 카테고리 레벨
    private String filterLvl;
    // 상위 카테고리 번호
    private String upFilterNo;
    // filter 정렬순번
    private String sortSeq;
    // 기존 카테고리 레벨
    private String orgFilterLvl;
    // 하위 카테고리 번호
    private String downFilterNo;
    // 변경 레벨값 계산
    private int calcLvl;

    // 하위 카테고리 번호 목록
    private List<Integer> childFilterNoList;
    // 전시존 번호 목록
    private List<String> dispNoList;

    // filter 일련 번호
    private long filterSerialNo;
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

    // 하위 filter 동일 적용 여부
    private String subFilterCmsRateApplyYn;

    // 필터 type
    private String filterDispType;
    // slide 필터 min value
    private String filterSlideMin;
    // slide 필터 max value
    private String filterSlideMax;
    // filter child code
    private String filterChildCd;
    // filter 상품군
    private String goodsTypeCd;

}
