package net.danvi.dmall.biz.app.member.level.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 8.
 * 작성자     : kjw
 * 설명       : 회원 등급 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class MemberLevelSO extends BaseSearchVO<MemberLevelSO> {
    // 회원등급 번호
    private String memberGradeNo;
    // 회원등급 레벨
    private String memberGradeLvl;
    // 회원등급 관리 코드
    private String memberGradeManageCd;
    // 회원등급 혜택 번호
    private String memberGradeBnfNo;

    private String useYn;
    private String chk;
}
