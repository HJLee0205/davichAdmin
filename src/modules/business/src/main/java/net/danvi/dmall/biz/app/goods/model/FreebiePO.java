package net.danvi.dmall.biz.app.goods.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.hibernate.validator.constraints.Length;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.BannedWordReplace;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2017. 7. 12.
 * 작성자     : dong
 * 설명       : FreebiePO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class FreebiePO extends EditorBasePO<FreebiePO> {
    // 사은품 번호
    private String freebieNo;
    // 사은품 명
    @Length(min = 0, max = 30)
    private String freebieNm;
    // 사은품 간단 상세
    @Length(min = 0, max = 100)
    private String simpleDscrt;
    // 사은품 상세
    @BannedWordReplace
    private String freebieDscrt;
    // 관리 메모
    @Length(min = 0, max = 100)
    private String manageMemo;
    // 사용 여부
    private String useYn;
    // 사은품 번호 목록
    private ArrayList<String> freebieNoList;
    // 사은품 이미지 정보
    @Valid
    private List<FreebieImageDtlPO> freebieImageDtlList;

    // 업로드 이미지 명
    private String uploadFileNm;
}