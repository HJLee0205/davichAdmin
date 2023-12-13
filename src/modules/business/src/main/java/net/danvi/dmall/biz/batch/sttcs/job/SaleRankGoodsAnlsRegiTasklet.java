package net.danvi.dmall.biz.batch.sttcs.job;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.sttcs.SttcsConstant;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.batch.sttcs.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.sttcs.service.SttcsService;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 23
 * 작성자     : dong
 * 설명       : 판매순위 상품분석 집계 Tasklet
 * </pre>
 */
public class SaleRankGoodsAnlsRegiTasklet implements Tasklet {

    @Resource(name = "sttcsService")
    private SttcsService sttcsService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        // 잡 파라미터
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setBtId(SttcsConstant.BT_ID_SALE_RANK_GOODS_ANLS);
        vo.setBtPgmId(SttcsConstant.BT_PGM_ID_SALE_RANK_GOODS_ANLS);
        vo.setBtPgmNm(SttcsConstant.BT_PGM_NM_SALE_RANK_GOODS_ANLS);

        sttcsService.registSaleRankGoodsAnls(vo); // 통계서비스.판매순위 상품분석 집계

        return RepeatStatus.FINISHED;
    }
}
