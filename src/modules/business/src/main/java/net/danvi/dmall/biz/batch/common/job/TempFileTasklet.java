package net.danvi.dmall.biz.batch.common.job;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.common.service.TempFileService;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 10. 18.
 * 작성자     : dong
 * 설명       : 임시 폴더 삭제 처리
 * </pre>
 */
public class TempFileTasklet implements Tasklet {

    @Resource(name = "tempFileService")
    private TempFileService tempFileService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        // 처리 내역
        // 임시 폴더 삭제 처리

        tempFileService.tempFileDel(); // 임시 폴더 삭제 처리

        return null;
    }
}
