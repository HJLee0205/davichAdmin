package net.danvi.dmall.biz.batch.member.job;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.batch.member.service.MemberBatchService;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : dong
 * 설명       : 휴면 회원 Tasklet
 * </pre>
 */
public class MemberDormantTasklet implements Tasklet {
    @Resource(name = "memberBatchService")
    private MemberBatchService memberBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        List<MemberManageVO> memDormantList = memberBatchService.memDormantReader();
        for (int i = 0; i < memDormantList.size(); i++) {
            memberBatchService.memDormantWriter(memDormantList.get(i));
        }
        return null;
    }
}
