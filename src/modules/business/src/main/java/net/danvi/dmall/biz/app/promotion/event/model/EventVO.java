package net.danvi.dmall.biz.app.promotion.event.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 이벤트 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class EventVO extends EditorBaseVO<EventVO> {
    private String rowNum = "";
    private String sortNum;
    private int eventNo = 0;
    private String eventNm = "";
    private String eventDscrt = "";
    private String eventKindCd = ""; // 이벤트 종류코드 : 01.이벤트 02.출석체크이벤트
    private String eventStatusCd = ""; // 이벤트상태코드 : 진행 전, 진행 중, 종료
    private String applyStartDttm = "";
    private String applyEndDttm = "";
    private String eventWngDttm = "";
    private String eventContentHtml = "";
    private String eventCmntUseYn = ""; // 댓글사용여부
    private String eventWebBannerImgPath = "";
    private String eventWebBannerImg = "";
    private String eventMobileBannerImgPath = "";
    private String eventMobileBannerImg = "";
    private String eventPeriodExptCd = ""; // 출첵이벤트기간 예외코드 : 01.토요일 제외 02.일요일 제외 03.제외일 없음
    private String eventPeriodExptCdNm = "";
    private int eventPvdPoint = 0; // 출첵이벤트 지급 포인트
    private String eventMethodCd = ""; // 출첵이벤트 방법코드 : 01.스탬프형 02.로그인형
    private String eventMethodCdNm = "";
    private String eventCndtCd = ""; // 출첵이벤트 조건코드 : 01.조건완성형 02.추가지급형
    private int eventTotPartdtCndt = 0; // 출첵이벤트 총 참여 수
    private int eventTotPartdtCndt01 = 0; // 출첵이벤트 총 참여 수( 일반형 )
    private int eventTotPartdtCndt02 = 0; // 출첵이벤트 총 참여 수( 추가지급형 )
    private int eventAddPvdPoint = 0; // 출첵이벤트 추가지급 포인트
    private String eventPointPvdMethodCd = ""; // 출첵이벤트 포인트 지급방법코드(현재 사용 안함)
    private String eventPointPvdMethodCdNm = ""; // 출첵이벤트 포인트 지급방법코드 이름(현재 사용 안함)
    private String eventPointApplyCd = ""; // 출첵이벤트 포인트 유효기간코드 : 01.지정기간 02.적립일로부터 몇개월
    private String pointApplyStartDttm = ""; // 포인트적용 시작일시
    private String pointApplyEndDttm = ""; // 포인트적용 종료일시
    private int eventApplyIssueAfPeriod = 0; // 출첵이벤트 포인트발급후 유효한 개월 수
    private String eventUseYn = ""; // 사용여부

    // 출첵이벤트 기간 겹치지 않게 체크 위한 모든 출첵이벤트(단, 진행예정 진행중 경우만)
    private String otherApplyStartDttm = ""; // 다른 출첵이벤트시작일시
    private String otherApplyEndDttm = ""; // 다른 출첵이벤트종료일시
    private String otherEventNm = ""; // 다른 출첵이벤트 이름
    private String otherEventNo = ""; // 다른 출첵이벤트 번호
    // admin
    private String searchStartDate;
    private String searchEndDate;
    private String eventStatusNm;

    private int wngContentNo; /* 당첨내용 번호 */
    private String wngNm; /* 당첨내용 제목 */
    private String wngContentHtml; /* 당첨내용 html */
    private int wngCnt; /* 당첨자 수 */
    private String eventCmntAuth; //댓글권한
    private String eventCmntAuthNm;

    private String ingYn; /* 진행중 여부 */

    private String goodsTypeCd; //상품군
    private String seoSearchWord;   //SEO 검색용 태그

    private String dlgtImgPath;
    private String dlgtImgNm; //대표이미지 이름
    private String dlgtImgOrgNm;//대표이미지 원본 이름
}