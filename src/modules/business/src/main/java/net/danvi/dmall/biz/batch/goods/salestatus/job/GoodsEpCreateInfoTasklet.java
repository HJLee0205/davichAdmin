package net.danvi.dmall.biz.batch.goods.salestatus.job;

import dmall.framework.common.constants.CommonConstants;
import net.danvi.dmall.biz.batch.goods.salestatus.model.GoodsBatchVO;
import net.danvi.dmall.biz.batch.goods.service.GoodsBatchService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import javax.annotation.Resource;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : dong
 * 설명       : 네이버 지식쇼핑 파일생성 Tasklet
 * </pre>
 */
public class GoodsEpCreateInfoTasklet implements Tasklet {

    @Resource(name = "goodsBatchService")
    private GoodsBatchService goodsBatchService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {
        goodsBatchService.createEpGoodsInfo(); // 네이버 지식쇼핑 파일생성
        return null;
    }
}
