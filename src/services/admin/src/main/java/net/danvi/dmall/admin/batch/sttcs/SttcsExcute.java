package net.danvi.dmall.admin.batch.sttcs;

import java.util.Date;

import javax.annotation.Resource;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 23.
 * 작성자     : 
 * 설명       : 통계분석을 위한 집계 배치 Excute
 * </pre>
 */
@Component("sttcsExcute")
@Slf4j
public class SttcsExcute {

    @Autowired
    private JobLauncher jobLauncher;

    @Resource(name = "vstrAnlsRegiJob") // 1.방문자분석 Job
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

    @Resource(name = "loginCurrentStatusRegiJob") // 11.로그인현황분석 Job
    private Job loginCurrentStatusRegiJob;

    /**
     * <pre>
     * 작성일 : 2016. 8. 23.
     * 작성자 : 
     * 설명   : 통계 집계 배치
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 23.  - 최초생성
     * </pre>
     *
     */

    // 1.방문자분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registVstrAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t1-0.방문자분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t1-0.방문자분석 집계 runJob Start : {}", param);
        runJob(vstrAnlsRegiJob, param);

        log.debug("t1-end.방문자분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 2.방문경로분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registVisitPathAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t2-0.방문경로분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t2-0.방문경로분석 집계 runJob Start : {}", param);
        runJob(visitPathAnlsRegiJob, param);

        log.debug("t2-end.방문경로분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 3.방문자IP분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registVstrIpAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t3-0.방문자IP분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t3-0.방문자IP분석 집계 runJob Start : {}", param);
        runJob(vstrIpAnlsRegiJob, param);

        log.debug("t3-end.방문자IP분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 4.신규회원분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registNwMemberAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t4-0.신규회원분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t4-0.신규회원분석 집계 runJob Start : {}", param);
        runJob(nwMemberAnlsRegiJob, param);

        log.debug("t4-end.신규회원분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 5.회원 마켓포인트 분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registMemberSvmnAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t5-0.회원 마켓포인트 분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t5-0.회원 마켓포인트 분석 집계 runJob Start : {}", param);
        runJob(memberSvmnAnlsRegiJob, param);

        log.debug("t5-end.회원 마켓포인트 분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 6.카테고리상품분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registCtgGoodsAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t6-0.카테고리상품분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t6-0.카테고리상품분석 집계 runJob Start : {}", param);
        runJob(ctgGoodsAnlsRegiJob, param);

        log.debug("t6-end.카테고리상품분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 7.판매순위 상품분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registSaleRankGoodsAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t7-0.판매순위 상품분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t7-0.판매순위 상품분석 집계 runJob Start : {}", param);
        runJob(saleRankGoodsAnlsRegiJob, param);

        log.debug("t7-end.판매순위 상품분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 8.장바구니 상품분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registBasketGoodsAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t8-0.장바구니 상품분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t8-0.장바구니 상품분석 집계 runJob Start : {}", param);
        runJob(basketGoodsAnlsRegiJob, param);

        log.debug("t8-end.장바구니 상품분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 9.주문통계분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registOrdSttcsAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t9-0.주문통계분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t9-0.주문통계분석 집계 runJob Start : {}", param);
        runJob(ordSttcsAnlsRegiJob, param);

        log.debug("t9-end.주문통계분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 10.매출통계분석 집계
    // @Scheduled(cron = "0 1/60 * * * *")
    public void registSalesSttcsAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t10-0.매출통계분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t10-0.매출통계분석 집계 runJob Start : {}", param);
        runJob(salesSttcsAnlsRegiJob, param);

        log.debug("t10-end.매출통계분석 집계 SttcsExcute 종료 : {}", param);
    }

    // 11.로그인현황분석 집계
    public void registLoginCurStatusAnls() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("t11-0.로그인현황분석 집계 SttcsExcute 시작");

        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 배치 실행 파라미터 세팅
        jobParametersBuilder = new JobParametersBuilder().addDate("d", new Date());
        param = jobParametersBuilder.toJobParameters();

        // 배치 실행
        // ---------------------------
        log.debug("t11-0.로그인현황분석 집계 runJob Start : {}", param);
        runJob(loginCurrentStatusRegiJob, param);

        log.debug("t11-end.로그인현황분석 집계 SttcsExcute 종료 : {}", param);
    }

    private void runJob(Job job, JobParameters param) throws JobParametersInvalidException,
            JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobExecution execution;// 배치 실행
        execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }
}
