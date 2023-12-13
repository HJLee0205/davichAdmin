package net.danvi.dmall.biz.batch.goods.salestatus.job;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.goods.service.GoodsBatchService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.batch.goods.salestatus.model.GoodsBatchVO;
import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : dong
 * 설명       : 상품 판매정보 변경 Tasklet
 * </pre>
 */
public class GoodsSaleInfoTasklet implements Tasklet {

    @Resource(name = "goodsBatchService")
    private GoodsBatchService goodsBatchService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        // 잡 파라미터
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        GoodsBatchVO vo = new GoodsBatchVO();
        vo.setRegrNo(CommonConstants.MEMBER_BATCH_SYSTEM); // 배치 > 시스템
        vo.setUpdrNo(CommonConstants.MEMBER_BATCH_SYSTEM); // 배치 > 시스템

        goodsBatchService.updateGoodsSortInfo(vo); // 상품 판매여부 변경

        return null;
    }
}
