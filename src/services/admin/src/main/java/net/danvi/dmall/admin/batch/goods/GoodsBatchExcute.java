package net.danvi.dmall.admin.batch.goods;

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
 * 작성일     : 2016. 7. 13.
 * 작성자     : 
 * 설명       : 상품 판매정보(판매여부, 판매금액등의 상품 정보) 변경
 * </pre>
 */
@Component("goodsBatchExcute")
@Slf4j
public class GoodsBatchExcute {

    @Autowired
    private JobLauncher jobLauncher;

    @Resource(name = "goodsSaleStatusJob") // 1. 상품 판매 상태 변경 Job
    private Job goodsSaleStatusJob;

    @Resource(name = "goodsSaleInfoJob") // 1. 상품 판매 정보 변경 Job
    private Job goodsSaleInfoJob;

    /**
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. dong - 최초생성
     * </pre>
     *
     * @throws JobParametersInvalidException
     * @throws JobExecutionAlreadyRunningException
     * @throws JobRestartException
     * @throws JobInstanceAlreadyCompleteException
     */
    // @Scheduled(cron = "0 0/1 10,18 * * ?")
    public void runGoodsSaleStatusBatch() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("상품 판매 상태 변경 배치 시작");

        JobParameters param;

        // 배치 실행
        param = new JobParametersBuilder().addString("goodsSaleStatusJob", "batch").addDate("d", new Date()) // 테스트;
                .toJobParameters();

        runJob(goodsSaleStatusJob, param);

        log.debug("상품 판매 상태 변경 배치 종료");
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. dong - 최초생성
     * </pre>
     *
     * @throws JobParametersInvalidException
     * @throws JobExecutionAlreadyRunningException
     * @throws JobRestartException
     * @throws JobInstanceAlreadyCompleteException
     */
    // @Scheduled(cron = "0 0/1 10,18 * * ?")
    public void runGoodsSaleInfoBatch() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("상품 판매 정보 변경 배치 시작");

        JobParameters param;

        // 배치 실행
        param = new JobParametersBuilder().addString("goodsSaleInfoJob", "batch").addDate("d", new Date()) // 테스트;
                .toJobParameters();

        runJob(goodsSaleInfoJob, param);

        log.debug("상품 판매 정보 변경 배치 종료");
    }

    private void runJob(Job job, JobParameters param) throws JobParametersInvalidException,
            JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobExecution execution;// 배치 실행
        execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }
}
