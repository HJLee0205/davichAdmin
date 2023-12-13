package net.danvi.dmall.biz.batch.member.job;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.batch.member.service.MemberBatchService;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 11. 20.
 * 작성자     : khy
 * 설명       : 방문예약에게 고객에게 알림 Tasklet
 * </pre>
 */
public class MemberVisitRsvAlamTasklet implements Tasklet {
    @Resource(name = "memberBatchService")
    private MemberBatchService memberBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        List<VisitVO> vistList = memberBatchService.selectMemVisitRsvList();
        for (int i = 0; i < vistList.size(); i++) {
            memberBatchService.visitRsvAlamWriter(vistList.get(i));
        }
        return null;
    }
}
