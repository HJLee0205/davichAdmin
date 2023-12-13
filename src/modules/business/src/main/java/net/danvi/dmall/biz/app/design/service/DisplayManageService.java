package net.danvi.dmall.biz.app.design.service;

import net.danvi.dmall.biz.app.design.model.DisplayPO;
import net.danvi.dmall.biz.app.design.model.DisplayPOListWrapper;
import net.danvi.dmall.biz.app.design.model.DisplaySO;
import net.danvi.dmall.biz.app.design.model.DisplayVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 19.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface DisplayManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 전시 목록을 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultListModel<DisplayVO> selectDisplayList(DisplaySO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 등록 화면 정보를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<DisplayVO> viewDisplayDtl(DisplaySO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 상세 정보를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<DisplayVO> selectDisplay(DisplaySO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 등록한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayPO> insertDisplay(DisplayPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 수정한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayPO> updateDisplay(DisplayPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 삭제한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayPO> deleteDisplay(DisplayPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 수정한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayPO> updateDisplayBanner(DisplayPOListWrapper po) throws Exception;

}
