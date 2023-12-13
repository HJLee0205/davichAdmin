package net.danvi.dmall.biz.app.main.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.app.main.model.*;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.statistics.model.VisitPathVO;

/**
 * Created by dong on 2016-07-11.
 */
public interface MainService {
	

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 메인 화면 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public Map<String, Object> getMain(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 관리자 정보보기
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public AdminInfoVO getAdminInfo(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 오늘의 쇼핑몰 조회 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public TodayShoppingmallVO getTodayShoppingmall(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 쇼핑몰 운영 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<MallOperStatusVO> getMallOperStatus(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 상품 문의 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<BbsLettManageVO> getGoodsQuestion(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 공지사항 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<BbsLettManageVO> getNotice(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 공지사항 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<BbsLettManageVO> getSellerNotice(AdminMainSO so);
    
    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 1:1 문의 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<BbsLettManageVO> getOne2OneInquiry(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 부가서비스 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<Map> getAdditionalService(AdminMainSO so);

    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 쇼핑몰 디스크 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    AdminInfoVO getAdminDiskInfo(AdminMainSO so);
    

    /**
     * <pre>
     * 작성일 : 2018. 01. 25.
     * 작성자 : khy
     * 설명   : 메인 화면 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 1. 25. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public Map<String, Object> getSellerMain(AdminMainSO so);
    
    
    /**
     * <pre>
     * 작성일 : 2018. 01. 25.
     * 작성자 : khy
     * 설명   : 메인 화면 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 1. 25. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<BbsLettManageVO> getSellerOne2OneInquiry(AdminMainSO so);

    
    
    public int getMonthVisitCnt(AdminMainSO so) ;

    public List<SellerVO> getStandSeller(AdminMainSO so);

    public List<VisitPathVO> getVisitPath(AdminMainSO so);

    public List<BbsLettManageVO> getGoodsReview(AdminMainSO so);

    public List<MallWeekStatusVO> getWeekStatus(AdminMainSO so);
}