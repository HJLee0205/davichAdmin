package net.danvi.dmall.smsemail.batch.job;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.smsemail.batch.service.EmailBatchService;
import net.danvi.dmall.smsemail.batch.service.SmsBatchService;
import net.danvi.dmall.smsemail.model.email.EmailSendHistVO;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
public class EmailTasklet implements Tasklet {
    @Resource(name = "smsBatchService")
    private SmsBatchService smsBatchService;

    @Resource(name = "emailBatchService")
    private EmailBatchService emailBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        List<EmailSendHistVO> emailSendingList = emailBatchService.selectEmailSendingList();

        if (emailSendingList.size() > 0) {
            List<EmailSendHistVO> emailSendCompletList = emailBatchService.selectEmailSendCompletList(emailSendingList);

            // 메일 발송 결과 테이블
            String campaignTbNm = "tm.campaign_result";
            // 발송 성공 건수
            String successCnt = "";

            if (emailSendCompletList.size() > 0) {
                for (int i = 0; i < emailSendCompletList.size(); i++) {
                    EmailSendHistVO vo = emailSendCompletList.get(i);

                    vo.setCampaignTbNm(campaignTbNm + vo.getCampaignNo());

                    // 성공 건수 조회
                    successCnt = emailBatchService.selectEmailSucsCnt(vo);
                    vo.setSucsCnt(successCnt);

                    // 성공 건수, 발송 상태 업데이트
                    emailBatchService.updateEmailSendResult(vo);
                }

            }
        }
        return null;
    }
}
