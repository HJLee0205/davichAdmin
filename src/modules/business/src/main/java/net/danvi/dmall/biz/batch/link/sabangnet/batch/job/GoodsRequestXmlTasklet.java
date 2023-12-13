package net.danvi.dmall.biz.batch.link.sabangnet.batch.job;

import dmall.framework.common.constants.CommonConstants;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.Goods;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.GoodsRequest;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.Order;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.OrderRequest;
import net.danvi.dmall.biz.batch.link.sabangnet.service.SabangnetService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 15.
 * 작성자     : dong
 * 설명       : 주문정보 수집 요청 XML 생성 Tasklet
 * </pre>
 */
public class GoodsRequestXmlTasklet implements Tasklet {

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
        vo.setGoodsField(SabangnetConstant.GOODS_PRT_FIELD); // 출력필드


        vo.setIfId(SabangnetConstant.IF_ID_GOODS_READ);
        vo.setIfPgmId(SabangnetConstant.IF_PGM_ID_GOODS_READ);
        vo.setIfPgmNm(SabangnetConstant.IF_PGM_NM_GOODS_READ_XML);
        vo.setIfGbCd(SabangnetConstant.IF_GB_CD);
        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 등록자 번호
        vo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 수정자 번호
        vo.setLang(param.getString(SabangnetConstant.LANG)); // 인코딩타입

        vo.setSendGoodsCdRt("");
        vo.setSendInvEditYn("");
        vo.setCsStatus("");
        vo.setClmField("");

        String domain = param.getString(SabangnetConstant.DOMAIN);

        GoodsRequest header = new GoodsRequest();
        header.setSendCompaynyId(vo.getSendCompaynyId());
        header.setSendAuthKey(vo.getSendAuthKey());
        header.setSendDate(vo.getSendDate());

        List<Goods> list = new ArrayList<>();

        Goods data = new Goods();
        data.setRegStDate(vo.getStDate());
        data.setRegEdDate(vo.getEdDate());
        data.setGoodsField(vo.getGoodsField());
        data.setLang(vo.getLang());

        list.add(data);

        header.setData(list);

        String fileName = sabangnetService.createGoodsRequestXml(header, list, vo);

        // 잡 파라미터 세팅
        chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().put("fileName",fileName);

        return null;
    }
}
