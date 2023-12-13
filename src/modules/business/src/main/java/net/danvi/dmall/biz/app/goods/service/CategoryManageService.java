package net.danvi.dmall.biz.app.goods.service;

import java.util.List;

import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManagePO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManageSO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManageVO;
import net.danvi.dmall.biz.app.goods.model.CategoryPO;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.CategoryVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 22.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
public interface CategoryManageService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 리스트 조회(트리구조)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return CategoryVO
     */
    public List<CategoryVO> selectCategoryList(CategorySO categorySO);
    
    /**
     * <pre>
     * 작성일 : 2018. 12. 10.
     * 작성자 : hskim
     * 설명   : 카테고리 리스트 조회(배너관리 1depth 카테고리 조회용)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 10. hskim - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return CategoryVO
     */
    public List<CategoryVO> selectCategoryList1depth(CategorySO categorySO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 상품 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return Integer
     */
    public Integer selectCtgGoodsYn(CategoryPO categoryPO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 관련 쿠폰 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return Integer
     */
    public Integer selectCpYn(CategoryPO categoryPO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    public ResultModel<CategoryPO> deleteCategory(CategoryPO categoryPO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return CategoryVO
     */
    public ResultModel<CategoryVO> selectCategory(CategorySO categorySO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 등록 상품, 판매중인 상품 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return CategoryVO
     */
    public ResultModel<CategoryVO> selectCtgGoodsCnt(CategorySO categorySO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : kjw
     * 설명   : 카테고리 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    public ResultModel<CategoryPO> updateCatagory(CategoryPO categoryPO, HttpServletRequest request);

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : kjw
     * 설명   : 카테고리 전시존 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. kjw - 최초생성
     * </pre>
     *
     * @param CategoryDisplayManagePO
     * @return CategoryDisplayManagePO
     */
    public ResultModel<CategoryDisplayManagePO> updateCatagoryDisplayManage(
            CategoryDisplayManagePO categoryDisplayManagePO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : kjw
     * 설명   : 카테고리 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. kjw - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    public ResultModel<CategoryPO> insertCategory(CategoryPO categoryPO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : kjw
     * 설명   : 카테고리 전시존 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param CategoryDisplayManageSO
     * @return CategoryDisplayManageVO
     */
    public List<CategoryDisplayManageVO> selectCtgDispMngList(CategoryDisplayManageSO categoryDisplayManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 04.
     * 작성자 : kjw
     * 설명   : 카테고리 전시존 상품 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 04. kjw - 최초생성
     * </pre>
     *
     * @param CategoryDisplayManageSO
     * @return CategoryDisplayManageVO
     */
    public List<GoodsVO> selectCtgDispGoodsList(CategoryDisplayManageSO categoryDisplayManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 07.
     * 작성자 : kjw
     * 설명   : 카테고리 노출 상품 관리 상품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. kjw - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return CategoryVO
     */
    // public List<DisplayGoodsVO> selectCtgGoodsList(CategorySO categorySO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 07.
     * 작성자 : kjw
     * 설명   : 카테고리 노출 상품 관리 전시 여부 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. kjw - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    // public ResultModel<CategoryPO> updateCtgGoodsDispYn(CategoryPO categoryPO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 08.
     * 작성자 : kjw
     * 설명   : 카테고리 노출 상품 관리 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 08. kjw - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    // public ResultModel<CategoryPO> updateCtgShowGoodsManage(CategoryPO categoryPO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명 : FRONT에 노출할 전체 카테고리를 가져온다.
     */
    public List<CategoryVO> selectFrontGnbList(Long siteNo);
    public List<CategoryVO> selectFrontLnbList(Long siteNo);

    // 네이게이션 (하위에서 상위조회)
    public List<CategoryVO> selectUpNavagation(CategorySO categorySO);

    // 동일 상위,레벨 카테고리 조회
    public List<CategoryVO> selectNavigationList(CategorySO categorySO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : kjw
     * 설명   : 하위 카테고리 번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. kjw - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    public List<Integer> selectChildCtgNo(CategoryPO categoryPO);
    
    /**
     * <pre>
     * 작성일 : 2018. 9. 20.
     * 작성자 : hskim
     * 설명   : 카테고리 순서 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 20. hskim - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    public ResultModel<CategoryPO> updateCatagorySort(CategoryPO categoryPO);
    
    /**
     * <pre>
     * 작성일 : 2019. 5. 9.
     * 작성자 : hskim
     * 설명   : 카테고리 주력제품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 5. 9. hskim - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return CategoryPO
     */
    public List<CategoryVO> selectMainDispGoodsList(CategoryPO categoryPO);
    
}
