package net.danvi.dmall.biz.app.goods.service;

import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.goods.model.*;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : keyword 정보 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
public interface KeywordManageService {

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 리스트 조회(트리구조)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public List<KeywordVO> selectKeywordList(KeywordSO keywordSO);
    
    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 리스트 조회(배너관리 1depth keyword 조회용)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 10. hskim - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public List<KeywordVO> selectKeywordList1depth(KeywordSO keywordSO);

    /**
     * <pre>
     * 작성일     : 2022. 10. 27.
     * 작성자     : slims
     * 설명   : keyword depth 별 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 27. sLims - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public List<KeywordVO> selectKeywordListDepth(KeywordSO keywordSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 상품 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return Integer
     */
    public Integer selectKeywordGoodsYn(KeywordPO keywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 관련 쿠폰 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return Integer
     */
    public Integer selectCpYn(KeywordPO keywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    public ResultModel<KeywordPO> deleteKeyword(KeywordPO keywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public ResultModel<KeywordVO> selectKeyword(KeywordSO keywordSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 등록 상품, 판매중인 상품 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public List<GoodsVO> selectKeywordGoodsList(KeywordSO keywordSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    public ResultModel<KeywordPO> updateKeyword(KeywordPO KeywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 전시존 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. kjw - 최초생성
     * </pre>
     *
     * @param KeywordDisplayManagePO
     * @return KeywordDisplayManagePO
     */
    /*public ResultModel<KeywordDisplayManagePO> updateKeywordDisplayManage(
            KeywordDisplayManagePO keywordDisplayManagePO);*/

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. kjw - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    public ResultModel<KeywordPO> insertKeyword(KeywordPO KeywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 전시존 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. kjw - 최초생성
     * </pre>
     *
     * @param KeywordDisplayManageSO
     * @return KeywordDisplayManageVO
     */
//    public List<KeywordDisplayManageVO> selectKeywordDispMngList(KeywordDisplayManageSO keywordDisplayManageSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 전시존 상품 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 04. kjw - 최초생성
     * </pre>
     *
     * @param KeywordDisplayManageSO
     * @return KeywordDisplayManageVO
     */
//    public List<GoodsVO> selectKeywordDispGoodsList(KeywordDisplayManageSO keywordDisplayManageSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 노출 상품 관리 상품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. kjw - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    // public List<DisplayGoodsVO> selectKeywordGoodsList(KeywordSO keywordSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 노출 상품 관리 전시 여부 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. kjw - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    // public ResultModel<KeywordPO> updateKeywordGoodsDispYn(KeywordPO keywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 노출 상품 관리 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 08. kjw - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    // public ResultModel<KeywordPO> updateKeywordShowGoodsManage(KeywordPO keywordPO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명 : FRONT에 노출할 전체 keyword를 가져온다.
     */
    public List<KeywordVO> selectFrontGnbList(Long siteNo);
    public List<KeywordVO> selectFrontLnbList(Long siteNo);

    // 네이게이션 (하위에서 상위조회)
    public List<KeywordVO> selectUpNavagation(KeywordSO keywordSO);

    // 동일 상위,레벨 keyword 조회
    public List<KeywordVO> selectNavigationList(KeywordSO keywordSO);

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : 하위 keyword 번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. kjw - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    public List<Integer> selectChildKeywordNo(KeywordPO keywordPO);
    
    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 순서 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 20. hskim - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    public ResultModel<KeywordPO> updateKeywordSort(KeywordPO keywordPO);
    
    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : keyword 주력제품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 5. 9. hskim - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return KeywordPO
     */
    public List<KeywordVO> selectMainDispGoodsList(KeywordPO keywordPO);
    
}
