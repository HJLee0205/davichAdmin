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
 * 작성일     : 2016. 6. 01.
 * 작성자     : dong
 * 설명       : 메인전시관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class DisplayGoodsPO extends BaseModel<DisplayGoodsPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long siteDispSeq; // 메인 전시 순번
    private String mainAreaGbCd; // 메인 전시 영역 구분
    private Long dispSeq; // 전시 순번
    private String dispNm; // 전시명
    private String useYn; // 사용유무
    private String dispTypeCd; // 전시 타입코드
    private String goodsNo; // 상품 번호
    private Long priorRank; // 우선 순위

    private String dispExhbtionTypeCd; // 전시 노출 유형 코드
    private String dispImgPath; // 전시 이미지 경로
    private String dispImgNm; // 전시 이미지 명

    private String dftFilePath; // 디폴트 파일 경로
    private String dftFileName; // 디폴트 파일 명
    private long maxSiteDispSeq;//메인 전시 마지막 순번
}
