package net.danvi.dmall.admin.batch.member;

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
 * 작성일     : 2016. 8. 17.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Component("memberExcute")
@Slf4j
public class MemberExcute {

    @Autowired
    protected ApplicationContext context;

    @Autowired
    private JobLauncher jobLauncher;

    public void runJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException, JobRestartException,
            JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("testJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute END============");
    }

    public void memberPointRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute memPointJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("memPointJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute memPointJob END============");
    }

    public void memberSavedmnRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute memSavedmnJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("memSavedmnJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute memSavedmnJob END============");
    }

    public void memberAdultCertifyRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute memAdultCertifyReaderJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("memAdultCertifyReaderJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute memAdultCertifyReaderJob END============");
    }

    public void memGradeRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute memGradeRunJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("memGradeJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute memGradeRunJob END============");
    }

    public void deleteMemberNoRelationInfoJob() throws JobParametersInvalidException,
            JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute deleteMemberNoRelationBbsInfo============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("deleteMemberNoRelationInfoJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute deleteMemberNoRelationBbsInfo END============");
    }

    public void memDormantRunAlamJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute memDormantAlamRunJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("memDormantRunAlamJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute memDormantAlamRunJob END============");
    }

    public void memDormantRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute memDormantRunJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("memDormantRunJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute memDormantRunJob END============");
    }

    public void mailSendResultRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        log.debug("==============memberExcute mailSendResultRunJob============");
        JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
        Job job = (Job) context.getBean("mailSendResultJob");
        jobLauncher.run(job, param);

        log.debug("==============memberExcute mailSendResultRunJob END============");
    }
    
    public void visitAlarmRunJob() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
	    JobRestartException, JobInstanceAlreadyCompleteException {
	
		log.debug("==============memberExcute visitAlarmRunJob============");
		JobParameters param = new JobParametersBuilder().addDate("d", new Date()).toJobParameters();
		Job job = (Job) context.getBean("visitAlarmRunJob");
		jobLauncher.run(job, param);
		
		log.debug("==============memberExcute visitAlarmRunJob END============");
	}    
    
}
