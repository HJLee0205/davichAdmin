package net.danvi.dmall.biz.app.goods.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.app.goods.model.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface GoodsManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 판매 상품 관리 화면에서 선택한 조건으로 상품 관련 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<GoodsVO> selectGoodsList(GoodsSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 카테고리 목록을 조회한다.
     *          파라메터 중 상위 카테고리 번호가 설정되어 있지 않을 경우는
     *          카테고리 레벨 1의 카테고리 목록을 조회하며
     *          상위 카테고리 번호가 존재할 때에는
     *          해당 상위 카테고리의 하위 카테고리 목록을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    List<CtgVO> selectCtgList(CtgVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 브랜드 목록을 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    List<BrandVO> selectBrandList(BrandVO vo);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 17.
     * 작성자 : hskim
     * 설명   : 렌즈 착용샷 브랜드 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 17. hskim - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    List<BrandVO> selectContactWearBrandList(BrandVO vo);
    
    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 브랜드 목록을 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    List<BrandVO> selectBrandCategoryList(BrandVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품의 판매상태를 품절로 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateSoldOut(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품의 전시상태를 전시로 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateDisplay(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품의 판매상태를 판매중지로 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateSaleStop(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품의 판매상태를 판매중으로 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateSaleStart(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 상품의 예상 배송 소요일을 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateDlvrExpectDays(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 상품의 배송 정보를 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateDlvrCost(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 상품의 판매가 정보를 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateSalePrice(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 상품의 아이콘 정보를 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    public ResultModel<GoodsPO> updateGoodsIcon(GoodsPOListWrapper wrapper);
    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 상품의 예상 이벤트 안내문을 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateEventWords(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 상품 조회건수를 변경(+1) 한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<GoodsPO> updateGoodsInqCnt(GoodsPO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품의 판매상태를 품절로 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> updateGoodsStatus(GoodsPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 상품을 삭제한다.(상품 정보 삭제 Flag 변경)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<GoodsPO> deleteGoods(GoodsPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 6. 1.
     * 작성자 : dong
     * 설명   : 해당 상품 및 상품 품목의 고시 정보(고시항목 및 고시값)을 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 1. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    List<GoodsNotifyVO> selectGoodsNotifyItemList(GoodsNotifySO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 관리자 화면의 상품등록 화면 표시에 필요한 정보들을 일괄적으로 조회하여
     *          VO에담아 넘겨준다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<GoodsDisplayInfoVO> getDefaultDisplayInfo(GoodsDetailSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : 해당 상품의 상세 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<GoodsDetailVO> selectGoodsInfo(GoodsDetailSO so);

    ResultModel<GoodsDetailVO> selectVegemilGoodsInfo(GoodsDetailSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 판매 상품 관리 엑셀 다운로드 처리용 판매상품관리 화면에서
     *          넘어온 파라메터로 상품 및 단품 목록 정보를 검색한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<GoodsVO> selectGoodsExcelList(GoodsSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 신규 상품 번호를 발행한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<GoodsVO> getNewGoodsNo(GoodsSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 신규 상품 정보를 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<GoodsDetailPO> insertGoodsInfo(GoodsDetailPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 03.
     * 작성자 : dong
     * 설명   : 상품 정보를 복사하여 동일한 정보를 가진 신규상품을 생성한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 03. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<GoodsDetailVO> copyGoodsInfo(GoodsPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 상품 정보의 상세 설명(주의사항) 값을 저장한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<GoodsContentsPO> saveGoodsContents(GoodsContentsPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 상품 정보의 상세 설명(주의사항) 값을 취득한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    ResultModel<GoodsContentsVO> selectGoodsContents(GoodsContentsVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 8.
     * 작성자 : dong
     * 설명   : 최근에 등록된 상품 옵션 목록을 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 8. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    ResultListModel<Map<String, Object>> selectRecentOption(GoodsOptionVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 단품 가격 변경 이력 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    List<GoodsItemHistoryVO> selectItemPriceHist(GoodsItemHistoryVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 단품 수량 변경 이력 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    List<GoodsItemHistoryVO> selectItemQttHist(GoodsItemHistoryVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 상품 정보 엑셀 업로드 처리
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     * @throws Exception
     */
    List<GoodsDetailPO> uploadGoodsInsertList(List<Map<String, Object>> plist,
                                              MultipartHttpServletRequest mRequest) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 6. 16.
     * 작성자 : slims
     * 설명   : 상품 정보 엑셀 업로드 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 6. 16. slims - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     * @throws Exception
     */
    public List<GoodsItemVO> uploadGoodsUpdateList(List<Map<String, Object>> plist,
                                                     MultipartHttpServletRequest mRequest) throws Exception;
    /**
     * 단품정보 조회(최신속성버전포함)
     *
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 최신 속성 버전등 단품 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. choiyousung - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<GoodsItemVO> selectItemInfo(GoodsItemSO so);

    /*
     * public List<Map<String, Object>> saveIconInfo(Model model,
     * MultipartHttpServletRequest mRequest) throws Exception;
     */

    /**
     * 상품 이미지정보 조회 (리스트)
     *
     * <pre>
     * 작성일 : 2016. 7. 29.
     * 작성자 : dong
     * 설명   : 상품 이미지 목록을 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 29. choiyousung - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<GoodsDetailVO> selectGoodsImageList(GoodsDetailSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 관련 상품 상품 번호 목록 정보로 해당 관련 상품의 상세 목록 정보를 취득한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    List<GoodsVO> selectRelateGoodsListByIn(GoodsDetailVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 7.
     * 작성자 : dong
     * 설명   : 관리자 상품 미리보기에서 상품에 설정된 관련상품 조건등으로 관련 상품 정보를 취득한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 7. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    List<GoodsVO> selectRelateGoodsList(GoodsDetailVO vo);
    
    /**
     * <pre>
     * 작성일 : 2018. 10. 23.
     * 작성자 : hskim
     * 설명   : 베스트브랜드 번호를 가져온다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 10. 23. hskim - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    String selectBestBrandNo(BrandVO vo);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 10.
     * 작성자 : hskim
     * 설명   : 증정상품 예약내역 확인
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 10. hskim - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    int preGoodsRsvChk(Map<String, String> param);

    /**
     * <pre>
     * 작성일 : 2019. 6. 17.
     * 작성자 : hskim
     * 설명   : 렌즈 착용샷 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 17. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    List<ContactWearVO> selectContactWearList(ContactWearSO so);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 17.
     * 작성자 : hskim
     * 설명   : 착용샷 이미지 세트 번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 17. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<ContactWearVO> selectWearImgsetNoList(ContactWearSO so);

    /**
     * <pre>
     * 작성일 : 2023. 01. 05.
     * 작성자 : slims
     * 설명   : 콘텍트렌즈 상위 메뉴 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 05. slims - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    FilterVO selectGoodsFilterLvl2Info(GoodsVO so);

    /**
     * <pre>
     * 작성일 : 2023. 5. 26.
     * 작성자 : slims
     * 설명   : 관리자 화면의 상품정보 등록 및 업데이트 history를
     *          VO에담아 넘겨준다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 5. 26. slims - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    List<GoodsVO> selectGoodsInfoChangeHist(GoodsSO so);

    public List<GoodsImageDtlPO> uploadGoodsImgList(List<Map<String, Object>> plist,
                                                    MultipartHttpServletRequest mRequest) throws Exception;
}
