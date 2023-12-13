package net.danvi.dmall.admin.batch.sample;

import java.util.Map;

import org.springframework.batch.item.ItemProcessor;

import net.danvi.dmall.biz.common.model.BizCodeVO;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 19.
 * 작성자     : dong
 * 설명       : Map을 BizCodeVO 으로 변환하여 반환하는 프로세서
 *              샘플용
 * </pre>
 */
public class MapToBizCodeVOProcessor implements ItemProcessor<Map, BizCodeVO> {

    @Override
    public BizCodeVO process(Map m) throws Exception {
        BizCodeVO bizCodeVO = new BizCodeVO();
        bizCodeVO.setGrpCd((String) m.get("GRP_CD"));
        bizCodeVO.setDtlCd((String) m.get("CD"));
        bizCodeVO.setDtlNm((String) m.get("CD_NM"));
        return bizCodeVO;
    }
}
