package net.danvi.dmall.biz.system.service;

import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.MenuVO;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 27.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface MenuService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 화면이 있는 메뉴 목록을 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<MenuVO> selectScreen();

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 메뉴 접근 가능 여부 반환
     *          대전제는 화면이 있는 메뉴 목록(권한 체크를 하는 메뉴)이 기준임
     *          팝업 등을 위해서 화면 있는 메뉴만 체크함
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public boolean isAccessable(MenuVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * 2022. 11. 10. sol - 파라미터 및 쿼리 수정
     * </pre>
     *
     * @param isSeller
     * @return
     */
    public List<MenuVO> selectMenuTree(Boolean isSeller);

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : url 이하의 서브 메뉴 트리를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param url
     * @return
     */
    public List<MenuVO> selectSideMenuTree(String url) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 대메뉴 목록 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<MenuVO> selectLevelOneMenu();

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 대메뉴의 접근 가능한 첫번째 메뉴(환면) URL 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    MenuVO selectFirstMenu(MenuVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 로그인 멤버의 권한 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param user
     * @return
     */
    List<String> getAuthMenuList(LoginVO user);

    /**
     * <pre>
     * 작성일 : 2016. 7. 21.
     * 작성자 : dong
     * 설명   : 대메뉴 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 21. dong - 최초생성
     * </pre>
     *
     * @param user
     * @return
     */
    List<MenuVO> getAuthLv1MenuList(LoginVO user);

    /**
     * <pre>
     * 작성일 : 2016. 7. 21.
     * 작성자 : dong
     * 설명   : 대메뉴 목록을 맵으로 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 21. dong - 최초생성
     * </pre>
     *
     * @param user
     * @return
     */
    Map<String, String> getAuthLv1MenuMap(LoginVO user);

    /**
     * <pre>
     * 작성일 : 2022. 9. 01.
     * 작성자 : lim
     * 설명   : sub 메뉴 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 01. dong - 최초생성
     * </pre>
     *
     * @param String
     * @return
     */
    List<MenuVO> getAuthSubMenuList(String url);

    /**
     * <pre>
     * 작성일 : 2016. 7. 21.
     * 작성자 : dong
     * 설명   : 관리자 메뉴 검색
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 21. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    List<MenuVO> findMenu(MenuVO vo);
}