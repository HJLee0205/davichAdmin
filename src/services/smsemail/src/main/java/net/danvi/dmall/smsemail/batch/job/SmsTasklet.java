package net.danvi.dmall.smsemail.batch.job;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.smsemail.batch.service.SmsBatchService;
import net.danvi.dmall.smsemail.model.sms.SmsSendHistVO;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
public class SmsTasklet implements Tasklet {
    @Resource(name = "smsBatchService")
    private SmsBatchService smsBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        List<SmsSendHistVO> smsFailListCount = smsBatchService.smsFailCountListReader();
        List<SmsSendHistVO> lmsFailListCount = smsBatchService.lmsFailCountListReader();
        smsBatchService.updSmsStatus();
        smsBatchService.updLmsStatus();
        for (int i = 0; i < smsFailListCount.size(); i++) {
            smsBatchService.updateSmsFailPointAdd(smsFailListCount.get(i));
        }
        for (int i = 0; i < lmsFailListCount.size(); i++) {
            smsBatchService.updateSmsFailPointAdd(lmsFailListCount.get(i));
        }
        return null;
    }
}
