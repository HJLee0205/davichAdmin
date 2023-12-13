package net.danvi.dmall.biz.app.order.manage.service;

import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import dmall.framework.common.util.*;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigVO;
import net.danvi.dmall.biz.app.visit.model.VisitSO;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.dto.OrderMapDTO;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.service.MappingService;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.dist.dto.OrderRegReqDTO;
import net.danvi.dmall.biz.ifapi.dist.dto.OrderRegResDTO;
import net.danvi.dmall.biz.ifapi.dist.dto.PurchaseConfirmReqDTO;
import net.danvi.dmall.biz.ifapi.dist.dto.PurchaseConfirmResDTO;
import net.danvi.dmall.biz.ifapi.dist.service.DistService;
import net.danvi.dmall.biz.ifapi.mem.dto.*;
import net.danvi.dmall.biz.ifapi.mem.service.ErpMemberService;
import net.danvi.dmall.biz.ifapi.mem.service.ErpPointService;
import net.danvi.dmall.biz.ifapi.mem.service.MemberService;
import net.danvi.dmall.core.model.payment.*;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.basicinfo.service.BasicInfoService;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionDtlVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.constants.OrdStatusConstants;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryPO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.app.order.deposit.service.DepositService;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimPayRefundPO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimSO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderExcelVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.order.payment.service.PaymentService;
import net.danvi.dmall.biz.app.order.refund.service.RefundService;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofPO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofVO;
import net.danvi.dmall.biz.app.order.salesproof.service.SalesProofService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieTargetVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.service.FreebieCndtService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.app.visit.service.VisitRsvService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.common.service.CodeCacheService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.remote.payment.PaymentAdapterService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.core.constants.CoreConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 주문목록, 주문상세, 취소등을 관리
 * </pre>
 */
