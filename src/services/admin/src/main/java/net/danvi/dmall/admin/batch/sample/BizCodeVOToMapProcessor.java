package net.danvi.dmall.admin.batch.sample;

import java.util.HashMap;
import java.util.Map;

import org.springframework.batch.item.ItemProcessor;

import net.danvi.dmall.biz.common.model.BizCodeVO;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 19.
 * 작성자     : dong
 * 설명       : BizCodeVO 객체를 Map 으로 반환하는 프로세서
 *              샘플용
 * </pre>
 */
public class BizCodeVOToMapProcessor implements ItemProcessor<BizCodeVO, Map> {

    @Override
    public Map process(BizCodeVO vo) throws Exception {
        Map m = new HashMap();
        m.put("GRP_CD", vo.getGrpCd());
        m.put("CD", vo.getDtlCd());
        m.put("CD_NM", vo.getDtlNm());
        return m;
    }
}
