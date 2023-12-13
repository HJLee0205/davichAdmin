package net.danvi.dmall.biz.batch.link.sabangnet.batch.job;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.Claim;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.ClaimRequest;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.batch.link.sabangnet.service.SabangnetService;
import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 15.
 * 작성자     : dong
 * 설명       : 클레임정보 수집 요청 XML 생성 Tasklet
 * </pre>
 */
public class ClaimRequestXmlTasklet implements Tasklet {

    @Resource(name = "sabangnetService")
    private SabangnetService sabangnetService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setSendCompaynyId(param.getString(SabangnetConstant.SEND_COMPAYNY_ID));
        vo.setSendAuthKey(param.getString(SabangnetConstant.SEND_AUTH_KEY));
        vo.setSendDate(param.getString(SabangnetConstant.SEND_DATE));
        vo.setSiteNo(param.getLong(SabangnetConstant.SITE_NO));
        vo.setSiteId(param.getString(SabangnetConstant.SITE_ID));
        vo.setSiteNm(param.getString(SabangnetConstant.SITE_NM));
        vo.setStDate(param.getString(SabangnetConstant.ST_DATE)); // 검색시작일자
        vo.setEdDate(param.getString(SabangnetConstant.ED_DATE)); // 검색종료일자
        vo.setClmField(SabangnetConstant.CLM_PRT_FIELD); // 출력필드

        vo.setIfId(SabangnetConstant.IF_ID_CLAIM);
        vo.setIfPgmId(SabangnetConstant.IF_PGM_ID_CLAIM);
        vo.setIfPgmNm(SabangnetConstant.IF_PGM_NM_CLAIM_XML);
        vo.setIfGbCd(SabangnetConstant.IF_GB_CD);
        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 등록자 번호
        vo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 수정자 번호
        vo.setLang(param.getString(SabangnetConstant.LANG)); // 인코딩타입

        vo.setSendGoodsCdRt("");
        vo.setJungChkYn2("");
        vo.setOrderId("");
        vo.setMallId("");
        vo.setSendInvEditYn("");
        vo.setCsStatus("");
        vo.setOrdField("");

        String domain = param.getString(SabangnetConstant.DOMAIN);

        ClaimRequest header = new ClaimRequest();
        header.setSendCompaynyId(vo.getSendCompaynyId());
        header.setSendAuthKey(vo.getSendAuthKey());
        header.setSendDate(vo.getSendDate());

        List<Claim> list = new ArrayList<>();

        Claim data = new Claim();
        data.setClmStDate(vo.getStDate());
        data.setClmEdDate(vo.getEdDate());
        data.setClmField(vo.getClmField());

        list.add(data);

        header.setData(list);

        String fileName = sabangnetService.createClaimRequestXml(header, list, vo);

        // 잡 파라미터 세팅
        chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().put("fileName",fileName);

        return null;
    }
}
