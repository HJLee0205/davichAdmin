package net.danvi.dmall.admin.batch.sttcs;

import javax.annotation.Resource;

import net.danvi.dmall.admin.batch.order.OrderExcute;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = {"classpath:spring/context/*.xml", "classpath:spring/job/*.xml","classpath:config/**/*.xml"})
@ContextConfiguration(locations = {
        "classpath:spring/context/*.xml"
        ,"classpath:config/**/system.xml"
         ,"classpath:spring/job/*.xml"})
public class SttcsJobTest {

    @Resource(name = "vstrAnlsRegiJob") // 1.방문자분석 집계 Job
    private Job vstrAnlsRegiJob;

    @Resource(name = "visitPathAnlsRegiJob") // 2.방문경로분석 Job
    private Job visitPathAnlsRegiJob;

    @Resource(name = "vstrIpAnlsRegiJob") // 3.방문자IP분석 Job
    private Job vstrIpAnlsRegiJob;

    @Resource(name = "nwMemberAnlsRegiJob") // 4.신규회원분석 Job
    private Job nwMemberAnlsRegiJob;

    @Resource(name = "memberSvmnAnlsRegiJob") // 5.회원 마켓포인트 분석 Job
    private Job memberSvmnAnlsRegiJob;

    @Resource(name = "ctgGoodsAnlsRegiJob") // 6.카테고리상품분석 Job
    private Job ctgGoodsAnlsRegiJob;

    @Resource(name = "saleRankGoodsAnlsRegiJob") // 7.판매순위 상품분석 Job
    private Job saleRankGoodsAnlsRegiJob;

    @Resource(name = "basketGoodsAnlsRegiJob") // 8.장바구니 상품분석 Job
    private Job basketGoodsAnlsRegiJob;

    @Resource(name = "ordSttcsAnlsRegiJob") // 9.주문통계분석 Job
    private Job ordSttcsAnlsRegiJob;

    @Resource(name = "salesSttcsAnlsRegiJob") // 10.매출통계분석 Job
    private Job salesSttcsAnlsRegiJob;

    @Autowired
    private JobLauncher jobLauncher;

    @Autowired
    private SttcsExcute sttcsExcute;

    @Autowired
    private OrderExcute orderExcute;

    // @Test // 1.방문자분석 집계
    // public void vstrAnlsRegiTest() throws JobParametersInvalidException,
    // JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registVstrAnls();
    // }

    // @Test // 2.방문경로분석 집계
    // public void visitPathAnlsRegiTest() throws JobParametersInvalidException,
    // JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registVisitPathAnls();
    // }

    // @Test // 3.방문자IP분석 집계
    // public void vstrIpAnlsRegiTest() throws JobParametersInvalidException,
    // JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registVstrIpAnls();
    // }

    // @Test // 4.신규회원분석 집계
    // public void nwMemberAnlsRegiTest() throws JobParametersInvalidException,
    // JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registNwMemberAnls();
    // }

    // @Test // 5.회원 마켓포인트 분석 집계
    // public void memberSvmnAnlsRegiTest() throws
    // JobParametersInvalidException, JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registMemberSvmnAnls();
    // }

    @Test // 6.카테고리상품분석 집계
    public void ctgGoodsAnlsRegiTest() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        sttcsExcute.registCtgGoodsAnls();
    }

    // @Test // 7.판매순위 상품분석 집계
    // public void saleRankGoodsAnlsRegiTest() throws
    // JobParametersInvalidException, JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registSaleRankGoodsAnls();
    // }

    // @Test // 8.장바구니 상품분석 집계
    // public void basketGoodsAnlsRegiTest() throws
    // JobParametersInvalidException, JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    //
    // sttcsExcute.registBasketGoodsAnls();
    // }

    @Test // 9.주문통계분석 집계
    public void ordSttcsAnlsRegiTest() throws JobParametersInvalidException,
            JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        sttcsExcute.registOrdSttcsAnls();
    }

    @Test // 10.매출통계분석 집계
    public void salesSttcsAnlsRegiTest() throws
            JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        sttcsExcute.registSalesSttcsAnls();
    }

    @Test // 구매확정 처리
    public void updateOrdStatusCdConfirm() throws
            JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        orderExcute.BaO003Job();
    }



}
