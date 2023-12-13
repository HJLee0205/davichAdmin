package net.danvi.dmall.biz.app.design.service;

import net.danvi.dmall.biz.app.design.model.PopManagePO;
import net.danvi.dmall.biz.app.design.model.PopManagePOListWrapper;
import net.danvi.dmall.biz.app.design.model.PopManageSO;
import net.danvi.dmall.biz.app.design.model.PopManageVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface PopupManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 팝업 목록을 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<PopManageVO> selectPopManagePaging(PopManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 팝업 상세 정보를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<PopManageVO> selectPopManage(PopManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 팝업 등록한다 
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
    public ResultModel<PopManagePO> insertPopManage(PopManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 팝업 수정한다 
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
    public ResultModel<PopManagePO> updatePopManage(PopManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 팝업 삭제한다 
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
    public ResultModel<PopManagePO> deletePopManage(PopManagePOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 팝업 전시수정한다 
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
    public ResultModel<PopManagePO> updatePopManageView(PopManagePOListWrapper po) throws Exception;

}
