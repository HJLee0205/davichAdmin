package net.danvi.dmall.biz.app.main.model;

import lombok.Data;

import java.io.Serializable;

/**
 * Created by dong on 2016-07-20.
 */
@Data
public class MallWeekStatusVO implements Serializable {
    private String dayOfWeek;
    private int salesAmt;
    private int ordCnt; // 모든 주문
    private int rsvCnt; // 모든 예약
    private int visitCnt; // 방문자 수
}
