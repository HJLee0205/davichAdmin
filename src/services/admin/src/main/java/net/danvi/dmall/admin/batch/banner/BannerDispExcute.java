package net.danvi.dmall.admin.batch.banner;

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
 * 설명       : 배너 자동 미전시 처리 Excute
 * </pre>
 */
@Component("bannerDispExcute")
@Slf4j
public class BannerDispExcute {
    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    public void bannerAutoDispNone() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============bannerDispExcute admin START============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("bannerAutoDispNoneJob");
        jobLauncher.run(job, param);
        log.debug("==============bannerDispExcute admin END============");
    }
}
