package net.danvi.dmall.admin.batch.common;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring/context/*.xml", "classpath:spring/job/*.xml",
        "classpath:config/**/*.xml" })
public class TempFileJobTest {

    @Resource(name = "tempFileDelJob") // 임시폴더 삭제
    private Job tempFileDelJob;

    @Autowired
    private JobLauncher jobLauncher;

    @Autowired
    protected ApplicationContext context;

    @Autowired
    private TempFileExcute tempFileExcute;

    @Test // 임시 폴더 삭제
    public void tempFileDelTest() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        tempFileExcute.tempFileDel();
    }

}
