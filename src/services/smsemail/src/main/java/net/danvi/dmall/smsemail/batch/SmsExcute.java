package net.danvi.dmall.smsemail.batch;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 17.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Component("smsExcute")
public class SmsExcute {

    private static final Logger log = LoggerFactory.getLogger(SmsExcute.class);

    @Autowired
    protected ApplicationContext context;

    @Autowired(required = true)
    private JobLauncher jobLauncher;

    public void smsUseCountRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============smsExcute smsUseCountRunJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("smsUseCountRunJob");
        jobLauncher.run(job, param);

        log.debug("==============smsExcute smsUseCountRunJob END============");
    }
}
