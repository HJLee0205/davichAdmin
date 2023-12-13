package net.danvi.dmall.biz.batch.link.sabangnet.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class ProcRunnerVO implements Serializable {

    private static final long serialVersionUID = -3878977625541451017L;

    private String sendCompaynyId; // 사방넷로그인ID
    private String sendAuthKey; // 사방넷인증키
    private String ifNo; // 연계 번호
    private String sendDate; // 전송 일자
    private Long siteNo; // 사이트 번호
    private String siteId; // 사이트 ID
    private String siteNm; // 사이트 명
    private Long regrNo; // 등록자 번호
    private Long updrNo; // 수정자 번호
    private String sendGoodsCdRt; // 상품코드 반환여부

    private String stDate; // 검색 시작일자
    private String edDate; // 검색 종료일자
    private String ordField; // 주문수집 출력 필드
    private String clmField; // 클레임수집 출력 필드
    private String goodsField; // 상품수집 출력 필드

    // 주문 수집 요청 조건
    private String jungChkYn2; // 매출정산 확인여부
    private String orderStatus; // 주문 상태
    private String orderId; // 주문 번호
    private String mallId; // 쇼핑몰 ID
    private String lang; // 인코딩 타입
    // 송장 등록 헤더
    private String sendInvEditYn; // 송장정보 수정 여부
    // 클레임 수집 요청 조건
    // 문의사항수집 요청 조건
    private String csStatus; // 검색 처리 구분 001:신규접수, 002:답변저장, 003:답변전송, 004:강제완료,
                             // NULL:전체
    private String ifId; // 연계ID
    private String ifPgmId; // 연계프로그램ID
    private String ifPgmNm; // 연계프로그램명
    private String ifGbCd; // 연계구분코드

    private String startIfSno; // 시작연계일련번호
    private String endIfSno; // 종료연계일련번호
    private String resultContent; // 결과내용
}
