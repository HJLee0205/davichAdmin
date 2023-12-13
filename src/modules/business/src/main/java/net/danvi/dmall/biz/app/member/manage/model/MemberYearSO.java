package net.danvi.dmall.biz.app.member.manage.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 12. 10.
 * 작성자     : kjw
 * 설명       : 연말정산 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class MemberYearSO extends BaseSearchVO<MemberYearSO> {
    // 연말정산년도
    private String yyyy;
    // 가맹점코드
    private String strCode;
    // 고객코드
    private String cdCust;
    // 주민번호
    private String resNo;
    
}
