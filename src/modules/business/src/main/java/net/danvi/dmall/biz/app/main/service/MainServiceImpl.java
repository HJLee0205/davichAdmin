package net.danvi.dmall.biz.app.main.service;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.main.model.*;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.app.statistics.model.VisitPathVO;
import net.sf.json.JSONArray;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.util.DateUtil;
//import dmall.framework.common.util.ExecuteExtCmdUtil;
import dmall.framework.common.util.SiteUtil;

@Service("adminMainService")
@Slf4j
@Transactional(readOnly = true, rollbackFor = Exception.class)
public class MainServiceImpl extends BaseService implements MainService {
	

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;
    @Resource(name = "sellerService")
    private SellerService sellerService;

    @Override
    public Map<String, Object> getMain(AdminMainSO so) {
    	String today = DateUtil.getNowDate();
    	String stDate = today.substring(0,6) + "01" ;
    	String endDate = DateUtil.addDays(today, 1);
    	
    	so.setStDate(stDate);
    	so.setEndDate(endDate);
    	
        Map<String, Object> main = new HashMap<>();
        // 오늘 데이터 조회
        main.put("TODAY", getTodayShoppingmall(so));

        List<Date> weekList = getWeek();
        main.put("WEEK_LIST", weekList);
        // 문의 조회
        main.put("GOODS_QUESTION", getGoodsQuestion(so));
        main.put("ONE2ONE_INQUIRY", getOne2OneInquiry(so));
        main.put("STAND_SELLER", getStandSeller(so));
        // 공지사항 조회
        main.put("NOTICE_LIST",getNotice(so));
        // 기타정보 조회
        main.put("ADMIN_INFO", getAdminInfo(so));
        main.put("ADDITIONAL_SERVICE", getAdditionalService(so));
        // 방문경로 조회
        main.put("VISIT_PATH", getVisitPath(so));
        // 최근 7일 후기 조회
        main.put("GOODS_REVIEW", getGoodsReview(so));
        // 쇼핑몰 운영 현황 조회
        Calendar cal = DateUtil.getCalendar(DateUtil.getNowDate());
        cal.set(Calendar.DATE, cal.getMinimum(Calendar.DAY_OF_MONTH));
        so.setStDate(DateUtil.getCalendar(cal));
        cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        so.setEndDate(DateUtil.getCalendar(cal));
        main.put("MALL_STATUS", getMallOperStatus(so));

        main.put("so", so);
        main.put("todayDttm", DateUtil.getNowDateTime("yyyy-MM-dd"));

        return main;
    }
    
    @Override
    public int getMonthVisitCnt(AdminMainSO so) {
    	String today = DateUtil.getNowDate();
    	String stDate = today.substring(0,6) + "01" ;
    	String endDate = DateUtil.addDays(today, 1);
    	
    	so.setStDate(stDate);
    	so.setEndDate(endDate);
    	
        return proxyDao.selectOne(MapperConstants.ADMIN_MAIN + "selectMonthVisitCnt", so);
    }    
    

    @Override
    public AdminInfoVO getAdminInfo(AdminMainSO so) {

        AdminInfoVO vo = proxyDao.selectOne(MapperConstants.ADMIN_MAIN + "selectAdminInfo", so);
        //setAccountDiskInfo(vo);

        return vo;
    }

    @Override
    public TodayShoppingmallVO getTodayShoppingmall(AdminMainSO so) {
        TodayShoppingmallVO vo = proxyDao.selectOne(MapperConstants.ADMIN_MAIN + "selectTodayShoppingmall", so);
        return vo;
    }

    @Override
    public List<MallOperStatusVO> getMallOperStatus(AdminMainSO so) {
        return proxyDao.selectList(MapperConstants.ADMIN_MAIN + "selectMallOperStatus", so);
    }

