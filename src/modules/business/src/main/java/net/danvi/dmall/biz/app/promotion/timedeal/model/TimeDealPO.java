package net.danvi.dmall.biz.app.promotion.timedeal.model;

import dmall.framework.common.model.EditorBasePO;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TimeDealPO extends EditorBasePO<TimeDealPO> {
    private int prmtNo;
    private int newPrmtNo;
    private int applySeq;
    private String prmtNm;
    private String applyStartDttm;
    private String applyEndDttm;
    private int prmtDcValue; // 할인률
    private String goodsNo; // 상품 번호
    private String[] goodsNm; // 상품 명
    private TimeDealTargetVO goodsInfo;
    private String[] goodsNoArr;
    private String prmtTypeCd;	//프로모션 유형
    private String prmtDcGbCd;	//프로모션 할인 구분 코드

    private String from; // 시작 일
    private String fromHour; // 시작 시
    private String fromMinute; // 시작 분
    private String to; // 종료 일
    private String toHoure; // 종료 시
    private String toMinute; // 종료 분;
    
    private List<TimeDealPO> dispzoneList;
    private List<TimeDealTargetVO> goodsInfoList;
    
    private String useYn;

    private String goodsTypeCd;	//상품군
    private String applyAlwaysYn;
}
