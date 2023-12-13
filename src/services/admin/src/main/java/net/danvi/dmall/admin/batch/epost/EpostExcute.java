package net.danvi.dmall.admin.batch.epost;

import java.util.Date;

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
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 13.
 * 작성자     : 
 * 설명       : 우체국 배송완료 송수신 배치
 * </pre>
 */
@Component("epostExcute")
@Slf4j
public class EpostExcute {

    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : dong
     * 설명   : 우체국 택배 수신 ( FILE to DB )   
     *          매일 매시 정각 실행
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13.  - 최초생성
     * </pre>
     *
     */
    // @Scheduled(cron = "0 0 /1 * * *")
    public void epostFileToDB() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("우체국 택배 수신 배치 시작");
        JobParameters param = new JobParametersBuilder()
                .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate()).addDate("d", new Date())
                .toJobParameters();
        Job job = (Job) context.getBean("epostReceiveJob");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
        log.debug("우체국 택배 수신 배치 종료");
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : dong
     * 설명   : 우체국 택배 송신 ( DB to FILE )  
     *          매일 매시 정각 실행
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13.  - 최초생성
     * </pre>
     *
     */
    // @Scheduled(cron = "0 0 /1 * * *")
    public void epostDBToFile() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("우체국 택배 송신 배치 시작");
        JobParameters param = new JobParametersBuilder()
                .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate()).addDate("d", new Date())
                .toJobParameters();
        Job job = (Job) context.getBean("epostSendJob");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
        log.debug("우체국 택배 송신 배치 종료");

    }

}
