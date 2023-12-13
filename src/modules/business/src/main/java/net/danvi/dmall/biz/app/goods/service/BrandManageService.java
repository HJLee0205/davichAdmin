package net.danvi.dmall.biz.app.goods.service;

import java.util.List;

import net.danvi.dmall.biz.app.goods.model.BrandPO;
import net.danvi.dmall.biz.app.goods.model.BrandSO;
import net.danvi.dmall.biz.app.goods.model.BrandVO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 22.
 * 작성자     : dong
 * 설명       : 브랜드 정보 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
public interface BrandManageService {

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 브랜드 리스트 조회(트리구조)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @param BrandSO
     * @return BrandVO
     */
    public List<BrandVO> selectBrandList(BrandSO brandSO);

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 브랜드 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @param BrandSO
     * @return BrandVO
     */
    public ResultModel<BrandVO> selectBrand(BrandSO brandSO);

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 브랜드 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @param BrandPO
     * @return BrandPO
     */
    public ResultModel<BrandPO> updateBrand(BrandPO brandPO);

    /**
     * <pre>
     * 작성일 : 2016. 8. 28.
     * 작성자 : dong
     * 설명   : 브랜드 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 28. dong - 최초생성
     * </pre>
     *
     * @param BrandPO
     * @return BrandPO
     */
    public ResultModel<BrandPO> insertBrand(BrandPO brandPO);

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 브랜드 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @param BrandPO
     * @return BrandPO
     */
    public ResultModel<BrandPO> deleteBrand(BrandPO brandPO);

}
