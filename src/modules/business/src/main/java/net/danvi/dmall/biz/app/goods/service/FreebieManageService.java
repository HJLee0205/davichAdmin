package net.danvi.dmall.biz.app.goods.service;

import net.danvi.dmall.biz.app.goods.model.FreebieImageInfoVO;
import net.danvi.dmall.biz.app.goods.model.FreebiePO;
import net.danvi.dmall.biz.app.goods.model.FreebieSO;
import net.danvi.dmall.biz.app.goods.model.FreebieVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 12.
 * 작성자     : dong
 * 설명       : 사은품 서비스 인터페이스
 * </pre>
 */
public interface FreebieManageService {
    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 목록 조회.
     */
    public ResultListModel<FreebieVO> selectFreebieList(FreebieSO so);

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 단건 조회.
     */
    public ResultModel<FreebieVO> selectFreebieContents(FreebieSO so) throws Exception;

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 등록.
     */
    public ResultModel<FreebiePO> insertFreebieContents(FreebiePO po, HttpServletRequest request) throws Exception;

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 수정.
     */
    public ResultModel<FreebiePO> updateFreebieContents(FreebiePO po, HttpServletRequest request) throws Exception;

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 삭제.
     */
    public ResultModel<FreebiePO> deleteFreebieContents(FreebiePO po) throws Exception;

    /**
     * 작성자 : dong
     * 설명 : 사은품 등록 이미지 조회.
     */
    public ResultModel<FreebieImageInfoVO> selectDefaultImageInfo(FreebieSO so);

    /**
     * 작성자 : dong
     * 설명 : 사은품 이미지 정보 저장.
     */
    public ResultModel<FreebiePO> saveFreebieImage(FreebiePO po) throws Exception;

    public ResultModel<FreebiePO> updateCheckFreebie(FreebiePO po) throws Exception;

    public String selectFreebieNo();

    public String copyFreebieContents(FreebieSO so) throws Exception;
}
