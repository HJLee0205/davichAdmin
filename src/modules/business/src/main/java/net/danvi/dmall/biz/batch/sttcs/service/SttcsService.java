package net.danvi.dmall.biz.batch.sttcs.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import net.danvi.dmall.biz.batch.sttcs.model.ProcRunnerVO;

public interface SttcsService {

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 :
     * 설명   : 통계 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 23.        - 최초생성
     * </pre>
     *
     * @param param
     * @param domain
     */
    // 1.방문자분석 집계
    public void registVstrAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 2.방문경로분석 집계
    public void registVisitPathAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 3.방문자IP분석 집계
    public void registVstrIpAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 4.신규회원분석 집계
    public void registNwMemberAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 5.회원마켓포인트분석 집계
    public void registMemberSvmnAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 6.카테고리상품분석 집계
    public void registCtgGoodsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 7.판매순위 상품분석 집계
    public void registSaleRankGoodsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 8.장바구니 상품분석 집계
    public void registBasketGoodsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 9.주문통계분석 집계
    public void registOrdSttcsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 10.매출통계분석 집계
    public void registSalesSttcsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 11.로그인현황분석 집계
    public void registLoginCurStatusAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;
}
