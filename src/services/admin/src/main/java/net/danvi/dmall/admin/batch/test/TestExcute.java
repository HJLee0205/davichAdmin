package net.danvi.dmall.admin.batch.test;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class TestExcute {

    // 초 분 시 일 월 달
    // 초(Seconds) 0 ~ 59
    // 분(Minutes) 0 ~ 59
    // 시(Hours) 0 ~ 23
    // 날(Day-of-month) 1 ~ 31
    // 달(Month) 1 ~ 12 or JAN ~ DEC
    // 요일(Day-of-week) 1 ~ 7 or SUN-SAT
    // 년도(Year) (선택가능) 빈값, 1970 ~ 2099

    // 초분시일월주(년)
    // "0 0 12 * * ?" : 아무 요일, 매월, 매일 12:00:00
    // "0 15 10 ? * *" : 모든 요일, 매월, 아무 날이나 10:15:00
    // "0 15 10 * * ?" : 아무 요일, 매월, 매일 10:15:00
    // "0 15 10 * * ? *" : 모든 연도, 아무 요일, 매월, 매일 10:15
    // "0 15 10 * * ? : 2005" 2005년 아무 요일이나 매월, 매일 10:15
    // "0 * 14 * * ?" : 아무 요일, 매월, 매일, 14시 매분 0초
    // "0 0/5 14 * * ?" : 아무 요일, 매월, 매일, 14시 매 5분마다 0초
    // "0 0/5 14,18 * * ?" : 아무 요일, 매월, 매일, 14시, 18시 매 5분마다 0초
    // "0 0-5 14 * * ?" : 아무 요일, 매월, 매일, 14:00 부터 매 14:05까지 매 분 0초
    // "0 10,44 14 ? 3 WED" : 3월의 매 주 수요일, 아무 날짜나 14:10:00, 14:44:00
    // "0 15 10 ? * MON-FRI" : 월~금, 매월, 아무 날이나 10:15:00
    // "0 15 10 15 * ?" : 아무 요일, 매월 15일 10:15:00
    // "0 15 10 L * ?" : 아무 요일, 매월 마지막 날 10:15:00
    // "0 15 10 ? * 6L" : 매월 마지막 금요일 아무 날이나 10:15:00
    // "0 15 10 ? * 6L 2002-2005" : 2002년부터 2005년까지 매월 마지막 금요일 아무 날이나 10:15:00
    // "0 15 10 ? * 6#3" : 매월 3번째 금요일 아무 날이나 10:15:00

    /**
     * <pre>
    * - 프로젝트명	: 21.batch
    * - 파일명		: TestExcute.java
    * - 작성일		: 2016. 5. 23.
    * - 작성자		: snw
    * - 설명		: Cron 형태의 스케줄러
     * </pre>
     */
    @Scheduled(cron = "0 50 17 * * *")
    public void cronTest1() {
        log.debug("오후 05:50:00에 호출이 됩니다 ");
    }

    @Scheduled(cron = "0 25 12 * * *")
    public void cronTest2() {
        log.debug("점심 먹자~~");
    }

    @Scheduled(cron = "0 00 18 * * MON-FRI")
    public void cronTest3() {
        log.debug("퇴근하자~~");
    }

    /**
     * <pre>
    * - 프로젝트명	: 21.batch
    * - 파일명		: TestExcute.java
    * - 작성일		: 2016. 5. 23.
    * - 작성자		: snw
    * - 설명		: 배치 실행이 완료된 후 7초후에 실행
     * </pre>
     */
//    @Scheduled(fixedDelay = 7000)
//    public void fixedDelayTest() {
//        log.debug("fixedDelay {}에 실행되었습니다.", DateUtil.getNowDateTime());
//    }

    /**
     * <pre>
    * - 프로젝트명	: 21.batch
    * - 파일명		: TestExcute.java
    * - 작성일		: 2016. 5. 23.
    * - 작성자		: snw
    * - 설명		: 배치 실행시작의 10초 후 실행
     * </pre>
     */
//    @Scheduled(fixedRate = 10000)
//    public void fixedRateTest() {
//        log.debug("fixedRate {}에 실행되었습니다.", DateUtil.getNowDateTime());
//    }

}
