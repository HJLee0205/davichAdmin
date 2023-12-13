package net.danvi.dmall.biz.system.service;

import net.danvi.dmall.biz.system.model.DavisionItmSO;
import net.danvi.dmall.biz.system.model.DavisionItmVO;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.MenuVO;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 11. 09.
 * 작성자     : slims
 * 설명       :
 * </pre>
 */
public interface DavisionService {

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
    public DavisionItmVO selectDavisionItm(DavisionItmSO so);

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
    public List<DavisionItmVO> selectDavisionItmList(DavisionItmSO so) throws Exception;
}