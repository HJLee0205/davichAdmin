package net.danvi.dmall.biz.batch.operation.job;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.system.remote.smseml.SmsDelegateService;
import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 10. 6.
 * 작성자     : dong
 * 설명       : sms 080 수신거부 상태 업데이트
 * </pre>
 */
public class Sms080RejectTasklet implements Tasklet {
    @Resource(name = "smsDelegateService")
    private SmsDelegateService smsDelegateService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
        List<Sms080RecvRjtVO> rectList = smsDelegateService.select080RectList();
        String[] memberTelnoTarget = new String[rectList.size()];
        if (rectList.size() > 0) {
            for (int i = 0; i < rectList.size(); i++) {
                memberTelnoTarget[i] = CryptoUtil.encryptAES(rectList.get(i).getTelno());
            }
            memberManageService.updateRecvRjtYnMemInfo(memberTelnoTarget);
            smsDelegateService.updateProcYn(rectList);
        }
        return null;
    }
}
