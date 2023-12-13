package net.danvi.dmall.biz.batch.sttcs.job;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.sttcs.SttcsConstant;
import net.danvi.dmall.biz.batch.sttcs.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.sttcs.service.SttcsService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import javax.annotation.Resource;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 23
 * 작성자     : dong
 * 설명       : 방문자분석 집계 Tasklet
 * </pre>
 */
@Slf4j
public class LoginCurrentStatusRegiTasklet implements Tasklet {

    @Resource(name = "sttcsService")
    private SttcsService sttcsService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        // 잡 파라미터
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setBtId(SttcsConstant.BT_ID_VSTR_ANLS);
        vo.setBtPgmId(SttcsConstant.BT_PGM_ID_VSTR_ANLS);
        vo.setBtPgmNm(SttcsConstant.BT_PGM_NM_VSTR_ANLS);

        sttcsService.registVstrAnls(vo); // 통계서비스.방문자분석 집계

        return RepeatStatus.FINISHED;
    }
}
