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
 * 설명       : 탈퇴 회원 Tasklet
 * </pre>
 */
public class MemberWithdrawalTasklet implements Tasklet {
    @Resource(name = "memberBatchService")
    private MemberBatchService memberBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        List<MemberManageVO> selectWithdrawalMemTargetBbs = memberBatchService.selectWithdrawalMemTargetBbs();
        for (int i = 0; i < selectWithdrawalMemTargetBbs.size(); i++) {
            MemberManageVO vo = selectWithdrawalMemTargetBbs.get(i);
            memberBatchService.deleteMemberNoRelationBbsInfo(vo);
        }
        List<MemberManageVO> selectWithdrawalMemTargetOrd = memberBatchService.selectWithdrawalMemTargetOrd();
        for (int i = 0; i < selectWithdrawalMemTargetOrd.size(); i++) {
            MemberManageVO vo = selectWithdrawalMemTargetOrd.get(i);
            memberBatchService.deleteMemberNoRelationOrdInfo(vo);
        }

        return null;
    }

}
