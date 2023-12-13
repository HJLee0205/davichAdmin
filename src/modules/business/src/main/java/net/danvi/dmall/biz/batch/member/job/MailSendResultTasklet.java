package net.danvi.dmall.biz.batch.member.job;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.operation.model.EmailSendVO;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.batch.member.service.MemberBatchService;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 26.
 * 작성자     : kjw
 * 설명       : 대량메일발송 결과값 수정 Tasklet
 * </pre>
 */
public class MailSendResultTasklet implements Tasklet {
    @Resource(name = "memberBatchService")
    private MemberBatchService memberBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {

        // 대량메일 솔루션에서 발송결과 목록 조회 (추후 추가)
        List<EmailSendVO> resultList = new ArrayList<>();

        for (int i = 0; i < resultList.size(); i++) {
            EmailSendPO po = new EmailSendPO();
            po.setMailSendNo(resultList.get(i).getMailSendNo());
            po.setResultCd(resultList.get(i).getResultCd());

            // 대량메일 발송 결과값 수정
            memberBatchService.updateMailSendResult(po);
        }

        return RepeatStatus.FINISHED;
    }

}
