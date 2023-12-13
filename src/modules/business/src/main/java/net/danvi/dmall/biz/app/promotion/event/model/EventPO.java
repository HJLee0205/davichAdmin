package net.danvi.dmall.biz.app.promotion.event.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 이벤트 PO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class EventPO extends EditorBasePO<EventPO> {
    private String rowNum = "";
    private int eventNo = 0;
    private String eventNm = "";
    private String eventDscrt = "";
    private String eventKindCd = ""; // 이벤트 종류코드 : 01.이벤트 02.출석체크이벤트
    private String eventStatusCd = ""; // 이벤트상태코드 : 진행 전, 진행 중, 종료
    private String applyStartDttm = ""; // 이벤트시작일시
    private String applyEndDttm = ""; // 이벤트종료일시
    private String eventWngDttm = ""; // 이벤트당첨자발표일시
    private String eventContentHtml = ""; // 이벤트 내용
    private String eventCmntUseYn = ""; // 이벤트댓글 사용여부
    private String eventWebBannerImgPath = ""; // 웹배너이미지 경로
    private String eventWebBannerImgOrg = ""; // 웹배너이미지(오리지널)
    private String eventWebBannerImg = ""; // 웹배너이미지
    private String eventMobileBannerImgPath = ""; // 모바일배너이미지 경로
    private String eventMobileBannerImgOrg = ""; // 모바일배너이미지(오리지널)
    private String eventMobileBannerImg = ""; // 모바일배너이미지 경로

    // 출첵 이벤트
    private String eventPeriodExptCd = ""; // 출첵이벤트기간 예외코드 : 01.토요일 제외 02.일요일 제외 03.제외일 없음
    private int eventPvdPoint = 0; // 출첵이벤트제공포인트
    private String eventMethodCd = ""; // 출첵이벤트 방법코드 : 01.스탬프형 02.로그인형
    private String eventCndtCd = ""; // 출첵이벤트 조건코드 : 01.조건완성형 02.추가지급형
    private int eventTotPartdtCndt = 0; // 출첵이벤트 총 참여 수
    private String eventTotPartdtCndt01 = ""; // 출첵이벤트 총 참여 수( 일반형 )_유효성 검사엔진이 빈칸을 String으로 인식해 타입오류나서 데이터타입 문자형
    private String eventTotPartdtCndt02 = ""; // 출첵이벤트 총 참여 수( 추가지급형 )_유효성 검사엔진이 빈칸을 String으로 인식해 타입오류나서 데이터타입 문자형
    private String eventAddPvdPoint = ""; // 출첵이벤트 추가지급 포인트
    private String eventPointApplyCd = ""; // 출첵이벤트 포인트 유효기간코드 : 01.지정기간 02.적립일로부터 몇개월
    private String pointApplyStartDttm = ""; // 포인트적용시작일시
    private String pointApplyEndDttm = ""; // 포인트적용종료일시
    private int eventApplyIssueAfPeriod = 0; // 포인트적립일로부터 몇개월 유효
    private String eventUseYn = "";

    // 당첨내용 등록
    private long wngContentNo;
    private String wngNm; /* 당첨 제목 */
    private String wngContentHtml; /* 당첨 내용 */

    // 기간
    private String from; // 시작 일
    private String fromHour; // 시작 시
    private String fromMinute; // 시작 분
    private String to; // 종료 일
    private String toHoure; // 종료 시
    private String toMinute; // 종료 분;
    private String wngFrom; // 당첨 일;
    private String wngFromHour; // 당첨 시;
    private String wngFromMinute; // 당첨 분;

    // 기간( 출석체크이벤트 )
    private String pointFrom; // 포인트시작 일;
    private String pointFromHour; // 포인트시작 시;
    private String pointFromMinute; // 포인트시작 분;
    private String pointTo; // 포인트종료 일;
    private String pointToHoure; // 포인트종료 시;
    private String pointToMinute; // 포인트종료 분;
    private Long siteNo;
    
    private String eventCmntAuth; //댓글권한

    private String goodsTypeCd; //상품 유형
    private String seoSearchWord;   //SEO 검색용 태그

    private String dlgtImgPath; //대표이미지 경로
    private String dlgtImgNm;   //대표이미지 이름
    private String dlgtImgOrgNm;//대표이미지 원본 이름
}
