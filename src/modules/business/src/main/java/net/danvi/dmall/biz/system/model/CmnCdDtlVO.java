package net.danvi.dmall.biz.system.model;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

@Data
@EqualsAndHashCode(callSuper = false)
public class CmnCdDtlVO extends BaseModel<T> {

    private static final long serialVersionUID = 1L;

    /** 그룹 코드 */
    private String grpCd;

    /** 상세 코드 */
    private String dtlCd;

    /** 상세 명 */
    private String dtlNm;

    /** 상세 약어 명 */
    private String dtlShtNm;

    /** 정렬 순서 */
    private Long sortSeq;

    /** 사용 여부 */
    private String useYn;

    /** 사용자 정의1 값 */
    private String userDefien1;

    /** 사용자 정의2 값 */
    private String userDefien2;

    /** 사용자 정의3 값 */
    private String userDefien3;

    /** 사용자 정의4 값 */
    private String userDefien4;

    /** 사용자 정의5 값 */
    private String userDefien5;

    /** 시스템 삭제 여부 */
    private String delYn;

    /** 코드 설명 */
    private String dtlDscrt;
}