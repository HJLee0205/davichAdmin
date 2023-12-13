package net.danvi.dmall.biz.app.design.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.design.model.IconPO;
import net.danvi.dmall.biz.app.design.model.IconPOListWrapper;
import net.danvi.dmall.biz.app.design.model.IconSO;
import net.danvi.dmall.biz.app.design.model.IconVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 19.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface IconManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 배너 목록 화면을 조회한다
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
    public ResultListModel<IconVO> selectSkinList(IconSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 배너 페이징 목록을 조회한다
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
    public List<IconVO> selectIconList(IconSO so);

    public ResultListModel<IconVO> selectIconListPaging(IconSO so);

    /**
     * <pre>
     * 작성일 : 2016. 07. 04.
     * 작성자 : dong
     * 설명   : 배너 등록 화면 정보를 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 07. 04. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<IconVO> viewIconDtl(IconSO so);

    public ResultModel<IconVO> viewIconDtlNew(IconSO so);

    /**
     * <pre>
     * 작성일 : 2016. 07. 04.
     * 작성자 : dong
     * 설명   : 배너 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 07. 04. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<IconPO> insertIcon(IconPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 07. 04.
     * 작성자 : dong
     * 설명   : 배너 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 07. 04. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<IconPO> updateIcon(IconPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 07. 04.
     * 작성자 : dong
     * 설명   : 배너 정보 전시 미전시 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 07. 04. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     * @throws Exception
     */
    public ResultModel<IconPO> updateIconView(IconPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 07. 04.
     * 작성자 : dong
     * 설명   : 배너 정보 순서변경저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 07. 04. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     * @throws Exception
     */
    public ResultModel<IconPO> updateIconSort(IconPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 07. 04.
     * 작성자 : dong
     * 설명   : 배너 정보 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 07. 04. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     * @throws Exception
     */
    public ResultModel<IconPO> deleteIcon(IconPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 01. 11.
     * 작성자 : slims
     * 설명   : 배너 상품 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 11. slims - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultListModel<GoodsVO> selectIconGoodsList(IconSO so) throws Exception;
}
