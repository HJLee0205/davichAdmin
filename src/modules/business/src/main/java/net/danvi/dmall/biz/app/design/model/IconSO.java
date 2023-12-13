package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2023. 01. 17.
 * 작성자     : slims
 * 설명       : 아이콘관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class IconSO extends BaseSearchVO<IconSO> {
    // 검색전용
    private String fromRegDt; // 검색 시작일시
    private String toRegDt; // 검색 종료일시
    private String[] goodsTypeCds; // 아이콘 유형
    private String goodsNm; // 아이콘 유형
    // 기본값들
    private String iconNo; // 아이콘 번호
    private String iconDispnm; // 아이콘 명

    private String goodsTypeCd; // 아이콘 유형
}
