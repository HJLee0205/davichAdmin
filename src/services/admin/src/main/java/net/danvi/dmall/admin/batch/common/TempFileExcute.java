package net.danvi.dmall.admin.batch.common;

import java.util.Date;

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

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 18.
 * 작성자     : dong
 * 설명       : 임시 폴더 삭제 배치 Excute
 * </pre>
 */
@Component("tempFileExcute")
@Slf4j
public class TempFileExcute {
    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    public void tempFileDel() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============tempFileExcute admin START============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("tempFileDelJob");
        jobLauncher.run(job, param);
        log.debug("==============tempFileExcute admin END============");
    }
}