    @Override
    public List<BbsLettManageVO> getGoodsQuestion(AdminMainSO so) {

        BbsLettManageSO bbsLettManageSO = new BbsLettManageSO();
        bbsLettManageSO.setSiteNo(so.getSiteNo());
        bbsLettManageSO.setRows(5);
        bbsLettManageSO.setPage(1);
        bbsLettManageSO.setBbsId("question");
        return bbsManageService.selectBbsLettPaging(bbsLettManageSO).getResultList();
    }

    @Override
    public List<BbsLettManageVO> getNotice(AdminMainSO so) {

        BbsLettManageSO bbsLettManageSO = new BbsLettManageSO();
        bbsLettManageSO.setSiteNo(so.getSiteNo());
        bbsLettManageSO.setRows(5);
        bbsLettManageSO.setPage(1);
        bbsLettManageSO.setBbsId("notice");
        bbsLettManageSO.setOrderGb("main");
        return bbsManageService.selectBbsLettPaging(bbsLettManageSO).getResultList();
    }

    @Override
    public List<BbsLettManageVO> getOne2OneInquiry(AdminMainSO so) {
        BbsLettManageSO bbsLettManageSO = new BbsLettManageSO();
        bbsLettManageSO.setSiteNo(so.getSiteNo());
        bbsLettManageSO.setRows(5);
        bbsLettManageSO.setPage(1);
        bbsLettManageSO.setBbsId("inquiry");
        return bbsManageService.selectBbsLettPaging(bbsLettManageSO).getResultList();
    }

    @Override
    public List<Map> getAdditionalService(AdminMainSO so) {
        return proxyDao.selectList(MapperConstants.ADMIN_MAIN + "selectAdditionalServiceList", so);
    }

