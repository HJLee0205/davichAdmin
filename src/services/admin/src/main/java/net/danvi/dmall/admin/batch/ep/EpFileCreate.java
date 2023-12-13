package net.danvi.dmall.admin.batch.ep;

import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.Job;
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

import java.util.Date;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 18.
 * 작성자     : dong
 * 설명       : 네이버 지식쇼핑 파일 생성 Excute
 * </pre>
 */
@Component("epFileCreate")
@Slf4j
public class EpFileCreate {
    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    public void epFileCreate() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============epFileCreate admin START============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("epFileCreateJob");
        jobLauncher.run(job, param);
        log.debug("==============epFileCreate admin END============");
    }
}
