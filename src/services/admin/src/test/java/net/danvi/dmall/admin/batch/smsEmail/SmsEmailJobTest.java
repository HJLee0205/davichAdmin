package net.danvi.dmall.admin.batch.smsEmail;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.batch.operation.SmsEmailExcute;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
//    ,"classpath:spring/context/context-application.xml"
//    ,"classpath:spring/context/context-security.xml"
//        ,"classpath:spring/context/context-ehcache.xml"
//     })
//@ContextConfiguration(locations = {"classpath:spring/context/*.xml", "classpath:spring/job/*.xml","classpath:config/**/*.xml"})
@ContextConfiguration(locations = {
        "classpath:spring/context/*.xml"
        ,"classpath:config/**/system.xml"
         ,"classpath:spring/job/*.xml"})
public class SmsEmailJobTest {

    @Autowired
    private SmsEmailExcute smsEmailExcute;

    @Test
    public void sms080RejectTest() throws
            JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        smsEmailExcute.sms080RejectJob();
    }

}