    @Override
    public AdminInfoVO getAdminDiskInfo(AdminMainSO so) {
        AdminInfoVO vo = new AdminInfoVO();
        //setAccountDiskInfo(vo);
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 쇼핑몰 계정의 디스크 사용 정보를 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @param vo
     */
    /*private void setAccountDiskInfo(AdminInfoVO vo) {
        try {
            String resultString = ExecuteExtCmdUtil.getDiskQuota(SiteUtil.getSiteId());
            String[] quota = resultString.split(" ");
            Double use;
            Double total;
            if (quota.length != 2) {
                throw new Exception("쿼타 결과 오류");
            }
            if (quota[0].contains("*")) {
                use = Double.parseDouble(quota[0].trim().replace("*", ""));
            } else {
                use = Double.parseDouble(quota[0].trim());
            }

            total = Double.parseDouble(quota[1].trim());

            // KB를 MB로 변환
            use = use / 1024;
            total = total / 1024;

            NumberFormat nf = NumberFormat.getInstance();
            nf.setMaximumFractionDigits(2);
            log.debug("totalSpace : {}", nf.format(total));
            log.debug("useSpace : {}", nf.format(use));
            vo.setTotalSpace(nf.format(total) + "M");
            vo.setUseSpace(nf.format(use) + "M");
            vo.setUseSpacePercent(nf.format((use / total) * 100));

        } catch (Exception e) {
            log.error("쿼타 조회 오류", e);
            vo.setTotalSpace("0");
            vo.setUseSpace("0");
            vo.setUseSpacePercent("0");
        }
    }*/

    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 서버의 이번주 첫 날자를 구하고, 이전 4주의 첫날자 목록을 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @return
     */
    private List<Date> getWeek() {
        List<Date> weekList = new ArrayList<>();
        Calendar firstOfWeek = Calendar.getInstance();
        firstOfWeek.set(Calendar.DAY_OF_MONTH,(firstOfWeek.get(Calendar.DAY_OF_MONTH) - (firstOfWeek.get(Calendar.DAY_OF_WEEK) - 1)));
        Date d = firstOfWeek.getTime();
        weekList.add(d);
        for (int i = 1; i < 5; i++) {
            d = DateUtils.addWeeks(d, -1);
            weekList.add(d);
        }

        return weekList;
    }
    
    
    
    @Override
    public Map<String, Object> getSellerMain(AdminMainSO so) {
        String today = DateUtil.getNowDate();
        String stDate = today.substring(0,6) + "01" ;
        String endDate = DateUtil.addDays(today, 1);

        so.setStDate(stDate);
        so.setEndDate(endDate);

        Map<String, Object> main = new HashMap<>();
        // 오늘 데이터 조회
        main.put("TODAY", getTodayShoppingmall(so));

        List<Date> weekList = getWeek();
        main.put("WEEK_LIST", weekList);
        // 판매자 문의 조회
        main.put("ONE2ONE_INQUIRY", getSellerOne2OneInquiry(so));
        // 판매자 공지 조회
        main.put("NOTICE_LIST",getSellerNotice(so));
        // 방문경로 조회
        main.put("VISIT_PATH", getVisitPath(so));
        // 최근 7일 후기 조회
        main.put("GOODS_REVIEW", getGoodsReview(so));
        // 쇼핑몰 운영 현황 조회
        Calendar cal = DateUtil.getCalendar(DateUtil.getNowDate());
        cal.set(Calendar.DATE, cal.getMinimum(Calendar.DAY_OF_MONTH));
        so.setStDate(DateUtil.getCalendar(cal));
        cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        so.setEndDate(DateUtil.getCalendar(cal));
        main.put("MALL_STATUS", getMallOperStatus(so));

        main.put("so", so);


        so.setFirstDayOfWeek(DateFormatUtils.format(weekList.get(0), "yyyyMMdd"));
        return main;
    }
    
    @Override
    public List<BbsLettManageVO> getSellerNotice(AdminMainSO so) {
        BbsLettManageSO bbsLettManageSO = new BbsLettManageSO();
        bbsLettManageSO.setSiteNo(so.getSiteNo());
        bbsLettManageSO.setRows(5);
        bbsLettManageSO.setPage(1);
        bbsLettManageSO.setBbsId("sellNotice");
        bbsLettManageSO.setSelSellerNo(String.valueOf(so.getSellerNo()));
        bbsLettManageSO.setPageGbn("S");
        return bbsManageService.selectBbsLettPaging(bbsLettManageSO).getResultList();
    }
    
    
    @Override
    public List<BbsLettManageVO> getSellerOne2OneInquiry(AdminMainSO so) {
        BbsLettManageSO bbsLettManageSO = new BbsLettManageSO();
        bbsLettManageSO.setSiteNo(so.getSiteNo());
        bbsLettManageSO.setRows(5);
        bbsLettManageSO.setPage(1);
        bbsLettManageSO.setBbsId("sellQuestion");
        bbsLettManageSO.setSelSellerNo(String.valueOf(so.getSellerNo()));
        return bbsManageService.selectBbsLettPaging(bbsLettManageSO).getResultList();
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 6.
     * 작성자 : truesol
     * 설명   : 입점/제휴 문의 게시글 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 6. truesol - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @Override
    public List<SellerVO> getStandSeller(AdminMainSO so) {
        SellerSO sellerSo = new SellerSO();
        sellerSo.setSiteNo(so.getSiteNo());
        sellerSo.setRows(5);
        sellerSo.setPage(1);
        sellerSo.setStatusCds(new String[]{"04"});
        return sellerService.selectSellerList(sellerSo).getResultList();
    }

    @Override
    public List<VisitPathVO> getVisitPath(AdminMainSO so) {
        String today = DateUtil.getNowDate();
        String stDate = today.substring(0,6) + "01" ;
        String endDate = DateUtil.addDays(today, 1);

        so.setStDate(stDate);
        so.setEndDate(endDate);

        return proxyDao.selectList(MapperConstants.ADMIN_MAIN + "selectVisitPath", so);
    }

    @Override
    public List<BbsLettManageVO> getGoodsReview(AdminMainSO so) {
        return proxyDao.selectList(MapperConstants.ADMIN_MAIN + "selectWeekGoodsReview", so);
    }

    @Override
    public List<MallWeekStatusVO> getWeekStatus(AdminMainSO so) {
        return proxyDao.selectList(MapperConstants.ADMIN_MAIN + "selectWeekStatus", so);
    }
}
