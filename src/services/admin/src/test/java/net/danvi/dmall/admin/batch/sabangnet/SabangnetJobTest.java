package net.danvi.dmall.admin.batch.sabangnet;

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
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
        "classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
    ,"classpath:spring/context/context-batch.xml"
    ,"classpath:spring/context/context-scheduler.xml"
        ,"classpath:spring/context/context-ehcache.xml"})
public class SabangnetJobTest {

    @Resource(name = "goodsRegiJob") // 1.상품등록&수정 Job
    private Job goodsRegiJob;

    @Resource(name = "goodsSmrUpdJob") // 2.상품요약수정 Job
    private Job goodsSmrUpdJob;

    @Resource(name = "orderRequestJob") // 3.주문수집 Job
    private Job orderRequestJob;

    @Resource(name = "invoiceRegiJob") // 4.송장등록 Job
    private Job invoiceRegiJob;

    @Resource(name = "claimRequestJob") // 5.클레임수집 Job
    private Job claimRequestJob;

    @Resource(name = "inquiryRequestJob") // 6.문의사항수집 Job
    private Job inquiryRequestJob;

    @Resource(name = "inquiryReplyRegiJob") // 7.문의답변등록 Job
    private Job inquiryReplyRegiJob;

    @Autowired
    private JobLauncher jobLauncher;

    @Autowired
    private SabangnetExcute sabangnetExcute;

    @Test // 1.상품등록&수정
    public void goodsRegiTest() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {

        sabangnetExcute.registGoods();
    }

     @Test // 2.상품요약수정
     public void goodsSmrUpdJobTest() throws JobParametersInvalidException,  JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        sabangnetExcute.smrUpdGoods();
     }

     @Test // 3.주문수집
     public void orderRequestTest() throws JobParametersInvalidException,
     JobExecutionAlreadyRunningException,
     JobRestartException, JobInstanceAlreadyCompleteException {

     sabangnetExcute.readOrderInfo();
     }

    @Test // 4.송장등록
    public void invoiceRegiTest() throws JobParametersInvalidException,
    JobExecutionAlreadyRunningException,
    JobRestartException, JobInstanceAlreadyCompleteException {

    sabangnetExcute.registInvoice();
    }

    @Test // 5.클레임수집
    public void claimRequestTest() throws JobParametersInvalidException,
    JobExecutionAlreadyRunningException,
    JobRestartException, JobInstanceAlreadyCompleteException {

    sabangnetExcute.readClaimInfo();
    }

    @Test // 6.문의사항수집
    public void inquiryRequestTest() throws JobParametersInvalidException,
    JobExecutionAlreadyRunningException,
    JobRestartException, JobInstanceAlreadyCompleteException {

    sabangnetExcute.readInquiryInfo();
    }

    @Test // 7.문의답변등록
    public void inquiryReplyRegiTest() throws JobParametersInvalidException,
    JobExecutionAlreadyRunningException,
    JobRestartException, JobInstanceAlreadyCompleteException {

    sabangnetExcute.registInquiryReply();
    }

}
