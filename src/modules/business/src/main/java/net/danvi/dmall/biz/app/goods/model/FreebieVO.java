package net.danvi.dmall.biz.app.goods.model;

import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2017. 7. 12.
 * 작성자     : dong
 * 설명       : FreebieVO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieVO extends EditorBaseVO<FreebieVO> {
    // 항목 번호
    private String rowNum;
    // 사은품 번호
    private String freebieNo;
    // 사은품 명
    private String freebieNm;
    // 사은품 간단 설명
    private String simpleDscrt;
    // 사은품 설명
    private String freebieDscrt;
    // 관리 메모
    private String manageMemo;
    // 사용 여부
    private String useYn;
    // 사용 명
    private String useNm;
    // 등록 일자
    private String regDate;
    // 수정 일자
    private String updDate;
    // 이미지 경로(프로모션 사용)
    private String imgPath;
    // 이미지 명(프로모션 사용)
    private String imgNm;
    // 이미지 정보
    private String freebieImg;
    // 이미지 세트 정보
    private List<Map<String, Object>> freebieImageSetList;
    // 대표이미지 정보
    private FreebieImageDtlVO dlgtImg;
}
