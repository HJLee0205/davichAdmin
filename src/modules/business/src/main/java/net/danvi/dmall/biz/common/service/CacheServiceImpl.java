package net.danvi.dmall.biz.common.service;

import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.PopManageSO;
import net.danvi.dmall.biz.app.design.model.PopManageVO;
import net.danvi.dmall.biz.app.goods.model.CategoryVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.common.dao.CommonDao;
import net.danvi.dmall.biz.system.model.*;
import net.danvi.dmall.biz.system.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.handler.CacheHandler;
import dmall.framework.common.model.ResultModel;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("cacheService")
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class CacheServiceImpl extends BaseService implements CacheService {

    @Autowired
    private CommonDao bizDao;

    @Resource(name = "menuService")
    private MenuService menuService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    @Autowired
    private CacheHandler cacheHandler;

    @Override
    @Transactional(readOnly = true)
    @PostConstruct
    public void listCodeCache() {
        List<CmnCdGrpVO> list = bizDao.listCodeAll();

        Map<String, List<CmnCdDtlVO>> codeMap = new HashMap<>();

        Map<String, Map<String, String>> codeValueMap = new HashMap<>();

        setCodeMap(list, codeMap, codeValueMap);
        log.info("코드 그룹 캐시 등록");
        cacheHandler.put(AdminConstants.CACHE_CODE_GROUP, list);
        log.info("코드 캐시 등록");
        cacheHandler.put(AdminConstants.CACHE_CODE, codeMap);
        log.info("코드 값 캐시 등록");
        cacheHandler.put(AdminConstants.CACHE_CODE_VALUE, codeValueMap);

    }

    private void setCodeMap(List<CmnCdGrpVO> list, Map<String, List<CmnCdDtlVO>> codeMap,
            Map<String, Map<String, String>> codeValueMap) {
        for (CmnCdGrpVO groupCode : list) {
            Map<String, String> code = new HashMap<>();
            for (CmnCdDtlVO detailCode : groupCode.getListCmnCdDtlVO()) {
                code.put(detailCode.getDtlCd(), detailCode.getDtlNm());
            }

            codeValueMap.put(groupCode.getGrpCd(), code);
            codeMap.put(groupCode.getGrpCd(), groupCode.getListCmnCdDtlVO());
        }
    }

    @Override
    @Transactional(readOnly = true)
    public void listCodeCacheRefresh() {
        List<CmnCdGrpVO> list = bizDao.listCodeAll();

        Map<String, List<CmnCdDtlVO>> codeMap = new HashMap<>();

        Map<String, Map<String, String>> codeValueMap = new HashMap<>();

        setCodeMap(list, codeMap, codeValueMap);

        // if (cacheHandler.getElement(AdminConstants.CACHE_CODE_GROUP) == null)
        // {
        // cacheHandler.put(AdminConstants.CACHE_CODE_GROUP, list);
        // } else {
        // cacheHandler.replace(AdminConstants.CACHE_CODE_GROUP, list);
        // }
        refresh(AdminConstants.CACHE_CODE_GROUP, list);

        // if (cacheHandler.getElement(AdminConstants.CACHE_CODE) == null) {
        // cacheHandler.put(AdminConstants.CACHE_CODE, codeMap);
        // } else {
        // cacheHandler.replace(AdminConstants.CACHE_CODE, codeMap);
        // }
        refresh(AdminConstants.CACHE_CODE, codeMap);

        // if (cacheHandler.getElement(AdminConstants.CACHE_CODE_VALUE) == null)
        // {
        // cacheHandler.put(AdminConstants.CACHE_CODE_VALUE, codeValueMap);
        // } else {
        // cacheHandler.replace(AdminConstants.CACHE_CODE_VALUE, codeValueMap);
        // }
        refresh(AdminConstants.CACHE_CODE_VALUE, codeValueMap);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, MenuVO> getScreenMap() throws Exception {
        String key = "SCREEN";
        Map<String, MenuVO> value = (Map<String, MenuVO>) getCacheValue(key, new CacheValue() {
            @Override
            Object getValue(Object obj) {
                List<MenuVO> list = menuService.selectScreen();
                Map<String, MenuVO> menuVOMap = new HashMap<>();
                for (MenuVO vo : list) {
                    menuVOMap.put(vo.getUrl(), vo);
                }
                return menuVOMap;
            }
        });

        return value;
    }

    @Override
    public void refreshScreenMapCache() {
        String key = "SCREEN";
        Map<String, MenuVO> newValue = new HashMap<>();
        List<MenuVO> list = menuService.selectScreen();

        for (MenuVO vo : list) {
            newValue.put(vo.getUrl(), vo);
        }

        refresh(key, newValue);
    }

    @Override
    public SiteVO selectBasicInfo(SiteSO so) throws Exception {
        String key = "SITE_INFO_" + so.getSiteNo();
        SiteVO value = (SiteVO) getCacheValue(key, so, new CacheValue() {
            @Override
            Object getValue(Object so) {
                ResultModel<SiteVO> resultModel = siteInfoService.selectSiteInfo((SiteSO) so);
                return resultModel.getData();
            }
        });

        return value;
    }

    @Override
    public void refreshBasicInfoCache(SiteSO so) {
        String key = "SITE_INFO_" + String.valueOf(so.getSiteNo());
        ResultModel<SiteVO> resultModel = siteInfoService.selectSiteInfo(so);

        refresh(key, resultModel.getData());
    }

    @Override
    public void refreshNopbInfo(Long siteNo) {
        String key = "NOPB_INFO_" + siteNo;
        List<NopbPaymentConfigVO> list = paymentManageService.selectNopbInfo(siteNo);

        refresh(key, list);
    }

    @Override
    public void refreshGnbInfo(Long siteNo) {
        String key = "GNB_INFO_" + siteNo;
        Map map = new HashMap();
        List<CategoryVO> list = categoryManageService.selectFrontGnbList(siteNo);
        if (list != null && list.size() > 0) {
        	List subCtgList;
            for (CategoryVO vo : list) {
                subCtgList = (List) map.get(vo.getUpCtgNo());
                if (subCtgList == null) {
                    subCtgList = new ArrayList();
                }
                subCtgList.add(vo);
                map.put(vo.getUpCtgNo(), subCtgList);
            }
        }

        refresh(key, map);
    }
    
    @Override
    public void refreshLnbInfo(Long siteNo) {
        String key = "LNB_INFO_" + siteNo;
        Map map = new HashMap();
        List<CategoryVO> list = categoryManageService.selectFrontLnbList(siteNo);
        if (list != null && list.size() > 0) {
            List subCtgList;
            for (CategoryVO vo : list) {
                subCtgList = (List) map.get(vo.getUpCtgNo());
                if (subCtgList == null) {
                    subCtgList = new ArrayList();
                }
                subCtgList.add(vo);
                map.put(vo.getUpCtgNo(), subCtgList);
            }
        }

        refresh(key, map);
    }

    @Override
    public List<NopbPaymentConfigVO> selectNopbInfo(SiteSO so) throws Exception {
        final long siteNo = so.getSiteNo();
        String key = "NOPB_INFO_" + siteNo;
        List<NopbPaymentConfigVO> value = (List<NopbPaymentConfigVO>) getCacheValue(key, new CacheValue() {
            @Override
            Object getValue(Object obj) {
                List<NopbPaymentConfigVO> list = paymentManageService.selectNopbInfo(siteNo);
                return list;
            }
        });
        return value;
    }

    @Override
    public List<PopManageVO> selectPopupInfo(SiteSO so) throws Exception {
        final long siteNo = so.getSiteNo();
        PopManageSO popSo = new PopManageSO();
        popSo.setSiteNo(siteNo);
        popSo.setDateGubn("Front");
        if(SiteUtil.isMobile()){
            popSo.setPcGbCd("M");
        }else{
            popSo.setPcGbCd("C");
        }
        popSo.setDispYn("Y");
        popSo.setOffset(10000);
        List<PopManageVO> value = proxyDao.selectList("design.popupManage.selectPopManagePaging", popSo);
        return value;
    }

    @Override
    public Map selectGnbInfo(SiteSO so) throws Exception {
        final long siteNo = so.getSiteNo();
        String key = "GNB_INFO_" + siteNo;
        final Map value = (Map) getCacheValue(key, new CacheValue() {
            @Override
            Object getValue(Object obj) {
                Map map = new HashMap();
                List<CategoryVO> list = categoryManageService.selectFrontGnbList(siteNo);
                if (list != null && list.size() > 0) {
                	List subCtgList;
                    for (CategoryVO vo : list) {
                        subCtgList = (List) map.get(vo.getUpCtgNo());
                        if (subCtgList == null) {
                            subCtgList = new ArrayList();
                        }
                        subCtgList.add(vo);
                        map.put(vo.getUpCtgNo(), subCtgList);
                    }
                }
                return map;
            }
        });
        return value;
    }
    
    @Override
    public Map selectLnbInfo(SiteSO so) throws Exception {
        final long siteNo = so.getSiteNo();
        String key = "LNB_INFO_" + siteNo;
        final Map value = (Map) getCacheValue(key, new CacheValue() {
            @Override
            Object getValue(Object obj) {
                Map map = new HashMap();
                List<CategoryVO> list = categoryManageService.selectFrontLnbList(siteNo);
                if (list != null && list.size() > 0) {
                    List subCtgList;
                    for (CategoryVO vo : list) {
                        subCtgList = (List) map.get(vo.getUpCtgNo());
                        if (subCtgList == null) {
                            subCtgList = new ArrayList();
                        }
                        subCtgList.add(vo);
                        map.put(vo.getUpCtgNo(), subCtgList);
                    }
                }
                return map;
            }
        });
        return value;
    }

    @Override
    public Long getSiteNo(final String domain) {
        String key = "DOMAIN_" + domain;
        Long value = (Long) getCacheValue(key, domain, new CacheValue() {
            @Override
            Object getValue(Object domain) {
                return proxyDao.selectOne(MapperConstants.COMMON + "getSiteNo", domain);
            }
        });

        return value;
    }

    @Override
    public SiteCacheVO getSiteInfo(Long siteNo) {
        String key = "SITE_" + String.valueOf(siteNo);

        Object value = cacheHandler.getValue(key);

        if (value == null) {
            value = proxyDao.selectOne(MapperConstants.COMMON + "selectSiteInfo", siteNo);

            if(value == null) return null;

            if("02".equals(((SiteCacheVO)value).getSiteStatusCd())) {
                // 쇼핑몰 상태가 정상일 경우에만 캐시에 등록
                //log.info("캐시 등록 : {}={}", key, value);
                cacheHandler.put(key, value);
            } else {
                //log.info("쇼핑몰 상태로 인해 캐시 등록 안함", key, value);
            }
        } else {
//            log.debug("캐시 적중 : {}={}", key, value);
        }

        return (SiteCacheVO) value;
    }

    @Override
    public void refreshSiteInfoCache(Long siteNo) {
        String key = "SITE_" + String.valueOf(siteNo);
        SiteCacheVO newValue = proxyDao.selectOne(MapperConstants.COMMON + "selectSiteInfo", siteNo);

        refresh(key, newValue);
    }

    @Override
    public Map<String, String> getAuthLv1MenuMap(LoginVO user) throws Exception {
        String key = "LV1_MENU_" + user.getMemberNo();

        Map<String, String> value = (Map<String, String>) getCacheValue(key, user, new CacheValue() {
            @Override
            Object getValue(Object user) {
                return menuService.getAuthLv1MenuMap((LoginVO) user);
            }
        });

        return value;
    }

    @Override
    public Map<String, String> getReplaceCd() throws Exception {
        String key = "REPLACE_CD";
        Map<String, String> value = (Map<String, String>) getCacheValue(key, new CacheValue() {
            @Override
            Object getValue(Object siteNo) {
                Map<String, String> resultMap = new HashMap<>();
                List<ReplaceCdVO> list = proxyDao.selectList(MapperConstants.REPLACE_CD + "selectReplaceCdList");
                for (ReplaceCdVO vo : list) {
                    resultMap.put(vo.getReplaceNm(), vo.getDispMappingColumn());
                }

                return resultMap;
            }
        });

        return value;
    }

    @Override
    public void refreshReplaceCd() {
        String key = "REPLACE_CD";
        SiteCacheVO newValue = proxyDao.selectOne(MapperConstants.REPLACE_CD + "selectReplaceCdList");

        refresh(key, newValue);
    }

    public void refreshAuthLv1MenuMap(LoginVO user) throws Exception {
        String key = "LV1_MENU_" + user.getMemberNo();
        Map<String, String> newValue = menuService.getAuthLv1MenuMap(user);

        refresh(key, newValue);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 캐시에서 값을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param key
     *            캐시의 키
     * @param obj
     *            캐시를 새로 조회하기 위한 조회조건으로 사용할 객체
     * @param cacheValue
     *            캐시에 값이 없으면 새로 조회하기 위한 추상 클래스
     * @return
     * @throws Exception
     */
    private Object getCacheValue(String key, Object obj, CacheValue cacheValue) {
        Object value = cacheHandler.getValue(key);

        if (value == null) {
            value = cacheValue.getValue(obj);
  //          log.debug("캐시 등록 : {}={}", key, value);
            cacheHandler.put(key, value);
        } else {
//            log.debug("캐시 적중 : {}={}", key, value);
        }
        return value;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 캐시에서 값을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param key
     *            캐시의 키
     * @param cacheValue
     *            캐시에 값이 없으면 새로 조회하기 위한 추상 클래스
     * @return
     * @throws Exception
     */
    private Object getCacheValue(String key, CacheValue cacheValue) throws Exception {
        Object value = cacheHandler.getValue(key);

        if (value == null) {
            value = cacheValue.getValue(null);
            if (value != null) {
                log.info("캐시 등록 : {}={}", key);
                cacheHandler.put(key, value);
            } else {
                log.info("캐시 {}에 등록할 값이 null", key);
            }
        } else {
            log.info("캐시 적중 : {}={}", key);
        }
        return value;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 캐시 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param key
     *            갱신할 캐시의 키 값
     * @param newValue
     *            캐시의 신규 값
     */
    private void refresh(String key, Object newValue) {
        Object value = cacheHandler.getElement(key);

        if (value == null) {
            //log.info("캐시 등록 : {}={}", key, newValue);
            cacheHandler.put(key, newValue);
        } else {
            //log.info("캐시 갱신 : {}={}", key, newValue);
//            cacheHandler.replace(key, newValue);
            cacheHandler.put(key, newValue);
        }
    }

    /**
     * <pre>
     * 프로젝트명 : 03.business
     * 작성일     : 2016. 5. 31.
     * 작성자     : dong
     * 설명       : 캐시 값을 반환하는 내부 추상 클래스
     *
     * </pre>
     */
    public abstract class CacheValue {
        public CacheValue() {
        }

        /**
         * <pre>
         * 작성일 : 2016. 5. 31.
         * 작성자 : dong
         * 설명   : 캐시의 값을 반환하는 추상 매소드
         *          캐시에 값이 있으면 반환하고 없으면 새로 조회하여 반환하도록 구현해야 함
         *
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------------------------------------------
         * 2016. 5. 31. dong - 최초생성
         * </pre>
         *
         * @param obj
         *            캐시를 새로 조회하기 위한 조회조건으로 사용할 객체
         * @return
         * @throws Exception
         */
        abstract Object getValue(Object obj);
    }
}
