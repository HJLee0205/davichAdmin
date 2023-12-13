package net.danvi.dmall.biz.batch.member.job;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelSO;
import net.danvi.dmall.biz.batch.member.service.MemberBatchService;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 17.
 * 작성자     : dong
 * 설명       : 회원 Tasklet
 * </pre>
 */
public class MemberTasklet implements Tasklet {
    @Resource(name = "memberBatchService")
    private MemberBatchService memberBatchService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {

        List<MemberLevelVO> rerrangeList = memberBatchService.selectMemGradeRearrangeList();

        for (int i = 0; i < rerrangeList.size(); i++) {
            // 산출기간
            MemberLevelSO so = new MemberLevelSO();
            so.setSiteNo(rerrangeList.get(i).getSiteNo());
            List<MemberLevelVO> memGradeList = memberBatchService.selectMemGradeList(so);

            MemberLevelPO po = new MemberLevelPO();
            po.setSiteNo(rerrangeList.get(i).getSiteNo());
            po.setGradeCcltPeriod(rerrangeList.get(i).getGradeCcltPeriod());

            for (int j = 0; j < memGradeList.size(); j++) {
                po.setMemberGradeNo(memGradeList.get(j).getMemberGradeNo());
                // 자동 산정 여부
                if (("Y").equals(memGradeList.get(j).getAutoYn())) {
                    // 주문금액, 주문횟수 기준
                    if (("10").equals(memGradeList.get(j).getMemberGradeManageCd())) {
                        // 주문금액 기준이 없는 경우
                        if (("0").equals(memGradeList.get(j).getTotBuyAmt())) {
                            po.setTotBuyAmt(memGradeList.get(j + 1).getTotBuyAmt());
                        } else {
                            po.setTotBuyAmt(memGradeList.get(j).getTotBuyAmt());
                        }
                        // 주문횟수 기준이 없는 경우
                        if (("0").equals(memGradeList.get(j).getTotBuyCnt())) {
                            po.setTotBuyCnt(memGradeList.get(j + 1).getTotBuyCnt());
                        } else {
                            po.setTotBuyCnt(memGradeList.get(j).getTotBuyCnt());
                        }

                        if (("0").equals(memGradeList.get(j).getTotBuyAmt()) && ("0").equals(memGradeList.get(j).getTotBuyCnt())) {
                            po.setRearrangeWhere("A.SALE_AMT < " + po.getTotBuyAmt() + " OR A.ORD_CNT < " + po.getTotBuyCnt());
                        } else {
                            if (j == (memGradeList.size() - 1)) {
                                po.setRearrangeWhere("A.SALE_AMT >= " + po.getTotBuyAmt() + " AND A.ORD_CNT >= "+ po.getTotBuyCnt());
                            } else {
                                po.setRearrangeWhere("(A.SALE_AMT >=" + po.getTotBuyAmt() + " AND A.SALE_AMT <"+ memGradeList.get(j + 1).getTotBuyAmt() + " AND A.ORD_CNT >= " + po.getTotBuyCnt() + " AND A.ORD_CNT < "+ memGradeList.get(j + 1).getTotBuyCnt() + ") OR (A.SALE_AMT >= "+ po.getTotBuyAmt() + " AND A.ORD_CNT >= " + po.getTotBuyCnt() + ")");
                            }
                        }
                    }
                    // 포인트 기준
                    else {
                        if (("0").equals(memGradeList.get(j).getTotPoint())) {
                            po.setTotPoint(memGradeList.get(j + 1).getTotPoint());

                            po.setRearrangeWhere("A.PRC_POINT < " + po.getTotPoint());
                        } else {
                            if (j == (memGradeList.size() - 1)) {
                                po.setRearrangeWhere("A.PRC_POINT >= " + po.getTotPoint());
                            } else {
                                po.setRearrangeWhere("A.PRC_POINT >= " + po.getTotPoint() + " AND A.PRC_POINT < "+ memGradeList.get(j + 1).getTotPoint());
                            }
                        }
                    }
                    // 등급 반영
                    memberBatchService.updateMemGradeRearrange(po);
                }

            }
        }

        return RepeatStatus.FINISHED;
    }

}
