package net.danvi.dmall.biz.app.design.service;

import net.danvi.dmall.biz.app.design.model.HtmlEditPO;
import net.danvi.dmall.biz.app.design.model.HtmlEditSO;
import net.danvi.dmall.biz.app.design.model.HtmlEditVO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface HtmlEditService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 HtmlEdit file목록을 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<HtmlEditVO> getEditFileInfo(HtmlEditSO so);

    public ResultModel<HtmlEditVO> getEditFileDtlInfo(HtmlEditSO so);

    public ResultModel<HtmlEditVO> getEditFileWorkInfo(HtmlEditSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : HtmlEdit 등록한다 
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
    public ResultModel<HtmlEditPO> insertHtmlEdit(HtmlEditPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : HtmlEdit 수정한다 
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
    public ResultModel<HtmlEditPO> updateHtmlEdit(HtmlEditPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 10. 24.
     * 작성자 : dong
     * 설명   : 미리보기 정보가 있는지 확인한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 24. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<HtmlEditVO> getPreViewInfo(HtmlEditSO so);

}
