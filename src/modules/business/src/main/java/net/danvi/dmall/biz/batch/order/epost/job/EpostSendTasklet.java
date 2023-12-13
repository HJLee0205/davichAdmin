package net.danvi.dmall.biz.batch.order.epost.job;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.order.epost.service.EpostService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 15.
 * 작성자     : dong
 * 설명       : 우체국택배 Tasklet
 * </pre>
 */
public class EpostSendTasklet implements Tasklet {

    @Resource(name = "epostService")
    private EpostService epostService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        // 잡 파라미터
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setRegrNo(300L); // 배치 > 시스템, 필요할 경우 배치 > 시스템 > 사방넷연계 로 101L등으로 수정
        vo.setUpdrNo(300L); // 배치 > 시스템
        vo.setSiteNo(param.getLong(SabangnetConstant.SITE_NO));
        vo.setSendDate(param.getString(SabangnetConstant.SEND_DATE));
        String domain = param.getString(SabangnetConstant.DOMAIN);

        epostService.epostSend(vo, domain); // 우체국 택배 송신 ( 파일쓰기 )

        return null;
    }
}
