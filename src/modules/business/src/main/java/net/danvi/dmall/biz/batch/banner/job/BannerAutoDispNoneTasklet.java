package net.danvi.dmall.biz.batch.banner.job;

import net.danvi.dmall.biz.batch.banner.service.BannerBatchService;
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
 * 설명       : 배너 자동 미전시 처리 Tasklet
 * </pre>
 */
public class BannerAutoDispNoneTasklet implements Tasklet {

    @Resource(name = "bannerBatchService")
    private BannerBatchService bannerBatchService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {
        bannerBatchService.bannerAutoDispNone(); // 기획전 자동 미전시 처리
        return null;
    }
}
