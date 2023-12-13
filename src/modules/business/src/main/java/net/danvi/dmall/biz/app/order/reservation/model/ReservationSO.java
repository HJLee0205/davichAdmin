package net.danvi.dmall.biz.app.order.reservation.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 11.
 * 작성자     : khy
 * 설명       : 방문예약내역
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ReservationSO extends BaseSearchVO<ReservationSO> {
	private String rsvNo;   //예약번호 
    private Long memberNo;  // 방문예약자 회원번호
    private String rsvDayS; // 방문예약 시작일자
    private String rsvDayE; // 방문예약 종료일자
    
    private String def1;   // 공통코드 사용자정의1
    private String sidoCode;   // 시도코드
    private String gugunCode;   // 구분코드
    
    private String storeCode;   // 매장코드
    private String week;   // 요일
    private String sidoName;  // 시/도명
    private String targetYM;    //년월
    private String strDate;    //방문예정일자
    private String visionChk;    
    private String visitPurposeNm;
    private String hearingAidYn;
    private String recvAllowYn;
    
    private String erpItmCode; //다비전코드
    private String strName; //가맹점명

    private String rsvDate;
    private String rsvTime;

    private String rsvName;
    private String rsvMobile;
    private String reservationTypeNoOrder;
    private String reservationTypeOrder;
    private String[] rsvOrdStatusCds;

    private String[] rsvType;
    private String[] goodsTypeCd;
    private String searchSeller;
    private String searchCd;
    private String searchWord;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchWordEncrypt;
}
