package net.danvi.dmall.biz.common.service;

import java.util.HashMap;
import java.util.Map;

import net.danvi.dmall.biz.app.goods.service.GoodsManageServiceImpl;
import net.danvi.dmall.biz.common.dao.CommonDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;

@Slf4j
@Service("bizService")
@Transactional(rollbackFor = Exception.class)
public class BizServiceImpl extends BaseService implements BizService {

    @Autowired
    @Qualifier("commonDao")
    private CommonDao bizDao;

    /*
     * 시퀀스 번호 조회
     *
     * @see biz.common.service.BizService#getSequence(java.lang.String)
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Long getSequence(String seqGb) throws Exception {
        return getSequence(seqGb, (long) 0);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Long getSequence(String seqGb, Long siteNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("seqGb", seqGb);
        param.put("siteNo", siteNo);
        long result;

        log.info("seqGb : "+seqGb);
        log.info("siteNo : "+siteNo);

        result = bizDao.getSequence(param);

        if (result < 0) {
            // TODO: 메시지화
            throw new CustomException("시퀀스 생성시 오류가 발생했습니다.");
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Long getSiteNo(String domain) {
        return proxyDao.selectOne(MapperConstants.COMMON + "getSiteNo", domain);
    }
}