package net.danvi.dmall.biz.app.promotion.event.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 이벤트 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class EventSO extends BaseSearchVO<EventSO> {
    private String periodSelOption; // 기간검색옵션 : 이벤트시작일 or 이벤트종료일
    private String searchStartDate; // 검색시작일
    private String searchEndDate; // 검색종료일
    private int eventNo;
    private String wngYn; // 당첨여부
    private String delYn; // 삭제여부
    private String[] eventUseYns; // 사용여부
    private String eventKindCd; // 이벤트 종류코드(01:이벤트, 02:출석체크이벤트)
    private String eventMethodCd; // 출첵이벤트 참여방법 : 스탬프형, 로그인형, 스템프형+로그인형(단건조회)
    private String[] eventMethodCds; // 출첵이벤트 참여방법 : 스탬프형, 로그인형, 스템프형+로그인형
    private String[] eventStatusCds; // 이벤트상태 : 진행 전, 진행 중, 종료
    private String searchWords; // 검색 - 검색어
    private String periodAllYn; // front 사용
    private String eventCd; // front 이벤트 페이지에서 사용
    private int pageNoOri; // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)

    private String ch; // 유입 채널 코드
    private String[] goodsTypeCd;   // 검색 - 상품군
    private String[] eventUseYn;    // 검색 - 노출
    private String goodsTypeCdSelectAll;
}
