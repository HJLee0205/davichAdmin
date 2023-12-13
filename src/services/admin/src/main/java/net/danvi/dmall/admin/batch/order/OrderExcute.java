package net.danvi.dmall.admin.batch.order;

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
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 17.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Component("orderExcute")
@Slf4j
public class OrderExcute {

    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    // BA-O-001 입금누락 주문무효처리 : DB-to-DB Mybatis 커서 사용
    public void BaO001Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        // 주문무효화 - 무통장 입금 5일 후 주문 무효화
        JobParameters param = new JobParametersBuilder()
                .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate()).addLong("intCnt", new Long("5"))
                .addString("jobId", "BA-O-001_Job")
                .addString("sendDate",dmall.framework.common.util.DateUtil.addHour(dmall.framework.common.util.DateUtil.getNowDateTime(), "yyyy-MM-dd HH:mm:ss", 10)).toJobParameters();

        Job job = (Job) context.getBean("BA-O-001_Job");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }

    // BA-O-002 배송완료누락 배송완료처리 : DB-to-DB Mybatis 커서 사용 =>배송프로세스에서 처리해야 함 배치 삭제 처리
    public void BaO002Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder()
                .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate())
                .addLong("intCnt", new Long("4")) // 배송완료- 배송중 4일이 지난건 자동 배송완료 전환
                .addLong("time",System.currentTimeMillis())                
                .toJobParameters();
        Job job = (Job) context.getBean("BA-O-002_Job");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }

    // BA-O-003 구매확정누락 구매확정처리 : Tasklet을 이용한 배치
    public void BaO003Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate())
                                                        .addLong("intCnt", new Long("3")) // 구매확정 - 배송완료 후 3일이 되는 날에 자동구매확정처리 ->마켓포인트, 포인트 적립처리
                                                        .addLong("time",System.currentTimeMillis())                
                                                        .toJobParameters();
        Job job = (Job) context.getBean("BA-O-003_Job");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }

    // BA-O-004 입금누락 주문무효 처리 SMS발송 : DB-to-DB Mybatis 커서 사용 (오전 10시경에 수행할 예정 - sms즉시 보냄)
    public void BaO004Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder()
                .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate()).addLong("intCnt", new Long("5")) // 주문무효화- 무통장 입금 5일 후 주문 무효화
                .addString("jobId", "BA-O-004_Job")
                .addString("sendDate", dmall.framework.common.util.DateUtil.getNowDateTime()).toJobParameters();
        Job job = (Job) context.getBean("BA-O-004_Job");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }

    // BA-O-005 구매확정누락 구매확정 안내 SMS발송 : DB-to-DB Mybatis 커서 사용 => 기획에서 배치 삭제 처리
    // public void BaO005Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    // JobParameters param = new JobParametersBuilder()
    // .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate())
    // .addLong("intCnt", new Long("7")) // 안내SMS-구매확정 - 배송완료 후 8일이 되는 날에 자동구매확정처리 ->마켓포인트, 포인트 적립처리 : -1일째 안내 발송
    // .addString("jobId", "BA-O-005_Job")
    // .addString("rsCd", "01") //즉시 및 예약 발송 = > 01.성공, 04.예약
    // .addString("sendDate", dmall.framework.common.util.DateUtil.getNowDateTime())
    // .addString("smsRecvYn", "Y")
    // .toJobParameters();
    // Job job = (Job) context.getBean("BA-O-005_Job");
    // jobLauncher.run(job, param);
    // }

    // BA-O-006 입금누락 주문무효 처리 이메일발송 : DB-to-DB Mybatis 커서 사용(오전 10시경에 수행할 예정 - email즉시 보냄)
    public void BaO006Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder()
                .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate()).addLong("intCnt", new Long("5")) // 주문무효화- 무통장 입금 5일 후  주문 무효화
                .addString("jobId", "BA-O-006_Job")
                .addString("sendDate", dmall.framework.common.util.DateUtil.getNowDateTime()).toJobParameters();
        Job job = (Job) context.getBean("BA-O-006_Job");
        JobExecution execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }

    // BA-O-007 구매확정누락 구매확정 안내 이메일발송 : DB-to-DB Mybatis 커서 사용 => 기획에서 배치 삭제 처리
    // public void BaO007Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
    // JobRestartException, JobInstanceAlreadyCompleteException {
    // JobParameters param = new JobParametersBuilder()
    // .addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate())
    // .addLong("intCnt", new Long("7")) // 안내Email-구매확정 - 배송완료 후 8일이 되는 날에 자동구매확정처리 ->마켓포인트, 포인트 적립처리 : -1일째 안내 발송
    // .addString("jobId", "BA-O-007_Job")
    // .addString("rsCd", "01") //즉시 및 예약 발송 = > 01.성공, 04.예약
    // .addString("sendDate", dmall.framework.common.util.DateUtil.getNowDateTime())
    // .addString("emailRecvYn", "Y")
    // .toJobParameters();
    // Job job = (Job) context.getBean("BA-O-007_Job");
    // jobLauncher.run(job, param);
    // }
}
