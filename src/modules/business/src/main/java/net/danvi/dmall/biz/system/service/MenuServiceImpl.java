package net.danvi.dmall.biz.system.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.MenuVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.util.StringUtil;

@Slf4j
@Service("menuService")
public class MenuServiceImpl extends BaseService implements MenuService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Override
    public List<MenuVO> selectScreen() {
        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "selectScreen");
    }

    public boolean isAccessable(MenuVO vo) throws Exception {
        int source;
        int target;

        String url = vo.getUrl();
        url = url.substring(0, url.indexOf("/", 7)); // /admin/XXXX 형태의 URL 추출

        Session session = SessionDetailHelper.getSession();
        if ("A".equals(session.getAuthGbCd()) || "S".equals(session.getAuthGbCd())) {
            log.debug("ID[{}]는 {}의 슈퍼 관리자", session.getLoginId(), session.getServerName());
            return true;
        }

        // 메뉴 맵(화면이 연결된 메뉴)에서 URL에 해당하는 메뉴 유무 확인
        Map<String, MenuVO> map = cacheService.getScreenMap();
        MenuVO menu = map.get(vo.getUrl());

        // 없으면 접속 가능
        if (menu == null) {
            return true;
        }

        // 대메뉴 권한 목록에 접근 URL에 속하는지 확인
        LoginVO user = new LoginVO();
        user.setSiteNo(session.getSiteNo());
        user.setMemberNo(session.getMemberNo());
        user.setLoginId(session.getLoginId());
        List<String> list = getAuthMenuList(user);

        // 권한 목록에 없으면 접근 불가
        if (!list.contains(url)) {
            log.debug("ID[{}]는 {}의 {} 접근 권한 없음", session.getLoginId(), session.getServerName(), url);
            return false;
        }

        source = Integer.parseInt(StringUtil.nvl(vo.getSiteTypeCd(), "1"));
        target = Integer.parseInt(StringUtil.nvl(menu.getSiteTypeCd(), "1"));

        if (source >= target) {
            return true;
        } else {
            log.debug("서버 {}는 {} 서비스를 이용 계약 안됨", session.getServerName(), url);
            return false;
        }
    }

    @Override
    public List<MenuVO> selectMenuTree(Boolean isSeller) {
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getSession().getSiteNo());

        MenuVO vo = new MenuVO();
        vo.setSiteTypeCd(siteCacheVO.getSiteTypeCd());
        vo.setIsSeller(isSeller);

        List<MenuVO> list = new ArrayList<>();

        // 판매자로 접속했을 시
        if(isSeller && SessionDetailHelper.getSession().getLoginId() == null && SessionDetailHelper.getSession().getSellerNo() != null) {
            SellerSO so = new SellerSO();
            so.setSiteNo(SessionDetailHelper.getSession().getSiteNo());
            so.setSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
            SellerVO sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", so);
            vo.setSellerStatusCd(sellerVO.getStatusCd());

            list = proxyDao.selectList(MapperConstants.SYSTEM_MENU + "selectMenuTree", vo);
        } else {
            if (!("A").equals(SessionDetailHelper.getSession().getAuthGbCd())) {
                vo.setMemberNo(SessionDetailHelper.getSession().getMemberNo());
            }
            list = proxyDao.selectList(MapperConstants.SYSTEM_MENU + "selectMenuTree", vo);
        }

        return list;
    }

    @Override
    public List<MenuVO> selectSideMenuTree(String url) {
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getSession().getSiteNo());

        MenuVO vo = new MenuVO();
        vo.setUrl(url);
        vo.setSiteTypeCd(siteCacheVO.getSiteTypeCd());

        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "selectSideMenuTree", vo);
    }

    @Override
    public List<MenuVO> selectLevelOneMenu() {
        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "selectLevelOneMenu");
    }

    @Override
    public MenuVO selectFirstMenu(MenuVO vo) throws Exception {
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getSession().getSiteNo());
        vo.setSiteTypeCd(siteCacheVO.getSiteTypeCd());
        return proxyDao.selectOne(MapperConstants.SYSTEM_MENU + "selectFirstScreen", vo);
    }

    @Override
    public List<String> getAuthMenuList(LoginVO user) {
        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "getAuthMenuList", user);
    }

    @Override
    public List<MenuVO> getAuthLv1MenuList(LoginVO user) {
        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "getAuthLv1MenuList", user);
    }

    @Override
    public Map<String, String> getAuthLv1MenuMap(LoginVO user) {
        Map<String, String> m = new HashMap<>();
        List<MenuVO> list = getAuthLv1MenuList(user);
        for (MenuVO menuVO : list) {
            m.put(menuVO.getMenuId(), menuVO.getSiteTypeCd());
        }

        return m;
    }

    @Override
    public List<MenuVO> getAuthSubMenuList(String url) {
        MenuVO vo = new MenuVO();
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getSession().getSiteNo());
        vo.setUrl(url);
        vo.setSiteTypeCd(siteCacheVO.getSiteTypeCd());
        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "getAuthSubMenuList", vo);
    }

    @Override
    public List<MenuVO> findMenu(MenuVO vo) {
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getDetails().getSiteNo());
        vo.setSiteTypeCd(siteCacheVO.getSiteTypeCd());
        return proxyDao.selectList(MapperConstants.SYSTEM_MENU + "selectMenuAutoComplition", vo);
    }
}