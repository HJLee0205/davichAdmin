package net.danvi.dmall.biz.app.goods.service;

import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.goods.model.*;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : filter 정보 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
public interface FilterManageService {

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 리스트 조회(트리구조)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    public List<FilterVO> selectFilterList(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 리스트 조회(트리구조)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 28. slims - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    public List<FilterVO> selectFilterListGoodsType(FilterSO filterSO);

    public List<FilterVO> selectFiltersGoodsType(FilterSO filterSO);
    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 리스트 조회(배너관리 1depth filter 조회용)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 10. hskim - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    public List<FilterVO> selectFilterList1depth(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 10. 27.
     * 작성자     : slims
     * 설명   : filter depth 별 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 27. sLims - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    public List<FilterVO> selectFilterListDepth(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 상품 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return Integer
     */
    public Integer selectFilterGoodsYn(FilterPO filterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 관련 쿠폰 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return Integer
     */
    public Integer selectCpYn(FilterPO filterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    public ResultModel<FilterPO> deleteFilter(FilterPO filterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    public ResultModel<FilterVO> selectFilter(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 등록 상품, 판매중인 상품 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    public ResultModel<FilterVO> selectFilterGoodsCnt(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    public ResultModel<FilterPO> updateFilter(FilterPO FilterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 전시존 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. kjw - 최초생성
     * </pre>
     *
     * @param FilterDisplayManagePO
     * @return FilterDisplayManagePO
     */
    /*public ResultModel<FilterDisplayManagePO> updateFilterDisplayManage(
            FilterDisplayManagePO filterDisplayManagePO);*/

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. kjw - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    public ResultModel<FilterPO> insertFilter(FilterPO FilterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 전시존 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param FilterDisplayManageSO
     * @return FilterDisplayManageVO
     */
//    public List<FilterDisplayManageVO> selectFilterDispMngList(FilterDisplayManageSO filterDisplayManageSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 전시존 상품 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 04. kjw - 최초생성
     * </pre>
     *
     * @param FilterDisplayManageSO
     * @return FilterDisplayManageVO
     */
//    public List<GoodsVO> selectFilterDispGoodsList(FilterDisplayManageSO filterDisplayManageSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 노출 상품 관리 상품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. kjw - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return FilterVO
     */
    // public List<DisplayGoodsVO> selectFilterGoodsList(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 노출 상품 관리 전시 여부 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. kjw - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    // public ResultModel<FilterPO> updateFilterGoodsDispYn(FilterPO filterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 노출 상품 관리 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 08. kjw - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    // public ResultModel<FilterPO> updateFilterShowGoodsManage(FilterPO filterPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명 : FRONT에 노출할 전체 filter를 가져온다.
     */
    public List<FilterVO> selectFrontGnbList(Long siteNo);
    public List<FilterVO> selectFrontLnbList(Long siteNo);

    // 네이게이션 (하위에서 상위조회)
    public List<FilterVO> selectUpNavagation(FilterSO filterSO);

    // 동일 상위,레벨 filter 조회
    public List<FilterVO> selectNavigationList(FilterSO filterSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : 하위 filter 번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. kjw - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    public List<Integer> selectChildFilterNo(FilterPO filterPO);
    
    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 순서 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 20. hskim - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    public ResultModel<FilterPO> updateFilterSort(FilterPO filterPO);
    
    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : filter 주력제품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 5. 9. hskim - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return FilterPO
     */
    public List<FilterVO> selectMainDispGoodsList(FilterPO filterPO);
    
}