@Slf4j
@Service("orderService")
@Transactional(rollbackFor = Exception.class)
public class OrderServiceImpl extends BaseService implements OrderService {
    @Resource(name = "paymentService")
    private PaymentService paymentService;
    @Resource(name = "deliveryService")
    private DeliveryService deliveryService;
    @Resource(name = "depositService")
    private DepositService depositService;
    @Resource(name = "codeCacheService")
    private CodeCacheService codeCacheService;
    @Resource(name = "refundService")
    private RefundService refundService;
    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;
    @Resource(name = "freebieCndtService")
    private FreebieCndtService freebieCndtService;
    @Resource(name = "basicInfoService")
    private BasicInfoService basicInfoService;
    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;
    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;
    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "salesProofService")
    private SalesProofService salesProofService;

    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;

    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Resource(name = "paymentAdapterService")
    private PaymentAdapterService paymentAdapterService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    @Resource(name = "visitRsvService")
    private VisitRsvService visitRsvService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "sellerService")
    private SellerService sellerService;

    @Resource(name = "mappingService")
    private MappingService mappingService;

    @Resource(name = "logService")
    private LogService logService;

    @Resource(name = "distService")
    private DistService distService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "erpPointService")
    private ErpPointService erpPointService;

    @Resource(name = "erpMemberService")
    private ErpMemberService erpMemberService;

    @Value("#{system['system.mall.strcode']}")
    String strCode;


    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 회원번호 또는 아이디로 주문횟수 및 결제금액 합계 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @return OrderInfoVO
     */
    @Override
    public MemberManageVO selectOrdHistbyMember(OrderSO so) throws CustomException {
        MemberManageVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdHistbyMember", so);
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 주문 목록을 조회하여 리턴
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public ResultListModel<OrderInfoVO> selectOrdListPaging(OrderSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if(so.getPaymentWayCd() != null && so.getPaymentWayCd().length == 1) {
            if("31".equals(so.getPaymentWayCd()[0])) {
                so.setPaymentWayCd(Add(so.getPaymentWayCd(), "23"));
                so.setPaymentWayForEasy("and");
            } else if("23".equals(so.getPaymentWayCd()[0])) {
                so.setPaymentWayForEasy("excld");
            }
        } else if(so.getPaymentWayCd() != null && so.getPaymentWayCd().length > 2) {
            String compare = StringUtil.convertStringArrayToString(so.getPaymentWayCd(), ",");
            if("31".contains(compare)) {
                if(!"23".contains(compare)) {
                    so.setPaymentWayCd(Add(so.getPaymentWayCd(), "23"));
                }
                so.setPaymentWayForEasy("or");
            }
        } else {
            so.setPaymentWayForEasy("");
        }
        log.debug("so ::::::::::::::::::: "+so);

        ResultListModel<OrderInfoVO> resultListModel = proxyDao.selectListPage(MapperConstants.ORDER_MANAGE + "selectOrdListPaging", so);

        List<OrderInfoVO> list = resultListModel.getResultList();
        List<OrderInfoVO> newList = new ArrayList<OrderInfoVO>();

        if (list != null && list.size() > 0) {
            for (OrderInfoVO orderVO : list) {
                if(StringUtil.isNotEmpty(orderVO.getDlvrMethodCd())) {
                    if( "02".equals(orderVO.getDlvrMethodCd())) {
                        if ("배송준비중".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("상품준비중");
                        } else if ("배송완료".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업가능");
                        } else if ("구매확정".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업완료");
                        }
                    }
                } else {
                    if ("04".equals(orderVO.getDlvrcPaymentCd())) {
                        if ("배송준비중".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("상품준비중");
                        } else if ("배송완료".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업가능");
                        } else if ("구매확정".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업완료");
                        }
                    }
                }
                orderVO = selectOrdStatusForward(orderVO);
                orderVO = selectOrdStatusBackward(orderVO, "N");
                newList.add(orderVO);
            }
        }
        resultListModel.setResultList(newList);
        return resultListModel;

    }

    private <T> T[] Add(T[] originArray, T Val) {
        T[] newArray = Arrays.copyOf(originArray, originArray.length + 1);

        newArray[originArray.length] = Val;

        return newArray;
    }

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<OrderInfoVO> selectOrdSrchListExcel(OrderSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        List<OrderInfoVO> resultList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdSrchListExcel", so);
        return resultList;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 13.
     * 작성자 : dong
     * 설명   : 순방향으로 선택 가능한 주문 상태코드를 조회
     * -   [주문완료(상태코드:입금확인중):10] -> [결제완료:20]
     * -   [결제완료:20] -> [배송준비:30]
     * -   [배송중:30]   -> [배송완료:50]
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 13. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public OrderInfoVO selectOrdStatusForward(OrderInfoVO vo) throws CustomException {
        if ("10".equals(vo.getOrdStatusCd())) {
            vo.setFordStatusCd("20");
            vo.setFordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "20"));
        } else if ("20".equals(vo.getOrdStatusCd())) {
            vo.setFordStatusCd("30");
            vo.setFordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "30"));
           /*
              } else if ("40".equals(vo.getOrdStatusCd())) {
              vo.setFordStatusCd("50");
              vo.setFordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD","50"));
           */
        } else {
            vo.setFordStatusCd("");
            vo.setFordStatusNm("");
        }

        /** 순방향 주문 상태의 CSS 컬러 조회 **/
        String[] cssClass = { "colb1", "colb2", "colo1", "coly1", "colo2", "colg1", "colg2" };
        String[] cd = { "10", "20", "30", "39", "40", "49", "50" };
        HashMap<String, String> tmp = new HashMap();
        for (int i = 0; i < cd.length; i++) {
            tmp.put(cd[i], cssClass[i]);
        }
        vo.setCssClass(tmp.get(vo.getFordStatusCd()));
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 13.
     * 작성자 : dong
     * 설명   : 역방향으로 선택 가능한 주문 상태코드를 조회
     * -   [주문완료(상태코드:입금확인중):10] -> [주문취소:11]
     * -   [결제완료:20] -> [주문완료(상태코드:입금확인중):10]
     * -   [주문접수:01] -> [주문무효:00]
     * -   [배송중:30]   -> [결제완료:20]
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 13. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public OrderInfoVO selectOrdStatusBackward(OrderInfoVO vo, String dtlYn) throws CustomException {
        vo.setBordStatusCd("");
        vo.setBordStatusNm("");
        if ("10".equals(vo.getOrdStatusCd())) {
            // 상세 페이지일경우만 주문 무효
            if ("Y".equals(dtlYn)) {
                vo.setBordStatusCd("11");
                vo.setBordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "11"));
            }
        } else if ("01".equals(vo.getOrdStatusCd())) {
            vo.setBordStatusCd("00");
            vo.setBordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "00"));
        } else if ("20".equals(vo.getOrdStatusCd()) && vo.getOrgOrdNo() == null) {
            // 상세 페이지일경우는 결제 취소
            if ("Y".equals(dtlYn)) {
                vo.setBordStatusCd("21");
                vo.setBordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "21"));
            }
        } else if ("30".equals(vo.getOrdStatusCd())) {
            vo.setBordStatusCd("20");
            vo.setBordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "20"));
        } else if ("40".equals(vo.getOrdStatusCd())) {
            vo.setBordStatusCd("30");
            vo.setBordStatusNm(codeCacheService.getCodeName("ORD_STATUS_CD", "30"));
        } else {
            vo.setBordStatusCd("");
            vo.setBordStatusNm("");
        }

        return vo;
    }

    /**
     * 주문 내역 리스트 엑셀 출력
     */
    public List<OrderExcelVO> selectOrdList(String[] ordNoList) throws CustomException {

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("ordNoList", ordNoList);
        map.put("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdList", map);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 13.
     * 작성자 : dong
     * 설명   : 다수 주문건의 주문 상태 변경
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 13. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public ResultModel<OrderInfoVO> updateOrdListStatus(List<OrderGoodsVO> listvo, String curOrdStatusCd)
            throws CustomException {
        ResultModel<OrderInfoVO> result = new ResultModel<>();
        int rcnt = 0;
        for (OrderGoodsVO vo : listvo) {
            updateOrdStatus(vo, vo.getCurOrdStatusCd());
            rcnt++;
        }

        String args[] = { rcnt + "" };
        result.setMessage(MessageUtil.getMessage("biz.result.ord.updateOrdStatus", args));
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문한 상품의 출력용 주문 내역서 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public OrderVO selectOrdDtlPrint(OrderInfoVO infoVo) throws CustomException {
        OrderVO vo = selectOrdDtl(infoVo);
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문한 상품의 상세 내역 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 19. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public OrderVO selectOrdDtl(OrderInfoVO vo) throws CustomException {

        OrderVO rVo = new OrderVO();
        // 기본 정보
        OrderInfoVO orderInfoVo = selectOrdDtlInfo(vo);
        orderInfoVo = selectOrdStatusForward(orderInfoVo);
        orderInfoVo = selectOrdStatusBackward(orderInfoVo, "Y");
        orderInfoVo.setSiteNo(vo.getSiteNo());

        // 안경구매 의사가 있는지 여부.
        if(StringUtil.isNotEmpty(orderInfoVo.getDlvrMethodCd()) && "01".equals(orderInfoVo.getDlvrMethodCd())) {
            // 택배 구매만
            orderInfoVo.setBuyGlassLensYn("N");
        } else if(StringUtil.isNotEmpty(orderInfoVo.getDlvrMethodCd()) && "03".equals(orderInfoVo.getDlvrMethodCd())) {
            // 택배 배송 주문하고, 스토어 방문예약 동시에 진행.
            // 스토어 방문예약 자체가 - 안경렌즈 구매 의사 있음을 의미
            orderInfoVo.setBuyGlassLensYn("Y");
        } else if(orderInfoVo.getDlvrMethodCd() != null && "02".equals(orderInfoVo.getDlvrMethodCd())) {
            // 스토어 픽업만.
            if(StringUtil.isNotEmpty(orderInfoVo.getVisitPurposeCd()) &&
                    "03".equals(orderInfoVo.getVisitPurposeCd())) {
                // 안경렌즈 ( '03' ) 구매 의사 있음.
                orderInfoVo.setBuyGlassLensYn("Y");
            } else {
                // 안경렌즈 구매 의사 없음.
                orderInfoVo.setBuyGlassLensYn("N");
            }
        } else {
            // 안경만 택배구매
            orderInfoVo.setBuyGlassLensYn("N");
        }

        if(StringUtil.isNotEmpty(orderInfoVo.getAppLinkGbCd())) {
            orderInfoVo.setPaymentWayNm(orderInfoVo.getPaymentWayNm() +
                    "(간편결제 : " + getPaymentWayForEasyNm(orderInfoVo.getAppLinkGbCd()) + ")");
        }
        // 결제 정보
        List<OrderPayVO> payVo = selectOrderPayInfoList(vo);
        for(OrderPayVO payVO: payVo) {
            if(StringUtil.isNotEmpty(payVO.getAppLinkGbCd())) {
                if(StringUtil.isNotEmpty(payVO.getPaymentWayNm()) && "신용카드".equals(payVO.getPaymentWayNm())) {
                    payVO.setPaymentWayNm(payVO.getPaymentWayNm() +
                            "(간편결제 : " + getPaymentWayForEasyNm(payVO.getAppLinkGbCd()) + ")");
                }
            }
        }

        //방문 상품예약이 아니라 그냥 방문예약을 조회 해야 한다.. 상품 결제 할때 방문은 그냥 예약이다 - 상품상세에 추가용, 위 쿼리에 있지만 상품용이라 일단 그냥 둔다
        /*VisitVO visitVO = this.selectRsvNoDetail(orderInfoVo.getRsvNo());
        if(visitVO != null) {
            String fm_sRsvDate = new SimpleDateFormat("yyyy-MM-dd").format(visitVO.getRsvDate());
            rVo.setRsvDate(fm_sRsvDate);
            rVo.setRsvTime(visitVO.getRsvTime());
            rVo.setStoreNo(visitVO.getStoreNo());
            rVo.setStoreNm(visitVO.getStoreNm());
            rVo.setVisitPurposeNm(visitVO.getVisitPurposeNm());
        }*/
		
        // 결제 실패 정보
        List<OrderPayVO> payFailVo = selectOrderPayFailInfoList(vo);


       // 배송 정보 조회
        DeliveryVO delivVo = new DeliveryVO();
        delivVo.setOrdNo(vo.getOrdNo());
        delivVo.setSellerNo(vo.getSellerNo());

        List<DeliveryVO> deliveryVOList = deliveryService.selectOrdDtlDelivery(delivVo);
        // 상품 정보
        List<OrderGoodsVO> goodsList = selectOrdDtlList(vo);
//        List<OrderGoodsVO> newGoodsList = new ArrayList<OrderGoodsVO>();

//        Map<String, String> map = new HashMap<String, String>();
//
//        for (OrderGoodsVO gvo : goodsList) {
//            // 01.상품기본정보 조회
//            GoodsDetailSO so = new GoodsDetailSO();
//            so.setGoodsNo(gvo.getGoodsNo());
//            // so.setItemNo(gvo.getItemNo());
//            ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);
//
//            try {
//                // 02.단품정보
//                //String jsonList = "";
//                //if (goodsInfo.getData().getGoodsItemList() != null ) {
//                //    ObjectMapper mapper = new ObjectMapper();
//                //    jsonList = mapper.writeValueAsString(goodsInfo.getData().getGoodsItemList());
//                //}
//                //gvo.setJsonList(jsonList);
//
//                //ghjo 추가 옵션 사용안함
//                //map.put("ordNo", gvo.getOrdNo());
//                //map.put("addOptYn", "Y");
//                //map.put("itemNo", gvo.getItemNo());
//                //List<GoodsAddOptionDtlVO> goodsOptionList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlAddOptionList", map);
//                //gvo.setGoodsAddOptList(goodsOptionList);
//
//            } catch (Exception e) {
//                log.debug("{}", e.getMessage());
//            }
//            gvo.setGoodsOptionList(goodsInfo.getData().getGoodsOptionList());
//            newGoodsList.add(gvo);
//        }

        // 부가 비용 목록
        List<OrderGoodsVO> ordAddedAmountList = selectAddedAmountList(vo);
        // 처리 로그 정보
        List<OrderGoodsVO> ordHistVOList = selectOrdDtlHistList(vo);
        // 클레임 이력
        List<ClaimGoodsVO> ordClaimList = selectClaimList(vo);

        rVo.setOrderInfoVO(orderInfoVo);
        rVo.setOrderPayVO(payVo);
        rVo.setOrderPayFailVO(payFailVo);
        rVo.setDeliveryVOList(deliveryVOList);
        rVo.setOrderGoodsVO(goodsList);
        rVo.setOrdAddedAmountList(ordAddedAmountList);
        rVo.setOrdHistVOList(ordHistVOList);
        rVo.setOrdClaimList(ordClaimList);
        return rVo;

    }

    private String getPaymentWayForEasyNm(String applinkgbcd) {
        String easyPaymentWayNm = "";
        switch (applinkgbcd) {
            case "C":
                easyPaymentWayNm = "PAYCO";
                break;
            case "B":
                easyPaymentWayNm = "삼성페이";
                break;
            case "D":
                easyPaymentWayNm = "삼성페이(체크)";
                break;
            case "O":
                easyPaymentWayNm = "KAKAOPAY";
                break;
            case "G":
                easyPaymentWayNm = "SSGPAY";
                break;
            case "L":
                easyPaymentWayNm = "LPAY";
                break;
            case "K":
                easyPaymentWayNm = "국민앱카드";
                break;
            case "H":
                easyPaymentWayNm = "토스페이";
                break;
            case "R":
                easyPaymentWayNm = "차이페이";
                break;
            case "I":
                easyPaymentWayNm = "네이버페이";
                break;
            case "U":
                easyPaymentWayNm = "티머니페이";
                break;
            case "J":
                easyPaymentWayNm = "핀페이";
                break;
            case "a":
                easyPaymentWayNm = "Apple Pay";
                break;
        }
        return easyPaymentWayNm;
    }
    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문한 상품 목록 정보를 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<OrderGoodsVO> selectOrdDtlList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlList", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 주문 메모 등록

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public boolean insertOrdMemo(OrderInfoPO po) throws CustomException {
        int rCnt = 0;
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        rCnt = proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertOrderMemo", po);
        return rCnt > 0;
    }

    /**
     * 상품의 옵션을 수정
     */
    public boolean updateOrdDtlOption(OrderGoodsVO vo) throws CustomException {
        int rCnt = 0;
        try {
            vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            rCnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdDtlOption", vo);
            // 새 itemNo 재고 감소
            proxyDao.update(MapperConstants.ORDER_MANAGE + "updateGoodsStock", vo);
            // 이전 itemNo 재고 복귀(증가)
            vo.setItemNo(vo.getOldItemNo());
            vo.setOrdQtt(vo.getOrdQtt() * -1);
            proxyDao.update(MapperConstants.ORDER_MANAGE + "updateGoodsStock", vo);
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }
        return rCnt > 0;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 7.
     * 작성자 : dong
     * 설명   : 주문 1건의 주문상태를 변경한다.
     *

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 7. dong - 최초생성
     * </pre>
     *
     * @param vo 주문번호
     * @param vo 주문상세번호
     *            && 상품 번호(선택)
     * @param curOrdStatusCd 현재주문상태
     * @return
     */
    @Override
    public ResultModel<OrderInfoVO> updateOrdStatus(OrderGoodsVO vo, String curOrdStatusCd) throws CustomException {
        OrderGoodsVO curVo = selectCurOrdStatus(vo);
        boolean isBackOrdStatus = false;
        if (vo.getRegrNo() == null || ("").equals(vo.getRegrNo())) {
            vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            vo.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        }
        if(Integer.parseInt(vo.getOrdStatusCd()) < Integer.parseInt(curOrdStatusCd)) {
            isBackOrdStatus = true;
        }

        log.error("curOrdSateVo :::::::::::::::::::::::::::::::::::: "+curVo);
        log.error("curOrdStatusCd :::::::::::::::::::::::::::::::::: "+curOrdStatusCd);
        ResultModel<OrderInfoVO> result = new ResultModel<>();
            if ("".equals(curVo.getOrdStatusCd())) {
                throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { vo.getOrdNo() });
            }
            // 변경 하려는 시점의 주문상세상태(주문상태)가 현재 상태와 같은 경우면 상태 변경
            if ((curVo.getOrdDtlStatusCd() != null && curOrdStatusCd.equals(curVo.getOrdDtlStatusCd())) || curVo.getOrdStatusCd().equals(curOrdStatusCd)) {
                int cnt = 0;
                try {
                    // 구매 확정일 경우 에스크로 처리 성공일 경우만 상태 변경 16.09.30
                    if ("90".equals(vo.getOrdStatusCd())) {
                        Map<String, Object> reqMap = new HashMap<String, Object>();
                        ModelAndView mav = new ModelAndView();
                        String method = "confirm"; // 구매확정
                        DeliveryPO po = new DeliveryPO();
                        po.setOrdNo(vo.getOrdNo());
                        po.setOrdDtlSeq(vo.getOrdDtlSeq());
                        // 에스크로 처리
                        ResultModel<PaymentModel<?>> resultModel = deliveryService.doEscrowAction(po, reqMap, mav,method);
                        if (resultModel.isSuccess()) {
                            cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatus", vo);
                            //if(cnt > 0){
                            cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDtl", vo);
                        }
                        //}
                    } else if ("20".equals(vo.getOrdStatusCd()) || "30".equals(vo.getOrdStatusCd())) { //결제완료, 배송준비중
                    	if(vo.getOrdDtlSeq() != null && !"".equals(vo.getOrdDtlSeq())) {//주문목록에서 업데이트
                    		cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatus", vo);
                            log.info("cnt :::::::::::::::::::::::::::::::::::::::: = "+cnt);
                    		//if(cnt > 0){
                            cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDtl", vo);
                        	//}
                    	}else {	//주문상세화면에서 업데이트
                    		OrderInfoVO orderInfoVo = new OrderInfoVO();
                            orderInfoVo.setOrdNo(vo.getOrdNo());
                            orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                            Long sellerNo = SessionDetailHelper.getSession().getSellerNo();
                            if(sellerNo != null && !"".equals(sellerNo)) {
                            	orderInfoVo.setSellerNo(String.valueOf(sellerNo));
                            }
                            log.info("sellerNo :::::::::::::::::::::::::::::::::: = "+sellerNo);
                            List<OrderGoodsVO> goodsList = selectOrdDtlList(orderInfoVo);
                            
                            cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatus", vo);
                            log.info("goodsList :::::::::::::::::::::::::::::::::: = "+goodsList);
                            log.info("cnt :::::::::::::::::::::::::::::::::::::::: = "+cnt);
                            for (OrderGoodsVO orderGoodsVo : goodsList) {
                            	vo.setOrdDtlSeq(orderGoodsVo.getOrdDtlSeq());
                                log.info("orderGoodsVo.getOrdDtlStatusCd() ::::::::::: = "+orderGoodsVo.getOrdDtlStatusCd());
                                log.info("vo.getOrdStatusCd() :::::::::::::::::::::::: = "+vo.getOrdStatusCd());
                                log.info("cnt :::::::::::::::::::::::::::::::::::::::: = "+cnt);
                                // md확정시 현제 상태가 결제 완료인 목록만 update
                                if("30".equals(vo.getOrdStatusCd()) && "20".equals(orderGoodsVo.getOrdDtlStatusCd())) {
                                    //if (cnt > 0) {
                                    cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDtl", vo);
                                    //}
                                } else if ("20".equals(vo.getOrdStatusCd()) && "10".equals(orderGoodsVo.getOrdDtlStatusCd())) {

                                    cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDtl", vo);
                                }
                            }
                    	}
                    } else {
                        cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatus", vo);
                        //if(cnt > 0){
                        cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDtl", vo);
//                    	}
                    }
                } catch (Exception e) {
                    log.info("주문상태 변경 에러 {}", e.getMessage());
                }

                if (cnt > 0) {
                    String sendTypeCdSms = "", sendTypeCdEmail = "";
                    String templateCode ="";
                    Map<String, String> templateCodeMap = new HashMap<>();
                    // 주문 테이블의 주문 상태 : 부분 배송중, 부분 배송 완료를 배송중 배송 완료로 변경
                    if (OrdStatusConstants.DELIV_DOING.equals(vo.getOrdStatusCd()) || OrdStatusConstants.DELIV_DONE.equals(vo.getOrdStatusCd())) {
                        try {
                            updateOrdStatusDone(vo);
                        } catch (Exception e) {
                            log.debug("{}", e.getMessage());
                        }
                        // 주문 상태에 따른 이메일, SMS 처리
                        if (!curOrdStatusCd.equals(vo.getOrdStatusCd())) { // 주문상태가 변경되는 경우만 처리
                            OrderGoodsVO tmpVo = selectCurOrdStatus(vo);

                            log.info("{}", curOrdStatusCd);
                            log.info("{}", vo.getOrdStatusCd());
                            log.info("{}", tmpVo.getOrdStatusCd());

                            if (OrdStatusConstants.DELIV_DOING_PARTLY.equals(tmpVo.getOrdStatusCd())) {
                                // 부분배송중
                                templateCode = "";
                                sendTypeCdSms = "";
                                sendTypeCdEmail = "";
                            } else if (OrdStatusConstants.DELIV_DOING.equals(tmpVo.getOrdStatusCd())) { // 주문  마스터 배송중일경우
                                //배송중
                                templateCode = "mk002";
                                templateCodeMap.put("member","mk030");
                                sendTypeCdSms = "06";
                                sendTypeCdEmail = "08";
                            } else if (OrdStatusConstants.DELIV_DONE_PARTLY.equals(tmpVo.getOrdStatusCd())) { // 주문  마스터 부분 배송완료
                                //부분배송완료
                                templateCode = "";
                                sendTypeCdSms = "";
                                sendTypeCdEmail = "";
                            } else if (OrdStatusConstants.DELIV_DONE.equals(tmpVo.getOrdStatusCd())) { // 주문 마스터  배송완료일경우
                                //배송완료
                                if("04".equals(tmpVo.getDlvrcPaymentCd())) {
                                    templateCode = "";
                                    templateCodeMap.put("member","mk027");
                                    sendTypeCdSms = "27";
                                    sendTypeCdEmail = "11";
                                } else {
                                    templateCode = "";
                                    templateCodeMap.put("member","mk031");
                                    sendTypeCdSms = "09";
                                    sendTypeCdEmail = "11";
                                }
                            }
                        }
                        // 주문 상태에 따른 이메일, SMS 처리(배송관련 이외)
                    } else if (!curOrdStatusCd.equals(vo.getOrdStatusCd()) && !isBackOrdStatus) {
                        /**
                         * Email
                         * 주문완료(상태코드:입금확인중) : 05
                         * 결제완료 : 06
                         * 배송준비 : 07
                         * 배송중 처리시 : 08
                         * 부분배송 처리시 : 09
                         * 부분배송 완료 시 : 10
                         * 배송 완료시 : 11
                         * 교환/환불 신청 : 12
                         * 주문무효 : 13
                         * 결제취소환불완료 : 14 ???? 이런 상태 없음.
                         * 반품환불완료 : 15
                         * 결제취소 : 16
                         * 결제 실패 : 17 (?)
                         **/


                        if (OrdStatusConstants.ORD_CANCEL.equals(vo.getOrdStatusCd())) {
                            //주문취소
                            templateCode ="";
                            sendTypeCdSms = "";
                            sendTypeCdEmail = "";
                        } else if (OrdStatusConstants.ORD_DONE.equals(vo.getOrdStatusCd())) {
                            //주문완료
                            templateCode ="";
                            sendTypeCdSms = "";
                            sendTypeCdEmail = "";
                        } else if (OrdStatusConstants.PAY_DONE.equals(vo.getOrdStatusCd())) {
                            //결제완료
                            templateCode ="mk001";
                            templateCodeMap.put("member","mk019");
                            templateCodeMap.put("admin","mk023");
                            templateCodeMap.put("seller","mk023");
                            sendTypeCdSms = "03";
                            sendTypeCdEmail = "06";
                            // 가상계좌 무통장 결제의 경우 재고 차감 및 입금완료 정보 수정
                            depositService.updateOrdStatusPayDoneCommon(vo, curOrdStatusCd);
                        } else if (OrdStatusConstants.DELIV_BEFORE.equals(vo.getOrdStatusCd())) {
                            //배송준비중
                            templateCode ="";
                            sendTypeCdSms = "";
                            sendTypeCdEmail = "";
                        } else if (OrdStatusConstants.EXCG_APPLY.equals(vo.getOrdDtlStatusCd())
                                || OrdStatusConstants.RETURN_APPLY.equals(vo.getOrdDtlStatusCd())) {
                                //교환신청 & 반품신청
                            templateCode ="";
                            templateCodeMap.put("member", "mk034");
                            templateCodeMap.put("admin", "mk035");
                            templateCodeMap.put("seller", "mk035");
                            sendTypeCdSms = "12";
                            sendTypeCdEmail = "12";
                        } else if (OrdStatusConstants.ORD_NOVALID.equals(vo.getOrdStatusCd())) {
                        //주문무효
                            templateCode ="";
                            sendTypeCdSms = "";
                            sendTypeCdEmail = "";
                        } else if (OrdStatusConstants.RETURN_DONE.equals(vo.getOrdDtlStatusCd())) {
                        //반품완료
                            templateCode ="";
                            sendTypeCdSms = "";
                            sendTypeCdEmail = "";
                        } else if (OrdStatusConstants.PAY_CANCEL.equals(vo.getOrdStatusCd())) {
                        //결제취소
                            templateCode ="mk003";
                            templateCodeMap.put("member", "mk028");
                            templateCodeMap.put("admin", "mk029");
                            sendTypeCdSms = "10";
                            sendTypeCdEmail = "16";
                        } else if (OrdStatusConstants.PAY_FAIL.equals(vo.getOrdStatusCd())) {
                        //결제실패
                            templateCode ="";
                            sendTypeCdSms = "";
                            sendTypeCdEmail = "";
                        }
                    }

                    log.info("{}", sendTypeCdSms);
                    log.info("{}", templateCodeMap);

                    try {
                        //배송중 상태 변경시 sms 전송 여부를 관리자의 선택으로 변경
                        if(vo.getSmsSendYn()==null || vo.getSmsSendYn().equals("")){
                            vo.setSmsSendYn("Y");
                        }

                        if(vo.getSmsSendYn().equals("Y")) {
                            if (!"".equals(sendTypeCdSms)) sendOrdAutoSms(templateCode, sendTypeCdSms, vo, templateCodeMap);
//                            if (!"".equals(sendTypeCdEmail)) sendOrdAutoEmail(sendTypeCdEmail, vo);
                        }
                    } catch (Exception eAuto) {
                        log.info("{}", eAuto.getMessage());
                    }

                    try {
                        /** 구매 확정 처리 **/
                        result = updateOrdStatusCdConfirm(vo);

                        if(result.isSuccess()){
                            if("Y".equals(vo.getMdConfirmYn())){
                                // MD확정일 경우 인터페이스 호출 (IF_ORD_001 : 발주등록)
                                OrderInfoVO orderInfoVo = new OrderInfoVO();
                                orderInfoVo.setOrdNo(vo.getOrdNo());
                                orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                                Long sellerNo = SessionDetailHelper.getSession().getSellerNo();
                                if(sellerNo != null && sellerNo > 0) {
                                	orderInfoVo.setSellerNo(String.valueOf(sellerNo));
                                }

                               /* if (CommonConstants.AUTH_GB_CD_ADMIN.equals(SessionDetailHelper.getSession().getAuthGbCd())) {
                                    sellerNo = null;
                                    orderInfoVo.setSellerNo(null);
                                }*/
                                HttpServletRequest request =  HttpUtil.getHttpServletRequest();
                                String referer = request.getHeader("referer");
                                if(referer.indexOf("seller")>-1){

                                }else{
                                    sellerNo = null;
                                    orderInfoVo.setSellerNo(null);
                                }

                                OrderVO orderVo = orderService.selectOrdDtl(orderInfoVo);

                                List<Map<String, Object>> ordDtlList =  new ArrayList<>();
                                List<Map<String, Object>> ordSellerDtlList =  new ArrayList<>();
                                log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>orderInfoVo = "+orderInfoVo);
                                log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>orderVo = "+orderVo);
                                log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>sellerNo = "+sellerNo);
                                String ordErpMappingDone = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectIsErpMappingDone", orderInfoVo);
                                orderInfoVo.setIsErpMappingDone(ordErpMappingDone);
                                if(sellerNo != null && sellerNo > 0) {
                                    // 실제 넘길 주문 상세 목록 조회(예약 전용이 아닌 셀러상품중 매장픽업 상품 목록 조회)
                                    ordDtlList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlListForInterface", orderInfoVo);
                                }else{// seller 정보가 없을때
                                    // 실제 넘길 주문 상세 목록 조회(예약 전용이 아닌 다비치 상품 목록 조회)
                                    ordDtlList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlListForInterface", orderInfoVo);
                                    // 실제 넘길 주문 상세 목록 조회(예약 전용이 아닌 셀러상품중 매장픽업 상품 목록 조회)
                                    ordSellerDtlList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectSellerOrdDtlListForInterface", orderInfoVo);

                                }
                                // erp 연동 필요한 상품만 담음
                                log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ordDtlList = "+ordDtlList);
                                Map<String, Object> param = new HashMap<>();
                                //예약전용이 아닌 다비치 상품 & 셀러상품중 매장픽업 상품이 있을때만 인터페이스로 발주 정보 등록
                                if(ordDtlList != null && ordDtlList.size() > 0) {

                                    param.put("orderNo", vo.getOrdNo());
                                    SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
                                    String orderDate = transFormat.format(orderVo.getOrderInfoVO().getOrdAcceptDttm());
                                    param.put("orderDate", orderDate);
                                    String payDate = transFormat.format(orderVo.getOrderInfoVO().getPaymentCmpltDttm());
                                    param.put("payDate", payDate);

                                    //주문번호에 해당하는 방문예약정보조회(매장코드)
                                    VisitVO visitVO = orderService.selectStrCode(orderInfoVo);
                                    String delivStrCode = "";
                                    String destType = "";
                                    if (visitVO != null && visitVO.getStoreNo() != null) {
                                        delivStrCode = visitVO.getStoreNo();
                                    }

                                    if(sellerNo != null && !"".equals(sellerNo) && sellerNo > 1 ) {
                                    	destType = "3";	//셀러상품 매장픽업
                                    	param.put("venCode", "100000");
                                    }else {
                                    	if (!delivStrCode.equals("")) {
                                            destType = "2";	//다비치상품 매장픽업
                                        } else {
                                            destType = "1";	//다비치상품 택배
                                        }
                                        param.put("venCode", "000000");
                                    }

                                    param.put("destType", destType);
                                    param.put("ordRute", destType);
                                    param.put("delivStrCode", delivStrCode);
                                    param.put("address1", orderVo.getOrderInfoVO().getRoadnmAddr());
                                    param.put("address2", orderVo.getOrderInfoVO().getStoreNm());
                                    param.put("zipcode", orderVo.getOrderInfoVO().getPostNo());
                                    param.put("receiverName", orderVo.getOrderInfoVO().getAdrsNm());
                                    param.put("receiverHp", orderVo.getOrderInfoVO().getAdrsMobile());
                                    param.put("memNo", orderVo.getOrderInfoVO().getMemberNo());
                                    param.put("bigo", orderVo.getOrderInfoVO().getMemoContent());


                                    param.put("orderName", orderVo.getOrderInfoVO().getOrdrNm());
                                    param.put("orderHp", orderVo.getOrderInfoVO().getOrdrMobile());

                                    int dlvrAmt = 0;
                                    for (OrderGoodsVO orderGoodsVo : orderVo.getOrderGoodsVO()) {
                                        dlvrAmt += Integer.parseInt(orderGoodsVo.getRealDlvrAmt());
                                    }
                                    param.put("dlvrAmt", dlvrAmt);
                                    param.put("ordDtlList", ordDtlList);

                                    List<Map<String, Object>> payList = new ArrayList<>();
                                    for (OrderPayVO payVo : orderVo.getOrderPayVO()) {
                                        Map<String, Object> listParam = new HashMap<>();
                                        listParam.put("payWayCd", payVo.getPaymentWayCd());
                                        listParam.put("payWayNm", payVo.getPaymentWayNm());
                                        listParam.put("payAmt", payVo.getPaymentAmt());
                                        payList.add(listParam);
                                    }
                                    param.put("payList", payList);


                                    //쿠폰사용 주문내역 조회
                                    List<CouponVO> cpList = orderService.selectCouponList(orderInfoVo);

                                    List<Map<String, Object>> couponList = new ArrayList<>();
                                    for (CouponVO cpVo : cpList) {
                                        Map<String, Object> listParam = new HashMap<>();
                                        listParam.put("ordDtlSeq", cpVo.getOrdDtlSeq());
                                        listParam.put("dcAmt", cpVo.getCpUseAmt());
                                        listParam.put("dcCode", cpVo.getCouponKindCd());
                                        listParam.put("dcName", cpVo.getCouponKindCdNm());
                                        couponList.add(listParam);
                                    }
                                    param.put("couponList", couponList);
                                    log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> param = "+param);
                                    // 인터페이스 호출
                                    ifOrderReg(param); // interface_block_temp
                                    /*Map<String, Object> ifresult = InterfaceUtil.send("IF_ORD_001", param);
									if ("1".equals(ifresult.get("result"))) {
                                        result.setSuccess(true);
                                    }else{
                                        throw new Exception(String.valueOf(ifresult.get("message")));
                                    }*/
                                }

                                //예약전용이 아닌 셀러상품중 매장픽업 이 있을때만 인터페이스로 발주 정보 등록
                                if(ordSellerDtlList != null && ordSellerDtlList.size() > 0) {

                                    param.put("orderNo", vo.getOrdNo());
                                    SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
                                    String orderDate = transFormat.format(orderVo.getOrderInfoVO().getOrdAcceptDttm());
                                    param.put("orderDate", orderDate);
                                    String payDate = transFormat.format(orderVo.getOrderInfoVO().getPaymentCmpltDttm());
                                    param.put("payDate", payDate);

                                    //주문번호에 해당하는 방문예약정보조회(매장코드)
                                    VisitVO visitVO = orderService.selectStrCode(orderInfoVo);
                                    String delivStrCode = "";
                                    String destType = "3";
                                    if (visitVO != null && visitVO.getStoreNo() != null) {
                                        delivStrCode = visitVO.getStoreNo();
                                    }

                                    param.put("venCode", "100000");
                                    param.put("destType", destType);
                                    param.put("ordRute", destType);
                                    param.put("delivStrCode", delivStrCode);
                                    param.put("address1", orderVo.getOrderInfoVO().getRoadnmAddr());
                                    param.put("address2", orderVo.getOrderInfoVO().getStoreNm());
                                    param.put("zipcode", orderVo.getOrderInfoVO().getPostNo());
                                    param.put("receiverName", orderVo.getOrderInfoVO().getAdrsNm());
                                    param.put("receiverHp", orderVo.getOrderInfoVO().getAdrsMobile());
                                    param.put("memNo", orderVo.getOrderInfoVO().getMemberNo());
                                    param.put("bigo", orderVo.getOrderInfoVO().getMemoContent());


                                    param.put("orderName", orderVo.getOrderInfoVO().getOrdrNm());
                                    param.put("orderHp", orderVo.getOrderInfoVO().getOrdrMobile());

                                    int dlvrAmt = 0;
                                    for (OrderGoodsVO orderGoodsVo : orderVo.getOrderGoodsVO()) {
                                        dlvrAmt += Integer.parseInt(orderGoodsVo.getRealDlvrAmt());
                                    }
                                    param.put("dlvrAmt", dlvrAmt);
                                    param.put("ordDtlList", ordSellerDtlList);

                                    List<Map<String, Object>> payList = new ArrayList<>();
                                    for (OrderPayVO payVo : orderVo.getOrderPayVO()) {
                                        Map<String, Object> listParam = new HashMap<>();
                                        listParam.put("payWayCd", payVo.getPaymentWayCd());
                                        listParam.put("payWayNm", payVo.getPaymentWayNm());
                                        listParam.put("payAmt", payVo.getPaymentAmt());
                                        payList.add(listParam);
                                    }
                                    param.put("payList", payList);


                                    //쿠폰사용 주문내역 조회
                                    List<CouponVO> cpList = orderService.selectCouponList(orderInfoVo);

                                    List<Map<String, Object>> couponList = new ArrayList<>();
                                    for (CouponVO cpVo : cpList) {
                                        Map<String, Object> listParam = new HashMap<>();
                                        listParam.put("ordDtlSeq", cpVo.getOrdDtlSeq());
                                        listParam.put("dcAmt", cpVo.getCpUseAmt());
                                        listParam.put("dcCode", cpVo.getCouponKindCd());
                                        listParam.put("dcName", cpVo.getCouponKindCdNm());
                                        couponList.add(listParam);
                                    }
                                    param.put("couponList", couponList);

                                    // 인터페이스 호출
                                    ifOrderReg(param); // interface_block_temp
                                    /*Map<String, Object> ifresult = InterfaceUtil.send("IF_ORD_001", param);
                                    if ("1".equals(ifresult.get("result"))) {
                                        result.setSuccess(true);
                                    }else{
                                        throw new Exception(String.valueOf(ifresult.get("message")));
                                    }*/
                                }
                            }
                            log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> vo = "+vo);

                            if("90".equals(vo.getOrdStatusCd())) {
                            	// 구매확정인 경우 인터페이스 호출
                                Map<String, Object> param = new HashMap<>();
                                OrderInfoVO dtlSearchVo = new OrderInfoVO();
                                dtlSearchVo.setOrdNo(vo.getOrdNo());
                                dtlSearchVo.setSiteNo(vo.getSiteNo());
                                dtlSearchVo.setOrdDtlSeq(vo.getOrdDtlSeq());
                                List<OrderGoodsVO> goodsList = selectOrdDtlList(dtlSearchVo);
                                List<Map<String, Object>> ordDtlList = new ArrayList<>();

                                param.put("orderNo", vo.getOrdNo());

                                for(OrderGoodsVO dtl : goodsList){
                                //다비치 상품인경우에만 interface 호출 용 데이터 생성
                                    Map<String, Object> listParam = new HashMap<>();
                                    if(dtl.getSellerNo().equals("1")) {
                                        listParam.put("ordDtlSeq", dtl.getOrdDtlSeq());
                                        ordDtlList.add(listParam);
                                    }
                                }

                                if(ordDtlList.size()>0) {
                                    param.put("ordDtlList", ordDtlList);
                                    ifPurchaseConfirm(param); // interface_block_temp
                                    /*Map<String, Object> confirmResult = InterfaceUtil.send("IF_ORD_008", param);

                                    if ("1".equals(confirmResult.get("result"))) {
                                        result.setSuccess(true);
                                    } else {
                                        throw new Exception(String.valueOf(confirmResult.get("message")));
                                    }*/
                                }
                            }
                        }
                    } catch (Exception e) {
                        log.debug("{}", e.getMessage());
                        throw new CustomException("biz.exception.error.interface", new Object[] {new String("<br>"+e.getMessage())}, e);
                    }

                    String args[] = { "1" };
                    result.setSuccess(true);
                    result.setMessage(MessageUtil.getMessage("biz.result.ord.updateOrdStatus", args));
                } else { // 주문번호[{0}]의 상태를 변경할 수 없습니다.
                    throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { vo.getOrdNo() });
                }
            } else { // 주문번호[{0}]의 주문상태를 다시 확인하세요
                throw new CustomException("biz.exception.ord.invalidOrdStatus", new Object[] { vo.getOrdNo() });
            }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 7.
     * 작성자 : dong
     * 설명   : 주문 1건의 주문상태를 변경한다. 주문 번호, 현재 주문상태 필수
     * 상태 코드 부분배송[준비]중을 전체완료로 변경

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 7. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultModel<OrderInfoVO> updateOrdStatusDone(OrderGoodsVO vo) throws CustomException {

        ResultModel<OrderInfoVO> result = new ResultModel<>();
        vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        int cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDone", vo);
        if (cnt > 0) result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /**
     * TO_PAYMENT 테이블 주문 상태 변경
     */
    @Override
    public ResultModel<OrderPayVO> updatePaymentStatus(PaymentModel model) throws CustomException {
        ResultModel<OrderPayVO> result = new ResultModel<>();
        int cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updatePaymentStatus", model);
        if (cnt > 0) result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : KNG
     * 설명   : PG 입금통보 입금정보 수신시 주문, 주문상세, 결제, 현금영수증 테이블 정보를 변경 및 추가하는 작업
     *
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. KNG - 최초생성
     * </pre>
     *
     * @param vo
     * @param model
     * @return
     * @throws CustomException
     * @throws Exception
     */
    @Override
    public ResultModel<OrderPayVO> updatePaymentStatusByDepositNotice(OrderGoodsVO vo, PaymentModel model)
            throws Exception {
        // 주문-주문상세 상태업데이트
        this.updateOrdStatus(vo, "10");// 주문완료(상태코드:입금확인중) => 결제완료

        // 결제테이블 update
        ResultModel<OrderPayVO> result = new ResultModel<>();
        int cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updatePaymentStatusByDepositNotice", model);
        if (cnt > 0) result.setMessage(MessageUtil.getMessage("biz.common.update"));

        // 현금영수증 DB 인서트 처리 : 입금과 내역과 함께 현금영수증 정보를 등록하려면 CashRctYn = "Y" 로 처리
        if ("Y".equals(model.getCashRctYn()) && !StringUtil.isEmpty(model.getPaymentAmt())) { // 현금영수증
            log.debug("=== 현금영수증 발행 ===");
            SalesProofPO cashPO = new SalesProofPO();
            cashPO.setOrdNo(model.getOrdNo());
            cashPO.setCashRctStatusCd("02"); // 상태코드(01:접수,02:승인,03:오류)
            cashPO.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자, 02:관리자)
            cashPO.setMemberNo(Long.parseLong((StringUtil.isEmpty(model.getOrdrNo())) ? "0" : model.getOrdrNo()));
            cashPO.setUseGbCd(model.getUseGbCd()); // 사용구분코드(01:소득공제, 02:지출증빙)
            cashPO.setIssueWayCd(model.getIssueWayCd()); // 발급수단코드(01:주민등록번호,02:휴대폰,03:사업자등록번호)
            cashPO.setIssueWayNo(model.getIssueWayNo()); // 발급수단번호
            cashPO.setTotAmt(Long.valueOf(model.getPaymentAmt())); // 총금액
            cashPO.setAcceptDttm(model.getRegDttm()); // 접수일시
            cashPO.setLinkTxNo(model.getLinkTxNo());
            cashPO.setApplicantNm(model.getApplicantNm()); // 신청자명
            cashPO.setRegrNo(model.getRegrNo()); // 등록자
            cashPO.setRegDttm(model.getRegDttm()); // 등록일자
            salesProofService.insertCashRct(cashPO);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 클레임 이력

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<ClaimGoodsVO> selectClaimList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectClaimList", vo);
    }

    /** 처리 로그 이력 조회 */
    public List<OrderGoodsVO> selectOrdDtlHistList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlHistList", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 13.
     * 작성자 : dong
     * 설명   : 주문의 현재 주문상태코드를 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 13. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public OrderGoodsVO selectCurOrdStatus(OrderGoodsVO vo) throws CustomException {
        OrderGoodsVO rVo = new OrderGoodsVO();
        rVo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectCurOrdStatus", vo);
        return rVo;
    }

    /********************************************************************************************************/
    /**
     * 주문 프로세스
     */
    @Override
    public ResultModel<OrderPO> insertOrder(OrderPO po, HttpServletRequest request) throws Exception {
        ResultModel<OrderPO> result = new ResultModel<>();
        try {

            Enumeration params = request.getParameterNames();
            log.debug("----------------------------");
            while (params.hasMoreElements()) {
                String name = (String) params.nextElement();
                log.debug("=== {} : {}", name, request.getParameter(name));
            }
            log.debug("----------------------------");

            boolean isMobile = SiteUtil.isMobile();
            Date today = po.getRegDttm();

            /** step01. 주문 데이터 확인 및 검증 */

            // 쿠폰 정보 검증
            if (SessionDetailHelper.getDetails().isLogin()) {
                String couponUseInfo = "";
                couponUseInfo = request.getParameter("couponUseInfo");
                List<CouponPO> couponList = new ArrayList<>();
                CouponSO couponSO = new CouponSO();
                couponSO.setSiteNo(po.getSiteNo());
                if (!"".equals(couponUseInfo) && couponUseInfo != null) {
                    String couponArr[] = couponUseInfo.split("\\▦");
                    for (int k = 0; k < couponArr.length; k++) {
                        // 0:아이템번호, 1:회원쿠폰번호, 2:쿠폰번호, 3:할인금액
                        String couponInfoArr[] = couponArr[k].split("\\^");
                        int couponNo = Integer.parseInt(couponInfoArr[2]);
                        couponSO.setCouponNo(couponNo);
                        couponSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        couponSO.setUseYn("N");
                        int cnt = couponService.selectMemberCoupon(couponSO);
                        if (cnt == 0) {
                            ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                            err_result.setMessage(MessageUtil.getMessage("front.web.goods.coupon.wrongCoupon"));
                            err_result.setSuccess(false);
                            return err_result;
                        }
                    }
                }
            }
            long chkPaymentAmt = 0; // 총 주문금액 확인용(위변조 방지)
            long ordNo = po.getOrdNo();
            OrderVO orderVO = new OrderVO();
            OrderInfoPO orderInfoPO = new OrderInfoPO();
            DeliveryPO deliveryPO = new DeliveryPO();
            GoodsDetailSO goodsDetailSO = new GoodsDetailSO();
            ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<>();

            /** step01-1.주문 정보&배송지 정보 */
            log.debug("step01-1.주문 정보");
            orderInfoPO.setOrdNo(ordNo); // 주문번호
            orderInfoPO.setSiteNo(po.getSiteNo()); // 사이트번호
            orderInfoPO.setOrdStatusCd("01"); // 주문상태(주문접수)
            if (isMobile) { // 수기주문은 추후 따로 처리
                orderInfoPO.setOrdMediaCd("02"); // 주문매체(모바일)
            } else {
                orderInfoPO.setOrdMediaCd("01"); // 주문매체(PC)
            }
            orderInfoPO.setSaleChannelCd("shop9999");
            long memberNo = 0;
            String loginId = "";
            long memberGradeNo = 0;
            if (SessionDetailHelper.getDetails().isLogin()) {
                memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
                loginId = SessionDetailHelper.getDetails().getSession().getLoginId();
                memberGradeNo = SessionDetailHelper.getDetails().getSession().getMemberGradeNo();
                orderInfoPO.setMemberOrdYn("Y"); // 회원 주문 여부(회원)
                orderInfoPO.setPvdSvmn(Long.parseLong(request.getParameter("pvdSvmnTotalAmt"))); // 적립예정금액
            } else {
                orderInfoPO.setMemberOrdYn("N"); // 회원 주문 여부(비회원)
                orderInfoPO.setPvdSvmn(0); // 적립예정금액
            }
            orderInfoPO.setMemberNo(memberNo); // 회원번호
            orderInfoPO.setRegrNo(memberNo); // 등록자 번호
            orderInfoPO.setLoginId(loginId); // 로그인아이디
            orderInfoPO.setMemberGradeNo(memberGradeNo); // 회원등급

            orderInfoPO.setOrdrNm(request.getParameter("ordrNm")); // 주문자명
            orderInfoPO.setOrdrEmail(request.getParameter("ordrEmail")); // 주문자 이메일
            orderInfoPO.setOrdrTel(request.getParameter("ordrTel")); // 주문자 전화번호
            orderInfoPO.setOrdrMobile(request.getParameter("ordrMobile")); // 주문자 휴대폰번호
            orderInfoPO.setOrdrIp(request.getRemoteAddr()); // 주문자 IP
            orderInfoPO.setOrdAcceptDttm(today); // 주문 접수 일자
            orderInfoPO.setPaymentAmt(po.getPaymentAmt() + po.getMileageTotalAmt()); // 결제금액(+마켓포인트)
            orderInfoPO.setSaleAmt(Long.parseLong(request.getParameter("orderTotalAmt"))); // 판매금액
            orderInfoPO.setDcAmt(po.getDcAmt()); // 할인금액
            orderInfoPO.setRegDttm(today); // 등록일자
            orderInfoPO.setManualOrdYn((request.getParameter("manualOrdYn") == null) ? "N" : request.getParameter("manualOrdYn"));
            orderInfoPO.setRecomMemberNo(po.getRecomMemberNo());

            /* 배송지 정보 */
            //일반주문서 일경우만 수령지 정보 세팅
            /*if(po.getOrderFormType()!=null && po.getOrderFormType().equals("01")) {*/
                String memberGbCd = request.getParameter("memberGbCd");
                orderInfoPO.setMemberGbCd(memberGbCd);  // 회원구분코드(10:국내/20:해외)
                orderInfoPO.setAdrsTel(request.getParameter("adrsTel"));    // 수취인 전화번호
                orderInfoPO.setAdrsMobile(request.getParameter("adrsMobile"));  // 수취인 휴대폰
                if ("10".equals(memberGbCd)) { // 국내
                    orderInfoPO.setAdrsNm(request.getParameter("adrsNm"));  // 수취인 명
                    orderInfoPO.setPostNo(request.getParameter("postNo"));  // 우편번호
                    orderInfoPO.setNumAddr(request.getParameter("numAddr"));    // 지번 주소
                    orderInfoPO.setRoadnmAddr(request.getParameter("roadnmAddr"));  // 도로명 주소
                    orderInfoPO.setDtlAddr(request.getParameter("dtlAddr"));    // 상세 주소
                } else { // 해외
                    orderInfoPO.setFrgAddrCountry(request.getParameter("frgAddrCountry"));
                    orderInfoPO.setFrgAddrCity(request.getParameter("frgAddrCity"));
                    orderInfoPO.setFrgAddrState(request.getParameter("firgAddrState"));
                    orderInfoPO.setFrgAddrZipCode(request.getParameter("frgAddrZipCode"));
                    orderInfoPO.setFrgAddrDtl1(request.getParameter("frgAddrDtl1"));
                    orderInfoPO.setFrgAddrDtl2(request.getParameter("frgAddrDtl2"));
                }
                orderInfoPO.setDlvrMsg(request.getParameter("dlvrMsg"));    // 배송메세지
            /*}*/
            po.setOrderInfoPO(orderInfoPO);

            /** step01-2.주문 상품 정보 */
            log.debug("step01-2.주문 상품 정보");
            String[] itemArr = po.getItemArr();
            log.debug(" ==== itemArr : {}", itemArr);
            List<OrderGoodsPO> orderGoodsList = new ArrayList();
            int ordDtlSeq = 1; // 상세 순번
            boolean areaDlvrApplyYn = false; // 지역추가 배송비 적용 여부
            String grpId = "";
            String preGrpId = "";
            int dlvrSeq = 0; // 배송순번(묶음배송 관련)
            long firstSellerNo =0;
            if (itemArr != null && itemArr.length > 0) {
                for (int i = 0; i < itemArr.length; i++) {
                    /*
                     * 전송 데이터 예제
                     * itemArr[0] : G1607121100_0815▦I1607121106_0960^1^01▦
                     * itemArr[1] : G1607121100_0815▦I1607121106_0961^1^02▦
                     * itemArr[2] : G1607121100_0815▦I1607121106_0962^1^03▦
                     * itemArr[3] :
                     * G1607121100_0815▦I1607121106_0963^1^04▦69^118^1*70^120^1*
                     * 69^119^1
                     */
                    // 상품번호
                    String goodsNo = itemArr[i].split("\\▦")[0];
                    // 단품정보(단품번호:수량)
                    String item = itemArr[i].split("\\▦")[1];
                    String itemNo = item.split("\\^")[0]; // 단품번호
                    int buyQtt = Integer.parseInt(item.split("\\^")[1]); // 단품 구매수량
                    String dlvrcPaymentCd = item.split("\\^")[2]; // 배송비 결제 코드
                    // 추가옵션정보(옵션번호:상세번호:수량)
                    String addOpt = "";
                    if (itemArr[i].split("\\▦").length == 5) {
                        addOpt = itemArr[i].split("\\▦")[2];
                    }
                    long ctgNo = Long.parseLong(itemArr[i].split("\\▦")[3]);
                    long sellerNo = Long.parseLong(itemArr[i].split("\\▦")[4]);


                    goodsDetailSO.setGoodsNo(goodsNo);
                    goodsDetailSO.setItemNo(itemNo);
                    goodsDetailSO.setSiteNo(po.getSiteNo());
                    OrderGoodsPO orderGoodsPO = new OrderGoodsPO();
                    OrderGoodsVO orderGoodsVO = this.selectOrderGoodsInfo(goodsDetailSO); // 주문상품정보 조회
                    if (orderGoodsVO == null) {
                        ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                        err_result.setMessage("상품정보가 존재하지 않습니다");
                        err_result.setSuccess(false);
                        return err_result;
                    } else {
                        if ("Y".equals(orderGoodsVO.getAdultCertifyYn())) {
                            if (!SessionDetailHelper.getDetails().isLogin()) {
                                ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                                err_result.setMessage("성인용품은 성인인증을 하셔야만 구매가 가능합니다.");
                                err_result.setSuccess(false);
                                return err_result;
                            } else {
                                if (SessionDetailHelper.getSession().getAdult() == null
                                        || !SessionDetailHelper.getSession().getAdult()) {
                                    ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                                    err_result.setMessage("성인용품은 성인인증을 하셔야만 구매가 가능합니다.");
                                    err_result.setSuccess(false);
                                    return err_result;
                                }
                            }
                        }
                    }

                    List<GoodsAddOptionDtlVO> goodsAddOptList = new ArrayList();
                    BeanUtils.copyProperties(orderGoodsVO, orderGoodsPO);
                    orderGoodsPO.setOrdNo(ordNo); // 주문번호
                    orderGoodsPO.setOrdDtlSeq(ordDtlSeq); // 주문상세순번
                    orderGoodsPO.setOrdQtt(buyQtt);// 구매수량
                    orderGoodsPO.setOrdDtlStatusCd("01"); // 주문상태(주문접수)
                    orderGoodsPO.setAddOptYn("N"); // 추가옵션여부
                    orderGoodsPO.setDcAmt(Long.parseLong(request.getParameterValues("goodsDcPriceInfo")[i])); // 할인금액
                    orderGoodsPO.setCtgNo(ctgNo); // 카테고리 번호
                    orderGoodsPO.setRegrNo(memberNo); // 등록자 번호
                    orderGoodsPO.setRegDttm(today); // 등록일자
                    orderGoodsPO.setGoodsDmoneyUseAmt(Long.parseLong(request.getParameterValues("goodsDmoneyUseAmt")[i])); // 마켓포인트 사용 분배금액

                    if (request.getParameterValues("goodsPvdSvmnAmt")[i] != null) {
                    	orderGoodsPO.setGoodsSvmnAmt(Long.parseLong(request.getParameterValues("goodsPvdSvmnAmt")[i])); // 상품별 지급 적립금
                    }
                    
                    if (request.getParameterValues("recomPvdSvmnAmt")[i] != null) {
                    	orderGoodsPO.setRecomSvmnAmt(Long.parseLong(request.getParameterValues("recomPvdSvmnAmt")[i])); // 상품별 지급 적립금
                    }

                    if(orderGoodsVO.getRsvOnlyYn()==null || !orderGoodsVO.getRsvOnlyYn().equals("Y")) {
                        chkPaymentAmt += orderGoodsVO.getSaleAmt() * buyQtt;
                    }
                    log.debug("=== 상품금액 : {}", chkPaymentAmt);

                    // 부가비용(기획전, 회원등급 할인 정보)
                    List<OrderGoodsPO> addedAmountList = new ArrayList<>();
                    String goodsPromotionDcInfo[] = request.getParameterValues("goodsPromotionDcInfo");// 기획전
                    String goodsMemberGradeDcInfo[] = request.getParameterValues("goodsMemberGradeDcInfo");// 회원등급
                    if (!"".equals(goodsPromotionDcInfo[i])) {
                        OrderGoodsPO promotionPO = new OrderGoodsPO();
                        promotionPO.setOrgAddedAmountNo(0); // 원본 부가비용 번호
                        promotionPO.setOrdNo(orderGoodsPO.getOrdNo());
                        promotionPO.setOrdDtlSeq(orderGoodsPO.getOrdDtlSeq());
                        promotionPO.setAddedAmountGbCd("02");
                        promotionPO.setMemberNo(memberNo);
                        promotionPO.setPrmtNo(Long.parseLong(goodsPromotionDcInfo[i].split("\\▦")[0]));
                        promotionPO.setAddedAmountAmt(Long.parseLong(goodsPromotionDcInfo[i].split("\\▦")[3]));
                        promotionPO.setAddedAmountBnfCd(goodsPromotionDcInfo[i].split("\\▦")[1]);
                        promotionPO.setAddedAmountBnfValue(Long.parseLong(goodsPromotionDcInfo[i].split("\\▦")[2]));
                        promotionPO.setRegrNo(memberNo); // 등록자 번호
                        promotionPO.setRegDttm(today); // 등록일자
                        addedAmountList.add(promotionPO);
                    }
                    if (goodsMemberGradeDcInfo != null && !"".equals(goodsMemberGradeDcInfo[i])) {
                        OrderGoodsPO memberGradePO = new OrderGoodsPO();
                        memberGradePO.setOrgAddedAmountNo(0); // 원본 부가비용 번호
                        memberGradePO.setOrdNo(orderGoodsPO.getOrdNo());
                        memberGradePO.setOrdDtlSeq(orderGoodsPO.getOrdDtlSeq());
                        memberGradePO.setAddedAmountGbCd("01");
                        memberGradePO.setMemberNo(memberNo);
                        memberGradePO.setAddedAmountAmt(Long.parseLong(goodsMemberGradeDcInfo[i].split("\\▦")[3]));
                        memberGradePO.setAddedAmountBnfCd(goodsMemberGradeDcInfo[i].split("\\▦")[1]);
                        memberGradePO.setAddedAmountBnfValue(Long.parseLong(goodsMemberGradeDcInfo[i].split("\\▦")[2]));
                        memberGradePO.setRegrNo(memberNo); // 등록자 번호
                        memberGradePO.setRegDttm(today); // 등록일자
                        addedAmountList.add(memberGradePO);
                    }
                    orderGoodsPO.setAddedAmountList(addedAmountList);

                    // 배송비 정보
                    Map<String, String> dlvrPriceMap = new HashMap<>();
                    String tempDlvrPriceMap = request.getParameter("dlvrPriceMap");
                    String value = StringUtils.substringBetween(tempDlvrPriceMap, "{", "}");
                    String keyValuePairs[] = value.split(",");

                    for (String pair : keyValuePairs) {
                        String[] entry = pair.split("=");
                        dlvrPriceMap.put(entry[0].trim().replaceAll("[\"]", ""),entry[1].trim().replaceAll("[\"]", ""));
                    }

                    if ( ("1".equals(orderGoodsVO.getDlvrSetCd()) ) && ("01".equals(dlvrcPaymentCd) || "02".equals(dlvrcPaymentCd))) {// 기본 무료 || "04".equals(dlvrcPaymentCd)
                        grpId = orderGoodsVO.getSellerNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + dlvrcPaymentCd;
                    } else if ("4".equals(orderGoodsVO.getDlvrSetCd()) && ("02".equals(dlvrcPaymentCd) )) { // 기본 선불  || "04".equals(dlvrcPaymentCd)
                        grpId = orderGoodsVO.getGoodsNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + dlvrcPaymentCd;
                    } else if ("6".equals(orderGoodsVO.getDlvrSetCd()) && ("02".equals(dlvrcPaymentCd) )) { //상품별배송비(조건부무료)  선불 || "04".equals(dlvrcPaymentCd)
                        grpId = orderGoodsVO.getGoodsNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + dlvrcPaymentCd;
                    } else {
                        grpId = orderGoodsVO.getItemNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + dlvrcPaymentCd;
                    }

                    orderGoodsPO.setDlvrcPaymentCd(dlvrcPaymentCd); // 배송비 결제 코드(무료,선불,착불,방문)
                    orderGoodsPO.setDlvrSetCd(orderGoodsVO.getDlvrSetCd()); // 배송 설정 코드
                    orderGoodsPO.setDlvrQtt(buyQtt); // 배송수량
                    orderGoodsPO.setDlvrMsg(request.getParameter("dlvrMsg")); // 배송메세지

                    // 원본 배송비
                    if ("1".equals(orderGoodsVO.getDlvrSetCd())) {
                        if ("1".equals(orderGoodsVO.getDefaultDlvrcTypeCd())) {
                            orderGoodsPO.setOrgDlvrAmt(0);
                        } else if ("2".equals(orderGoodsVO.getDefaultDlvrcTypeCd())) {
                            orderGoodsPO.setOrgDlvrAmt(orderGoodsVO.getDefaultDlvrc());
                        } else if ("3".equals(orderGoodsVO.getDefaultDlvrcTypeCd())) {
                            long orderPrice = orderGoodsVO.getSaleAmt() * orderGoodsVO.getOrdQtt();
                            if (orderPrice >= orderGoodsVO.getDefaultDlvrMinAmt()) {
                                orderGoodsPO.setOrgDlvrAmt(0);
                            } else {
                                orderGoodsPO.setOrgDlvrAmt(orderGoodsVO.getDefaultDlvrMinDlvrc());
                            }
                        }
                    } else if ("2".equals(orderGoodsVO.getDlvrSetCd())) {
                        orderGoodsPO.setOrgDlvrAmt(0);
                    } else if ("3".equals(orderGoodsVO.getDlvrSetCd())) {
                        orderGoodsPO.setOrgDlvrAmt(orderGoodsVO.getGoodseachDlvrc());
                    } else if ("4".equals(orderGoodsVO.getDlvrSetCd())) {
                        int packCnt = (int) orderGoodsVO.getOrdQtt() / orderGoodsVO.getPackMaxUnit();
                        if (orderGoodsVO.getOrdQtt() % orderGoodsVO.getPackMaxUnit() > 0) {
                            packCnt++;
                        }
                        orderGoodsPO.setOrgDlvrAmt(orderGoodsVO.getPackUnitDlvrc() * packCnt);
                    } else if ("6".equals(orderGoodsVO.getDlvrSetCd())) {
                        long orderPrice = orderGoodsVO.getSaleAmt() * orderGoodsVO.getOrdQtt();
                        if (orderPrice > 0 && orderPrice >= orderGoodsVO.getFreeDlvrMinAmt()) {
                            orderGoodsPO.setOrgDlvrAmt(0);
                        } else if (orderPrice > 0 && orderPrice < orderGoodsVO.getFreeDlvrMinAmt()) {
                            orderGoodsPO.setOrgDlvrAmt(orderGoodsVO.getGoodseachcndtaddDlvrc());
                        }
                    }
                    // 실제배송비
                    if (!grpId.equals(preGrpId)) {
                        dlvrSeq++;
                        orderGoodsPO.setDlvrSeq(dlvrSeq);
                        orderGoodsPO.setRealDlvrAmt(Long.parseLong(dlvrPriceMap.get(grpId)));
                    } else {
                        orderGoodsPO.setDlvrSeq(dlvrSeq);
                        orderGoodsPO.setRealDlvrAmt(0);
                    }

                    String addDlvrAmt = request.getParameter("addDlvrAmt");
                    if (addDlvrAmt != null && !"".equals(addDlvrAmt)  && Long.parseLong(addDlvrAmt)>0) {
                        if (!areaDlvrApplyYn) { // 지역추가배송비 적용 전
                            if (!"04".equals(orderGoodsVO.getDlvrcPaymentCd())) {
                                // 지역 배송 설정 번호
                                String areaDlvrSetNo = "";
                                areaDlvrSetNo = request.getParameter("areaDlvrSetNo");
                                if (areaDlvrSetNo != null && !"".equals(areaDlvrSetNo)) {
                                    //판매자별 첫번째 상품에만 추가
                                    /*if(sellerNo != firstSellerNo){*/

                                        String areaSellerNo = "";
                                      /*  String [] areaDlvrSetNoArr = request.getParameter("areaDlvrSetNo").split(",");
                                        if(areaDlvrSetNoArr.length >= (i+1)) {
                                            for (String areaDlvrSet : areaDlvrSetNoArr) {
                                                areaSellerNo = areaDlvrSet.split(":")[0];
                                                areaDlvrSetNo = areaDlvrSet.split(":")[1];
                                                if (Long.parseLong(areaSellerNo) == sellerNo) {
                                                    firstSellerNo = sellerNo;
                                                    orderGoodsPO.setAreaDlvrSetNo(Long.parseLong(areaDlvrSetNo));
                                                    break;
                                                }
                                            }
                                        }*/

                                        String [] addDlvrAmtArr = request.getParameter("addDlvrAmtString").split(",");
                                        String addDlvrAmtSplit ="";
                                        String areaDlvrSetNoSplit= "";

                                        String [] fsellerNo = request.getParameterValues("fsellerNo");
                                        String [] addDlvrItem = request.getParameterValues("addDlvrItem");

                                        for(String addDlvrItems : addDlvrItem){
                                            String addDlvrItemNo = addDlvrItems.split("@")[0];
                                            String addDlvrSellerNo = addDlvrItems.split("@")[1];

                                            if(itemNo.equals(addDlvrItemNo)){
                                                for (String addDlvrAt : addDlvrAmtArr) {
                                                    areaSellerNo = addDlvrAt.split(":")[0];
                                                    addDlvrAmtSplit = addDlvrAt.split(":")[1];
                                                    areaDlvrSetNoSplit = addDlvrAt.split(":")[2];
                                                    /*int cnt = Arrays.binarySearch(fsellerNo,areaSellerNo);*/

                                                    if (Long.parseLong(addDlvrSellerNo) == Long.parseLong(areaSellerNo) ) {
                                                        // 지역 추가 배송비(매장픽업이 아닌 묶음 배송이 아닌 상품에 추가한다.)
                                                        orderGoodsPO.setAreaDlvrSetNo(Long.parseLong(areaDlvrSetNoSplit));
                                                        orderGoodsPO.setAreaAddDlvrc(Long.parseLong(addDlvrAmtSplit));
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                }
                                //areaDlvrApplyYn = true;
                            } else {
                                orderGoodsPO.setAreaAddDlvrc(0); // 지역 추가 배송비
                            }
                        }
                    } else {
                        orderGoodsPO.setAreaAddDlvrc(0); // 지역 추가 배송비
                    }
                    preGrpId = grpId;
                    if(orderGoodsPO.getRsvOnlyYn()==null || !orderGoodsPO.getRsvOnlyYn().equals("Y")) {
                        if(!"03".equals(dlvrcPaymentCd)) {
                            chkPaymentAmt += orderGoodsPO.getRealDlvrAmt() + orderGoodsPO.getAreaAddDlvrc();
                        }
                    }
                    log.debug("=== 배송비 : {}", chkPaymentAmt);

                    // 사은품 대상 조회
                    FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
                    freebieCndtSO.setGoodsNo(goodsNo);
                    freebieCndtSO.setFreebieEventAmt(po.getPaymentAmt());
                    freebieCndtSO.setSiteNo(po.getSiteNo());
                    List<OrderGoodsPO> freebieGoodsList = new ArrayList();
                    ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
                    freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);
                    log.debug("== freebieEventList : {}", freebieEventList.getExtraData().get("goodsResult"));
                    List<FreebieGoodsVO> freebieList = new ArrayList();
                    freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
                    if (freebieList != null && freebieList.size() > 0) {
                        // 사은품 조회
                        for (int j = 0; j < freebieList.size(); j++) {
                            FreebieGoodsVO freebieEventVO = freebieList.get(j);
                            FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
                            freebieGoodsSO.setFreebieEventNo(freebieEventVO.getFreebieEventNo());
                            freebieGoodsSO.setSiteNo(po.getSiteNo());

                            ResultModel<FreebieCndtVO> freeGoodsList = new ResultModel<>();
                            freeGoodsList = freebieCndtService.selectFreebieCndtDtl(freebieGoodsSO);
                            log.debug("== freeGoodsList : {}", freeGoodsList.getExtraData().get("goodsResult"));
                            List<FreebieGoodsVO> freebieList2 = new ArrayList();
                            freebieList2 = (List<FreebieGoodsVO>) freeGoodsList.getExtraData().get("goodsResult");
                            if (freebieList2 != null && freebieList2.size() > 0) {
                                for (int m = 0; m < freebieList2.size(); m++) {
                                    FreebieGoodsVO freebieGoodsVO = freebieList2.get(m);
                                    OrderGoodsPO freebieGoodsPO = new OrderGoodsPO();
                                    freebieGoodsPO.setFreebieNo(Long.parseLong(freebieGoodsVO.getFreebieNo()));
                                    freebieGoodsPO.setOrdNo(ordNo);
                                    freebieGoodsPO.setOrdDtlSeq(ordDtlSeq);
                                    freebieGoodsPO.setRegrNo(memberNo);
                                    freebieGoodsPO.setRegDttm(today);
                                    freebieGoodsList.add(freebieGoodsPO);
                                }
                            }
                        }
                    }
                    orderGoodsPO.setFreebieList(freebieGoodsList);
                    orderGoodsList.add(orderGoodsPO);
                    // 추가옵션
                    if (!"".equals(addOpt)) {
                        String[] addOptArr = addOpt.split("\\*");
                        for (int k = 0; k < addOptArr.length; k++) {
                            OrderGoodsPO addOptPO = new OrderGoodsPO();
                            ordDtlSeq++;
                            long addOptNo = Long.parseLong(addOptArr[k].split("\\^")[0]);
                            long addOptDtlSeq = Long.parseLong(addOptArr[k].split("\\^")[1]);
                            int optBuyQtt = Integer.parseInt(addOptArr[k].split("\\^")[2]);
                            goodsDetailSO.setAddOptNo(addOptNo);
                            goodsDetailSO.setAddOptDtlSeq(addOptDtlSeq);
                            // 추가옵션 정보 조회
                            GoodsAddOptionDtlVO goodsAddOptionDtlVO = this.selectOrderAddOptionInfo(goodsDetailSO);
                            addOptPO.setOrdNo(ordNo); // 주문번호
                            addOptPO.setOrdDtlSeq(ordDtlSeq); // 주문상세순번
                            addOptPO.setOrdDtlStatusCd("01"); // 주문상태(주문접수)
                            addOptPO.setGoodsNo(orderGoodsPO.getGoodsNo()); // 상품번호
                            addOptPO.setItemNo(orderGoodsPO.getItemNo()); // 아이템번호
                            addOptPO.setGoodsNm(orderGoodsPO.getGoodsNm()); // 상품명
                            addOptPO.setOrdQtt(optBuyQtt); // 구매수량
                            long addOptAmt = (long) Double.parseDouble(goodsAddOptionDtlVO.getAddOptAmt());
                            if(goodsAddOptionDtlVO.getAddOptAmtChgCd().equals("1")){
                            }else{
                                addOptAmt=addOptAmt*(-1);
                            }
                            if(orderGoodsPO.getRsvOnlyYn()==null || !orderGoodsPO.getRsvOnlyYn().equals("Y")) {
                                chkPaymentAmt += (addOptAmt * optBuyQtt);
                            }

                            log.debug("=== 옵션 : {}", chkPaymentAmt);
                            addOptPO.setSaleAmt(addOptAmt);
                            addOptPO.setAddOptYn("Y"); // 추가옵션 여부
                            addOptPO.setOptNo(goodsAddOptionDtlVO.getAddOptNo()); // 추가옵션  번호
                            String optNm = goodsAddOptionDtlVO.getAddOptNm() + ":"+ goodsAddOptionDtlVO.getAddOptValue();
                            addOptPO.setOptNm(optNm); // 추가옵션 명
                            addOptPO.setOptDtlSeq(goodsAddOptionDtlVO.getAddOptDtlSeq()); // 추가옵션 상세순번
                            addOptPO.setRegrNo(memberNo); // 등록자
                            addOptPO.setRegDttm(today); // 등록일자
                            addOptPO.setRsvOnlyYn(orderGoodsPO.getRsvOnlyYn()); //예약전용여부

                            orderGoodsList.add(addOptPO);
                        }
                    }
                    ordDtlSeq++;
                }
            } else {
                ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                err_result.setMessage(MessageUtil.getMessage("front.web.common.wrongapproach"));
                err_result.setSuccess(false);
                return err_result;
            }

            po.setOrderGoodsPO(orderGoodsList);

            chkPaymentAmt = chkPaymentAmt - po.getDcAmt();
            log.debug("=== 할인금액 : {}", po.getDcAmt());
            // 주문금액 검증
            log.debug("==== 주문금액 : {}", po.getPaymentAmt() + po.getMileageTotalAmt()+ po.getPointTotalAmt());
            log.debug("==== 계산금액 : {}", chkPaymentAmt);
            if (po.getPaymentAmt() + po.getMileageTotalAmt()  + po.getPointTotalAmt()!= chkPaymentAmt) {
                ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                err_result.setMessage("주문 금액이 일치하지 않습니다.");
                err_result.setSuccess(false);
                return err_result;
            }

            /** step02.주문정보 등록 Biz실행 */
            OrderInfoPO orderInfo = po.getOrderInfoPO().clone();
            this.insertOrderInfo(orderInfo);

            /** step03.주문 배송지정보 등록 */
            OrderInfoPO deliveryInfoPO = po.getOrderInfoPO().clone();
            this.insertOrderDelivery(deliveryInfoPO);

            if(po.getOrderFormType()!=null && po.getOrderFormType().equals("02")) {
                /* TODO... 매장픽업일경우 방문예약데이터 추가 입력...... 여기서*/
            	visitRsvService.insertVisitInfo(po, orderGoodsList);
            }

            /** step04.상품정보(주문상세정보) 등록 Biz실행 */
            this.insertOrderGoods(po.getOrderGoodsPO());

            /** step05.배송비 정보 등록 */
            this.insertDlvrc(po.getOrderGoodsPO());

            /** step06.부가비용 등록 */
            this.insertAddedAmount(po.getOrderGoodsPO());

            /** step07.주문 사은품 정보 등록 */
            this.insertFreebie(po.getOrderGoodsPO());

        } catch (Exception e) {
            log.error("주문 등록 에러 : {}", e.getMessage(), e);
            ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
            err_result.setMessage(MessageUtil.getMessage("front.web.order.insert.error"));
            err_result.setSuccess(false);
            return err_result;
        }

        result.setSuccess(true);
        result.setData(po);
        return result;
    }

    /**
     * 결제 프로세스
     */
    @Override
    public ResultModel<OrderPO> orderPayment(OrderPO po, HttpServletRequest request, Map<String, Object> reqMap,
            ModelAndView mav) throws Exception {
        ResultModel<OrderPO> result = new ResultModel<>();
        PaymentModel<?> payResult = new PaymentModel<>();

        // step01. pg결제 처리
        boolean standBydeposit = false;// 입금대기 주문여부
        boolean paymentByMileage = false;// 마켓포인트만으로 주문여부
        try {
            if (po.getPaymentAmt() > 0) {
                if ("11".equals(po.getOrderPayPO().getPaymentWayCd())) { // 무통장
                    standBydeposit = true;
                    payResult.setSiteNo(po.getSiteNo());
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentPgCd("00"); // PG코드(내부)
                    payResult.setPaymentWayCd(po.getOrderPayPO().getPaymentWayCd()); // PG코드(내부)
                    payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    payResult.setPaymentAmt(Long.toString(po.getPaymentAmt())); // 결제금액
                    if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) { // 회원번호
                        payResult.setMemberNo(Long.toString(SessionDetailHelper.getDetails().getSession().getMemberNo()));
                    }
                    payResult.setBankCd(request.getParameter("bankCd")); // 은행코드
                    payResult.setActNo(request.getParameter("depositActNo")); // 계좌번호
                    payResult.setHolderNm(request.getParameter("depositHolderNm")); // 예금주명
                    payResult.setDpsterNm(request.getParameter("ordrNm")); // 입금자명
                    payResult.setDpstScdDt((DateUtil.addDays(DateUtil.getNowDate(), 5)) + "235959"); // 입금예정일자(5일)
                    payResult.setRegrNo(po.getRegrNo()); // 등록자
                    payResult.setRegDttm(po.getRegDttm()); // 등록일자
                }

                // 무통장 주문이 아니고 외부결제수단(PG)을 사용했을 경우
                if (!standBydeposit) {
                    if (CoreConstants.PG_CD_PAYCO.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_PAYPAL.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_ALIPAY.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_TENPAY.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_WECH.equals(po.getOrderPayPO().getPaymentPgCd())
                        ) {
                        // PAYCO,PAYPAL,ALIPAY,TENPAY,WECHPAY
                        // insertOrderPay를 위한 payResult맵핑
                         payResult.setPaymentPgCd(po.getOrderPayPO().getPaymentPgCd()); // 결제PG코드
                         payResult.setPaymentWayCd(po.getOrderPayPO().getPaymentWayCd());// 결제수단코드
                         payResult.setPaymentStatusCd("02"); // 결제상태코드 01: 접수, 02: 완료, 03: 취소

                         payResult.setPaymentCmpltDttm(po.getOrderPayPO().getConfirmDttm());// 결제 완료 일시 값이 들어가야한다.
                         payResult.setPaymentAmt(String.valueOf(po.getOrderPayPO().getPaymentAmt())); // 상품가격
                         payResult.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo())); // 회원 번호

                         po.getOrderPayPO().setTxNo(request.getParameter("txNo")); // 거래번호(paypal은  mid로  사용)
                         po.getOrderPayPO().setConfirmNo(request.getParameter("confirmNo")); // 승인번호(paypal은 tid로 사용)

                         payResult.setTxNo(po.getOrderPayPO().getTxNo());
                         payResult.setConfirmDttm(po.getOrderPayPO().getConfirmDttm());// 승인 일시
                         payResult.setConfirmResultCd(po.getOrderPayPO().getConfirmResultCd());// 승인 결과 코드
                         payResult.setConfirmResultMsg(po.getOrderPayPO().getConfirmResultMsg()); // 승인 결과 메세지

                        // 페이코는 인증과 승인이 분리되어있기때문에 pgPayment를 사용한다.
                        if (CoreConstants.PG_CD_PAYCO.equals(po.getOrderPayPO().getPaymentPgCd())) {
                            log.debug("=== orderPO.orderPayPO : {}", po.getOrderPayPO());
                            payResult = paymentService.pgPayment(po.getOrderPayPO(), reqMap, mav).getData();
                        }

                    } else {
                        log.debug("=== orderPO.orderPayPO : {}", po.getOrderPayPO());
                        payResult = paymentService.pgPayment(po.getOrderPayPO(), reqMap, mav).getData();
                        // payResult.setPaymentNo(DateUtil.getNowDate() +ordNo);
                    }
                    // 중복매핑되는 변수들은 if else 밖에둔다
                    log.debug("=== orderPO : {}", po);
                    log.debug("=== payResult : {}", payResult);
                    payResult.setSiteNo(po.getSiteNo());
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentStatusCd("02"); // 상태코드(완료)
                    payResult.setSiteNo(po.getSiteNo());
                    payResult.setRegrNo(po.getRegrNo());
                    payResult.setRegDttm(po.getRegDttm());
                }
            } else {
                paymentByMileage = true;
            }
        } catch (Exception e) {
            log.error("PG PAYMENT ERROR : {}", e);
            ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
            err_result.setMessage("PG 통신중 오류가 발생하였습니다.");
            err_result.setSuccess(false);
            return err_result;
        }

        try {
            log.debug("======== payResult.getConfirmResultCd() : {}", payResult.getConfirmResultCd());
            if (paymentByMileage || standBydeposit || (!standBydeposit && ("00".equals(payResult.getConfirmResultCd()) || "0000".equals(payResult.getConfirmResultCd())))) {
                // step02.결제정보 등록 Biz실행(PG)
                if (!paymentByMileage) {
                    payResult.setConfirmResultCd("00");
                    payResult.setPaymentTurn("1");
                    // 가상계좌일경우 입금자명에 주문자명 세팅
                    if ("22".equals(payResult.getPaymentWayCd())) {
                        payResult.setDpsterNm("");
                        payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    }
                    this.insertOrderPay(payResult);
                }

                // step03.결제정보 등록 Biz실행(마켓포인트)
                if (po.getMileageTotalAmt() > 0) {
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentPgCd("00"); // PG코드(내부)
                    payResult.setPaymentWayCd("01"); // 결제 수단 코드(마켓포인트)
                    if (standBydeposit) {
                        payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    } else {
                        payResult.setPaymentStatusCd("02"); // 상태코드(완료)
                    }
                    payResult.setPaymentAmt(Long.toString(po.getMileageTotalAmt())); // 결제금액
                    payResult.setRegrNo(po.getRegrNo()); // 등록자
                    payResult.setRegDttm(po.getRegDttm()); // 등록일자
                    this.insertOrderPay(payResult);

                    // 마켓포인트 사용 정보 등록
                    SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
                    savedmnPointPO.setSiteNo(po.getSiteNo());
                    savedmnPointPO.setOrdNo(Long.toString(po.getOrdNo()));
                    savedmnPointPO.setGbCd("20"); // 차감
                    savedmnPointPO.setOrdCanselYn("N"); // 일반차감
                    savedmnPointPO.setMemberNo(po.getRegrNo()); // 회원번호
                    savedmnPointPO.setTypeCd("M"); // 유형코드(A:자동, M:수동)
                    savedmnPointPO.setReasonCd("03"); // 사유코드(상품구매)
                    savedmnPointPO.setEtcReason(""); // 기타사유
                    savedmnPointPO.setDeductGbCd("01"); // 차감구분코드(사용)
                    savedmnPointPO.setPrcAmt(Long.toString(po.getMileageTotalAmt()));

                    //적립금 분할을 위한 주문 상품 내역 세팅..
                    savedmnPointPO.setOrderGoodsPO(po.getOrderGoodsPO());

                    savedMnPointService.insertSavedMn(savedmnPointPO);
                }



                // step04.쿠폰정보 등록
                String couponUseInfo = "";
                couponUseInfo = request.getParameter("couponUseInfo");
                List<CouponPO> couponList = new ArrayList<>();

                log.debug("===couponUseInfo : {}", couponUseInfo);
                if (!"".equals(couponUseInfo) && couponUseInfo != null) {
                    String couponArr[] = couponUseInfo.split("\\▦");
                    for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
                        OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(i);
                        if ("N".equals(orderGoodsPO.getAddOptYn())) {
                            for (int k = 0; k < couponArr.length; k++) {
                                // 0:아이템번호, 1:회원쿠폰번호, 2:쿠폰번호, 3:할인금액
                                String couponInfoArr[] = couponArr[k].split("\\^");
                                if (couponInfoArr[0].equals(orderGoodsPO.getItemNo())) {
                                    CouponPO couponPO = new CouponPO();
                                    couponPO.setSiteNo(po.getSiteNo());
                                    couponPO.setMemberCpNo(Integer.parseInt(couponInfoArr[1]));
                                    couponPO.setOrdNo(orderGoodsPO.getOrdNo());
                                    couponPO.setOrdDtlSeq(orderGoodsPO.getOrdDtlSeq());
                                    couponPO.setCpUseAmt(Long.parseLong(couponInfoArr[3]));
                                    couponPO.setCpKindCd("01");
                                    couponPO.setRegrNo(orderGoodsPO.getRegrNo());
                                    couponPO.setRegDttm(orderGoodsPO.getRegDttm());
                                    couponPO.setUseYn("Y");
                                    couponPO.setUseDttm(orderGoodsPO.getRegDttm());
                                    couponPO.setCouponNo(Integer.parseInt(couponInfoArr[2]));
                                    couponList.add(couponPO);
                                }
                            }
                        }
                    }
                    this.insertCouponUse(couponList);

                    // 회원 쿠폰 사용 정보 등록
                    couponService.updateMemberUseCoupon(couponList);

                }

                String cashRctYn = request.getParameter("cashRctYn"); // N:발급안함, Y:현금영수증, B:계산서
                log.debug("===cashRctYn : {}", cashRctYn);
                if ("Y".equals(cashRctYn)) { // 현금영수증
                    if ("Y".equals(payResult.getCashRctYn())) {
                        log.debug("=== 현금영수증 발행 ===");
                        SalesProofPO cashPO = new SalesProofPO();
                        cashPO.setOrdNo(po.getOrdNo());
                        cashPO.setCashRctStatusCd("02"); // 상태코드(01:접수,02:승인,03:오류)
                        cashPO.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자, 02:관리자)
                        cashPO.setMemberNo(po.getRegrNo());
                        cashPO.setUseGbCd(payResult.getUseGbCd()); // 사용구분코드(01:소득공제,02:지출증빙)
                        cashPO.setIssueWayCd(payResult.getIssueWayCd()); // 발급수단코드(01:주민등록번호,02:휴대폰,03:사업자등록번호)
                        cashPO.setIssueWayNo(payResult.getIssueWayNo()); // 발급수단번호
                        cashPO.setTotAmt(po.getPaymentAmt()); // 총금액
                        cashPO.setAcceptDttm(po.getRegDttm()); // 접수일시
                        cashPO.setLinkTxNo(payResult.getLinkTxNo());
                        cashPO.setApplicantNm(po.getOrderInfoPO().getOrdrNm()); // 신청자명
                        cashPO.setRegrNo(po.getRegrNo()); // 등록자
                        cashPO.setRegDttm(po.getRegDttm()); // 등록일자
                        salesProofService.insertCashRct(cashPO);
                    }
                } else if ("B".equals(cashRctYn)) { // 계산서
                    log.debug("=== 계산서 발행 ===");
                    SalesProofPO billPO = new SalesProofPO();
                    billPO.setOrdNo(po.getOrdNo());
                    billPO.setTaxBillStatusCd("01"); // 상태코드(01:접수,02:승인,03:오류)
                    billPO.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자, 02:관리자)
                    billPO.setMemberNo(po.getRegrNo());
                    billPO.setCompanyNm(request.getParameter("billCompanyNm")); // 업체명
                    billPO.setBizNo(request.getParameter("billBizNo")); // 사업자번호
                    billPO.setCeoNm(request.getParameter("billCeoNm")); // 대표자명
                    billPO.setBsnsCdts(request.getParameter("billBsnsCdts")); // 업태
                    billPO.setItem(request.getParameter("billItem")); // 종목
                    billPO.setPostNo(request.getParameter("billPostNo")); // 우편번호
                    billPO.setRoadnmAddr(request.getParameter("billRoadnmAddr")); // 도로명
                                                                                  // 주소
                    billPO.setDtlAddr(request.getParameter("billDtlAddr")); // 상세주소
                    billPO.setTotAmt(po.getPaymentAmt() + po.getMileageTotalAmt()); // 총금액
                    billPO.setManagerNm(request.getParameter("billManagerNm")); // 담당자
                    billPO.setEmail(request.getParameter("billEmail")); // 이메일
                    billPO.setTelNo(request.getParameter("billTelNo")); // 연락처
                    billPO.setAcceptDttm(po.getRegDttm()); // 접수일시
                    billPO.setRegrNo(po.getRegrNo()); // 등록자
                    billPO.setRegDttm(po.getRegDttm()); // 등록일자
                    salesProofService.insertTaxBill(billPO);
                }

                // 무통장, 가상계좌가 아니거나 마켓포인트만으로 결제했을 경우 결제완료 처리
                if ((!standBydeposit && !"22".equals(po.getOrderPayPO().getPaymentWayCd())) || paymentByMileage) {
                    // step05.상품테이블 수정(재고변경)- 입금대기 주문의 경우 결제 완료시점에 재고 차감처리
                    this.updateGoodsStock(po.getOrderGoodsPO());
                    // step06.주문상태 수정
                    OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                    orderGoodsVO.setSiteNo(po.getSiteNo());
                    orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
                    orderGoodsVO.setOrdStatusCd("20"); // 결제완료
                    String curOrdStatusCd = "01"; // 주문접수(현재)
                    if (SessionDetailHelper.getDetails().isLogin()) {
                        orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    }else{
                        //비회원
                        orderGoodsVO.setRegrNo((long) 0.00);
                    }
                    this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);

                } else {
                    OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                    orderGoodsVO.setSiteNo(po.getSiteNo());
                    orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
                    orderGoodsVO.setOrdStatusCd("10"); // 주문완료(상태코드:입금확인중)
                    String curOrdStatusCd = "01"; // 주문접수
                    if (SessionDetailHelper.getDetails().isLogin()) {
                        orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    }else{
                        //비회원
                        orderGoodsVO.setRegrNo((long) 0.00);
                    }
                    this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);

                }

                // 장바구니 삭제
                int d = 0;
                List<String> itemNoList = new ArrayList();
                if (SessionDetailHelper.getDetails().isLogin()) { // 회원
                    long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
                    for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
                        OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(i);
                        if ("N".equals(orderGoodsPO.getAddOptYn())) {
                            itemNoList.add(orderGoodsPO.getItemNo());
                            d++;
                        }
                    }
                    String[] itemNoArr = itemNoList.toArray(new String[itemNoList.size()]);
                    BasketSO basketSO = new BasketSO();
                    basketSO.setSiteNo(po.getSiteNo());
                    basketSO.setItemNoArr(itemNoArr);
                    basketSO.setMemberNo(memberNo);
                    List<BasketVO> basketList = frontBasketService.selectBasketByItemNo(basketSO);
                    if (basketList != null && basketList.size() > 0) {
                        for (BasketVO basketVO : basketList) {
                            BasketPO deletePO = new BasketPO();
                            deletePO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                            deletePO.setMemberNo(memberNo);
                            deletePO.setBasketNo(basketVO.getBasketNo());
                            frontBasketService.deleteBasket(deletePO);
                        }
                    }
                } else { // 비회원
                    HttpSession session = request.getSession();
                    List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
                    if (basketSession != null && basketSession.size() > 0) {
                        for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
                            OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(i);
                            if ("N".equals(orderGoodsPO.getAddOptYn())) {
                                for (int k = 0; k < basketSession.size(); k++) {
                                    BasketPO sessionPO = basketSession.get(k);
                                    if (orderGoodsPO.getItemNo().equals(sessionPO.getItemNo())) {
                                        basketSession.remove(k);
                                    }
                                }
                            }
                        }
                    }
                    List<BasketPO> refreshBasketSession = (List<BasketPO>) session.getAttribute("basketSession");
                    if (refreshBasketSession != null && refreshBasketSession.size() == 0) {
                        session.removeAttribute("basketSession");
                    }
                }

                result.setSuccess(true);
            } else {
                // 결제 실패 처리(로그?)
                OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                orderGoodsVO.setSiteNo(po.getSiteNo());
                orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
                orderGoodsVO.setOrdStatusCd("22"); // 결제실패
                OrderGoodsVO curVo = selectCurOrdStatus(orderGoodsVO);
                String curOrdStatusCd = curVo.getOrdStatusCd(); // 현재 상태
                if (SessionDetailHelper.getDetails().isLogin()) {
                    orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                }else{
                    //비회원
                    orderGoodsVO.setRegrNo((long) 0.00);
                }
                this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);

                log.error("주문 결제 실패 에러[{}:{}]", payResult.getConfirmResultCd(), payResult.getConfirmResultMsg());
                ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                err_result.setMessage("PG결제에 실패하였습니다.");
                err_result.setSuccess(false);
                return err_result;
            }
            if(result.isSuccess()) {
                // 인터페이스 결제정보 등록 Biz실행(가맹점포인트)
                if (po.getPointTotalAmt() > 0) {
                    long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentPgCd("00"); // PG코드(내부)
                    payResult.setPaymentWayCd("02"); // 결제 수단 코드(가맹점포인트)
                    if (standBydeposit) {
                        payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    } else {
                        payResult.setPaymentStatusCd("02"); // 상태코드(완료)
                    }
                    payResult.setPaymentAmt(Long.toString(po.getPointTotalAmt())); // 결제금액
                    payResult.setRegrNo(po.getRegrNo()); // 등록자
                    payResult.setRegDttm(po.getRegDttm()); // 등록일자
                    this.insertOrderPay(payResult);

                    // 가맹점포인트 사용 정보 등록 (인터페이스)
                    // 인터페이스로 보유 포인트 차감
                    Map<String, Object> param = new HashMap<>();
                    param.put("memNo", memberNo);
                    param.put("useOffPointAmt", po.getPointTotalAmt());
                    param.put("orderNo", po.getOrdNo());
                    param.put("orderDate", po.getRegDttm());

                    String integrationMemberGbCd = SessionDetailHelper.getDetails().getSession().getIntegrationMemberGbCd();
                    if ("03".equals(integrationMemberGbCd)) {
                        ifMemOffPointUse(param); // interface_block_temp
                        /*Map<String, Object> point_res = InterfaceUtil.send("IF_MEM_018", param);
                        if ("1".equals(point_res.get("result"))) {
                            result.setSuccess(true);
                        }else{
                            throw new Exception(String.valueOf(point_res.get("message")));
                        }*/
                    }
                }
            }
        } catch (Exception e) {
            log.error("주문 결제 등록 에러 : {}", e.getMessage());
            log.error("==== 결제 롤백(취소) start");
            log.error("==== payResult.getPaymentPgCd : {}", payResult);
            if (!standBydeposit && !paymentByMileage) { // 무통장이 아니고 마켓포인트만으로 결제가
                                                        // 아닐때만
                payResult.setPartCancelYn("N"); // Y:부분취소, N:전체취소
                payResult = paymentService.pgPaymentCancel(payResult).getData();
            }

            // 주문상태 수정(실패)
            OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
            orderGoodsVO.setSiteNo(po.getSiteNo());
            orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
            orderGoodsVO.setOrdStatusCd("22"); // 결제실패
            String curOrdStatusCd = "01"; // 주문접수(현재)
            if (SessionDetailHelper.getDetails().isLogin()) {
                orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            }else{
                //비회원
                orderGoodsVO.setRegrNo((long) 0.00);
            }
            this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);
            log.error("==== 결제 롤백(취소) End ");
            ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
            err_result.setMessage("주문 결제 정보 등록중 오류가 발생하였습니다.");
            err_result.setSuccess(false);
            return err_result;
        }

        result.setSuccess(true);
        return result;
    }

    /**
     * 주문정보 등록
     * table : TO_ORD
     */
    @Override
    public ResultModel<OrderInfoPO> insertOrderInfo(OrderInfoPO po) throws Exception {
        ResultModel<OrderInfoPO> result = new ResultModel<>();
        // 주문정보 등록 Biz실행
        try {
            proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertOrderInfo", po);
        } catch (Exception e) {
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 주문 배송지정보 등록
     * table : TO_ORD
     */
    @Override
    public ResultModel<OrderInfoPO> insertOrderDelivery(OrderInfoPO po) throws Exception {
        ResultModel<OrderInfoPO> result = new ResultModel<>();
        // 주문 배송지 정보 등록 Biz실행
        try {
            proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertOrderDelivery", po);
        } catch (Exception e) {
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 주문상품정보 등록
     * table : TO_ORD_DTL
     */
    @Override
    public ResultModel<OrderGoodsPO> insertOrderGoods(List<OrderGoodsPO> poList) throws Exception {
        ResultModel<OrderGoodsPO> result = new ResultModel<>();
        // 상품정보 등록 Biz실행
        try {
            for (OrderGoodsPO po : poList) {
                proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertOrderGoods", po);
            }
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 배송비 정보 등록
     * table : TO_DLVR
     */
    @Override
    public ResultModel<OrderGoodsPO> insertDlvrc(List<OrderGoodsPO> poList) throws Exception {
        ResultModel<OrderGoodsPO> result = new ResultModel<>();
        // 배송비 정보 등록 Biz실행
        try {
            for (OrderGoodsPO po : poList) {
                if ("N".equals(po.getAddOptYn())) {
                    proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertDlvrc", po);
                }
            }
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 결제 정보 등록
     * table : TO_PAYMENT
     */
    @Override
    public ResultModel<PaymentModel<?>> insertOrderPay(PaymentModel po) throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();
        // 결제 정보 등록 Biz실행
        try {
            proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertOrderPay", po);
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 부가비용 정보 등록
     * table : TO_ADDED_AMOUNT
     */
    @Override
    public ResultModel<OrderGoodsPO> insertAddedAmount(List<OrderGoodsPO> poList) throws Exception {
        ResultModel<OrderGoodsPO> result = new ResultModel<>();
        // 부가 비용 정보 등록 Biz실행
        try {
            for (OrderGoodsPO po : poList) {
                if ("N".equals(po.getAddOptYn())) {
                    if (po.getAddedAmountList() != null & po.getAddedAmountList().size() > 0) {
                        for (OrderGoodsPO addedPO : po.getAddedAmountList()) {
                            proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertAddedAmount", addedPO);
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 주문 사은품 정보 등록
     * table : TO_ORD_FREEBIE
     */
    @Override
    public ResultModel<OrderGoodsPO> insertFreebie(List<OrderGoodsPO> poList) throws Exception {
        ResultModel<OrderGoodsPO> result = new ResultModel<>();
        // 주문 사은품 정보 등록 Biz실행
        try {
            for (OrderGoodsPO po : poList) {
                if ("N".equals(po.getAddOptYn())) {
                    if (po.getFreebieList() != null & po.getFreebieList().size() > 0) {
                        for (OrderGoodsPO freebiePO : po.getFreebieList()) {
                            proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertFreebie", freebiePO);
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 쿠폰 사용 정보 등록
     * table : TO_COUPON_USE
     */
    @Override
    public ResultModel<CouponPO> insertCouponUse(List<CouponPO> poList) throws Exception {
        ResultModel<CouponPO> result = new ResultModel<>();
        // 쿠폰 사용 정보 등록 Biz실행
        try {
            for (CouponPO po : poList) {
                proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertCouponUse", po);
            }
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 상품 구매 재고 수정
     */
    @Override
    public void updateGoodsStock(List<OrderGoodsPO> poList) throws Exception {
        try {
            if (poList != null && poList.size() > 0) {
                for (OrderGoodsPO po : poList) {
                    if ("N".equals(po.getAddOptYn())) {
                        proxyDao.update(MapperConstants.ORDER_MANAGE + "updateGoodsStock", po);
                    }
                }
            }
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
    }

    /**
     * 주문 취소 프로세스
     * STEP. 1 파라미터 확인, 금액확인
     * STEP. 2 현재 주문상태 검증 및 메일VO set
     * STEP. 3 결제 정보 확인 (마켓포인트 제외한 결제수단 확인)
     * STEP. 4 데이터 취소 처리
     * STEP. 4-1 환불, 취소정보 상태 상세 업데이트
     * STEP. 4-2 상품재고 처리
     * STEP. 4-3 배송비0원 처리
     * STEP. 4-4 배송 정보 등록
     * STEP. 4-5 배송 정보 등록 기 취소된 배송정보 등록
     * STEP. 4-6 마켓포인트 사용 정보 복원
     * STEP. 4-7 남은 마켓포인트 등록
     * STEP. 4-8 현금 환불 정보 등록/수정
     * STEP. 4-9 주문 마스터 정보 금액 업데이트
     * STEP. 5-1 PG 취소처리
     * STEP. 5-2 결제 정보 처리 PG 취소시 처리 및 현금영수증 취소 처리
     * STEP. 6 SMS, EMAIL 처리
     */
    @Override
    public ResultModel<OrderPayPO> cancelOrder(OrderPO po) throws CustomException {
        ResultModel<OrderPayPO> result = new ResultModel<>();

        log.debug("/** STEP. 1 파라미터 확인, 금액확인 *******************************************************/ {}",po);
        // 프론트/관리자 분기 처리

        log.debug("ordNo ::::::::::::::::: " + po.getOrdNo());
        log.debug("pgType ::::::::::::::::: " + po.getPgType());
        log.debug("pgAmt ::::::::::::::::: " + po.getPgAmt());
        log.debug("orgPgAmt ::::::::::::::::: " + po.getOrgPgAmt());
        log.debug("refundAmt ::::::::::::::::: " + po.getRefundAmt());
        log.debug("payReserveAmt ::::::::::::::::: " + po.getPayReserveAmt());
        log.debug("bankCd ::::::::::::::::: " + po.getBankCd());
        log.debug("actNo ::::::::::::::::: " + po.getActNo());
        log.debug("holderNm ::::::::::::::::: " + po.getHolderNm());
        log.debug("partCancelYn ::::::::::::::::: " + po.getPartCancelYn());
        log.debug("siteNo :::::::::::::: " + po.getSiteNo());
        log.debug("restAmt :::::::::::::: " + po.getRestAmt());
        log.debug("orgReserveAmt :::::::::::::: " + po.getOrgReserveAmt());
        log.debug("cancelType :::::::::::::: " + po.getCancelType());
        log.debug("claimReasonCd :::::::::::::: " + po.getClaimReasonCd());
        log.debug("getClaimMemo :::::::::::::: " + po.getClaimMemo());

        String strOrdNo = Long.toString(po.getOrdNo());
        long longOrdNo = po.getOrdNo();
        long longSiteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        String cancelType = po.getCancelType(); // 01:프론트, 02:관리자
        String partCancelYn = po.getPartCancelYn(); // Y:부분취소, N:전체취소
        String fm_sRsvNo = po.getRsvNo();//결제시 예약된 정보 번호
        Date today = new Date();

        long pgAmt = 0; // 마켓포인트 제외한 금액
        long payReserveAmt = 0; // 마켓포인트 금액
        long orgReserveAmt = 0; // 마켓포인트 원 결제금액
        long restAmt = 0; // 취소 후 남은 금액
        long refundAmt = 0; // 환불 금액
        long orgPgAmt = 0;
        int dlvrSeq = 0; // 묶음배송 번호
        String strOrdStatusCd = po.getCancelStatusCd();

        long longMemberNo = 0;
        if (SessionDetailHelper.getDetails().isLogin()) {
            longMemberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        }

        // 결제 금액 확인 ( pg, 무통장, 가상계좌, 마켓포인트 등 )
        ClaimSO claimSO = new ClaimSO();
        claimSO.setOrdNo(strOrdNo);
        claimSO.setOrdDtlSeqArr(po.getOrdDtlSeqArr());
        claimSO.setClaimQttArr(po.getClaimQttArr());

        log.debug("claimSO :::::::::::::::::::: " + claimSO);
        log.debug("프론트, 주문취소 데이터 확인 ");
        ResultModel<ClaimVO> claimVO = null;
        try {
            claimVO = refundService.selectOrdDtlPayPartCancelInfo(claimSO);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomException("biz.exception.common.error");
        }
        log.debug("strOrdStatusCd :::::::::::::::::::: " + strOrdStatusCd);
        log.debug("claimVO :::::::::::::::::::: " + claimVO);
        if(claimVO.getData().getClaimPayRefundVO()!=null) {
            // pg 금액
            if (claimVO.getData().getClaimPayRefundVO().getPayPgAmt() > 0) {
                pgAmt = claimVO.getData().getClaimPayRefundVO().getPayPgAmt();
                orgPgAmt = pgAmt;
            }
            // 무통장 금액
            if (claimVO.getData().getClaimPayRefundVO().getPayUnpgAmt() > 0) {
                pgAmt = claimVO.getData().getClaimPayRefundVO().getPayUnpgAmt();//가상계좌일경우 결제 금액
                orgPgAmt = pgAmt;
            }
            // 마켓포인트 금액
            payReserveAmt = claimVO.getData().getClaimPayRefundVO().getPayReserveAmt();
            orgReserveAmt = payReserveAmt;
            // 취소 후 남은 금액
            restAmt = claimVO.getData().getClaimPayRefundVO().getRestAmt();
            // 환불 금액(취소 금액)
            refundAmt = pgAmt + orgReserveAmt - restAmt;

            fm_sRsvNo = claimVO.getData().getClaimPayRefundVO().getRsvNo();
        }
        if (cancelType.equals("01")) {
            // 프론트, 주문취소, 환불취소
            if (pgAmt < refundAmt) {
                payReserveAmt = refundAmt - pgAmt;
            } else if (pgAmt == refundAmt) {
                payReserveAmt = 0;
            } else {
                pgAmt = refundAmt;
                payReserveAmt = 0;
            }
        } else if (cancelType.equals("02")) {
            if (pgAmt < refundAmt) {
                payReserveAmt = refundAmt - pgAmt;
            } else if (pgAmt == refundAmt) {
                payReserveAmt = 0;
            } else {
                pgAmt = refundAmt;
                payReserveAmt = 0;
            }
            // 관리자
            // pg 금액
            //결제취소가 아닐경우엔 받은값으로 세팅.....
            if(!strOrdStatusCd.equals("21")){
                pgAmt = po.getPgAmt();
            }
            if (refundAmt < pgAmt) { // 총 취소 할 금액이 PG금액보다 작을때
                // 원 pg금액
                orgPgAmt = po.getOrgPgAmt();
            } else { // 총 취소 할 금액이 PG 금액과 같거나 클때
                orgPgAmt = pgAmt;
            }
            // 마켓포인트 금액
            payReserveAmt = po.getPayReserveAmt();
            // 원 마켓포인트 금액
            orgReserveAmt = po.getOrgReserveAmt();
            // 취소 후 남은 금액
            restAmt = po.getRestAmt();
            // 환불 금액(취소 금액)
            refundAmt = po.getRefundAmt();

        } else if (cancelType.equals("03")) {
            /**
             * 2023-06-04 210
             * 기존 결제 한사람들 취소 때문에 이 로직은 다 바꾸진 못하고 기존거를 살리면서
             * 03 으로 넘어오면 다시 01(프론트) 로 변경한다 02는 어드민쪽인데 쓰는가 몰라서 놔둠
             * 03 으로 넘어왔을경우 orderController 에서 사용한포인트나 환불금액 차액등 을 미리 계산되서 넘어온걸로 셋팅해준다.
             * 결제 당시에 미리 셋팅해둔 값이 있기 때문에 위와 같은 절차가 필요없을거같다. 미리계산된 상품별 적립된포인트와 사용포인트가 있다.
             * 그래서 위와같이 머리아픈 계산은 필요없다. 정해진대로 취소시 미리 정해진 포인트로 처리 해주면되기 때문.
             * **/
            cancelType = "01";//다시 프론트용 으로 바꾼다 아랫쪽 외부취소모듈쪽에서 사용하기때문
            pgAmt = po.getPgAmt(); // 해당 상품(취소할 상품결제했을때 금액)을 결제할때 결제한금액(포인트를 해용햇다면 그것도 차감 쿠폰도 배송비도 같이 포함된급액이다)
            payReserveAmt = po.getPayReserveAmt(); // 부분취소시 취소상품에 분배된 디포인트
            orgReserveAmt = po.getOrgReserveAmt(); // 결제시 총 사용한 디 포인트
            restAmt = po.getRestAmt(); // 취소 후 남은 금액
            refundAmt = po.getRefundAmt(); // 환불 금액
            orgPgAmt = po.getOrgPgAmt();// 상품 결제시 전체 금액, 상품을두개 결제 했으면 전체의 금액

        } else {
            throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { strOrdNo });
        }

        log.debug("=================================== payReserveAmt : {}", payReserveAmt);
        log.debug("=================================== restAmt : {}", restAmt);
        log.debug("=================================== refundAmt : {}", refundAmt);
        log.debug("=================================== pgAmt : {}", pgAmt);

        log.debug("/** STEP. 2 현재 주문상태 검증 및 메일VO set ***********************************************/");
        OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
        orderGoodsVO.setSiteNo(po.getSiteNo());
        orderGoodsVO.setOrdNo(strOrdNo);
        OrderGoodsVO curVo = selectCurOrdStatus(orderGoodsVO);
        log.debug("curVo::::::::::::::::::::::::::::::"+curVo);
        // 현재상태 결제완료 확인
        // boolean currStatusFlag = false;
        // if
        // (OrdStatusConstants.PAY_DONE.equals(curVo.getOrdStatusCd())||OrdStatusConstants.ORD_DONE.equals(curVo.getOrdStatusCd()))
        // {
        // currStatusFlag = true;
        // }
        // if (!currStatusFlag) {
        // throw new CustomException("biz.exception.ord.failUpdateOrdStatus",
        // new Object[] { strOrdNo });
        // }

        log.debug("/** STEP. 3 결제 정보 확인 (마켓포인트 제외한 결제수단 확인) **************************************/");
        OrderInfoVO infoVo = new OrderInfoVO();
        infoVo.setOrdNo(strOrdNo);
        infoVo.setSiteNo(po.getSiteNo());
        infoVo.setPgType("Y"); // 마켓포인트 제외 결제수단 확인
        OrderPayVO payVo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdDtlPayInfo", infoVo);
        payVo.setPgType("N");
        log.debug("payVo::::::::::::::::::::::::::::::"+payVo);
        boolean standBydeposit = false;
        // 무통장,가상계좌라면
        log.debug("payVo.getPaymentWayCd() 결제 수단 코드 ::::::: " + payVo.getPaymentWayCd());
        if (CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd()) || CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS.equals(payVo.getPaymentWayCd())) {
            standBydeposit = true;
        }

        PaymentModel<?> payResult = new PaymentModel<>();
        payResult.setUpdrNo(po.getRegrNo());
        payResult.setAppLinkGbCd(payVo.getAppLinkGbCd());

        log.debug("/** STEP. 4 데이터 취소 처리 *************************************************************/");
        ClaimGoodsPO cpo = new ClaimGoodsPO();
        String ordDtlSeqArr[] = po.getOrdDtlSeqArr();
        String claimNoArr[] = po.getClaimNoArr();
        try {

            int idx = 0;
            HashMap<String, String> map = new HashMap<String, String>();
            cpo.setOrdNo(strOrdNo);
            log.debug("cpo.getOrdNo() ::::::::::: " + cpo.getOrdNo());

            List<CouponPO> couponList = new ArrayList<>();
            CouponPO couponPO = new CouponPO();
            couponPO.setSiteNo(longSiteNo);

            List<OrderGoodsPO> stockGoodsList = new ArrayList<>();
            OrderGoodsPO stockGoodsPO = new OrderGoodsPO();
            long areaDlvrAmt = 0;
            log.debug("/** 취소 리스트 처리 (-) ***************************************************************/");
            log.debug("/** 취소 주문 상품 조회 start */");

            cpo.setClaimReasonCd(po.getClaimReasonCd()); // 10:제품파손, 20:제품불일치, 30:사이즈안맞음, 90:기타
            //사용자 주문취소시...
            if(claimNoArr==null || claimNoArr.length==0){
                String claimNo = null;
                try {
                    claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
                cpo.setClaimNo(claimNo);
            }

            for (String ordDtlSeq : ordDtlSeqArr) {
                log.debug("idx ::::::::::::::::::::::::::::::: " + idx);
                if (!"".equals(ordDtlSeq)) {
                    dlvrSeq++; // 묶음배송 번호
                    cpo.setOrdDtlSeq(ordDtlSeq);

                    // 주문상태 정보
                    OrderGoodsVO statusVO = new OrderGoodsVO();
                    statusVO.setSiteNo(longSiteNo);
                    statusVO.setOrdNo(strOrdNo);
                    statusVO.setOrdDtlSeq(ordDtlSeq);

                    // 주문 단건 조회 ( 마켓포인트, 배송비 관련 등 )
                    OrderGoodsVO ogVO = selectOrdCancelDtlInfo(statusVO);
                    log.debug("ordDtlSeq {} {}",ordDtlSeq,strOrdNo);
                    log.debug("ogVOogVO {}",ogVO);

                    // 취소에 필요한 정보
                    statusVO.setOrdStatusCd(strOrdStatusCd); // 결제취소

                    log.debug("ogVO.getMemberCpNo() 회원쿠폰번호 ::::: " + ogVO.getMemberCpNo());

                    // 쿠폰 정보
                    /*
                    * 전체환불일경우 사용여부 N
                    * 부분반품일경우 되돌리지않음.
                    * */
                    if(ogVO.getClaimQtt() == ogVO.getOrdQtt()) {
                        if (ogVO.getMemberCpNo() > 0) {
                            couponPO.setMemberCpNo(ogVO.getMemberCpNo());// 회원쿠폰번호
                            // 쿠폰사용가능종료일자가 현재보다 과거이면 현재일자에서 + 3 day
                            couponPO.setOrderCancelYn("Y"); // 주문취소 구분
                            couponPO.setUseYn("N"); // 쿠폰사용유무
                            couponPO.setUseDttm(null); // 쿠폰사용일자
                            couponList.add(couponPO);
                        }
                    }else{
                        log.debug("부분반품일경우 쿠폰 안살려요~~~~~~");
                    }

                    log.debug("/** STEP. 취소배송비 처리 *******************************/");
                    stockGoodsPO.setGoodsNo(ogVO.getGoodsNo());
                    stockGoodsPO.setRealDlvrAmt(0);
                    stockGoodsPO.setAreaAddDlvrc(0);
                    stockGoodsPO.setSiteNo(longSiteNo);
                    stockGoodsPO.setOrdNo(longOrdNo);
                    log.debug("-주문 vo.getOrdDtlSeq() :::::::::::::::::::::: " + ogVO.getOrdDtlSeq());
                    stockGoodsPO.setOrdDtlSeq(Long.parseLong(ogVO.getOrdDtlSeq()));
                    stockGoodsPO.setOrgDlvrAmt(ogVO.getOrgDlvrAmt());
                    stockGoodsPO.setDlvrQtt(ogVO.getDlvrQtt());
                    stockGoodsPO.setDlvrMsg(ogVO.getDlvrMsg());
                    stockGoodsPO.setDlvrPrcTypeCd(ogVO.getDlvrPrcTypeCd());
                    stockGoodsPO.setDlvrcPaymentCd(ogVO.getDlvrcPaymentCd());
                    stockGoodsPO.setDlvrSetCd(ogVO.getDlvrSetCd());
                    stockGoodsPO.setDlvrcPaymentCd(ogVO.getDlvrcPaymentCd());
                    stockGoodsPO.setAddOptYn(ogVO.getAddOptYn());
                    stockGoodsPO.setDlvrMsg(ogVO.getDlvrMsg());
                    stockGoodsPO.setDlvrQtt((int) ogVO.getOrdQtt());
                    stockGoodsPO.setDlvrSeq(dlvrSeq);
                    stockGoodsPO.setRegrNo(longMemberNo);
                    stockGoodsPO.setRegDttm(today);
                    stockGoodsPO.setSaleAmt(ogVO.getSaleAmt());
                    stockGoodsPO.setDcAmt(ogVO.getDcAmt());
                    stockGoodsPO.setGoodsDmoneyUseAmt(ogVO.getGoodsDmoneyUseAmt());
                    stockGoodsPO.setDlvrAmt(ogVO.getDlvrAmt());
                    stockGoodsPO.setGoodsSvmnAmt(ogVO.getPvdSvmn());//이컬럼이 좀 햇갈리는데 결재 할때 기존에 이렇게 써서 일단은 따른다
                    stockGoodsPO.setDlvrAddAmt(ogVO.getDlvrAddAmt());
                    log.debug("ogVO.getDlvrAddAmt() 지역 추가 배송비 ::::: " + ogVO.getDlvrAddAmt());
                    // 재고 정보
                    log.debug("ogVO.getItemNo() 단품번호 ::::: " + ogVO.getItemNo());
                    log.debug("ogVO.getOrdQtt() * (-1) 수량 ::::: " + ogVO.getOrdQtt() * (-1));
                    log.debug("ogVO.getClaimQtt() * (-1) 수량 ::::: " + ogVO.getClaimQtt() * (-1));
                    stockGoodsPO.setItemNo(ogVO.getItemNo());
                    stockGoodsPO.setOrdQtt(ogVO.getOrdQtt() * (-1));
                    stockGoodsPO.setClaimQtt(ogVO.getClaimQtt() * (-1));
                    stockGoodsList.add(stockGoodsPO);

                    // 주문상태 정보
                    log.debug("ogVO.getOrdStatusCd() ::::::::::::::::::::::: " + ogVO.getOrdDtlStatusCd());
                    // 지역배송비
                    if (Double.parseDouble(ogVO.getAreaAddDlvrc()) > 0) {
                        log.debug("지역배송비 :::::::::::: " + ogVO.getAreaAddDlvrc());
                        areaDlvrAmt = (long) Double.parseDouble(ogVO.getAreaAddDlvrc());
                    }
                    log.debug("/** STEP. 4-1 환불, 취소정보 상태 상세 업데이트 ******************************/");

                    //관리자 반품/환불 처리시...
                    if(claimNoArr!=null && claimNoArr.length>0){
                        cpo.setClaimNo(claimNoArr[idx]);
                        cpo.setClaimQtt(Integer.parseInt(po.getClaimQttArr()[idx]));
                    }

                    cpo.setSiteNo(longSiteNo);
                    cpo.setOrdNo(strOrdNo);
                    cpo.setOrdDtlSeq(ordDtlSeq);
                    cpo.setClaimReasonCd(po.getClaimReasonCd());
                    cpo.setClaimDtlReason(po.getClaimDtlReason());
                    cpo.setClaimMemo(po.getClaimMemo());
                    cpo.setOrdDtlStatusCd(strOrdStatusCd); // 주문 취소시 적용
                    cpo.setRegrNo(longMemberNo);
                    // 주문 상태 변경 ( 각 상태값 하드코딩 되어있음 )
                    try {
                        refundService.updateClaimRefund(cpo);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                }
                idx++;
            }
            log.debug("/** 취소 주문 상품 조회 end */");

            log.debug("/** STEP. 3-3 쿠폰 처리 */");
            // 쿠폰 원복 TC_MEMBER_CP
            // 회원 쿠폰 사용 정보 등록 TP_MEMBER_CP USE_YN = 'N'
            // USE_DTTM= null , CP_APPLY_END_DDTM + 3 DAY
            log.debug("쿠폰 처리 시작 ");
            boolean couponFlag = true;
            if (couponList == null || couponList.size() == 0) {
                couponFlag = false;
                log.debug("쿠폰 사용 안함 :::::::::::::  " + couponFlag);
            }
            if (couponFlag) {
                try {
                    couponService.updateMemberUseCoupon(couponList);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
            }
            log.debug("쿠폰 처리 완료 ");

            /** STEP. 4-2 상품 재고 처리 */
            log.debug("/** STEP. 4-2 상품재고 처리 **********************************************/");
            log.debug("상품 재고 처리 시작 ");
            try {
                if(!"11".equals(strOrdStatusCd)) {
                    //2023-06-05 210
                    //취소 상태가 주문취소일경우(가상계좌지만 돈이 아직 입금되지 않은 상태라 결제취소가 아니라 주문이 취소다) 결제할때 재고를 빼지 않기 때문에
                    //여기서도 재고를 다시 더해주지 않는다.
                    updateGoodsStock(stockGoodsList);
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new CustomException("biz.exception.common.error");
            }
            log.debug("상품 재고 처리 완료 ");

            /** STEP. 4-3 배송정보 등록 (취소 0원 처리) */
            if (partCancelYn.equals("Y") && restAmt > 0) {
                log.debug("/** STEP. 4-3 배송비0원 처리 **********************************************/");
                log.debug("취소주문 배송비 0원 처리 시작 ");
                try {
                    insertDlvrc(stockGoodsList);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
                log.debug("취소주문 배송비 0원 처리 완료 ");
            }

            log.debug("/** 취소 제외된 리스트 처리 ( +) *******************************************************/");
            log.debug("/** 취소 제외한 주문 상품 조회 START 재계산 배송비, 마켓포인트 */");

            List<OrderGoodsPO> goodsList = new ArrayList<>();
            List<OrderGoodsPO> goodsCancelList = new ArrayList<>(); // 이미 취소된 리스트(배송테이블 관련)
            OrderInfoVO oiv = new OrderInfoVO();
            oiv.setOrdNo(strOrdNo);

            // 재계산 판매가, 할인가
            long reSaleAmt = 0;
            long reDcAmt = 0;
            log.debug("partCancelYn ::::::::::::::::::::::::::::::::: "+partCancelYn);
            // 부분 취소일때 계산 ( 배송비, 마켓포인트 등 )
            if (partCancelYn.equals("Y")) {
                // 전체 주문상품 조회
                List<OrderGoodsVO> orderGoodsList = selectOrdCancelDtlList(oiv);

                // 선택된 상품제거
                for (int i = 0; i < po.getOrdDtlSeqArr().length; i++) {
                    String ordDtlSeq = po.getOrdDtlSeqArr()[i];
                    if (ordDtlSeq != null && !"".equals(ordDtlSeq)) {
                        for (int ov = 0; ov < orderGoodsList.size(); ov++) {
                            if (ordDtlSeq.equals(orderGoodsList.get(ov).getOrdDtlSeq())) {
                                orderGoodsList.remove(ov);
                            }
                        }
                    }
                }

                // 취소된 상품 제거 ( 과거 부분취소 제거 )
                // 11:주문취소, 21:결제취소, 66:교환완료, 74:환불완료
                for (int ov = 0; ov < orderGoodsList.size(); ov++) {
                    OrderGoodsVO cancelVO = orderGoodsList.get(ov);
                    if ((cancelVO.getOrdDtlStatusCd().equals("11") || cancelVO.getOrdDtlStatusCd().equals("21") || cancelVO.getOrdDtlStatusCd().equals("66")|| cancelVO.getOrdDtlStatusCd().equals("74"))) {
                        // 과거 취소된 배송비 List
                        OrderGoodsPO cancelPO = new OrderGoodsPO();
                        dlvrSeq++;
                        cancelPO.setOrdNo(Long.parseLong(cancelVO.getOrdNo()));
                        cancelPO.setOrdDtlSeq(Long.parseLong(cancelVO.getOrdDtlSeq()));
                        cancelPO.setOrgDlvrAmt(cancelVO.getOrgDlvrAmt());
                        cancelPO.setDlvrQtt((int) cancelVO.getOrdQtt());
                        cancelPO.setDlvrMsg(cancelVO.getDlvrMsg());
                        cancelPO.setDlvrPrcTypeCd(cancelVO.getDlvrPrcTypeCd());
                        cancelPO.setDlvrcPaymentCd(cancelVO.getDlvrcPaymentCd());
                        cancelPO.setDlvrSetCd(cancelVO.getDlvrSetCd());
                        cancelPO.setDlvrcPaymentCd(cancelVO.getDlvrcPaymentCd());
                        cancelPO.setAddOptYn(cancelVO.getAddOptYn());
                        cancelPO.setSiteNo(longSiteNo);
                        cancelPO.setDlvrSeq(dlvrSeq);
                        cancelPO.setRegrNo(longMemberNo);
                        cancelPO.setRegDttm(today);
                        goodsCancelList.add(cancelPO);
                        orderGoodsList.remove(ov);
                    }
                }

                // 재주문된 상품에 대해 배송비 재계산
                String grpCd = "";
                String preGrpCd = "";
                boolean areaDlvrApplyYn = false; // 지역추가배송비 적용 여부
                long rePayAmt = 0; // 프론트용 재결제금액
                int i = 0;
                Map mapGoods = null;
                try {
                    mapGoods = calcDlvrAmt(orderGoodsList, "order");
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
                log.debug("배송비 재계산 1 dlvrPriceMap" + mapGoods.get("dlvrPriceMap"));
                Map<String, Long> dlvrPriceMap = (Map<String, Long>) mapGoods.get("dlvrPriceMap");

                if (orderGoodsList != null && orderGoodsList.size() > 0) {
                    for (OrderGoodsVO vo : orderGoodsList) {
                        OrderGoodsPO goodsPO = new OrderGoodsPO();
                        /***** 배송비 설정 *****/
                        if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                            grpCd = vo.getSellerNo()+"**"+vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                        } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                            grpCd = vo.getSellerNo()+"**"+vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                        } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 포장단위별 || "04".equals(vo.getDlvrcPaymentCd())
                            grpCd = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                        } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {  //상품별배송비(조건부무료)  선불 || "04".equals(vo.getDlvrcPaymentCd())
                            grpCd = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                        } else {
                            grpCd = vo.getItemNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                        }

                        log.debug("배송비 계산 grpCd ::::::::::::: " + grpCd);
                        log.debug("배송비 계산 preGrpCd :::::::::: " + preGrpCd);
                        log.debug("배송비 계산 dlvrPriceMap.get(grpCd) ::::::::: " + dlvrPriceMap.get(grpCd));

                        // 배송비 재계산
                        if (grpCd.equals(preGrpCd) || dlvrPriceMap.get(grpCd) == null) {
                            goodsPO.setRealDlvrAmt(0);
                        } else {
                            log.debug("배송비 계산 14 " + dlvrPriceMap.get(grpCd));
                            dlvrSeq++;
                            // vo.setRealDlvrAmt(Long.toString(dlvrPriceMap.get(grpCd)));
                            goodsPO.setRealDlvrAmt(dlvrPriceMap.get(grpCd));
                        }

                        log.debug("배송비 계산 15 " + vo.getRealDlvrAmt());

                        goodsPO.setDlvrSeq(dlvrSeq);
                        if (areaDlvrAmt > 0 && !areaDlvrApplyYn) {
                            if (!"04".equals(vo.getDlvrcPaymentCd())) {
                                areaDlvrApplyYn = true;
                                goodsPO.setAreaAddDlvrc(areaDlvrAmt);
                            } else {
                                goodsPO.setAreaAddDlvrc(0);
                            }
                        } else {
                            goodsPO.setAreaAddDlvrc((long) Double.parseDouble(vo.getAreaAddDlvrc()));
                        }
                        log.debug("배송비 계산 2 " + Long.parseLong(vo.getOrdNo()));
                        log.debug("배송비 계산 3 " + Long.parseLong(vo.getOrdDtlSeq()));
                        goodsPO.setSiteNo(longSiteNo);
                        goodsPO.setOrdNo(Long.parseLong(vo.getOrdNo()));
                        goodsPO.setOrdDtlSeq(Long.parseLong(vo.getOrdDtlSeq()));

                        log.debug("vo.getGoodsSvmnPolicyUseYn() " + vo.getGoodsSvmnPolicyUseYn());
                        // 마켓포인트정보, 배송비정보
                        goodsPO.setGoodsSvmnPolicyUseYn(vo.getGoodsSvmnPolicyUseYn());
                        goodsPO.setGoodsSvmnAmt(vo.getGoodsSvmnAmt());
                        goodsPO.setAddOptYn(vo.getAddOptYn()); // N 고정

                        goodsPO.setOrgDlvrAmt(vo.getOrgDlvrAmt());
                        goodsPO.setDlvrQtt((int) vo.getOrdQtt());
                        goodsPO.setDlvrMsg(vo.getDlvrMsg());
                        goodsPO.setDlvrPrcTypeCd(vo.getDlvrPrcTypeCd());
                        goodsPO.setDlvrcPaymentCd(vo.getDlvrcPaymentCd());
                        goodsPO.setDlvrSetCd(vo.getDlvrSetCd());
                        goodsPO.setDlvrcPaymentCd(vo.getDlvrcPaymentCd());
                        goodsPO.setRegrNo(longMemberNo);
                        goodsPO.setRegDttm(today);
                        goodsList.add(goodsPO);

                        rePayAmt += (vo.getSaleAmt() * vo.getOrdQtt()) - vo.getDcAmt();
                        reSaleAmt += rePayAmt;
                        reDcAmt += vo.getDcAmt();

                        i++;
                    }
                }
            }
            log.debug("goodsList ::::::::::::::::::::::::::::::::: "+goodsList);
            // 마켓포인트부여 원복 TC_MEMBER_SVMN_USE, TO_MEMBER_SVMN_PVD
            long svmnAmt = 0;
            // 부분 취소일때 실행 전체취소는 필요없음
            if (goodsList != null && goodsList.size() > 0) {
                if (partCancelYn.equals("Y") && restAmt > 0) {
                    try {
                    log.debug("##### 마켓포인트 부여처리 및 배송정보 등록 처리 시작 ");
                    /** STEP. 3-5 마켓포인트 처리 ( 주문마스터에 업데이트 svmnAmt) */
                        svmnAmt = this.calcSvmnAmt(goodsList);

                    log.debug("마켓포인트 업데이트 할 금액 재계산 ::: " + svmnAmt);

                    log.debug("/** STEP. 4-4 배송 정보 등록 **********************************/");
                    /** STEP. 4-4 배송정보 등록 */
                    //위쪽 배송비 계산부분은 잘못되엇다 어차피 결제할때 배송비계산을 바르게 하고넘어 오기때문에 취소제외한 상품의 배송비를 다시 인서트 할피요는없는데 왜이렇게 햇는건지 모르겟네;;
                    //2023-06-04 210
                    //this.insertDlvrc(goodsList);

                    /** STEP. 3-7 기 취소된 배송정보 등록 */
                    if (goodsCancelList != null && goodsCancelList.size() > 0) {
                        log.debug("/** STEP. 4-5 배송 정보 등록 기 취소된 배송정보 등록 ***************/");
                        //this.insertDlvrc(goodsCancelList);
                    }
                    log.debug("마켓포인트 부여처리 및 배송정보 등록 처리 끝 ");
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                }
            }

            // 마켓포인트 환불이 있을시
            /**
             * 2023-06-05 210
             * 취소 포인트 수정
             * **/
            if (payReserveAmt > 0) { // 포인트 결제가 있을 때만 포인트 취소
                OfflineMemberSO oso = new OfflineMemberSO();
                oso.setCustName(claimVO.getData().getClaimPayRefundVO().getOrdrNm());
                oso.setHp(claimVO.getData().getClaimPayRefundVO().getOrdrMobile().replace("-", ""));
                /*String fm_sCdCust = SessionDetailHelper.getDetails().getSession().getCdCust();
                String fm_sMallCard = SessionDetailHelper.getDetails().getSession().getMemberCardNo();
                String fm_sStrCode = SessionDetailHelper.getDetails().getSession().getStrCode();*/
                List<OfflineMemberVO>  offLineMembers =  erpMemberService.getOfflineMemberInfo(oso);
                log.debug("offLineMembers : {}",offLineMembers);
                if(offLineMembers.size() != 1){
                    throw new CustomException("다비젼 회원정보 오류입니다. 관리자에게 문의 부탁드립니다.");
                }
                MemberDPointCtVO memberDPointCtVO = new MemberDPointCtVO();
                memberDPointCtVO.setSubType(2);
                memberDPointCtVO.setCdCust(offLineMembers.get(0).getCdCust());
                memberDPointCtVO.setMemberCardNo(offLineMembers.get(0).getOfflineCardNo());
                memberDPointCtVO.setMemberNo(po.getRegrNo());
                memberDPointCtVO.setStrCode(offLineMembers.get(0).getStrCode());
                memberDPointCtVO.setOrderGoodsPOS(stockGoodsList);
                memberDPointCtVO.setOrdNo(po.getOrdNo());
                memberDPointCtVO.setPaymentWayCd(payVo.getPaymentWayCd());
                memberDPointCtVO.setOrdDtlSeqArr(po.getOrdDtlSeqArr());

                erpPointService.PaymentDPoint(memberDPointCtVO);//사용했던 포인트 돌려받기
            }
            /** 취소제외한 주문 END */

            log.debug("/** 단건 데이터 처리 ******************************************************************/");
            // 무통장, 가상계좌일때 처리, 주문완료(상태코드:입금확인중)(10) 상태이면 처리 안함
            if (standBydeposit && !OrdStatusConstants.ORD_DONE.equals(curVo.getOrdStatusCd())) {
                log.debug("/** STEP. 3-7 환불정보 등록 or 수정 */");
                ClaimPayRefundPO cprp = new ClaimPayRefundPO();
                // cprp.setCashRefundNo("현금환불번호");
                log.debug("결제번호 : " + payVo.getPaymentNo());
                log.debug("결제유형코드 : " + po.getRefundTypeCd());
                log.debug("환불상태코드 : " + po.getRefundStatusCd());
                log.debug("환불금액 : " + pgAmt);
                log.debug("환불메모 : " + po.getRefundMemo());
                log.debug("은행코드 : " + po.getBankCd());
                log.debug("계좌번호 : " + po.getActNo());
                log.debug("예금주 : " + po.getHolderNm());
                cprp.setPaymentNo(payVo.getPaymentNo());
                if (strOrdStatusCd.equals(OrdStatusConstants.PAY_CANCEL)) {
                    // 결제취소
                    cprp.setRefundTypeCd("01");
                } else {
                    // 환불
                    cprp.setRefundTypeCd("02");
                }
                cprp.setRefundStatusCd("03");
                cprp.setRefundAmt(Long.toString(pgAmt));
                cprp.setRefundMemo(po.getClaimDtlReason());
                cprp.setBankCd(po.getBankCd());
                cprp.setActNo(po.getActNo());
                cprp.setHolderNm(po.getHolderNm());
                cprp.setOrdNo(strOrdNo);
                cprp.setRegrNo(longMemberNo);
                log.debug("/** STEP. 4-8 현금 환불 정보 등록/수정 **************************/");
                try {
                    refundService.insertPaymerCashRefund(cprp);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
                log.debug("환불금액 등록 완료 ");
            }

            log.debug("/** STEP. 4-9 주문 마스터 정보 금액 업데이트 **********************/");
            log.debug("주문번호 : " + longOrdNo);
            log.debug("결제취소코드 : " + strOrdStatusCd);
            log.debug("취소하고 남은금액 : " + restAmt);
            log.debug("총환불금액 (취소금액) : " + refundAmt);
            log.debug("적립부여금액 : " + svmnAmt);

            OrderInfoPO infoPo = new OrderInfoPO();
            infoPo.setOrdNo(longOrdNo);

            // 부분취소일때만 금액 업데이트
            infoPo.setRegrNo(longMemberNo);
            infoPo.setSaleAmt(reSaleAmt);
            infoPo.setPaymentAmt(restAmt);
            infoPo.setPvdSvmn(svmnAmt);
            infoPo.setDcAmt(reDcAmt);
            infoPo.setPartCancelYn(partCancelYn); // 전체취소시에 쿼리에서 금액 업데이트 안되게처리

            if (partCancelYn.equals("Y")) {
                OrderSO orderSO = new OrderSO();
                orderSO.setSiteNo(po.getSiteNo());
                orderSO.setOrdNo(strOrdNo);
                orderSO.setOrdDtlSeqArr(po.getOrdDtlSeqArr());
                // 전체 취소 or 부분취소 마지막 취소일경우 취소 아닌 데이터 확인
                ResultModel<OrderVO> ordVO = partCancelStatusOrderCount(orderSO);
                int orderCnt = Integer.parseInt(ordVO.getData().getStatusOrderCount());
                log.debug("orderCnt : " + orderCnt);
                if (orderCnt == 0) {
                    infoPo.setOrdStatusCd(strOrdStatusCd);
                }
            } else {
                infoPo.setOrdStatusCd(strOrdStatusCd);
            }
            // 환불일때는 주문 마스터 상태 업데이트 안함
            if (strOrdStatusCd.equals(OrdStatusConstants.RETURN_DONE)) {
                infoPo.setOrdStatusCd("");
            }
            log.debug("partCancelYn :::::::::::::::::::::::::::::: " + infoPo.getPartCancelYn());

            try {
                updateOrderInfo(infoPo);
            } catch (Exception e) {
                e.printStackTrace();
                throw new CustomException("biz.exception.common.error");
            }
            log.debug("주문 마스터 금액 수정 완료 ");

            // 마켓포인트 단일 결제시
            if (payReserveAmt > 0 && pgAmt == 0) {
                log.debug("마켓포인트 단일 결제시 ( 결제 상태 변경 )");
                payResult.setRefundAmt(payReserveAmt);
                payResult.setRefundType("01");
                updatePaymentStatus(payResult);

                // 부분 취소일때 남은 금액 결제 재등록
                if (partCancelYn.equals("Y") && restAmt > 0) {
                    log.debug("부분 취소일때 남은 금액 결제 재등록");
                    // 마켓포인트 재등록
                    payResult.setOrdNo(longOrdNo);
                    payResult.setPaymentWayCd("01");
                    payResult.setPaymentAmt(Long.toString(orgReserveAmt - payReserveAmt));
                    try {
                        insertPartCancelOrderPay(payResult);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                }
            }

            // 무통장 + 마켓포인트 결제테이블 취소 업데이트
            if (standBydeposit && pgAmt > 0) {
                // 무통장 주문
                log.debug("무통장, 가상계좌 + 마켓포인트 결제시 or 무통장 가상계좌");
                // 결제정보 업데이트
                payResult.setOrdNo(payVo.getOrdNo());
                payResult.setPaymentTurn(payVo.getPaymentTurn());
                payResult.setConfirmResultCd("00");
                payResult.setPaymentStatusCd("03"); // 취소

                // 마켓포인트 환불금액이 있을시
                if (payReserveAmt > 0) {
                    log.debug("무통장, 가상계좌 + 마켓포인트 결제시 ( 결제 상태 변경 )");
                    payResult.setRefundAmt(payReserveAmt);
                    payResult.setRefundType("01");
                    updatePaymentStatus(payResult);
                }

                // 무통장, 가상계좌 환불금액이 있을시
                if (pgAmt > 0) {
                    log.debug("무통장 결제 취소상태 변경 ");
                    payResult.setRefundAmt(pgAmt);
                    payResult.setRefundType("02");
                    updatePaymentStatus(payResult);
                }

                // 부분 취소일때 남은 금액 결제 재등록
                if (partCancelYn.equals("Y") && restAmt > 0) {
                    log.debug("마켓포인트 결제시 부분취소일경우 남은 금액 결제테이블 등록 ");
                    payResult.setOrdNo(longOrdNo);
                    payResult.setPaymentWayCd("01");
                    payResult.setPaymentAmt(Long.toString(orgReserveAmt - payReserveAmt));
                    try {
                        insertPartCancelOrderPay(payResult);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }

                    log.debug("부분취소일경우 남은 금액 결제테이블 등록 ");
                    payResult.setOrdNo(longOrdNo);
                    payResult.setPaymentWayCd(payVo.getPaymentWayCd());
                    /*payResult.setPaymentAmt(Long.toString(orgPgAmt - pgAmt));*/
                    payResult.setPaymentAmt(Long.toString(restAmt));

                    try {
                        insertPartCancelOrderPay(payResult);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                }

            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "" }, e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        /**
         * 참고 부가비용 ( TO_ADDED_AMOUNT ) , 주문쿠폰 ( TO_COUPON_USE ) 업데이트 하지않음
         * TO_ORD_DTL 취소상태로 확인가능
         * 주문상세와 조인해서 데이터를 확인하기 때문에 따로 취소상태 관리 안함
         */
        try {
            /*if (!standBydeposit && pgAmt > 0) {*/
            if (!CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd()) && pgAmt > 0) {
            // 무통장 주문이 아니고 외부결제수단(PG)을 사용했을 경우
                log.debug("/*** STEP. 5-1 결제모듈 취소처리*****************************************************************/");

                // 간편결제(PAYCO), PAYPAL
                if (CoreConstants.PG_CD_PAYCO.equals(payVo.getPaymentPgCd())
                    || CoreConstants.PG_CD_PAYPAL.equals(payVo.getPaymentPgCd())
                    || CoreConstants.PG_CD_ALIPAY.equals(payVo.getPaymentPgCd())
                    || CoreConstants.PG_CD_TENPAY.equals(payVo.getPaymentPgCd())
                    || CoreConstants.PG_CD_WECH.equals(payVo.getPaymentPgCd())
                ) {
                    log.debug("/*** STEP. 5-1-1 간편결제(PAYCO), PAYPAL 취소처리*****************************************************************/");
                    // 결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우), 03.DMALL(BO일경우)
                    payResult.setMainCd("02".equals(cancelType) ? "03" : "01"); // cancelType => 01:프론트, 02:관리자
                    // SITE번호
                    payResult.setSiteNo(longSiteNo);
                    // PG 코드
                    payResult.setPaymentPgCd(payVo.getPaymentPgCd());
                    // PG 결제 상태 코드
                    payResult.setPaymentStatusCd(payVo.getPaymentStatusCd());
                    // 결제 수단 코드
                    payResult.setPaymentWayCd(payVo.getPaymentWayCd());
                    // 거래번호 ****
                    payResult.setTxNo(payVo.getTxNo());
                    // 승인번호
                    payResult.setConfirmNo(payVo.getConfirmNo());
                    // 승인일시
                    payResult.setConfirmDttm(payVo.getConfirmDttm());
                    // 카드사코드
                    payResult.setCardCd(payVo.getCardCd());
                    // 은행코드
                    payResult.setBankCd(payVo.getBankCd());
                    // 통신사코드
                    payResult.setTelecomCd(payVo.getTelecomCd());
                    // 부분취소확인
                    payResult.setPartCancelYn("N");
                    // 부분취소할금액
                    payResult.setPartCancelAmt(Long.toString(pgAmt));
                    // 부분취소후 남은금액
                    payResult.setPartCancelRemainAmt(Long.toString(restAmt));
                    payResult.setPaymentAmt(payVo.getPaymentAmt());
                    payResult.setOrdNo(payVo.getOrdNo());
                    payResult.setPaymentTurn(payVo.getPaymentTurn());
                    payResult = paymentService.pgPaymentCancel(payResult).getData();

                    // 그외 PG ( 이니시스, KCP, 올더게이트 등 )
                } else {
                    log.debug("/*** STEP. 5-1-2 PG 취소처리*****************************************************************/");
                    // 결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우),
                    // 03.BO일경우
                    payResult.setMainCd("02".equals(cancelType) ? "03" : "01"); // cancelType => 01:프론트, 02:관리자
                    // SITE번호
                    payResult.setSiteNo(longSiteNo);
                    // PG 코드
                    payResult.setPaymentPgCd(payVo.getPaymentPgCd());
                    // PG 결제 상태 코드
                    payResult.setPaymentStatusCd(payVo.getPaymentStatusCd());
                    // 결제 수단 코드
                    payResult.setPaymentWayCd(payVo.getPaymentWayCd());
                    // 거래번호 ****
                    payResult.setTxNo(payVo.getTxNo());
                    // 승인번호
                    payResult.setConfirmNo(payVo.getConfirmNo());
                    // 승인일시
                    payResult.setConfirmDttm(payVo.getConfirmDttm());
                    // 카드사코드
                    payResult.setCardCd(payVo.getCardCd());
                    // 은행코드
                    payResult.setBankCd(payVo.getBankCd());
                    // 통신사코드
                    payResult.setTelecomCd(payVo.getTelecomCd());
                    // 부분취소확인
                    payResult.setPartCancelYn(partCancelYn);
                    // 부분취소할 금액
                    payResult.setPartCancelAmt(Long.toString(pgAmt));
                    // 부분취소후 남은금액
                    payResult.setPartCancelRemainAmt(Long.toString(restAmt));
                    // 에스크로 여부
                    payResult.setEscrowYn(payVo.getEscrowYn());
                    // 주문 마스터 상태
                    payResult.setOrdStatusCd(curVo.getOrdStatusCd());
                    payResult.setPaymentAmt(payVo.getPaymentAmt());
                    payResult.setOrdNo(payVo.getOrdNo());
                    payResult.setPaymentTurn(payVo.getPaymentTurn());


                    //가상계좌 일경우 환불 계좌 정보 세팅...
                    if (CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS.equals(payVo.getPaymentWayCd())) {
                        payResult.setBankCd(po.getBankCd());
                        payResult.setActNo(po.getActNo());
                        payResult.setHolderNm(po.getHolderNm());
                    }

                    //PG취소처리 테스트시 강제로 성공 세팅..
                    //주문완료(상태코드:입금확인중)(10) 상태이면 처리 안함(가상계좌 주문취소시)
                    log.debug("OrdStatusConstants.ORD_DONE payResult::::::::::::::::::::::::::::::"+payResult);
                    if(!OrdStatusConstants.ORD_DONE.equals(curVo.getOrdStatusCd())) {
                        log.debug("OrdStatusConstants.ORD_DONE payResult::::::::::::::::::::::::::::::"+payResult);
                        payResult = paymentService.pgPaymentCancel(payResult).getData();
                    }
                    //payResult.setConfirmResultCd("0000");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            //throw new Exception("PG 통신 오류");
            throw new CustomException("biz.exception.common.error");
        }
        log.debug("payResult::::::::::::::::::::::::::::::"+payResult);
        // PG 성공 확인
        log.debug("/** STEP. 5-2 결제 정보 처리 PG 취소시 처리 */");
        //2023-06-07 210 포인트로만 결제시 성공으로보냄
        if (CoreConstants.PAYMENT_WAY_CD_SVMN.equals(payVo.getPaymentWayCd()) ||
            (CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS.equals(payVo.getPaymentWayCd())
                    && !OrdStatusConstants.ORD_DONE.equals(curVo.getOrdStatusCd())
                    && (("00".equals(payResult.getConfirmResultCd()) || "0000".equals(payResult.getConfirmResultCd()))))
            ||
            (!CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd())
                            && (("00".equals(payResult.getConfirmResultCd()) || "0000".equals(payResult.getConfirmResultCd()))))
        ) {
            log.debug("payResult::::::::::::::::::::::::::::::"+payResult);
            result.setSuccess(true);
            // 결제정보 업데이트
            payResult.setConfirmResultCd("00");
            payResult.setPaymentStatusCd("03"); // 취소

            // 마켓포인트있을시
            if (payReserveAmt > 0) {

                payResult.setRefundAmt(payReserveAmt);
                payResult.setRefundType("01");
                updatePaymentStatus(payResult);
            }

            // 마켓포인트 외 결제
            if (pgAmt > 0) {
                payResult.setRefundAmt(pgAmt);
                payResult.setRefundType("02");
                //관리자 환불처리시
                if(claimNoArr!=null && claimNoArr.length>0){
                    payResult.setClaimNo(claimNoArr[0]);
                }

                updatePaymentStatus(payResult);
            }

            // 부분 취소일때 남은 금액 결제 재등록
            if (partCancelYn.equals("Y") && restAmt > 0) {
                try {
                    // PG 등록
                    log.debug("pg 결제시 부분취소일경우 남은 금액 결제테이블 등록 ");
                    payResult.setOrdNo(longOrdNo);
                    payResult.setPaymentWayCd(payVo.getPaymentWayCd());
                    payResult.setPaymentAmt(Long.toString(orgPgAmt - pgAmt));
                    payResult.setPaymentAmt(Long.toString(restAmt));
                    insertPartCancelOrderPay(payResult);

                    // 마켓포인트 등록
                    log.debug("마켓포인트 결제시 부분취소일경우 남은 금액 결제테이블 등록 ");
                    payResult.setOrdNo(longOrdNo);
                    payResult.setPaymentWayCd("01");
                    payResult.setPaymentAmt(Long.toString(orgReserveAmt - payReserveAmt));
                    insertPartCancelOrderPay(payResult);
                 } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
            }
        } else if (!CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd())
                && !CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS.equals(payVo.getPaymentWayCd())
                && !("00".equals(payResult.getConfirmResultCd()) || "0000".equals(payResult.getConfirmResultCd()))) {
            //취소 상태가 아니고 가상계좌가 아닌 카드결제 일때 이니시스 오류 일경우
            throw new CustomException("msg : "+payResult.getConfirmResultMsg() +" code : "+ payResult.getConfirmResultCd(), new Object[] { payResult.getConfirmResultMsg() });//biz.exception.ord.cancelMsg
            //throw new Exception("취소 PG 처리중 오류");
        }else if(!CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd())
                && CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS.equals(payVo.getPaymentWayCd())
                && !OrdStatusConstants.ORD_DONE.equals(curVo.getOrdStatusCd())
                && !("00".equals(payResult.getConfirmResultCd()) || "0000".equals(payResult.getConfirmResultCd()))){
            //취소 상태가 아니고 가상계좌인데 입금전 상태가 아닌데 이니시스 오류라면
            throw new CustomException("msg : "+payResult.getConfirmResultMsg() +" code : "+ payResult.getConfirmResultCd(), new Object[] { payResult.getConfirmResultMsg() });//biz.exception.ord.cancelMsg
        }else{
            //가상계좌인데 입금전에 취소 했을경우 그냥 취소 시킴
        }

        /**
         * 2023-07-10 210
         * 결제시 얘약이 같이 된경우 예약도 취소해주자
         * **/
        if(fm_sRsvNo != null && !fm_sRsvNo.equals("")){
            VisitSO viSso = new VisitSO();
            viSso.setRsvNo(fm_sRsvNo);
            VisitVO visitVO = visitRsvService.selectVisitDtl(viSso);
            if(visitVO != null){
                try {
                    visitRsvService.removeVisit(viSso);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
            /** STEP. 5 현금영수증 취소 (부분취소일때 전체취소 하고 나머지금액 현금영수증 등록 ) */
            // 전체취소만 처리 부분취소 데이터매핑 문제로 우선 보류
            log.debug("=== 현금영수증 취소 ===");

            SalesProofVO cashVO = new SalesProofVO();
            SalesProofPO cashPO = new SalesProofPO();
            cashVO.setOrdNo(strOrdNo);
            cashVO.setProofType("02"); // 현금영수증
            ResultModel<SalesProofVO> salesProofVO = salesProofService.selectSalesProofOrdNo(cashVO);

            // 현금영수증 발급 확인 후 상태 변경
            if (!CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd()) && ("N").equals(salesProofVO.getData().getOrdNo())) {

                // PG현금영수증 취소 처리
                PaymentModel<?> paymentModel = new PaymentModel<>();
                paymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                paymentModel.setReqMode("mod"); // pay:발급, mod:취소
                paymentModel.setModType("STSC"); // 변경타입(STSC:취소,STPC:부분취소,STSQ:조회)
                paymentModel.setLinkTxNo(salesProofVO.getData().getLinkTxNo()); // 거래번호
                paymentModel.setPaymentPgCd(salesProofVO.getData().getPaymentPgCd());
                paymentModel.setOrdNo(longOrdNo);
                paymentModel.setUseGbCd(salesProofVO.getData().getUseGbCd()); // 발행구분

                // PG정보 조회
                if ("01".equals(paymentModel.getPaymentPgCd()) || "02".equals(paymentModel.getPaymentPgCd())
                    || "03".equals(paymentModel.getPaymentPgCd()) || "04".equals(paymentModel.getPaymentPgCd())) {
                    CommPaymentConfigVO vo = null;
                    try {
                        vo = paymentService.getPGInfo(paymentModel.getPaymentPgCd());
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                    paymentModel.setPgId(vo.getPgId());
                    paymentModel.setPgKey(vo.getPgKey());
                    paymentModel.setPgKey2(vo.getPgKey2());
                    paymentModel.setPgKey3(vo.getPgKey3());
                    paymentModel.setPgKey4(vo.getPgKey4());
                    paymentModel.setKeyPasswd(vo.getKeyPasswd());
                } else if ("41".equals(paymentModel.getPaymentPgCd())) {
                    SimplePaymentConfigVO vo = null;
                    try {
                        vo = paymentService.getPaycoPGInfo();
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                    paymentModel.setFrcCd(vo.getFrcCd());
                } else if ("81".equals(paymentModel.getPaymentPgCd())) {
                    CommPaymentConfigVO vo = null;
                    try {
                        vo = paymentService.getPaypalPGInfo();
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                    paymentModel.setFrgPaymentStoreId(vo.getFrgPaymentStoreId());
                    paymentModel.setFrgPaymentPw(vo.getFrgPaymentPw());
                }

                try {
                    paymentModel = paymentAdapterService.receipt(paymentModel).getData();
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }
                if ("00".equals(paymentModel.getConfirmResultCd()) || "0000".equals(paymentModel.getConfirmResultCd())) {
                    log.debug("// 취소처리 ");
                    cashPO.setCashRctStatusCd("04"); // 상태코드(01:접수, 02:승인,03:오류, 04:취소)

                    // throw new Exception("현금영수증 취소 에러");
                } else {
                    // PG 취소처리 후 현금영수증 PG 연동이라 트랜잭션 불가
                    cashPO.setCashRctStatusCd("03"); // 상태코드(01:접수, 02:승인, 03:오류, 04:취소)
                }
                cashPO.setProofNo(salesProofVO.getData().getProofNo());
                try {
                    salesProofService.updateCashRct(cashPO);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new CustomException("biz.exception.common.error");
                }

                // //신규등록 우선 주석
                if (partCancelYn.equals("Y") && cashPO.getCashRctStatusCd().equals("04")) {
                    log.debug("=== 현금영수증 발행 ===");
                    cashPO.setOrdNo(longOrdNo);
                    cashPO.setCashRctStatusCd("02"); // 상태코드(01:접수,02:승인,03:오류,04:취소)
                    cashPO.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자, 02:관리자)
                    cashPO.setMemberNo(po.getRegrNo());
                    cashPO.setUseGbCd(payResult.getUseGbCd()); // 사용구분코드(01:소득공제, 02:지출증빙)
                    cashPO.setIssueWayCd(payResult.getIssueWayCd()); // 발급수단코드(01:주민등록번호,02:휴대폰,03:사업자등록번호)
                    cashPO.setIssueWayNo(payResult.getIssueWayNo()); // 발급수단번호
                    cashPO.setTotAmt(restAmt); // 총금액 ( 남은 금액 )
                    // cashPO.setAcceptDttm(po.getRegDttm()); // 접수일시
                    // cashPO.setLinkTxNo(payResult.getLinkTxNo());
                    cashPO.setApplicantNm(po.getOrderInfoPO().getOrdrNm()); // 신청자명
                    cashPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo()); // 등록자
                    // cashPO.setRegDttm(po.getRegDttm()); // 등록일자 ( now() )
                    try {
                        salesProofService.insertCashRctIssue(cashPO,null);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new CustomException("biz.exception.common.error");
                    }
                }
            }

        log.debug("/** Interface 처리 **********************/ {}", po);
            ClaimGoodsPO claimGodosPo  = new ClaimGoodsPO();
            if (po.getCancelStatusCd().equals(OrdStatusConstants.PAY_CANCEL) || po.getCancelStatusCd().equals(OrdStatusConstants.PAY_CANEL_REQUEST) || po.getCancelStatusCd().equals(OrdStatusConstants.ORD_CANCEL)) {
                /** 주문취소,주문취소신청,결제취소 시에는 인터페이스 호출 안함 */
            } else {
                if(po.getReturnCd()!=null && po.getClaimCd()!=null) {
                    if (po.getReturnCd().equals("11") && po.getClaimCd().equals("11")) {
                        /** 반품등록 interface 호출*/
                    } else {
                            if (po.getReturnCd().equals("12") && !po.getClaimCd().equals("12")) { /** 반품확정 interface 호출*/
                            } else if (po.getReturnCd().equals("13")) {/** 반품취소 interface 호출*/
                                try {
                                    //관리자 반품/환불 처리시...
                                    if (claimNoArr != null && claimNoArr.length > 0) {
                                        cpo.setClaimNo(claimNoArr[0]);
                                        claimGodosPo.setClaimNo(cpo.getClaimNo());
                                        refundService.returnCancel(claimGodosPo);
                                        result.setSuccess(true);
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    throw new CustomException("biz.exception.common.error");
                                }
                            }

                            if (po.getClaimCd().equals("12")) {  /** 환불완료 interface 호출*/
                                try {
                                    //관리자 반품/환불 처리시...
                                    if (claimNoArr != null && claimNoArr.length > 0) {
                                        String orgClaimNo ="";
                                    	for(String claimNo : claimNoArr) {
                                            if(!orgClaimNo.equals(claimNo)) {
                                                cpo.setClaimNo(claimNo);
                                                claimGodosPo.setClaimNo(cpo.getClaimNo());
                                                claimGodosPo.setOrdNo(String.valueOf(po.getOrdNo()));
                                                refundService.refundConfirm(claimGodosPo);
                                            }
                                            orgClaimNo = claimNo;
                                    	}
                                        result.setSuccess(true);
                                    }

                                } catch (Exception e) {
                                    result.setSuccess(false);
                                    throw new CustomException("biz.exception.common.error");
                                }
                            } else if (po.getClaimCd().equals("66")) { /** 교환완료 interface 호출*/
                                try {
                                    refundService.exchangeConfirm(claimGodosPo);
                                    result.setSuccess(true);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    throw new CustomException("biz.exception.common.error");
                                }
                            }
                        }
                }
            }

            log.debug("/** Interface 처리 완료 **********************/");

            log.debug("/** STEP. 6 SMS, EMAIL 처리 **********************/");
            /**
             * EMAIL (sendTypeCdEmail)
             * 환불 신청 : 12
             * 환불완료 : 15
             * 결제취소 : 16
             * 주문무효 : 13
             * SMS (sendTypeCdSms)
             * 결제취소 : 10
             * 주문취소 : 11
             */
            String sendTypeCdEmail = "";
            String sendTypeCdSms = "";
            String templateCode = "";
            Map<String, String> templateCodeMap = new HashMap<>();
            if ("11".equals(strOrdStatusCd)) {
                // 주문취소
                templateCode ="";
                sendTypeCdSms = "";
            } else if ("21".equals(strOrdStatusCd)) {
                // 결제취소
                templateCode ="mk003";
                templateCodeMap.put("member","mk028");
                //templateCodeMap.put("admin","mk029");
                sendTypeCdSms = "10";
                sendTypeCdEmail = "";
            } else if ("74".equals(strOrdStatusCd)) {
                // 환불완료
                templateCode ="";
                sendTypeCdEmail = "";
            }

            try {
                if (!"".equals(sendTypeCdSms)) sendOrdAutoSms(templateCode,sendTypeCdSms, orderGoodsVO, templateCodeMap);
//                if (!"".equals(sendTypeCdEmail)) sendOrdAutoEmail(sendTypeCdEmail, orderGoodsVO);
            } catch (Exception eAuto) {
                log.debug("{}", eAuto.getMessage());
            }
            log.debug("SMS EMAIL 완료");

        /*} catch (Exception e) {
            log.debug("{}", e);
            e.printStackTrace();
            //throw new Exception("취소 DB처리중 오류");
            throw new CustomException("biz.exception.ord.cancelMsg", new Object[] { "<br>"+payResult.getConfirmResultMsg()+"<br>" });
        }*/

        return result;
    }

    /**
     * 주문 번호 생성
     */
    @Override
    public long createOrdNo(long siteNo) throws Exception {
        long ordNo = 0;
        ordNo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "createOrdNo", siteNo);
        return ordNo;
    }

    /**
     * 페이팔 hash 데이터 생성
     */
    public ResultModel<PaypalPO> getPaypalHashData(PaypalPO po) {
        ResultModel<PaypalPO> returnPo = new ResultModel<PaypalPO>();
        po.setHashdata(encryptSHA512(po.getTimestamp() + po.getMid() + po.getReqtype() + po.getWebordernumber()+ po.getCurrency() + po.getPrice() + po.getMerchantKey()));
        returnPo.setData(po);
        return returnPo;
    }

    /**
     * 알리페이 hash 데이터 생성
     */
    public ResultModel<AlipayPO> getAlipayHashData(AlipayPO po) {
        ResultModel<AlipayPO> returnPo = new ResultModel<AlipayPO>();
        po.setHashdata(encryptSHA512(po.getTimestamp() + po.getMid() + po.getReqtype() + po.getWebordernumber()+ po.getCurrency() + po.getPrice() + po.getMerchantKey()));
        returnPo.setData(po);
        return returnPo;
    }

    /**
     * 텐페이 hash 데이터 생성
     */
    public ResultModel<TenpayPO> getTenpayHashData(TenpayPO po) {
        ResultModel<TenpayPO> returnPo = new ResultModel<TenpayPO>();
        po.setHashdata(encryptSHA512(po.getTimestamp() + po.getMid() + po.getReqtype() + po.getWebordernumber()+ po.getCurrency() + po.getPrice() + po.getMerchantKey()));
        returnPo.setData(po);
        return returnPo;
    }

    /**
     * 페이팔 SHA-256 생성함수1
     */
    private String encryptSHA512(String input) {
        String output = "";

        StringBuffer sb = new StringBuffer();
        MessageDigest md = null;

        try {
            md = MessageDigest.getInstance("SHA-512");
            md.update(input.getBytes());
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }

        return byteArrayToHex(md.digest());
    }

    /**
     * 페이팔 SHA-256 생성함수2
     */
    private String byteArrayToHex(byte[] ba) {
        if (ba == null || ba.length == 0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int x = 0; x < ba.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & ba[x]);
            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 31.
     * 작성자 : proliebe
     * 설명   : 부분취소 적립 예정금 재계산
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 31. proliebe - 최초생성
     * </pre>
     *
     * @param orderGoodsList
     * @return Long
     */
    public Long calcSvmnAmt(List<OrderGoodsPO> orderGoodsList) throws Exception {
        long svmnAmt = 0;
        // 사이트 기본정보 조회
        SiteSO siteSO = new SiteSO();
        siteSO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        SiteVO siteVO = cacheService.selectBasicInfo(siteSO);

        if (orderGoodsList == null || orderGoodsList.size() == 0) {
            throw new Exception("데이터가 없습니다.");
        }

        // 비회원구매가 아닐 경우 회원정보 조회
        ResultModel<MemberManageVO> member_info = new ResultModel<>();
        if (orderGoodsList.get(0).getMemberNo() > 0) {
            long memberNo = orderGoodsList.get(0).getMemberNo();
            MemberManageSO so = new MemberManageSO();
            so.setMemberNo(memberNo);
            so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
            member_info = frontMemberService.selectMember(so);
        }

        // 적립예정금 계산
        long svmnPvdStndrd = 0; // 절사단위
        if ("0".equals(siteVO.getSvmnPvdStndrdCd())) {
            svmnPvdStndrd = 1;
        } else if ("1".equals(siteVO.getSvmnPvdStndrdCd())) {
            svmnPvdStndrd = 10;
        } else if ("2".equals(siteVO.getSvmnPvdStndrdCd())) {
            svmnPvdStndrd = 100;
        }
        for (OrderGoodsPO po : orderGoodsList) {
            // 01.상품별
            if ("Y".equals(po.getGoodsSvmnPolicyUseYn())) { // 기본정책 사용
                if ("Y".equals(siteVO.getSvmnPvdYn())) { // 마켓포인트 사용여부
                	if(svmnPvdStndrd != 0){
                        svmnAmt += Math.floor(((po.getSaleAmt() * po.getOrdQtt()) - po.getDcAmt())* (siteVO.getSvmnPvdRate() / 100) / svmnPvdStndrd) * svmnPvdStndrd;
                	}
                }
            } else if ("N".equals(po.getGoodsSvmnPolicyUseYn())) { // 상품별 정책 사용(원 단위)
                svmnAmt += po.getGoodsSvmnAmt();
            }
            // 02.회원등급
            if (orderGoodsList.get(0).getMemberNo() > 0) {
            	if(svmnPvdStndrd != 0){
	                svmnAmt += Math.floor(((po.getSaleAmt() * po.getOrdQtt()) - po.getDcAmt()) * (member_info.getData().getSvmnValue() / 100) / svmnPvdStndrd) * svmnPvdStndrd;
            	}
            }
        }
        return svmnAmt;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : proliebe
     * 설명   : 상품평 작성을 위한 상품 구매 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. proliebe - 최초생성
     * </pre>
     *
     * @param so
     * @return int
     */
    public OrderGoodsVO selectOrdGoodsReview(OrderSO so) throws Exception {
        OrderGoodsVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdGoodsReview", so);
        return vo;
    }

    /**
     * 주문 확인용 상품 정보 조회
     */
    @Override
    public OrderGoodsVO selectOrderGoodsInfo(GoodsDetailSO so) throws Exception {
        OrderGoodsVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrderGoodsInfo", so);
        int avlLen = 0;

        if(vo != null && vo.getCouponAvlInfo()!=null && !vo.getCouponAvlInfo().equals("")) {
            avlLen = vo.getCouponAvlInfo().split("\\|").length;
            for (int j = 0; j < avlLen; j++) {
                if (j == 0)
                    vo.setCouponApplyAmt(vo.getCouponAvlInfo().split("\\|")[j]);
                if (j == 1)
                    vo.setCouponDcAmt(vo.getCouponAvlInfo().split("\\|")[j]);
                if (j == 2)
                    vo.setCouponDcRate(vo.getCouponAvlInfo().split("\\|")[j]);
                if (j == 3)
                    vo.setCouponDcValue(vo.getCouponAvlInfo().split("\\|")[j]);
                if (j == 4)
                    vo.setCouponBnfCd(vo.getCouponAvlInfo().split("\\|")[j]);
                if (j == 5)
                    vo.setCouponBnfValue(vo.getCouponAvlInfo().split("\\|")[j]);
                if (j == 6)
                    vo.setCouponBnfTxt(vo.getCouponAvlInfo().split("\\|")[j]);
            }
        }

        return vo;
    }

    /**
     * 배송비 계산용 주문 정보 조회
     */
    @Override
    public List<OrderGoodsVO> selectOrderGoodsInfoList(GoodsDetailSO so) throws Exception {
        List<OrderGoodsVO> list = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrderGoodsInfoList", so);
        return list;
    }

    /**
     * 배송비 계산
     *
     * @param list
     *            : 주문/장바구니 리스트
     * @param type
     *            : 리스트 타입
     */
    public Map calcDlvrAmt(List list, String type) throws Exception {

        Map resultMap = new HashMap();
        Map<String, Long> dlvrPriceMap = new HashMap<>();
        Map<String, Integer> dlvrCountMap = new HashMap<>();
        Map<String, Integer> dlvrPackUnitMap = new HashMap<>();

        if (!"order".equals(type) && !"basket".equals(type)) {
            return resultMap;
        }

        long siteNo = SessionDetailHelper.getSession().getSiteNo();


        //판매자별 배송정책 가져오기
        /*SellerPO po = new SellerPO();
        po.setSiteNo(siteNo);
        po.setSellerNo(String.valueOf(sellerNo));
        ResultModel<DeliveryConfigVO> result = sellerService.selectDeliveryConfig(po);
        DeliveryConfigVO svo = result.getData();*/
        /*ResultListModel<BasicInfoVO> result = basicInfoService.selectBasicInfo(siteNo);*/
        /*SiteVO svo = (SiteVO) result.get("site_info");*/
        //log.debug("=== svo : {}", svo);
        /*
         * (상품)
         * 배송 설정 코드 dlvrSetCd - 1:기본배송비, 2:상품별배송비(무료), 3:상품별배송비(유료), 4:포장단위별배송비
         * (사이트 기본설정)
         * 기본배송비 유형 코드 defaultDlvrcTypeCd - 1:무료배송비, 2:고정배송비, 3:주문금액에 따른 배송비
         * 배송비 결제 코드 dlvrcPaymentCd - 01:무료, 02:선불, 03:착불, 04:매장픽업
         * // 1.기본 배송비 또는 상품 포장단위별 일때만 묶음 배송 처리
         * // 2.기본배송비 이면서 무료 설정이면 무료(묶음 이지만 의미 없음)
         * // 3.기본배송비 이면서 유료 설정이면 유료(묶음)
         * // 4.기본배송비 이면서 주문금액 조건이면
         * // 4-1)조건이 충족되면 선불,착불 상관없이 묶음 배송(무료)
         * // 4-2)조건이 충족되지 않으면, 선불끼리만 묶음 배송(유료)
         * // 5.상품별이면서 포장단위별일경우 상품단위로 묶음 배송 선불인 경우
         */

        List<String> itemNoArr = new ArrayList<>();
        String ordNo = "";
        List<String> ordDtlSeqArr = new ArrayList<>();
        if (list != null && list.size() > 0) {
            if ("order".equals(type)) {
                for (int m = 0; m < list.size(); m++) {
                    OrderGoodsVO vo = (OrderGoodsVO) list.get(m);
                    itemNoArr.add(vo.getItemNo());
                    if(vo.getOrdNo()!=null){
                        ordNo=vo.getOrdNo();
                    }
                    if(vo.getOrdDtlSeq()!=null){
                        ordDtlSeqArr.add(vo.getOrdDtlSeq());
                    }
                }
            } else {
                for (int m = 0; m < list.size(); m++) {
                    BasketVO vo = (BasketVO) list.get(m);
                    itemNoArr.add(vo.getItemNo());
                }
            }
            GoodsDetailSO so = new GoodsDetailSO();
            so.setItemNoArr(itemNoArr);
            so.setSiteNo(siteNo);
            so.setOrdNo(ordNo);
            so.setOrdDtlSeqArr(ordDtlSeqArr);
            List<OrderGoodsVO> orderGoodsList = this.selectOrderGoodsInfoList(so); // 조회

            List<OrderGoodsVO> basicDlvrList1 = new ArrayList(); // 기본배송비 묶음 리스트(무료)
            List<OrderGoodsVO> basicDlvrList2 = new ArrayList(); // 기본배송비 묶음 리스트(선불)
            List<OrderGoodsVO> condDlvrList = new ArrayList(); // 상품별배송비(조건부무료) 묶음 리스트
            List<OrderGoodsVO> packDlvrList = new ArrayList(); // 상품별배송비 포장단위별 묶음 리스트

            List<OrderGoodsVO> etcList = new ArrayList(); // 그외

            for (int i = 0; i < orderGoodsList.size(); i++) {
                OrderGoodsVO vo = orderGoodsList.get(i);
                if ("order".equals(type)) {
                    for (int k = 0; k < list.size(); k++) {
                        OrderGoodsVO ogVO = (OrderGoodsVO) list.get(k);
                        if (vo.getItemNo().equals(ogVO.getItemNo())) {
                            vo.setDlvrcPaymentCd(ogVO.getDlvrcPaymentCd());
                            vo.setOrdQtt(ogVO.getOrdQtt());
                        }
                    }
                } else {
                    for (int k = 0; k < list.size(); k++) {
                        BasketVO ogVO = (BasketVO) list.get(k);
                        if (vo.getItemNo().equals(ogVO.getItemNo())) {
                            vo.setDlvrcPaymentCd(ogVO.getDlvrcPaymentCd());
                            vo.setOrdQtt(ogVO.getBuyQtt());
                        }
                    }
                }
                if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                    basicDlvrList1.add(vo);
                } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) ) ) {// 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                    basicDlvrList2.add(vo);
                } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) ) ) { // 상품별배송비 포장단위별 선불 || "04".equals(vo.getDlvrcPaymentCd())
                    packDlvrList.add(vo);
                } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) ) ) {  //상품별배송비(조건부무료)  선불 || "04".equals(vo.getDlvrcPaymentCd())
                    condDlvrList.add(vo);
                } else {
                    etcList.add(vo);
                }
            }

            String grpId = "";
            // 기본배송비 리스트(무료)
            if (basicDlvrList1 != null && basicDlvrList1.size() > 0) {
                for (OrderGoodsVO bvo : basicDlvrList1) {
                    int groupCount = 0;
                    long dlvrPrice = 0;
                    grpId = bvo.getSellerNo()+"**"+bvo.getDlvrSetCd() + "**" + bvo.getDlvrcPaymentCd(); // sellerNo**1**01

                    if (dlvrCountMap.get(grpId) == null) {
                        groupCount = 1;
                    } else {
                        groupCount = dlvrCountMap.get(grpId) + 1;
                    }

                    dlvrPriceMap.put(grpId, dlvrPrice);
                    dlvrCountMap.put(grpId, groupCount);
                }
            }

            // 기본배송비 리스트(선불)
            if (basicDlvrList2 != null && basicDlvrList2.size() > 0) {
                long grpDlvrPrice = 0;
                long orderPrice = 0;
                for (OrderGoodsVO bvo : basicDlvrList2) {

                    /*SellerPO po = new SellerPO();
                    po.setSiteNo(siteNo);
                    po.setSellerNo(String.valueOf(bvo.getSellerNo()));
                    ResultModel<DeliveryConfigVO> result = sellerService.selectDeliveryConfig(po);
                    DeliveryConfigVO svo = result.getData();*/

                    AdminPointConfigVO adminPointConfigVO = erpPointService.selectPointConfig();
                    //판매자별 기본 배송 설정이 없으면 유료 2500배송을 설정한다.
                    if(adminPointConfigVO == null){
                        adminPointConfigVO = new AdminPointConfigVO();
                        adminPointConfigVO.setDefaultDlvrcTypeCd("2");
                        adminPointConfigVO.setDefaultDlvrc(String.valueOf(2500));
                        adminPointConfigVO.setDefaultDlvrMinAmt(String.valueOf(2500));
                        adminPointConfigVO.setDefaultDlvrMinDlvrc(String.valueOf(2500));
                    }

                    int groupCount = 0;
                    grpId = bvo.getSellerNo()+"**"+bvo.getDlvrSetCd() + "**" + bvo.getDlvrcPaymentCd(); // sellerNo**1**02
                    if ("1".equals(adminPointConfigVO.getDefaultDlvrcTypeCd())) {//무료
                        grpDlvrPrice = 0;
                        orderPrice=0;
                    } else if ("2".equals(adminPointConfigVO.getDefaultDlvrcTypeCd())) {//유료
                        grpDlvrPrice = Long.parseLong(adminPointConfigVO.getDefaultDlvrc());
                        orderPrice=0;
                    } else if ("3".equals(adminPointConfigVO.getDefaultDlvrcTypeCd())) {//주문합계
                        orderPrice += bvo.getSaleAmt() * bvo.getOrdQtt();
                    }

                    log.debug("==== orderPrice : {}", orderPrice);
                    if (orderPrice > 0 && orderPrice >= Long.parseLong(adminPointConfigVO.getDefaultDlvrMinAmt())) {//주문금액이 얼마 이상일경우 무료
                        grpDlvrPrice = 0;
                    } else if (orderPrice > 0 && orderPrice < Long.parseLong(adminPointConfigVO.getDefaultDlvrMinAmt())) {//미만일경우 배송비
                        grpDlvrPrice = Long.parseLong(adminPointConfigVO.getDefaultDlvrMinDlvrc());
                    }

                    if (dlvrCountMap.get(grpId) == null) {
                        groupCount = 1;
                    } else {
                        groupCount = dlvrCountMap.get(grpId) + 1;
                    }
                    dlvrPriceMap.put(grpId, grpDlvrPrice);
                    dlvrCountMap.put(grpId, groupCount);
                }

            }

            // 상품별배송비(조건부무료) 리스트
            if (condDlvrList != null && condDlvrList.size() > 0) {

                long orderPrice =0;
                for (OrderGoodsVO bvo : condDlvrList) {
                    int groupCount = 0;
                    long dlvrPrice = 0;
                    //grpId = bvo.getDlvrSetCd() + "**" + bvo.getDlvrcPaymentCd();
                    grpId = bvo.getGoodsNo() + "**" + bvo.getDlvrSetCd() + "**" + bvo.getDlvrcPaymentCd(); // goodsNo**6**02
                    if ("03".equals(bvo.getDlvrcPaymentCd()) || "04".equals(bvo.getDlvrcPaymentCd())) {
                        dlvrPrice = 0;
                    } else {

                        if (dlvrCountMap.get(grpId) == null) {
                            groupCount = 1;
                            orderPrice = 0;
                        } else {
                            groupCount = dlvrCountMap.get(grpId) + 1;
                        }

                        orderPrice += bvo.getSaleAmt() * bvo.getOrdQtt();
                        if (orderPrice > 0 && orderPrice >= bvo.getFreeDlvrMinAmt()) {
                            dlvrPrice = 0;
                        } else if (orderPrice > 0 && orderPrice < bvo.getFreeDlvrMinAmt()) {
                            dlvrPrice = bvo.getGoodseachcndtaddDlvrc();
                        }
                    }

                    dlvrPriceMap.put(grpId, dlvrPrice);
                    dlvrCountMap.put(grpId, groupCount);
                }
            }

            // 포장단위별 리스트
            if (packDlvrList != null && packDlvrList.size() > 0) {
                for (OrderGoodsVO bvo : packDlvrList) {
                    int groupCount = 0;
                    long goodsCnt = 0;
                    long dlvrPrice = 0;
                    bvo.setDlvrPrice(bvo.getPackUnitDlvrc());
                    grpId = bvo.getGoodsNo() + "**" + bvo.getDlvrSetCd() + "**" + bvo.getDlvrcPaymentCd(); // goodsNo**4**02
                    /**
                     * 2023-05-16 210
                     * 포장단위별 배송비 결정짓는 알고리즘인데 기존 구마켓부터 크리티컬한 버그가 있어서 고침
                     * **/
                    if(!dlvrPackUnitMap.containsKey(grpId)){
                        dlvrPackUnitMap.put(grpId, 0);
                    }
                    int packUnit = bvo.getPackMaxUnit();
                    long packDlvrPrice = bvo.getPackUnitDlvrc();
                    if (dlvrCountMap.get(grpId) == null) {
                        groupCount = 1;
                        goodsCnt = bvo.getOrdQtt();
                    } else {
                        groupCount = dlvrCountMap.get(grpId) + 1;
                        goodsCnt = dlvrPackUnitMap.get(grpId) + bvo.getOrdQtt();
                    }
                    int packCnt = (int) goodsCnt / packUnit;
                    if (goodsCnt % packUnit > 0) {
                        packCnt++;
                    }
                    dlvrPackUnitMap.put(grpId, (int)goodsCnt);
                    dlvrPriceMap.put(grpId, packDlvrPrice * packCnt);
                    dlvrCountMap.put(grpId, groupCount);
                }
            }



            // 그외(묶음 배송 X)
            if (etcList != null && etcList.size() > 0) {

                long orderPrice =0;
                for (OrderGoodsVO bvo : etcList) {

                    AdminPointConfigVO adminPointConfigVO = erpPointService.selectPointConfig();

                    long dlvrPrice = 0;
                    grpId = bvo.getItemNo() + "**" + bvo.getDlvrSetCd() + "**" + bvo.getDlvrcPaymentCd();
                    if ("1".equals(bvo.getDlvrSetCd()) && ("03".equals(bvo.getDlvrcPaymentCd())  || "04".equals(bvo.getDlvrcPaymentCd()))) {

                        if ("1".equals(adminPointConfigVO.getDefaultDlvrcTypeCd())) {
                            dlvrPrice = 0;
                            orderPrice =0;
                        } else if ("2".equals(adminPointConfigVO.getDefaultDlvrcTypeCd())) {
                            dlvrPrice = Long.parseLong(adminPointConfigVO.getDefaultDlvrc());
                            orderPrice =0;
                        } else if ("3".equals(adminPointConfigVO.getDefaultDlvrcTypeCd())) {
                            if ("03".equals(bvo.getDlvrcPaymentCd()) || "04".equals(bvo.getDlvrcPaymentCd())) {
                                dlvrPrice = 0;
                                orderPrice = 0;
                            } else {
                                orderPrice += bvo.getSaleAmt() * bvo.getOrdQtt();
                            }
                        }

                        log.debug("==== orderPrice : {}", orderPrice);
                        if (orderPrice > 0 && orderPrice >= Long.parseLong(adminPointConfigVO.getDefaultDlvrMinAmt())) {
                            dlvrPrice = 0;
                        } else if (orderPrice > 0 && orderPrice < Long.parseLong(adminPointConfigVO.getDefaultDlvrMinAmt())) {
                            dlvrPrice = Long.parseLong(adminPointConfigVO.getDefaultDlvrMinDlvrc());
                        }

                        dlvrPriceMap.put(grpId, dlvrPrice);
                        dlvrCountMap.put(grpId, 1);

                    } else if ("2".equals(bvo.getDlvrSetCd())) {
                        dlvrPrice = 0;
                        dlvrPriceMap.put(grpId, dlvrPrice);
                        dlvrCountMap.put(grpId, 1);
                    } else if ("3".equals(bvo.getDlvrSetCd())) {
                        if ("03".equals(bvo.getDlvrcPaymentCd()) || "04".equals(bvo.getDlvrcPaymentCd())) {
                            dlvrPrice = 0;
                        } else {
                            dlvrPrice = bvo.getGoodseachDlvrc();
                        }
                        dlvrPriceMap.put(grpId, dlvrPrice);
                        dlvrCountMap.put(grpId, 1);
                    } else if ("4".equals(bvo.getDlvrSetCd())) {
                        if ("03".equals(bvo.getDlvrcPaymentCd()) || "04".equals(bvo.getDlvrcPaymentCd())) {
                            dlvrPrice = 0;
                        } else {
                            int packCnt = (int) bvo.getOrdQtt() / bvo.getPackMaxUnit();
                            if (bvo.getOrdQtt() / bvo.getPackMaxUnit() > 0) {
                                packCnt++;
                            }
                            dlvrPrice = bvo.getPackUnitDlvrc() * packCnt;
                        }
                        dlvrPriceMap.put(grpId, dlvrPrice);
                        dlvrCountMap.put(grpId, 1);
                    } else if ("6".equals(bvo.getDlvrSetCd())) {
                        int groupCount = 0;
                        if ("03".equals(bvo.getDlvrcPaymentCd()) || "04".equals(bvo.getDlvrcPaymentCd())) {
                            dlvrPrice = 0;
                        } else {
                           if (dlvrCountMap.get(grpId) == null) {
                                groupCount = 1;
                                orderPrice = 0;
                            } else {
                                groupCount = dlvrCountMap.get(grpId) + 1;
                            }

                            orderPrice += bvo.getSaleAmt() * bvo.getOrdQtt();
                            if (orderPrice > 0 && orderPrice >= bvo.getFreeDlvrMinAmt()) {
                                dlvrPrice = 0;
                            } else if (orderPrice > 0 && orderPrice < bvo.getFreeDlvrMinAmt()) {
                                dlvrPrice = bvo.getGoodseachcndtaddDlvrc();
                            }
                        }
                        dlvrPriceMap.put(grpId, dlvrPrice);
                        dlvrCountMap.put(grpId, 1);
                    }
                }
            }

            List groupDlvrList = new ArrayList(); // 묶음관련 재조합 리스트
            basicDlvrList1 = new ArrayList();
            basicDlvrList2 = new ArrayList();
            packDlvrList = new ArrayList();
            condDlvrList = new ArrayList();
            etcList = new ArrayList();
            List<BasketVO> basketBasicDlvrList1 = new ArrayList();
            List<BasketVO> basketBasicDlvrList2 = new ArrayList();
            List<BasketVO> basketPackDlvrList = new ArrayList();
            List<BasketVO> basketCondDlvrList = new ArrayList();
            List<BasketVO> basketEtcList = new ArrayList();

            if ("order".equals(type)) {
                for (int k = 0; k < list.size(); k++) {
                    OrderGoodsVO vo = (OrderGoodsVO) list.get(k);
                    if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                        basicDlvrList1.add(vo);
                    } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) ) ) { // 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                        basicDlvrList2.add(vo);
                    } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) { // || "04".equals(vo.getDlvrcPaymentCd())
                        packDlvrList.add(vo);
                    } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) { // || "04".equals(vo.getDlvrcPaymentCd())
                        condDlvrList.add(vo);
                    } else {
                        etcList.add(vo);
                    }
                }
                groupDlvrList.addAll(basicDlvrList1);
                groupDlvrList.addAll(basicDlvrList2);
                groupDlvrList.addAll(condDlvrList);
                groupDlvrList.addAll(packDlvrList);
                groupDlvrList.addAll(etcList);
            } else {
                for (int k = 0; k < list.size(); k++) {
                    BasketVO vo = (BasketVO) list.get(k);
                    if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                        basketBasicDlvrList1.add(vo);
                    } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()))) {// 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                        basketBasicDlvrList2.add(vo);
                    } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()))) { //|| "04".equals(vo.getDlvrcPaymentCd())
                        basketPackDlvrList.add(vo);
                    } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()))) { //|| "04".equals(vo.getDlvrcPaymentCd())
                        basketCondDlvrList.add(vo);
                    } else {
                        basketEtcList.add(vo);
                    }
                }
                groupDlvrList.addAll(basketBasicDlvrList1);
                groupDlvrList.addAll(basketBasicDlvrList2);
                groupDlvrList.addAll(basketCondDlvrList);
                groupDlvrList.addAll(basketPackDlvrList);
                groupDlvrList.addAll(basketEtcList);
            }

            resultMap.put("list", groupDlvrList);
            resultMap.put("dlvrPriceMap", dlvrPriceMap);
            resultMap.put("dlvrCountMap", dlvrCountMap);
        } else {
            return resultMap;
        }
        log.debug(" === resultMap : {}", resultMap);
        return resultMap;
    }

    /**
     * 주문 확인용 상품 추가 옵션 정보 조회
     */
    @Override
    public GoodsAddOptionDtlVO selectOrderAddOptionInfo(GoodsDetailSO so) throws Exception {
        GoodsAddOptionDtlVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrderAddOptionInfo", so);
        return vo;
    }

    /**
     * 주문현황 정보 조회
     */
    @Override
    public ResultModel<OrderVO> selectOrderCountInfo(OrderSO so) {
        ResultModel<OrderVO> result = new ResultModel<OrderVO>();
        OrderVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrderCountInfo", so);
        result.setData(vo);
        return result;
    }

    /**
     * 선택한 주문상태의 주문건수 조회
     */
    @Override
    public ResultModel<OrderVO> selectStatusOrderCount(OrderSO so) {
        ResultModel<OrderVO> result = new ResultModel<OrderVO>();
        OrderVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectStatusOrderCount", so);
        result.setData(vo);
        return result;
    }

    /**
     * 비회원 주문 조회 유효성 검사
     */
    @Override
    public boolean selectNonMemberOrder(OrderSO so) {
        boolean ordYn = false;
        String ordMobile1 = so.getOrdrMobile().replaceAll("-", ""); // 입력받은 번호
        OrderInfoVO orderInfoVO = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectNonMemberOrder", so);
        if (orderInfoVO != null) {
            String ordMobile2 = orderInfoVO.getOrdrMobile().replaceAll("-", ""); // 조회한
                                                                                 // 번호
            if (ordMobile1.equals(ordMobile2)) {
                ordYn = true;
            }
        }
        return ordYn;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 5.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 주문 상세 목록을 조회하여 리턴
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 5. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public ResultListModel<OrderGoodsVO> selectOrdDtlAllListPaging(OrderSO so) throws CustomException {

        ResultListModel<OrderGoodsVO> resultListModel = proxyDao.selectListPage(MapperConstants.ORDER_MANAGE + "selectOrdDtlAllListPaging", so);
        return resultListModel;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 프론트 주문 목록을 조회하여 리턴
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @Override
    public ResultListModel<OrderVO> selectOrdListFrontPaging(OrderSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (so.getSidx().length() == 0) {
            so.setSidx("A.REG_DTTM");
            so.setSord("DESC");
        }

        ResultListModel<OrderVO> resultList = new ResultListModel<OrderVO>();
        ResultListModel<OrderInfoVO> orderInfoListModel = proxyDao.selectListPage(MapperConstants.ORDER_MANAGE + "selectOrdListFrontPaging", so);
        List<OrderInfoVO> list = orderInfoListModel.getResultList();
        List<OrderVO> newList = new ArrayList<OrderVO>();

        if (list != null && list.size() > 0) {
            for (OrderInfoVO infoVO : list) {
                // 결제 정보
                List<OrderPayVO> orderPayVO = selectOrderPayInfoList(infoVO);
                // 상품 정보
                Map<String, String> map = new HashMap<String, String>();
                map.put("siteNo", String.valueOf(so.getSiteNo()));
                map.put("ordNo", infoVO.getOrdNo());
                map.put("addOptYn", "N");
                map.put("claimStatusYn",so.getClaimStatusYn());

                List<OrderGoodsVO> goodsList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlNoOptionList", map);

                // 추가 옵션 목록을 추가할 새로운 상품 목록
                List<OrderGoodsVO> newGoodsList = new ArrayList<OrderGoodsVO>();

                for (OrderGoodsVO gvo : goodsList) {
                    map.put("addOptYn", "Y");
                    map.put("itemNo", gvo.getItemNo());
                    List<GoodsAddOptionDtlVO> goodsOptionList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlAddOptionList", map);
                    gvo.setGoodsAddOptList(goodsOptionList);
                    newGoodsList.add(gvo);
                }
                OrderVO vo = new OrderVO();
                // 기본 정보
                vo.setOrderInfoVO(infoVO);
                // 결제 목록
                vo.setOrderPayVO(orderPayVO);
                // 상품 목록
                vo.setOrderGoodsVO(newGoodsList);

                newList.add(vo);
            }
        }
        resultList.setResultList(newList);
        resultList.setRows(orderInfoListModel.getRows());
        resultList.setTotalRows(orderInfoListModel.getTotalRows());
        resultList.setTotalPages(orderInfoListModel.getTotalPages());
        resultList.setFilterdRows(orderInfoListModel.getFilterdRows());
        resultList.setSuccess(orderInfoListModel.getSuccess());
        resultList.setPage(orderInfoListModel.getPage());
        return resultList;

    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 12.
     * 작성자 : kdy
     * 설명   : 부가 비용 사용 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 12. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public List<OrderGoodsVO> selectAddedAmountList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectAddedAmountList", vo);
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 25.
     * 작성자 : kdy
     * 설명   : 주문 상태 변경시 자동 SMS 보내기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 25. kdy - 최초생성
     * 03 : 주문완료(상태코드:입금확인중)
     * 04 : 결제완료
     * 05 : 배송준비
     * 06 : 배송중 처리
     * 07 : 부분 배송중
     * 08 : 부분 배송완료
     * 09 : 배송완료
     * 10 : 결제취소
     * 11 : 주문취소
     * 12 : 상품 반품 교환
     * 13 : 주문무효
     * 14 : 결제 실패
     * </pre>
     *
     * @param sendTypeCd
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public boolean sendOrdAutoSms(String templateCode,String sendTypeCd, OrderGoodsVO vo, Map<String, String> templateCodeMap) throws Exception {
        SmsSendSO sendSo = new SmsSendSO();
        ReplaceCdVO replaceVO = new ReplaceCdVO();

        log.info("{}", sendTypeCd);
        log.info("{}", templateCodeMap);

        try {
            // 기본 정보
            OrderInfoVO orderInfoVo = new OrderInfoVO();
            orderInfoVo.setSiteNo(vo.getSiteNo());
            orderInfoVo.setOrdNo(vo.getOrdNo());
            OrderInfoVO orderDtl = selectOrdDtlInfo(orderInfoVo);
            //주문상품정보
            orderInfoVo.setOrdDtlSeq(vo.getOrdDtlSeq());
            List<OrderGoodsVO> goodsList = selectOrdDtlList(orderInfoVo);

            /***** 치환코드 set *****/
            // 주문상품
            if (StringUtils.isNotEmpty(vo.getOrdDtlSeq())) {
                replaceVO.setOrderItem(goodsList.get(0).getGoodsNm() +" ("+ goodsList.get(0).getItemNm() +")");
            } else {
                String itemNm = "";
                if(goodsList.get(0).getItemNm() != null) itemNm = " ("+ goodsList.get(0).getItemNm() +")";
                orderDtl.setGoodsNm(goodsList.get(0).getGoodsNm() + itemNm);
                if(orderDtl.getOrdGoodsCnt() > 1) orderDtl.setGoodsNm(orderDtl.getGoodsNm()+" 외 "+(orderDtl.getOrdGoodsCnt()-1)+"건");
                replaceVO.setOrderItem(orderDtl.getGoodsNm());
            }
            // 주문번호
            replaceVO.setOrderNo(orderDtl.getOrdNo());
            // 송장번호
            replaceVO.setDeliveryNumber(StringUtils.isNotEmpty(goodsList.get(0).getRlsInvoiceNo()) ? goodsList.get(0).getRlsInvoiceNo() : "");
            // 방문매장
            replaceVO.setStoreNm(orderDtl.getStoreNm());
            // 방문일시
            replaceVO.setRsvDate(orderDtl.getStrVisitDate());
            // 상품명
            replaceVO.setGoodsNm(StringUtils.isNotEmpty(goodsList.get(0).getGoodsNm()) ? goodsList.get(0).getGoodsNm() : "");
            // 주문금액
            if (StringUtils.isEmpty(vo.getOrdDtlSeq())) {
                replaceVO.setOrdPayAmt(StringUtil.formatMoney(orderDtl.getPaymentAmt()));
            } else {
                replaceVO.setOrdPayAmt(StringUtil.formatMoney(String.valueOf(goodsList.get(Integer.parseInt(vo.getOrdDtlSeq()) - 1).getPayAmt())));
            }

            /***** SmsSendSO set *****/
            sendSo.setSiteNo(StringUtils.isNotEmpty(String.valueOf(vo.getSiteNo())) ? vo.getSiteNo() : SessionDetailHelper.getDetails().getSiteNo());
            sendSo.setSendTypeCd(sendTypeCd);
            sendSo.setMemberTemplateCode(templateCodeMap.get("member"));
            sendSo.setAdminTemplateCode(templateCodeMap.get("admin"));
            sendSo.setSellerTemplateCode(templateCodeMap.get("seller"));
            sendSo.setMemberNo(Long.parseLong(orderDtl.getMemberNo()));
            sendSo.setSellerNo(Long.parseLong(goodsList.get(0).getSellerNo()));
        } catch (Exception e) {
            log.info("{}", e.getMessage());
        }
        return smsSendService.sendAutoSms(sendSo, replaceVO);

    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 17.
     * 작성자 : kdy
     * 설명   : 주문 상태 변경시 자동 이메일 보내기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 17. kdy - 최초생성
     *
     * </pre>
     *
     * @param sendTypeCd
     * @param vo
     * @return
     */
    @Override
    public boolean sendOrdAutoEmail(String sendTypeCd, OrderGoodsVO vo) {

        /**
         * 주문완료(상태코드:입금확인중) : 05
         * 결제완료 : 06
         * 배송준비 : 07
         * 배송중 처리시 : 08
         * 부분배송 처리시 : 09
         * 부분배송 완료 시 : 10
         * 배송 완료시 : 11
         * 교환/환불 신청 : 12
         * 주문무효 : 13
         * 결제취소환불완료 : 14
         * 반품환불완료 : 15
         * 결제취소 : 16
         * 결제 실패 : 17 (?)
         **/
        boolean result = false;
        // 기본 정보
        OrderInfoVO tVO = new OrderInfoVO();
        tVO.setSiteNo((!StringUtil.isEmpty(vo.getSiteNo())) ? vo.getSiteNo() : SessionDetailHelper.getDetails().getSiteNo());
        tVO.setOrdNo(vo.getOrdNo());
        OrderInfoVO orderDtl = selectOrdDtlInfo(tVO);

        List<OrderGoodsVO> goodsList = selectOrdDtlList(tVO);
        // 결제 정보
        List<OrderPayVO> payVo = selectOrderPayInfoList(tVO);
        EmailSendSO sendSo = new EmailSendSO();
        /* 변경할 치환 코드 설정 */
        ReplaceCdVO replaceVO = new ReplaceCdVO();
        try {
            /* 이메일 자동 발송 기본 설정 */
            sendSo.setMailTypeCd(sendTypeCd); // ERD 메일 유형 코드 참조 ex)1:1문의 답변 코드 : 23
            sendSo.setSiteNo((!StringUtil.isEmpty(vo.getSiteNo())) ? vo.getSiteNo(): SessionDetailHelper.getDetails().getSiteNo());
            sendSo.setOrdNo(new Long(tVO.getOrdNo()));
            if (orderDtl.getMemberNo() != null) sendSo.setReceiverNo(new Long(orderDtl.getMemberNo()));
            sendSo.setReceiverId(orderDtl.getLoginId());
            sendSo.setReceiverNm(orderDtl.getOrdrNm());
            sendSo.setReceiverEmail(orderDtl.getOrdrEmail());
            // Set 해줘야 할 컬럼 : emailSendSo- receiverId, receiverNm, receiverEmail,
            // siteNo
            double dlvrAmt = 0;

            SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", tVO);
            siteVO.setDlgtDomain(siteVO.getDlgtDomain());

            replaceVO.setOrderNm(orderDtl.getOrdrNm());
            SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String orderDate = transFormat.format(orderDtl.getOrdAcceptDttm());
            replaceVO.setReqDate(orderDate);
            replaceVO.setOrderNo(orderDtl.getOrdNo());

            if(orderDtl.getOrdGoodsCnt()>1){
                orderDtl.setGoodsNm(orderDtl.getGoodsNm()+" 외 "+(orderDtl.getOrdGoodsCnt()-1)+"건");
            }
            replaceVO.setOrderItem(orderDtl.getGoodsNm());

            String rlsCourierNm = "";
            String rlsInvoiceNo = "";
            int idx = 1;
            String comma=",";
            for(OrderGoodsVO ordGoodsVo : goodsList){
                rlsCourierNm += ordGoodsVo.getRlsCourierNm();
                rlsInvoiceNo += ordGoodsVo.getRlsInvoiceNo();
                if(idx <goodsList.size()){
                    rlsCourierNm += comma;
                    rlsInvoiceNo += comma;
                }
                idx++;
            }
            replaceVO.setDeliveryCompany(rlsCourierNm);
            replaceVO.setDeliveryNumber(rlsInvoiceNo);

            replaceVO.setShopName(siteVO.getSiteNm());
            replaceVO.setCustCtEmail(siteVO.getCustCtEmail());
            replaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
            replaceVO.setDlgtDomain(siteVO.getDlgtDomain());
            replaceVO.setLogoPath(siteVO.getLogoPath());

            replaceVO.setMemberNm(orderDtl.getOrdrNm());
            replaceVO.setOrdEmail(orderDtl.getOrdrEmail()); // 이메일
            replaceVO.setOrdTel(orderDtl.getOrdrTel());
            replaceVO.setOrdMobile(orderDtl.getOrdrMobile());
            replaceVO.setOrdAdrsNm(orderDtl.getAdrsNm());
            replaceVO.setOrdAdrsTel(orderDtl.getAdrsTel());
            replaceVO.setOrdAdrsMobile(orderDtl.getAdrsMobile());
            replaceVO.setOrdRoadAddr(orderDtl.getRoadnmAddr());
            replaceVO.setOrdNumAddr(orderDtl.getNumAddr());
            replaceVO.setOrdDtlAddr(orderDtl.getDtlAddr());
            replaceVO.setOrdDlvrMsg(orderDtl.getDlvrMsg());
            replaceVO.setOrdSaleAmt(StringUtil.formatMoney(orderDtl.getSaleAmt() + ""));
            replaceVO.setOrdDcAmt(StringUtil.formatMoney(orderDtl.getDcAmt() + ""));
            replaceVO.setOrdSvmnAmt("0");
            for (OrderPayVO pvo : payVo) {
                if (pvo.getPaymentWayCd().equals("01")) // 마켓포인트
                    replaceVO.setOrdSvmnAmt(StringUtil.formatMoney(pvo.getPaymentAmt()));
                else
                    replaceVO.setOrdPaymentWayNm(pvo.getPaymentWayNm());
                if (pvo.getPaymentWayCd().equals("11") || pvo.getPaymentWayCd().equals("22")) {// 가상계좌,  무통장
                    replaceVO.setOrdBankNm(pvo.getBankNm()); // 입금은행명
                    replaceVO.setOrdBankAccntNm(pvo.getDpsterNm()); // 입금자명
                    replaceVO.setOrdBankAccntNo(pvo.getActNo()); // 입금은행 계좌

                    replaceVO.setSettleprice(StringUtil.formatMoney((long) (new Double(pvo.getPaymentAmt())).doubleValue() + ""));
                    String today = DateUtil.getNowDate();
                    replaceVO.setDormancyDuDate(StringUtil.formatDate(DateUtil.addDays(today, 5)));
                    replaceVO.setOrdClaimBankNm(pvo.getBankNm());
                    replaceVO.setOrdClaimAccntNo(pvo.getActNo());
                    replaceVO.setOrdClaimAccntNm(pvo.getDpsterNm());

                }
            }
            replaceVO.setOrdPayAmt(StringUtil.formatMoney((long) (new Double(orderDtl.getPaymentAmt())).doubleValue() + ""));

            // replaceVO.setOrdClaimReason();
            // replaceVO.setOrdClaimDtlReason();
            // replaceVO.setOrdClaimAmt();
            // replaceVO.setOrdClaimCmpltDttm();
            // replaceVO.setOrdClaimSvmnAmt();
            // replaceVO.setOrdClaimRefundWay();
            StringBuffer itemBuf = new StringBuffer();
            int rownum = 1;
            itemBuf.append("<table class=\"basic3\" style=\"width:100%;border-collapse:collapse;margin-bottom:30px;font-size:12px;border-top:1px solid #dddddd;\">");
            itemBuf.append("<tr>");
            itemBuf.append("    <th colspan=\"3\" style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
            itemBuf.append("        상품명");
            itemBuf.append("    </th>");
            if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("        수량");
                itemBuf.append("    </th>");
            } else {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("    주문수량/<br>");
                itemBuf.append("    요청수량");
                itemBuf.append("    </th>");
            }
            itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
            itemBuf.append("        상품금액");
            itemBuf.append("    </th>");
            /*
             * 교환/환불 신청 : 12
             * 결제취소환불완료 : 14
             * 반품환불완료 : 15
             */
            if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("        배송비");
                itemBuf.append("    </th>");
            }
            // 주문 상태
            if ("08".equals(sendTypeCd) || "09".equals(sendTypeCd) || "10".equals(sendTypeCd) || "11".equals(sendTypeCd)
                    || "12".equals(sendTypeCd) || "14".equals(sendTypeCd) || "15".equals(sendTypeCd)
                    || "16".equals(sendTypeCd)) {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("        주문/배송상태");
            }
            itemBuf.append("</tr>");
            if ("12".equals(sendTypeCd) || "14".equals(sendTypeCd) || "15".equals(sendTypeCd)) {
                itemBuf.append("    <tr>");
                itemBuf.append("        <td colspan=\"6\" style=\"width:100%;text-align:left;padding:15px 10px;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("            <strong>배송지</strong><br>");
                itemBuf.append("             (" + orderDtl.getPostNo() + ")" + orderDtl.getRoadnmAddr() == ""? orderDtl.getNumAddr(): orderDtl.getRoadnmAddr() + " " + orderDtl.getDtlAddr() + "<br>");
                itemBuf.append("             " + orderDtl.getAdrsNm() + " / " + orderDtl.getAdrsMobile() + " / "+ orderDtl.getAdrsTel());
                itemBuf.append("        </td>");
                itemBuf.append("    </tr>");
            }
            for (OrderGoodsVO goodVo : goodsList) {
                itemBuf.append("<tr>");
                itemBuf.append("   <td style=\"width:50px;pappending:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                if ("N".equals(goodVo.getAddOptYn())) { // 추가옵션 아닐때
                    itemBuf.append("    " + rownum);
                    rownum++;
                } else {
                    itemBuf.append("    <img src=\"http://" + siteVO.getDlgtDomain()+ "/admin/img/email/icon_addition.png\" alt=\"추가상품\" style=\"border:0;\">");
                }

                itemBuf.append("    </td>");
                itemBuf.append("    <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("    <img src=\"http://" + siteVO.getDlgtDomain() + goodVo.getImgPath()+ "\" alt=\"\" style=\"border:0;\">");
                itemBuf.append("    </td>");
                itemBuf.append("    <td class=\"tal\" style=\"width:150px;padding:15px 10px;text-align:left;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("    <a href=\"http://" + siteVO.getDlgtDomain() + "/front/goods/goods-detail?goodsNo="+ goodVo.getGoodsNo() + "\" class=\"goods_txt\">");
                itemBuf.append(goodVo.getGoodsNm() + "<br>");
                if ("Y".equals(goodVo.getAddOptYn())) { // 추가옵션
                    itemBuf.append("</a>");
                } else {
                    if (goodVo.getItemNm() != null && !"".equals(goodVo.getItemNm())) {
                        itemBuf.append("    [기본옵션:");
                        itemBuf.append("    " + goodVo.getItemNm() == null ? "" : goodVo.getItemNm());
                        itemBuf.append("    ]><br>");
                        // itemBuf.append(" <span class=\"code\">[상품코드 : " +
                        // goodVo.getGoodsNo() + "]</span>");
                    }
                    if (goodVo.getFreebieNm() != null && !"".equals(goodVo.getFreebieNm())) {
                        itemBuf.append("    [사은품:");
                        itemBuf.append(goodVo.getFreebieNm() == null ? "" : goodVo.getFreebieNm());
                        itemBuf.append("    ]");
                    }
                    itemBuf.append("</a>");
                }
                itemBuf.append("    </td>");
                itemBuf.append("   <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                    itemBuf.append("     " + goodVo.getOrdQtt());
                } else {
                    itemBuf.append("     " + goodVo.getOrdQtt() + "<br>");
                    itemBuf.append("    <span class=\"point1\" style=\"color:red;\">(-" + goodVo.getOrdQtt() + ")</span>");
                }
                itemBuf.append("   </td>");
                itemBuf.append("   <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("     "+ StringUtil.formatMoney((long) (new Double(goodVo.getPaymentAmt()).doubleValue()) + "") + "원");
                itemBuf.append("   </td>");
                try {
                    if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                        if ("N".equals(goodVo.getAddOptYn()) && !"0".equals(goodVo.getDlvrcCnt())) {
                            itemBuf.append("   <td rowspan=\"" + goodVo.getDlvrcCnt() + "\" style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                            if (!"0".equals(goodVo.getAreaAddDlvrc())) {
                                itemBuf.append("   선불<br>");
                            } else {
                                itemBuf.append(goodVo.getDlvrcPaymentNm() + "<br>");
                            }
                            double amt1 = new Double(goodVo.getRealDlvrAmt());
                            double amt2 = new Double(goodVo.getAreaAddDlvrc());

                            if ((amt1 + amt2) > 0) {
                                itemBuf.append(StringUtil.formatMoney((long) (amt1 + amt2) + ""));
                            }
                            itemBuf.append("   </td>");
                        }
                    }
                    // 배송비 계산
                    if ("N".equals(goodVo.getAddOptYn()) && !"0".equals(goodVo.getDlvrcCnt())) {
                        double amt1 = new Double(goodVo.getRealDlvrAmt());
                        double amt2 = new Double(goodVo.getAreaAddDlvrc());
                        dlvrAmt = dlvrAmt + amt1 + amt2;
                    }
                } catch (Exception e) {
                    log.debug("{}", e.getMessage());
                }

                /*
                 * 교환/환불 신청 : 12
                 * 결제취소환불완료 : 14
                 * 반품환불완료 : 15
                 */
                if ("12".equals(sendTypeCd) || "14".equals(sendTypeCd) || "15".equals(sendTypeCd)) {
                    // 클레임 정보 조회
                    ClaimSO so = new ClaimSO();
                    so.setOrdNo(goodVo.getOrdNo());
                    so.setOrdDtlSeq(goodVo.getOrdDtlSeq());
                    ClaimGoodsVO claimVo = proxyDao.selectOne(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange",so);
                    if (claimVo != null) {
                        replaceVO.setOrdClaimReason(claimVo.getClaimReasonNm());
                        replaceVO.setOrdClaimDtlReason(claimVo.getClaimDtlReason());
                        Calendar caldate = Calendar.getInstance();
                        caldate.setTime(claimVo.getClaimAcceptDttm());
                        replaceVO.setReqDate(DateUtil.getFormatDate(caldate, "yyyy-MM-dd HH:mm:ss"));
                    }

                }
                // 주문 상태
                if ("08".equals(sendTypeCd) || "09".equals(sendTypeCd) || "10".equals(sendTypeCd)
                        || "11".equals(sendTypeCd) || "12".equals(sendTypeCd) || "14".equals(sendTypeCd)
                        || "15".equals(sendTypeCd) || "16".equals(sendTypeCd)) {
                    itemBuf.append("   <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                    itemBuf.append("     " + goodVo.getOrdDtlStatusNm());
                    itemBuf.append("   </td>");
                }
                itemBuf.append("   </tr>");
            }
            replaceVO.setOrdDlvrAmt(StringUtil.formatMoney((long) dlvrAmt + "")); // 배송비
            itemBuf.append("</table>");
            replaceVO.setOrderItemList(itemBuf.toString());
//             return "true";
//            result = emailSendService.emailAutoSend(sendSo, replaceVO);
            result = true;
        } catch (Exception e) {
            log.debug("{}", e.getMessage());

        }
        return result;
    }

    /**
     * 취소시 배송비 재 계산용 주문 정보 조회
     */
    @Override
    public List<ClaimGoodsVO> selectDlvrCalOrdGoodsList(GoodsDetailSO so) throws Exception {
        // 정상 주문 확인
        List<ClaimGoodsVO> list = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectDlvrCalOrdGoodsList", so);
        // 배송비 재계산

        return list;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : kdy
     * 설명   : 결제 정보 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public List<OrderPayVO> selectOrderPayInfoList(OrderInfoVO vo) {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlPayInfo", vo);
    }

    /**
     *
     * <pre>
     * 작성일 : 2023. 5. 18.
     * 작성자 : 210
     * 설명   : 주문 상세 페이지에 방문예약 추가 하기위해 기존퀴리 에 는 상품까지 결제된거만 조회됨
     *
     */
    public VisitVO selectRsvNoDetail(String rsvNo) {
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectRsvNoDetail", rsvNo);
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : kdy
     * 설명   : 결제 실패 정보 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public List<OrderPayVO> selectOrderPayFailInfoList(OrderInfoVO vo) {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlPayFailInfo", vo);
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : kdy
     * 설명   : 주문 기본 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public OrderInfoVO selectOrdDtlInfo(OrderInfoVO vo) {
        return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdDtlInfo", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 09. 01.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문한 상품 목록 정보를 조회 (상품, 쿠폰, 마켓포인트 관련 조회 리스트 )

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 09. 01. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<OrderGoodsVO> selectOrdCancelDtlList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdCancelDtlList", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 09. 01.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문한 상품 목록 정보를 조회 (상품, 쿠폰, 마켓포인트 관련 조회 )

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 09. 01. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public OrderGoodsVO selectOrdCancelDtlInfo(OrderGoodsVO vo) throws CustomException {
        return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdCancelDtlInfo", vo);
    }

    /** 묶음배송 해제여부 조회 **/
    public boolean changeDlvrPriceYn(OrderPO po) throws CustomException {
        boolean dlvrChangeYn = false;
        long areaAddDlvrc = 0;

        // 첫번째 인자 : 재결제할 상품리스트
        // 두번째 인자 : 주문 or 장바구니(order/basket)
        // 재결제할 상품리스트에 dlvrSetCd(배송설정코드)/dlvrcPaymentCd(배송비결제코드)
        OrderInfoVO oiv = new OrderInfoVO();
        oiv.setOrdNo(Long.toString(po.getOrdNo()));
        List<OrderGoodsVO> orderGoodsList = selectOrdDtlList(oiv);

        // 옵션상품제거
        for (int o = 0; o < orderGoodsList.size(); o++) {
            if ("Y".equals(orderGoodsList.get(o).getAddOptYn())) {
                orderGoodsList.remove(o);
                o--;
            }
        }
        // 선택된 상품제거
        if(po.getOrdDtlSeqArr() != null) {
            for (int i = 0; i < po.getOrdDtlSeqArr().length; i++) {
                String ordDtlSeq = po.getOrdDtlSeqArr()[i];
                if (ordDtlSeq != null && !"".equals(ordDtlSeq)) {
                    for (int ov = 0; ov < orderGoodsList.size(); ov++) {
                        if (ordDtlSeq.equals(orderGoodsList.get(ov).getOrdDtlSeq())) {
                            if ((long) Double.parseDouble(orderGoodsList.get(ov).getAreaAddDlvrc()) > 0) {
                                //areaAddDlvrc += (long) Double.parseDouble(orderGoodsList.get(ov).getAreaAddDlvrc());
                            }
                            orderGoodsList.remove(ov);
                        }
                    }
                }
            }
        }
        // 취소된 상품 제거 ( 과거 부분취소 제거 )
        // 11:주문취소, 21:결제취소, 66:교환완료, 74:환불완료
        for (int ov = 0; ov < orderGoodsList.size(); ov++) {
            if ((orderGoodsList.get(ov).getOrdDtlStatusCd().equals("11")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("21")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("66")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("74"))) {
                orderGoodsList.remove(ov);
            }
        }
        try {
            // 재주문된 상품에 대해 배송비 재계산
            Map map = calcDlvrAmt(orderGoodsList, "order");
            String totalDlvrPrice = (String) map.get("totalDlvrPrice");

            List<OrderGoodsVO> list = (List<OrderGoodsVO>) map.get("list");
            Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
            Map dlvrCountMap = (Map) map.get("dlvrCountMap");

            String grpId = "";
            String preGrpId = "";
            boolean areaDlvrApplyYn = false; // 지역추가배송비 적용 여부
            long dlvrPrice = 0; // 재계산 배송비
            long orgDlvrPrice = 0; // 기존 배송비
            if (orderGoodsList != null && orderGoodsList.size() > 0) {
                for (OrderGoodsVO vo : orderGoodsList) {
                    /***** 배송비 설정 *****/
                    if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                        grpId = vo.getSellerNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                    } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                        grpId = vo.getSellerNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                    } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 포장단위별 || "04".equals(vo.getDlvrcPaymentCd())
                        grpId = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                    } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {  //상품별배송비(조건부무료)  선불 || "04".equals(vo.getDlvrcPaymentCd())
                        grpId = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                    } else {
                        grpId = vo.getItemNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                    }
                    //2023-06-06 210 취소상품제외한 상품의 배송비 재 계산방식이 잘못되었다.
                    //일단 기존 구마켓에 결제한사람 취소를 할수있으니 고쳐쓴다.
                    //기존 알고리즘에 문제는 취소제외한 남은 상품에 드간 배송비만 계산 되어야 하는데 취소한 상품에 이든 뭐든 추가 배송비가 잇으면 잘못됨
                    areaAddDlvrc += (long) Double.parseDouble(vo.getAreaAddDlvrc());
                    dlvrPrice += (long) dlvrPriceMap.get(grpId);
                    orgDlvrPrice += (long) Double.parseDouble(vo.getRealDlvrAmt());
//                    log.debug("grpId : " + grpId);
//                    log.debug("preGrpId : " + preGrpId);
//                    log.debug("grpId : " + dlvrPriceMap.get(grpId));
//                    if (!grpId.equals(preGrpId)) {
//                        dlvrPrice += (long) dlvrPriceMap.get(grpId);
//                    } else {
//                        dlvrPrice += 0;
//                    }
//
//                    // 지역추가 배송비
//                    if (areaAddDlvrc > 0 && !areaDlvrApplyYn) {
//                        if (!"04".equals(vo.getDlvrcPaymentCd())) {//무료(01)/선불(02)/착불(03)
//                            areaDlvrApplyYn = true;
//                            dlvrPrice += areaAddDlvrc;
//                        }
//                    } else {
//                        areaAddDlvrc += (long) Double.parseDouble(vo.getAreaAddDlvrc());
//                    }
//
//                    orgDlvrPrice += (long) Double.parseDouble(vo.getRealDlvrAmt());
//                    preGrpId = grpId;
                }
//                orgDlvrPrice += areaAddDlvrc;
                dlvrPrice += areaAddDlvrc;
                orgDlvrPrice += areaAddDlvrc;
                log.debug("지역 배송비 : " + areaAddDlvrc);
                log.debug("재계산 배송비 : " + dlvrPrice);
                log.debug("기존 배송비 : " + orgDlvrPrice);
                if (orgDlvrPrice != dlvrPrice) {
                    dlvrChangeYn = true;
                }
            }
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }
        return dlvrChangeYn;
    }

    /**
     * 주문정보 등록
     * table : TO_ORD
     */
    @Override
    public ResultModel<OrderInfoPO> updateOrderInfo(OrderInfoPO po) throws Exception {
        ResultModel<OrderInfoPO> result = new ResultModel<>();
        // 주문정보 수정 Biz실행
        try {
            proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrderInfo", po);
        } catch (Exception e) {
            throw new Exception(e);
        }
        return result;
    }



    /**
     * 주문상세 구매확정 처리
     * table : TO_ORD_DTL
     */
    @Override
    public ResultModel<OrderInfoVO> updateOrderDtl(OrderGoodsVO vo) throws Exception {
        ResultModel<OrderInfoVO> result = new ResultModel<>();
        // 주문정보 수정 Biz실행
        try {
            proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrderDtl", vo);
        } catch (Exception e) {
            throw new Exception(e);
        }
        return result;
    }

    /**
    *
    * <pre>
    * 작성일 : 2016. 9. 13.
    * 작성자 : kdy
    * 설명   : 주문테이블의 전체 구매 확정 처리
    *
    * 수정내역(수정일 수정자 - 수정내용)
    * -------------------------------------------------------------------------
    * 2016. 9. 13. kdy - 최초생성
    * </pre>
    *
    * @param vo
    * @return
    * @throws CustomException
    */
   @Override
   public ResultModel<OrderInfoVO> updateOrdStatusCdConfirm(OrderGoodsVO vo) throws Exception {

       ResultModel<OrderInfoVO> result = new ResultModel<>();

       try {

           if (vo.getRegrNo() == null || ("").equals(vo.getRegrNo())) {
               if (SessionDetailHelper.getDetails().isLogin()) {
	               vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	               vo.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
	               vo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
               }
           }

           // 추천인 조회
           //MemberManagePO po = proxyDao.selectOne(MapperConstants.MEMBER_INFO + "selectRecomMember", vo);

	       int cnt = proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusCdConfirm", vo);
           long totalSaleAmt = 0L;

	        // 최종구매확정시
	        if (cnt > 0) {
	            // 마켓포인트 부여 처리
	            OrderInfoVO orderInfoVO = new OrderInfoVO();
	            orderInfoVO.setOrdNo(vo.getOrdNo());
                orderInfoVO.setSiteNo(vo.getSiteNo());
	            OrderInfoVO infoVO = this.selectOrdDtlInfo(orderInfoVO);
                totalSaleAmt = (infoVO.getTotalSaleAmt() - infoVO.getTotalDcAmt() - infoVO.getTotalGoodsDmoneyUseAmt()) + infoVO.getTotalDlvrAmt() + infoVO.getTotalDlvrAddAmt();
                log.debug("selectOrdDtlInfo :::::::::::::::::::::::::::::: infoVO "+infoVO);
	            if (infoVO.getTotalPvdSvmn() > 0 && totalSaleAmt > 0) { // 실제 결제 금액이 0인경우 포인트 지급 안함

	                String validPeriod = DateUtil.getNowDate();
	                // 사이트 기본정보 조회
	                SiteSO siteSO = new SiteSO();
	                siteSO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
	                SiteVO siteVO = cacheService.selectBasicInfo(siteSO);
	                if (siteVO.getSvmnUseLimitday() > 0) {
	                    validPeriod = DateUtil.addMonths(validPeriod, siteVO.getSvmnUseLimitday());
	                }

                    OfflineMemberSO oso = new OfflineMemberSO();
                    oso.setCustName(infoVO.getOrdrNm());
                    oso.setHp(infoVO.getOrdrMobile().replace("-", ""));

                    List<OfflineMemberVO>  offLineMembers =  erpMemberService.getOfflineMemberInfo(oso);
                    log.debug("offLineMembers : {}",offLineMembers);
                    if(offLineMembers != null && offLineMembers.size() > 1){
                        throw new CustomException("이전에 가입된 정보가 있습니다. 관리자에게 문의 부탁드립니다.");
                    }
                    MemberDPointCtVO memberDPointCtVO = new MemberDPointCtVO();
                    memberDPointCtVO.setCdCust(offLineMembers.get(0).getCdCust());
                    memberDPointCtVO.setMemberCardNo(offLineMembers.get(0).getOfflineCardNo());
                    memberDPointCtVO.setStrCode(offLineMembers.get(0).getStrCode());
                    memberDPointCtVO.setOrdNo(Long.parseLong(infoVO.getOrdNo()));
                    memberDPointCtVO.setPaymentWayCd(infoVO.getPaymentWayCd());
                    memberDPointCtVO.setSalDpoint(infoVO.getTotalPvdSvmn());
                    memberDPointCtVO.setSaleAmt(totalSaleAmt);
                    memberDPointCtVO.setGoodsSvmnAmt(infoVO.getTotalGoodsDmoneyUseAmt());
                    memberDPointCtVO.setMemberNo(Long.parseLong(infoVO.getMemberNo()));

                    erpPointService.ordConfirmDPointPvdSvMn(memberDPointCtVO);

                    // 마켓포인트 사용 정보 등록
                    //2023-06-03 210 확정은 어드민에서 하고 결제후 포인트 사용과 적립을 하기 때문에 주석
//                    SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
//                    savedmnPointPO.setSiteNo(SessionDetailHelper.getSession().getSiteNo());
//                    savedmnPointPO.setOrdNo(infoVO.getOrdNo());
//                    savedmnPointPO.setGbCd("10"); // 지급
//                    if (siteVO.getSvmnUseLimitday() > 0) {
//                        savedmnPointPO.setEtcValidPeriod(validPeriod); // 유효기간
//                    }
//                    savedmnPointPO.setMemberNo(Long.parseLong(infoVO.getMemberNo())); // 회원번호
//                    savedmnPointPO.setTypeCd("A"); // 유형코드(A:자동, M:수동)
//                    savedmnPointPO.setReasonCd("02"); // 사유코드(상품구매 추가 지급)
//                    savedmnPointPO.setEtcReason(""); // 기타사유
//                    savedmnPointPO.setPrcAmt(Long.toString((long) ((double) infoVO.getPvdSvmn())));
//                    savedmnPointPO.setSvmnUsePsbYn("Y"); // 마켓포인트 사용 가능 여부
//                    savedMnPointService.insertSavedMn(savedmnPointPO);
	            }

	            // 추천인이 있을경우 마켓포인트 적립
		        /*if (po != null && !"".equals(po.getRecomMemberNo()) ) {
			        int recomPvdAmt = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectRecomPvdAmt", vo);

		            if (recomPvdAmt > 0) {

		                String validPeriod = DateUtil.getNowDate();
		                // 사이트 기본정보 조회
		                SiteSO siteSO = new SiteSO();
		                siteSO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
		                SiteVO siteVO = cacheService.selectBasicInfo(siteSO);
		                if (siteVO.getSvmnUseLimitday() > 0) {
		                    validPeriod = DateUtil.addMonths(validPeriod, siteVO.getSvmnUseLimitday());
		                }

		                // 마켓포인트 사용 정보 등록
                        //2023-06-03 210 추천인은 안쓰는거같아서 주석
//                        SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
//                        savedmnPointPO.setSiteNo(SessionDetailHelper.getSession().getSiteNo());
//                        savedmnPointPO.setOrdNo(infoVO.getOrdNo());
//                        savedmnPointPO.setGbCd("10"); // 지급
//                        if (siteVO.getSvmnUseLimitday() > 0) {
//                            savedmnPointPO.setEtcValidPeriod(validPeriod); // 유효기간
//                        }
//                        savedmnPointPO.setMemberNo(Long.parseLong(po.getRecomMemberNo())); // 회원번호
//                        savedmnPointPO.setTypeCd("A"); // 유형코드(A:자동, M:수동)
//                        savedmnPointPO.setReasonCd("10"); // 사유코드(추천인 적립금 지급)
//                        savedmnPointPO.setEtcReason(""); // 기타사유
//                        savedmnPointPO.setPrcAmt(Long.toString((long) ((double) recomPvdAmt)));
//                        savedmnPointPO.setSvmnUsePsbYn("Y"); // 마켓포인트 사용 가능 여부
//                        savedMnPointService.insertSavedMn(savedmnPointPO);
		            }
		        }*/

		        //첫구매 쿠폰 사용 가능일 UPDATE
		        cnt = proxyDao.update(MapperConstants.PROMOTION_COUPON + "updateCouponApplyDttm", vo);

	        }

           // 추천인이 있을경우 마켓포인트 적립
	       /* if (po != null && !"".equals(po.getRecomMemberNo()) ) {
		        int recomPvdAmt = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectRecomPvdAmt", vo);

	            if (recomPvdAmt > 0) {
	                //추천인 적립금을 주문상세에 분배
			        proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdDtlRecomPvdAmt", vo);
	            }
	        }*/

           result.setSuccess(true);
           result.setMessage(MessageUtil.getMessage("biz.common.update"));
       }catch (Exception e){
            e.printStackTrace();
           result.setSuccess(false);
           result.setMessage(MessageUtil.getMessage("biz.common.update"));
           return result;
       }
       return result;
   }

    /**
     * 현재 결제완료 주문상태 확인
     */
    @Override
    public ResultModel<OrderVO> partCancelStatusOrderCount(OrderSO so) {
        ResultModel<OrderVO> result = new ResultModel<OrderVO>();
        String ordDtlSeqs = "";
        for(int i = 0; i < so.getOrdDtlSeqArr().length; i++) {
            if(StringUtil.isNotEmpty(so.getOrdDtlSeqArr()[i])) {
                if(i > 0) {
                    ordDtlSeqs += ",";
                }
                ordDtlSeqs += so.getOrdDtlSeqArr()[i];
            }
        }
        OrderSO orderSO = new OrderSO();
        orderSO.setSiteNo(so.getSiteNo());
        orderSO.setOrdNo(so.getOrdNo());
        orderSO.setOrdDtlSeqArr(ordDtlSeqs.split(","));
        OrderVO vo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "partCancelStatusOrderCount", orderSO);
        result.setData(vo);
        return result;
    }

    /**
     * 부분 취소 결제 정보 등록
     * table : TO_PAYMENT
     */
    @Override
    public ResultModel<PaymentModel<?>> insertPartCancelOrderPay(PaymentModel po) throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();
        // 결제 정보 등록 Biz실행
        try {
            proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertPartCancelOrderPay", po);
        } catch (Exception e) {
            log.error("ERROR : {}", e);
            throw new Exception(e);
        }
        return result;
    }

    /**
     * 주문취소/교환/환불 내역 상세 정보 조회
     * table : TO_ORD_DTL
     */
    public ResultListModel<OrderVO> orderCancelDtlInfo(OrderSO vo) {


        ResultListModel<OrderVO> resultList = new ResultListModel<OrderVO>();
        List<OrderVO> orderCancelList = new ArrayList<>();

        // 기본 정보
        /*OrderInfoVO orderInfoVo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "orderCancelDtlInfo", vo);*/
        List<OrderInfoVO> orderInfoList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "orderCancelDtlInfo", vo);

        for(OrderInfoVO orderInfoVo : orderInfoList) {
            OrderVO rVo = new OrderVO();
            orderInfoVo = selectOrdStatusForward(orderInfoVo);
            orderInfoVo = selectOrdStatusBackward(orderInfoVo, "Y");
            orderInfoVo.setSiteNo(vo.getSiteNo());

            // 결제 정보
            List<OrderPayVO> payVo = selectOrderPayInfoList(orderInfoVo);
            // 배송 정보 조회
            DeliveryVO delivVo = new DeliveryVO();
            delivVo.setOrdNo(vo.getOrdNo());
            List<DeliveryVO> deliveryVOList = deliveryService.selectOrdDtlDelivery(delivVo);
            // 상품 정보
            List<OrderGoodsVO> goodsList = selectOrdDtlList(orderInfoVo);
            List<OrderGoodsVO> newGoodsList = new ArrayList<OrderGoodsVO>();

            for (OrderGoodsVO gvo : goodsList) {
                // 01.상품기본정보 조회
                GoodsDetailSO so = new GoodsDetailSO();
                so.setGoodsNo(gvo.getGoodsNo());
                // so.setItemNo(gvo.getItemNo());
                ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);

                try {
                    // 02.단품정보
                    String jsonList = "";
                    if (goodsInfo.getData().getGoodsItemList() != null) {
                        ObjectMapper mapper = new ObjectMapper();
                        jsonList = mapper.writeValueAsString(goodsInfo.getData().getGoodsItemList());
                    }
                    gvo.setJsonList(jsonList);
                } catch (Exception e) {
                    log.debug("{}", e.getMessage());
                }
                gvo.setGoodsOptionList(goodsInfo.getData().getGoodsOptionList());
                newGoodsList.add(gvo);
            }

            // 부가 비용 목록
            List<OrderGoodsVO> ordAddedAmountList = selectAddedAmountList(orderInfoVo);
            // 처리 로그 정보
            List<OrderGoodsVO> ordHistVOList = selectOrdDtlHistList(orderInfoVo);
            // 클레임 이력
            List<ClaimGoodsVO> ordClaimList = selectClaimList(orderInfoVo);



        rVo.setOrderInfoVO(orderInfoVo);
        rVo.setOrderPayVO(payVo);
        rVo.setDeliveryVOList(deliveryVOList);
        rVo.setOrderGoodsVO(newGoodsList);
        rVo.setOrdAddedAmountList(ordAddedAmountList);
        rVo.setOrdHistVOList(ordHistVOList);
        rVo.setOrdClaimList(ordClaimList);

         orderCancelList.add(rVo);
        }
        resultList.setResultList(orderCancelList);
        return resultList;
    }

    /**
     * 모바일 결제 프로세스
     */
    @Override
    public ResultModel<OrderPO> orderPaymentMobile(OrderPO po, HttpServletRequest request, Map<String, Object> reqMap,
            ModelAndView mav) throws Exception {
        ResultModel<OrderPO> result = new ResultModel<>();
        PaymentModel<?> payResult = new PaymentModel<>();

        // step01. pg결제 처리
        boolean standBydeposit = false;// 입금대기 주문여부
        boolean paymentByMileage = false;// 마켓포인트만으로 주문여부
        try {
            if (po.getPaymentAmt() > 0) {
                if ("11".equals(po.getOrderPayPO().getPaymentWayCd())) { // 무통장
                    standBydeposit = true;
                    payResult.setSiteNo(po.getSiteNo());
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentPgCd("00"); // PG코드(내부)
                    payResult.setPaymentWayCd(po.getOrderPayPO().getPaymentWayCd()); // PG코드(내부)
                    payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    payResult.setPaymentAmt(Long.toString(po.getPaymentAmt())); // 결제금액
                    if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) { // 회원번호
                        payResult.setMemberNo(Long.toString(SessionDetailHelper.getDetails().getSession().getMemberNo()));
                    }
                    payResult.setBankCd(request.getParameter("bankCd")); // 은행코드
                    payResult.setActNo(request.getParameter("depositActNo")); // 계좌번호
                    payResult.setHolderNm(request.getParameter("depositHolderNm")); // 예금주명
                    payResult.setDpsterNm(request.getParameter("ordrNm")); // 입금자명
                    payResult.setDpstScdDt((DateUtil.addDays(DateUtil.getNowDate(), 5)) + "235959"); // 입금예정일자(5일)
                    payResult.setRegrNo(po.getRegrNo()); // 등록자
                    payResult.setRegDttm(po.getRegDttm()); // 등록일자
                }

                if (!standBydeposit) {// 무통장 주문이 아니고 외부결제수단(PG)을 사용했을 경우
                    if (CoreConstants.PG_CD_PAYCO.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_PAYPAL.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_ALIPAY.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_TENPAY.equals(po.getOrderPayPO().getPaymentPgCd())
                        || CoreConstants.PG_CD_WECH.equals(po.getOrderPayPO().getPaymentPgCd())
                    ) {
                        // PAYCO,PAYPAL,ALIPAY,TENPAY,WECHPAY
                        // insertOrderPay를 위한 payResult맵핑
                         payResult.setPaymentPgCd(po.getOrderPayPO().getPaymentPgCd()); // 결제PG코드
                         payResult.setPaymentWayCd(po.getOrderPayPO().getPaymentWayCd());// 결제수단코드
                         payResult.setPaymentStatusCd("02"); // 결제상태코드 01: 접수, 02: 완료, 03: 취소

                         payResult.setPaymentCmpltDttm(po.getOrderPayPO().getConfirmDttm());// 결제 완료 일시 값이 들어가야한다.
                         payResult.setPaymentAmt(String.valueOf(po.getOrderPayPO().getPaymentAmt())); // 상품가격
                         payResult.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo())); // 회원 번호

                         po.getOrderPayPO().setTxNo(request.getParameter("txNo")); // 거래번호(paypal은  mid로  사용)
                         po.getOrderPayPO().setConfirmNo(request.getParameter("confirmNo")); // 승인번호(paypal은 tid로 사용)
                         payResult.setConfirmDttm(po.getOrderPayPO().getConfirmDttm());// 승인 일시
                         payResult.setConfirmResultCd(po.getOrderPayPO().getConfirmResultCd());// 승인 결과 코드
                         payResult.setConfirmResultMsg(po.getOrderPayPO().getConfirmResultMsg()); // 승인 결과 메세지


                         // 페이코는 인증과 승인이 분리되어있기때문에 pgPayment를 사용한다.
                        if (CoreConstants.PG_CD_PAYCO.equals(po.getOrderPayPO().getPaymentPgCd())) {
                            log.debug("=== orderPO.orderPayPO : {}", po.getOrderPayPO());
                            payResult = paymentService.pgPaymentMobile(po.getOrderPayPO(), reqMap, mav).getData();
                        }

                    } else {
                        log.debug("=== orderPO.orderPayPO : {}", po.getOrderPayPO());

                        /*if(reqMap.get("P_REQ_URL")!=null && !reqMap.get("P_REQ_URL").equals("")) {*/
                        if (!"21".equals(po.getOrderPayPO().getPaymentWayCd())) {
                            //실시간 계좌이체 외...
                            payResult = paymentService.pgPaymentMobile(po.getOrderPayPO(), reqMap, mav).getData();
                        }else{

                            /*InicisPO childPO = new InicisPO();*/
                            //실시간 계좌이체 모바일 ...
                            Map<String, String> paramMap = new Hashtable<String, String>();
                            Enumeration elems = request.getParameterNames();
                            String temp = "";
                            while (elems.hasMoreElements()) {
                                temp = (String) elems.nextElement();
                                paramMap.put(temp, request.getParameter(temp));
                            }

                            /*ResultModel<PaymentModel<?>> bankResult = new ResultModel<>();*/
                            Map<String, Object> resultMap = new Hashtable<String, Object>();
                            resultMap = orderService.selectIniCisNotiInfo(paramMap);
                            reqMap.putAll(resultMap);

                            payResult = paymentService.pgPaymentMobile(po.getOrderPayPO(), reqMap, mav).getData();

                        }
                    }
                    // 중복매핑되는 변수들은 if else 밖에둔다
                    log.debug("=== orderPO : {}", po);
                    log.debug("=== payResult : {}", payResult);
                    payResult.setSiteNo(po.getSiteNo());
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentStatusCd("02"); // 상태코드(완료)
                    payResult.setSiteNo(po.getSiteNo());
                    payResult.setRegrNo(po.getRegrNo());
                    payResult.setRegDttm(po.getRegDttm());
                }
            } else {
                paymentByMileage = true;
            }
        } catch (Exception e) {
            log.error("PG PAYMENT ERROR : {}", e);
            ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
            err_result.setMessage("PG 통신중 오류가 발생하였습니다.");
            err_result.setSuccess(false);
            return err_result;
        }

        try {
            log.debug("======== payResult.getConfirmResultCd() : {}", payResult.getConfirmResultCd());
            if (paymentByMileage || standBydeposit || (!standBydeposit && ("00".equals(payResult.getConfirmResultCd())
                    || "0000".equals(payResult.getConfirmResultCd())))) {
                // step02.결제정보 등록 Biz실행(PG)
                if (!paymentByMileage) {
                    payResult.setConfirmResultCd("00");
                    payResult.setPaymentTurn("1");
                    // 가상계좌일경우 입금자명에 주문자명 세팅
                    if ("22".equals(payResult.getPaymentWayCd())) {
                        payResult.setDpsterNm(request.getParameter("ordrNm"));
                        payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    }
                    this.insertOrderPay(payResult);
                }

                // step03.결제정보 등록 Biz실행(마켓포인트)
                if (po.getMileageTotalAmt() > 0) {
                    payResult.setOrdNo(po.getOrdNo());
                    payResult.setPaymentPgCd("00"); // PG코드(내부)
                    payResult.setPaymentWayCd("01"); // 결제 수단 코드(마켓포인트)
                    if (standBydeposit) {
                        payResult.setPaymentStatusCd("01"); // 상태코드(접수)
                    } else {
                        payResult.setPaymentStatusCd("02"); // 상태코드(완료)
                    }
                    payResult.setPaymentAmt(Long.toString(po.getMileageTotalAmt())); // 결제금액
                    payResult.setRegrNo(po.getRegrNo()); // 등록자
                    payResult.setRegDttm(po.getRegDttm()); // 등록일자
                    this.insertOrderPay(payResult);

                    // 마켓포인트 사용 정보 등록
                    SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
                    savedmnPointPO.setSiteNo(po.getSiteNo());
                    savedmnPointPO.setOrdNo(Long.toString(po.getOrdNo()));
                    savedmnPointPO.setGbCd("20"); // 차감
                    savedmnPointPO.setOrdCanselYn("N"); // 일반차감
                    savedmnPointPO.setMemberNo(po.getRegrNo()); // 회원번호
                    savedmnPointPO.setTypeCd("M"); // 유형코드(A:자동, M:수동)
                    savedmnPointPO.setReasonCd("03"); // 사유코드(상품구매)
                    savedmnPointPO.setEtcReason(""); // 기타사유
                    savedmnPointPO.setDeductGbCd("01"); // 차감구분코드(사용)
                    savedmnPointPO.setPrcAmt(Long.toString(po.getMileageTotalAmt()));

                    //적립금 분할을 위한 주문 상품 내역 세팅..
                    savedmnPointPO.setOrderGoodsPO(po.getOrderGoodsPO());

                    savedMnPointService.insertSavedMn(savedmnPointPO);
                }

                // step04.쿠폰정보 등록
                String couponUseInfo = "";
                couponUseInfo = request.getParameter("couponUseInfo");
                List<CouponPO> couponList = new ArrayList<>();
                CouponPO couponPO = new CouponPO();
                couponPO.setSiteNo(po.getSiteNo());
                log.debug("===couponUseInfo : {}", couponUseInfo);
                if (!"".equals(couponUseInfo) && couponUseInfo != null) {
                    String couponArr[] = couponUseInfo.split("\\▦");
                    for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
                        OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(i);
                        if ("N".equals(orderGoodsPO.getAddOptYn())) {
                            for (int k = 0; k < couponArr.length; k++) {
                                // 0:아이템번호, 1:회원쿠폰번호, 2:쿠폰번호, 3:할인금액
                                String couponInfoArr[] = couponArr[k].split("\\^");
                                if (couponInfoArr[0].equals(orderGoodsPO.getItemNo())) {
                                    couponPO.setMemberCpNo(Integer.parseInt(couponInfoArr[1]));
                                    couponPO.setOrdNo(orderGoodsPO.getOrdNo());
                                    couponPO.setOrdDtlSeq(orderGoodsPO.getOrdDtlSeq());
                                    couponPO.setCpUseAmt(Long.parseLong(couponInfoArr[3]));
                                    couponPO.setCpKindCd("01");
                                    couponPO.setRegrNo(orderGoodsPO.getRegrNo());
                                    couponPO.setRegDttm(orderGoodsPO.getRegDttm());
                                    couponPO.setUseYn("Y");
                                    couponPO.setUseDttm(orderGoodsPO.getRegDttm());
                                    couponList.add(couponPO);
                                }
                            }
                        }
                    }
                    this.insertCouponUse(couponList);

                    // 회원 쿠폰 사용 정보 등록
                    couponService.updateMemberUseCoupon(couponList);

                }

                String cashRctYn = request.getParameter("cashRctYn"); // N:발급안함,
                                                                      // Y:현금영수증,
                                                                      // B:계산서
                log.debug("===cashRctYn : {}", cashRctYn);
                if ("Y".equals(cashRctYn)) { // 현금영수증
                    if ("Y".equals(payResult.getCashRctYn())) {
                        log.debug("=== 현금영수증 발행 ===");
                        SalesProofPO cashPO = new SalesProofPO();
                        cashPO.setOrdNo(po.getOrdNo());
                        cashPO.setCashRctStatusCd("02"); // 상태코드(01:접수,02:승인,03:오류)
                        cashPO.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자,02:관리자)
                        cashPO.setMemberNo(po.getRegrNo());
                        cashPO.setUseGbCd(payResult.getUseGbCd()); // 사용구분코드(01:소득공제,02:지출증빙)
                        cashPO.setIssueWayCd(payResult.getIssueWayCd()); // 발급수단코드(01:주민등록번호,02:휴대폰,03:사업자등록번호)
                        cashPO.setIssueWayNo(payResult.getIssueWayNo()); // 발급수단번호
                        cashPO.setTotAmt(po.getPaymentAmt()); // 총금액
                        cashPO.setAcceptDttm(po.getRegDttm()); // 접수일시
                        cashPO.setLinkTxNo(payResult.getLinkTxNo());
                        cashPO.setApplicantNm(po.getOrderInfoPO().getOrdrNm()); // 신청자명
                        cashPO.setRegrNo(po.getRegrNo()); // 등록자
                        cashPO.setRegDttm(po.getRegDttm()); // 등록일자
                        salesProofService.insertCashRct(cashPO);
                    }
                } else if ("B".equals(cashRctYn)) { // 계산서
                    log.debug("=== 계산서 발행 ===");
                    SalesProofPO billPO = new SalesProofPO();
                    billPO.setOrdNo(po.getOrdNo());
                    billPO.setTaxBillStatusCd("01"); // 상태코드(01:접수,02:승인,03:오류)
                    billPO.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자, 02:관리자)
                    billPO.setMemberNo(po.getRegrNo());
                    billPO.setCompanyNm(request.getParameter("billCompanyNm")); // 업체명
                    billPO.setBizNo(request.getParameter("billBizNo")); // 사업자번호
                    billPO.setCeoNm(request.getParameter("billCeoNm")); // 대표자명
                    billPO.setBsnsCdts(request.getParameter("billBsnsCdts")); // 업태
                    billPO.setItem(request.getParameter("billItem")); // 종목
                    billPO.setPostNo(request.getParameter("billPostNo")); // 우편번호
                    billPO.setRoadnmAddr(request.getParameter("billRoadnmAddr")); // 도로명
                                                                                  // 주소
                    billPO.setDtlAddr(request.getParameter("billDtlAddr")); // 상세주소
                    billPO.setTotAmt(po.getPaymentAmt() + po.getMileageTotalAmt()); // 총금액
                    billPO.setManagerNm(request.getParameter("billManagerNm")); // 담당자
                    billPO.setEmail(request.getParameter("billEmail")); // 이메일
                    billPO.setTelNo(request.getParameter("billTelNo")); // 연락처
                    billPO.setAcceptDttm(po.getRegDttm()); // 접수일시
                    billPO.setRegrNo(po.getRegrNo()); // 등록자
                    billPO.setRegDttm(po.getRegDttm()); // 등록일자
                    salesProofService.insertTaxBill(billPO);
                }

                // 무통장, 가상계좌가 아니거나 마켓포인트만으로 결제했을 경우 결제완료 처리
                if ((!standBydeposit && !"22".equals(po.getOrderPayPO().getPaymentWayCd())) || paymentByMileage) {
                    // step05.상품테이블 수정(재고변경)- 입금대기 주문의 경우 결제 완료시점에 재고 차감처리
                    this.updateGoodsStock(po.getOrderGoodsPO());
                    // step06.주문상태 수정
                    OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                    orderGoodsVO.setSiteNo(po.getSiteNo());
                    orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
                    orderGoodsVO.setOrdStatusCd("20"); // 결제완료
                    String curOrdStatusCd = "01"; // 주문접수(현재)
                    if (SessionDetailHelper.getDetails().isLogin()) {
                        orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    }else{
                        //비회원
                        orderGoodsVO.setRegrNo((long) 0.00);
                    }
                    this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);
                } else {
                    OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                    orderGoodsVO.setSiteNo(po.getSiteNo());
                    orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
                    orderGoodsVO.setOrdStatusCd("10"); // 주문완료(상태코드:입금확인중)
                    String curOrdStatusCd = "01"; // 주문접수
                    if (SessionDetailHelper.getDetails().isLogin()) {
                        orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    }else{
                        //비회원
                        orderGoodsVO.setRegrNo((long) 0.00);
                    }
                    this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);
                }

                // 장바구니 삭제
                int d = 0;
                List<String> itemNoList = new ArrayList();
                if (SessionDetailHelper.getDetails().isLogin()) { // 회원
                    long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
                    for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
                        OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(i);
                        if ("N".equals(orderGoodsPO.getAddOptYn())) {
                            itemNoList.add(orderGoodsPO.getItemNo());
                            d++;
                        }
                    }
                    String[] itemNoArr = itemNoList.toArray(new String[itemNoList.size()]);
                    BasketSO basketSO = new BasketSO();
                    basketSO.setSiteNo(po.getSiteNo());
                    basketSO.setItemNoArr(itemNoArr);
                    basketSO.setMemberNo(memberNo);
                    List<BasketVO> basketList = frontBasketService.selectBasketByItemNo(basketSO);
                    if (basketList != null && basketList.size() > 0) {
                        for (BasketVO basketVO : basketList) {
                            BasketPO deletePO = new BasketPO();
                            deletePO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                            deletePO.setMemberNo(memberNo);
                            deletePO.setBasketNo(basketVO.getBasketNo());
                            frontBasketService.deleteBasket(deletePO);
                        }
                    }
                } else { // 비회원
                    HttpSession session = request.getSession();
                    List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
                    if (basketSession != null && basketSession.size() > 0) {
                        for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
                            OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(i);
                            if ("N".equals(orderGoodsPO.getAddOptYn())) {
                                for (int k = 0; k < basketSession.size(); k++) {
                                    BasketPO sessionPO = basketSession.get(k);
                                    if (orderGoodsPO.getItemNo().equals(sessionPO.getItemNo())) {
                                        basketSession.remove(k);
                                    }
                                }
                            }
                        }
                    }
                    List<BasketPO> refreshBasketSession = (List<BasketPO>) session.getAttribute("basketSession");
                    if (refreshBasketSession != null && refreshBasketSession.size() == 0) {
                        session.removeAttribute("basketSession");
                    }
                }

                result.setSuccess(true);
            } else {
                // 결제 실패 처리(로그?)
                OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                orderGoodsVO.setSiteNo(po.getSiteNo());
                orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
                orderGoodsVO.setOrdStatusCd("22"); // 결제실패
                OrderGoodsVO curVo = selectCurOrdStatus(orderGoodsVO);
                String curOrdStatusCd = curVo.getOrdStatusCd(); // 현재 상태
                if (SessionDetailHelper.getDetails().isLogin()) {
                    orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                }else{
                    //비회원
                    orderGoodsVO.setRegrNo((long) 0.00);
                }
                this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);

                log.error("주문 결제 실패 에러[{}:{}]", payResult.getConfirmResultCd(), payResult.getConfirmResultMsg());
                ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
                err_result.setMessage("PG결제에 실패하였습니다.");
                err_result.setSuccess(false);
                return err_result;
            }
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
            log.error("주문 결제 등록 에러 : {}", e.getMessage());
            log.error("==== 결제 롤백(취소) start");
            log.error("==== payResult.getPaymentPgCd : {}", payResult);
            if (!standBydeposit && !paymentByMileage) { // 무통장이 아니고 마켓포인트만으로 결제가 아닐때만
                payResult.setPartCancelYn("N"); // Y:부분취소, N:전체취소
                payResult = paymentService.pgPaymentCancelMobile(payResult).getData();
            }

            // 주문상태 수정(실패)
            OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
            orderGoodsVO.setSiteNo(po.getSiteNo());
            orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
            orderGoodsVO.setOrdStatusCd("22"); // 결제실패
            String curOrdStatusCd = "01"; // 주문접수(현재)
            if (SessionDetailHelper.getDetails().isLogin()) {
                orderGoodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            }else{
                //비회원
                orderGoodsVO.setRegrNo((long) 0.00);
            }
            this.updateOrdStatus(orderGoodsVO, curOrdStatusCd);
            log.error("==== 결제 롤백(취소) End ");
            ResultModel<OrderPO> err_result = new ResultModel<OrderPO>();
            err_result.setMessage("주문 결제 정보 등록중 오류가 발생하였습니다.");
            err_result.setSuccess(false);
            return err_result;
        }

        result.setSuccess(true);
        return result;
    }

    /**
     * 인터페이스 주문취소 프로세스 ( 상세 번호 확인 및 취소처리 )
     */
    @Override
    public ResultModel<OrderPayPO> orderCancelAllIf(OrderPO po) throws Exception {

        log.debug(" 주문취소 IF 에서 실행 시작 (주문번호) ::::" + po.getOrdNo());
        int cnt = 0;
        cnt = selectOrderDtlSeqCancelCount(po);

        log.debug(" 주문취소 IF 에서 실행 시작 (상세카운트) ::::" + cnt);

        OrderPayPO opp = new OrderPayPO();
        opp.setOrdNo(po.getOrdNo());

        String strOrdDtlSeq = "";

        for (int x = 1; x < cnt + 1; x++) {
            strOrdDtlSeq += x;
            strOrdDtlSeq += ",";
        }
        String[] ordDtlSeqArr = { strOrdDtlSeq };
        String[] ordNoArr = { Long.toString(po.getOrdNo()) };

        po.setOrdNoArr(ordNoArr);
        po.setOrdDtlSeqArr(ordDtlSeqArr);
        po.setOrderPayPO(opp);
        po.setPartCancelYn("N");
        po.setCancelType("01");
        po.setCancelStatusCd("11"); // 주문취소 상태
        ResultModel<OrderPayPO> result = cancelOrder(po);
        log.debug(" 주문취소 IF 에서 실행 끝 ");
        return result;
    }

    /**
     * 주문 상세 카운트 확인
     */
    @Override
    @Transactional(readOnly = true)
    public Integer selectOrderDtlSeqCancelCount(OrderPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrderDtlSeqCancelCount", po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 09. 01.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문시 사용한 쿠폰 리스트 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 09. 01. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<CouponVO> selectCouponList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectCouponList", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 09. 01.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문시 사용한 매장번호 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 09. 01. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public VisitVO selectStrCode(OrderInfoVO vo) throws Exception {
        return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectStrCode", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 반품신청한 상품 목록 정보를 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<OrderGoodsVO> selectReturnRegistList(ClaimGoodsPO po) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectReturnRegistList", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 반품완료한 상품 목록 정보를 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<OrderGoodsVO> selectReturnConfirmList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectReturnConfirmList", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 환불완료 후 남아있는 주문상세 리스트 정보를 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<OrderGoodsVO> selectRefundConfirmList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectRefundConfirmList", vo);
    }

    /**
     * NOTIE 결제 정보 등록
     * table : TO_PAYMENT_MX
     */
    @Override
    public int insertIniCisNotiInfo(Map<String, String> paramMap) throws Exception {
        return proxyDao.insert(MapperConstants.ORDER_MANAGE + "insertIniCisNotiInfo", paramMap);
    }

     /**
     * NOTIE 결제 정보 조회
     * table : TO_PAYMENT_MX
     */
    @Override
    public Map<String, Object>  selectIniCisNotiInfo(Map<String, String> paramMap) throws Exception {
        return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectIniCisNotiInfo", paramMap);
    }

    /**
     * 다비전코드 조회
     * table : TI_ERP_PRD_MAPPING
     */
	@Override
	public String selectErpItmCode(String mallItmCode) throws Exception {
		return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectErpItmCode", mallItmCode);
	}

    private void ifOrderReg(Map<String, Object> param) throws CustomIfException {
        String ifId = Constants.IFID.ORDER_REG;

        boolean isPartIfOrdReg = false;

        log.debug("ifOrderReg strCode = "+strCode);
        ObjectMapper objectMapper = new ObjectMapper();
        OrderRegReqDTO orderRegReqDTO = objectMapper.convertValue(param, OrderRegReqDTO.class);
        log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ orderRegReqDTO = "+orderRegReqDTO);
        try {
            log.debug("ifOrderReg - orderRegReqDTO = "+orderRegReqDTO);
            // 쇼핑몰 처리부분

            /*OrderMapDTO ordMapDto = mappingService.getErpOrderNo(param.getOrderNo());*/
            OrderMapDTO ordDtlMapDto = null;
            OrderMapDTO ordMapDto = mappingService.getErpOrderNo(orderRegReqDTO);

            if(orderRegReqDTO.getOrdDtlList() != null) {
                if (orderRegReqDTO.getOrdDtlList().size() == 1) {
                    ordDtlMapDto = mappingService.getErpOrderDtlNo(orderRegReqDTO.getOrderNo(), orderRegReqDTO.getOrdDtlList().get(0).getOrdDtlSeq());
                    if(ordDtlMapDto == null) {
                        isPartIfOrdReg = true;
                    }
                } else if (orderRegReqDTO.getOrdDtlList().size() > 1) {
                    for(OrderRegReqDTO.OrderDetailDTO dto : orderRegReqDTO.getOrdDtlList()) {
                        ordDtlMapDto = mappingService.getErpOrderDtlNo(orderRegReqDTO.getOrderNo(), dto.getOrdDtlSeq());
                        if(ordDtlMapDto == null) {
                            isPartIfOrdReg = true;
                            break;
                        }
                    }
                }
            }
            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ordMapDto = "+ordMapDto);
            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ordDtlMapDto = "+ordDtlMapDto);
            // to_ord가 업데이트 되었더라도 to_ord_dtl에 여러게의 주문이 있을때
            // 각각의 주문을 단건으로 처리시 dtl도 고려해야 됨
            if(ordMapDto != null && ordDtlMapDto != null) {
                // 이미 등록된 주문번호 입니다.
                throw new CustomException("ifapi.exception.order.orderno.exist");
            }
            // 여러개의 dtl 주문중 최초 부분 상태 업데이트 후 나머지 주문 상태 업데이트
            if(ordMapDto != null && isPartIfOrdReg) {
                orderRegReqDTO.setPartIfOrdReg(true);
                orderRegReqDTO.setOrdSlip(ordMapDto.getErpOrdSlip());
            } else {
                orderRegReqDTO.setPartIfOrdReg(false);
            }
            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ifOrderReg - orderRegReqDTO = "+orderRegReqDTO);
            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ifOrderReg - ordMapDto = "+ordMapDto);
            // ERP 상품코드로 변경
            for(OrderRegReqDTO.OrderDetailDTO dtlDto : orderRegReqDTO.getOrdDtlList()) {
                if("Y".equals(dtlDto.getAddOptYn())) {
                    // 추가 옵션 상품인 경우 상품코드 설정 안함.
                    continue;
                }

                String erpItmCode = "";
                if(orderRegReqDTO.getOrdRute() != null && !"".equals(orderRegReqDTO.getOrdRute()) && !"3".equals(orderRegReqDTO.getOrdRute())) {
                    if(dtlDto.getOrdRute()!=null && !dtlDto.getOrdRute().equals("3")) { // 셀러 메장픽업은 제외?
                        erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
                        log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ifOrderReg - erpItmCode = "+erpItmCode);
                        if (erpItmCode == null) {
                            // 매핑되지 않은 상품입니다.
                            throw new CustomException("ifapi.exception.product.notmapped");
                        }

                    }
                }
                                            /*String erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
                                            if(erpItmCode == null) {
                                                // 매핑되지 않은 상품입니다.
                                                throw new CustomException("ifapi.exception.product.notmapped");
                                            }*/
                log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ifOrderReg - erpItmCode = "+erpItmCode);
                dtlDto.setErpItmCode(erpItmCode);

            }

            // 회원번호를 ERP회원코드로 변경 (없으면 없는대로 설정)
            if(orderRegReqDTO.getMemNo() != null) {
                orderRegReqDTO.setCdCust(mappingService.getErpMemberNo(orderRegReqDTO.getMemNo()));
            }

            // ERP쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);
            // ResponseDTO 생성
            OrderRegResDTO resDto = new OrderRegResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 저장
            distService.insertOrderInfo(orderRegReqDTO);

            String resParam = JSONObject.fromObject(resDto).toString();
            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ifOrderReg - resParam = "+resParam);
            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, param, resParam, OrderRegResDTO.class);

        } catch (CustomIfException ce) {
            ce.setReqParam(orderRegReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderRegReqDTO, ifId);
        }
    }

    private void ifPurchaseConfirm(Map<String, Object> param) throws CustomIfException {
        String ifId = Constants.IFID.PURCHASE_CONFIRM;

        ObjectMapper objectMapper = new ObjectMapper();
        PurchaseConfirmReqDTO orderRegReqDTO = objectMapper.convertValue(param, PurchaseConfirmReqDTO.class);
        log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ orderRegReqDTO = "+orderRegReqDTO);
        try {
            // 쇼핑몰 처리 부분
            // 쇼핑몰 주문 번호를 ERP 주문번호로 변경
            OrderMapDTO ordMap = mappingService.getErpOrderNo(orderRegReqDTO.getOrderNo());
            if(ordMap == null) {
                // 매핑되지 않은 주문번호입니다.
                throw new CustomException("ifapi.exception.order.orderno.notmapped");
            }
            // ERP주문 Key를 파라미터에 담기
            orderRegReqDTO.setOrdDate(ordMap.getErpOrdDate());
            orderRegReqDTO.setStrCode(ordMap.getErpStrCode());
            orderRegReqDTO.setOrdSlip(ordMap.getErpOrdSlip());

            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ordMap = "+ordMap);
            // 쇼핑몰 주문상세번호를 ERP 주문상세 번호로 변경
            for(PurchaseConfirmReqDTO.PurchaseConfirmOrdDtlDTO dtlDto : orderRegReqDTO.getOrdDtlList()) {
                OrderMapDTO ordDtlMap = mappingService.getErpOrderDtlNo(orderRegReqDTO.getOrderNo(), dtlDto.getOrdDtlSeq());
                if(ordDtlMap == null) {
                    // 매핑되지 않은 주문상세번호입니다.
                    throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");
                }
                dtlDto.setOrdSeq(ordDtlMap.getErpOrderDtlNo());
                dtlDto.setOrdAddNo(ordDtlMap.getErpOrderAddNo());
            }

            // ERP 쪽으로 데이터 전송
            //String resorderRegReqDTO = sendUtil.send(orderRegReqDTO, ifId);
            // ERP 처리 부분
            // Response DTO 생성
            PurchaseConfirmResDTO resDto = new PurchaseConfirmResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 등록
            distService.updateErpPurchaseConfirm(orderRegReqDTO);

            String resParam = JSONObject.fromObject(resDto).toString();
            log.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ resParam = "+resParam);
            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, orderRegReqDTO, resParam, PurchaseConfirmResDTO.class);

        } catch (CustomIfException ce) {
            ce.setReqParam(orderRegReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderRegReqDTO, ifId);
        }
    }

    private void ifMemOffPointUse(Map<String, Object> param) throws CustomIfException {
        String ifId = Constants.IFID.MEM_OFF_POINT_USE;

        ObjectMapper objectMapper = new ObjectMapper();
        OffPointUseReqDTO orderRegReqDTO = objectMapper.convertValue(param, OffPointUseReqDTO.class);

        try {
            // 쇼핑몰 처리 부분
            // 쇼핑몰 회원번호를 다비젼 회원 번호로 변환
            String cdCust = mappingService.getErpMemberNo(orderRegReqDTO.getMemNo());
            if(cdCust == null) {
                // 통합회원이 아닙니다.
                throw new CustomException("ifapi.exception.member.notcombined");
            }
            orderRegReqDTO.setCdCust(cdCust);

            // ERP 쪽으로 전송
            //String resParam = sendUtil.send(param, ifId);

            // ERP 처리 부분
            // Response DTO 생성
            OffPointUseResDTO resDto = new OffPointUseResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 저장
            List<String> seqNoList = memberService.useOfflinePoint(orderRegReqDTO);
            // Response에 순번 목록 설정
            resDto.setErpPointSeq(seqNoList);

            String resParam = JSONObject.fromObject(resDto).toString();

            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, orderRegReqDTO, resParam, OffPointUseResDTO.class);

        } catch (CustomIfException ce) {
            ce.setReqParam(orderRegReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderRegReqDTO, ifId);
        }
    }
}
