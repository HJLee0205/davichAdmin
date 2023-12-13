package net.danvi.dmall.biz.system.service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.model.SiteQuotaPO;
import net.danvi.dmall.biz.system.model.SiteQuotaVO;
import net.danvi.dmall.core.remote.homepage.model.request.PaymentInfoPO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;

import javax.annotation.Resource;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 11.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("siteQuotaService")
@Transactional(rollbackFor = Exception.class)
public class SiteQuotaServiceImpl extends BaseService implements SiteQuotaService {

    @Resource(name = "siteService")
    private SiteService siteService;

    private String RENTAL_FREE = "1";
    private String RENTAL = "2";
    private String STANDALONE = "3";

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#getDiskQuota(java.lang.Long)
     */
//    @Override
//    public Long getDiskQuota(Long siteNo) {
//        // TODO Auto-generated method stub
//
//        return Long.valueOf(getDummyResultPoint());
//    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#isManagerAddible(java.lang.Long)
     */
    @Override
    public boolean isManagerAddible(Long siteNo) {
        // 무료형일 경우만 체크
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        if (RENTAL.equals(vo.getSiteTypeCd()) || STANDALONE.equals(vo.getSiteTypeCd())) {
            return true;
        }

        SiteQuotaVO siteQuotaVO = proxyDao.selectOne("selectManagerCount", siteNo);
        return siteQuotaVO.getQuotaCount() > siteQuotaVO.getRealCount();
    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#isIconAddible(java.lang.Long)
     */
    @Override
    public boolean isIconAddible(Long siteNo) {
        // 무료형일 경우만 체크
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        if (RENTAL.equals(vo.getSiteTypeCd()) || STANDALONE.equals(vo.getSiteTypeCd())) {
            return true;
        }

        SiteQuotaVO siteQuotaVO = proxyDao.selectOne("selectIconCount", siteNo);
        return siteQuotaVO.getQuotaCount() > siteQuotaVO.getRealCount();
    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#isAccountAddible(java.lang.Long)
     */
    @Override
    public boolean isAccountAddible(Long siteNo) {
        // 무료형일 경우만 체크
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        if (RENTAL.equals(vo.getSiteTypeCd()) || STANDALONE.equals(vo.getSiteTypeCd())) {
            return true;
        }

        SiteQuotaVO siteQuotaVO = proxyDao.selectOne("selectNopbActCount", siteNo);
        return siteQuotaVO.getQuotaCount() > siteQuotaVO.getRealCount();
    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#isBbsAddible(java.lang.Long)
     */
    @Override
    public boolean isBbsAddible(Long siteNo) {
        // 무료형일 경우만 체크
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        if (RENTAL.equals(vo.getSiteTypeCd()) || STANDALONE.equals(vo.getSiteTypeCd())) {
            return true;
        }

        SiteQuotaVO siteQuotaVO = proxyDao.selectOne("selectBbsCount", siteNo);
        return siteQuotaVO.getQuotaCount() > siteQuotaVO.getRealCount();
    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#getTrafficQuota(java.lang.Long)
     */
//    @Override
//    public Long getTrafficQuota(Long siteNo) {
//        // TODO Auto-generated method stub
//        return Long.valueOf(getDummyResultPoint());
//    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#getSmsPoint(java.lang.Long)
     */
//    @Override
//    public int getSmsPoint(Long siteNo) {
//        // TODO Auto-generated method stub
//        return getDummyResultPoint();
//    }

    /*
     * (non-Javadoc)
     * 
     * @see SiteQuotaService#getEmailPoint(java.lang.Long)
     */
//    @Override
//    public int getEmailPoint(Long siteNo) {
//        // TODO Auto-generated method stub
//        return getDummyResultPoint();
//    }

    @Override
    public boolean isSnsAddible(Long siteNo, String outsiteLinkCd) {
        // 무료형일경우만 체크
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        if (RENTAL.equals(vo.getSiteTypeCd()) || STANDALONE.equals(vo.getSiteTypeCd())) {
            return true;
        }

        PaymentInfoPO po = new PaymentInfoPO();
        po.setSiteNo(siteNo);
        po.setOutsideLinkCd(outsiteLinkCd);
        return hasSnsLoginInfo(po);
    }

    @Override
    public Integer getManagerCount(Long siteNo) throws Exception {
        SiteQuotaVO vo = proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectManagerCount", siteNo);
        return vo.getRealCount();
    }

    @Override
    public Integer updateManagerCount(PaymentInfoPO po) {
        SiteQuotaPO siteQuotaPO = new SiteQuotaPO();
        siteQuotaPO.setSiteNo(po.getSiteNo());
        siteQuotaPO.setManagerActCnt(Integer.parseInt(po.getAmt()));
        siteQuotaPO.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        return proxyDao.update(MapperConstants.SYSTEM_SITE + "updateAdminCnt", siteQuotaPO);
    }

    @Override
    public Integer getAccountCount(Long siteNo) {
        SiteQuotaVO vo = proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectBbsCount", siteNo);
        return vo.getRealCount();
    }

    @Override
    public Integer updateAccountCount(PaymentInfoPO po) {
        SiteQuotaPO siteQuotaPO = new SiteQuotaPO();
        siteQuotaPO.setSiteNo(po.getSiteNo());
        siteQuotaPO.setNopbActCnt(Integer.parseInt(po.getAmt()));
        siteQuotaPO.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        return proxyDao.update(MapperConstants.SYSTEM_SITE + "updateNopbActCnt", siteQuotaPO);
    }

    @Override
    public Integer getIconCount(Long siteNo) {
        SiteQuotaVO vo = proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectBbsCount", siteNo);
        return vo.getRealCount();
    }

    @Override
    public Integer updateIconCount(PaymentInfoPO po) {
        SiteQuotaPO siteQuotaPO = new SiteQuotaPO();
        siteQuotaPO.setSiteNo(po.getSiteNo());
        siteQuotaPO.setIconCnt(Integer.parseInt(po.getAmt()));
        siteQuotaPO.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        return proxyDao.update(MapperConstants.SYSTEM_SITE + "updateIconCnt", siteQuotaPO);
    }

    @Override
    public Integer getBbsCount(Long siteNo) {
        SiteQuotaVO vo = proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectBbsCount", siteNo);
        return vo.getRealCount();
    }

    @Override
    public Integer updateBbsCount(PaymentInfoPO po) {
        SiteQuotaPO siteQuotaPO = new SiteQuotaPO();
        siteQuotaPO.setSiteNo(po.getSiteNo());
        siteQuotaPO.setBbsCnt(Integer.parseInt(po.getAmt()));
        siteQuotaPO.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        return proxyDao.update(MapperConstants.SYSTEM_SITE + "updateBbsCnt", siteQuotaPO);
    }

    @Override
    public boolean hasSnsLoginInfo(PaymentInfoPO po) {
        return (Integer)proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectSocialLoginInfo", po) > 0 ? true : false;
    }

    @Override
    public Integer insertSnsLoginInfo(PaymentInfoPO po) {
        return proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSocialLogin", po);
    }
}
