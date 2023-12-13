package net.danvi.dmall.admin.batch.sabangnet;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
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
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Date;

import static org.hamcrest.CoreMatchers.is;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
 "classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
    ,"classpath:spring/context/context-batch.xml"
    ,"classpath:spring/context/context-scheduler.xml"
        ,"classpath:spring/context/context-ehcache.xml"
 })
public class SampleJobTest {

    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    @Test
    public void testDummy() {
        Assert.assertThat(true, is(true));
    }

//    @Test
    public void testDB2DB() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testJob");
        jobLauncher.run(job, param);
    }

//    @Test
    public void testDBPaging2DB() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testPagingJob");
        jobLauncher.run(job, param);
    }

//    @Test
    public void testDB2Beans2Text() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testTextJob");

        jobLauncher.run(job, param);
    }

//    @Test
    public void testDB2Processor2Text() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testTextJob2");

        jobLauncher.run(job, param);
    }

//    @Test
    public void testTextMapJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testTextMapJob");

        jobLauncher.run(job, param);
    }

//    @Test
    public void testDB2Map2Text() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addString("fileName", "file:/dmall/reportMap.txt").addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testText2DBJob");

        jobLauncher.run(job, param);
    }

    // BA-O-003 구매확정누락 구매확정처리 : Tasklet을 이용한 배치
    @Test
    public void BaO003Job() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        JobParameters param = new JobParametersBuilder().addString("stdDate", dmall.framework.common.util.DateUtil.getNowDate())
                                                        .addLong("intCnt", new Long("3")) // 구매확정 - 배송완료 후 3일이 되는 날에 자동구매확정처리 ->마켓포인트, 포인트 적립처리
                                                        .addLong("time",System.currentTimeMillis())
                                                        .toJobParameters();
        Job job = (Job) context.getBean("BA-O-003_Job");
        jobLauncher.run(job, param);
    }

}
