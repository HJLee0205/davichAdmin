package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 택배사 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class RestockNotifyVO extends BaseModel<RestockNotifyVO> {
    // 재입고 알림 번호
    private Long reinwareAlarmNo;
    // 상품 번호
    private String goodsNo;
    // 상품 명
    private String goodsNm;
    // 상품 이미지
    private String goodsImg;
    // 상품 판매 상태 코드
    private String goodsSaleStatusCd;
    // 상품 판매 상태 명
    private String goodsSaleStatusNm;
    // 등록 일시(화면표시용)
    private String strRegDttm;
    // 재입고 알림 상태 코드
    private String alarmStatusCd;
    // 재입고 알림 일시
    private String alarmDttm;
    // 재입고 알림 일시 (화면표시용)
    private String strAlarmDttm;
    // 단품 번호
    private String itemNo;
    // 판매가
    private Long salePrice;
    // 재고 수량
    private Long stockQtt;
    // 가용 재고 수량
    private Long availStockQtt;
    // 회원 번호
    private Long memberNo;
    // 회원 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    // 회원 등급
    private String memberGradeNo;
    // 회원 등급 명
    private String memberGradeNm;
    // 재입고 알림 수신 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    // 행번호
    private int rowNum;
    // 중복 카운트
    private int dupleCnt;
    // 관리자 메모
    private String managerMemo;
    // 대표이미지 목록
    private List<String> imgList;
    // 재입고 요청자 목록
    private List<RestockNotifyVO> restockMemberList;
    // 재입고 알림 발송 로그
    private List<RestockNotifyVO> notifySendLog;

    private String sendDttm;
    private String sendCnt;
}
