package net.danvi.dmall.biz.app.basket.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.danvi.dmall.biz.app.goods.model.CategorySO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basket.model.BasketOptPO;
import net.danvi.dmall.biz.app.basket.model.BasketOptSO;
import net.danvi.dmall.biz.app.basket.model.BasketOptVO;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import net.danvi.dmall.biz.app.goods.model.GoodsCtgVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.model.GoodsItemSO;
import net.danvi.dmall.biz.app.goods.model.GoodsItemVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("frontBasketService")
@Transactional(rollbackFor = Exception.class)
public class FrontBasketServiceImpl extends BaseService implements FrontBasketService {

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Override
    @Transactional(readOnly = true)
    public Integer selectBasketTotalCount(BasketSO so) {
        return proxyDao.selectOne(MapperConstants.BASKET + "selectBasketListPagingTotalCount", so);
    }

    @Override
    @Transactional(readOnly = true)
    public List<BasketVO> selectBasketList(BasketSO so) throws Exception {
        List<BasketVO> basketInfoList = proxyDao.selectList(MapperConstants.BASKET + "selectBasketList", so);
        for (int i = 0; i < basketInfoList.size(); i++) {
            BasketVO bvo = basketInfoList.get(i);
            BasketOptSO optSo = new BasketOptSO();

            // 옵션조회
            optSo.setBasketNo(bvo.getBasketNo());
            optSo.setGoodsNo(bvo.getGoodsNo());
            optSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            List<BasketOptVO> basketOptInfoList = proxyDao.selectList(MapperConstants.BASKET + "selectBasketOptList",optSo);
            int addTotalPrice = 0;
            int addBuyQtt = 0;
            int addPrice = 0;
            if (basketOptInfoList != null) {
                for (int j = 0; j < basketOptInfoList.size(); j++) {
                    BasketOptVO optVo = basketOptInfoList.get(j);
                    addBuyQtt = optVo.getOptBuyQtt();
                    String addOptAmtChgCd = optVo.getAddOptAmtChgCd();

                    addPrice = optVo.getAddOptAmt();
                    if ("2".equals(addOptAmtChgCd)) {
                        addPrice = -addPrice;
                    }
                    addTotalPrice = addTotalPrice + addBuyQtt * addPrice;
                }
            }
            bvo.setBasketOptList(basketOptInfoList);

            // 금액계산
            int buyQtt = bvo.getBuyQtt();
            int salePrice = (int) bvo.getSalePrice();
            int dcAmt = (int) bvo.getDcAmt();
            int totalPrice = salePrice * buyQtt - dcAmt + addTotalPrice;
            bvo.setBuyQtt(buyQtt);
            bvo.setSalePrice(salePrice);
            bvo.setTotalPrice(totalPrice);
        }
        return basketInfoList;
    }

    @Override
    @Transactional(readOnly = true)
    public BasketOptVO addOptInfo(BasketOptSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectOne(MapperConstants.BASKET + "selectAddOptInfo", so);
    }

    @Override
    public ResultModel<BasketPO> insertBasket(BasketPO po) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        boolean isMobile = SiteUtil.isMobile();
        GoodsItemSO so = new GoodsItemSO();

        if ("Y".equals(po.getDelChkYn())) {
            if ("Y".equals(po.getDelItemYn())) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                proxyDao.delete(MapperConstants.BASKET + "deleteBasket", po);
                proxyDao.delete(MapperConstants.BASKET + "deleteBasketAddOpt", po);
            } else {
                BasketOptPO optPo = new BasketOptPO();
                optPo.setBasketNo(po.getBasketNo());
                if (po.getDelBasketAddOptNo() != null) {
                    for (int d2 = 0; d2 < po.getDelBasketAddOptNo().length; d2++) {
                        optPo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                        optPo.setBasketNo(po.getBasketNo());
                        optPo.setBasketAddOptNo(po.getDelBasketAddOptNo()[d2]);
                        proxyDao.delete(MapperConstants.BASKET + "deleteBasketAddOpt", optPo);
                    }
                }
            }
        }

        if (po.getItemNoArr() != null && po.getItemNoArr().length > 0) {
            for (int i = 0; i < po.getItemNoArr().length; i++) {
                String itemNo = po.getItemNoArr()[i];

                // 단품 버전 조회
                so.setGoodsNo(po.getGoodsNo());
                so.setItemNo(itemNo);
                so.setSiteNo(po.getSiteNo());
                GoodsItemVO goodsItemVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectItemInfo", so);

                // 장바구니 등록
                HttpServletRequest request = HttpUtil.getHttpServletRequest();
                String dlvrMethodCd = request.getParameter("dlvrMethodCd"); // 택배/매장픽업
                String dlvrcPaymentCd = request.getParameter("dlvrcPaymentCd"); // 무료(01)/선불(02)/착불(03)
                if ("01".equals(dlvrMethodCd)) { // 택배
                    po.setDlvrcPaymentCd(dlvrcPaymentCd);
                } else if ("02".equals(dlvrMethodCd)) { // 매장픽업
                    po.setDlvrcPaymentCd("04");
                }
                po.setItemVer(goodsItemVO.getItemVer());
                po.setAttrVer(goodsItemVO.getAttrVer());
                po.setItemNo(itemNo);
                po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                if (isMobile) {
                    po.setOrdMediaCd("02");
                } else {
                    po.setOrdMediaCd("01");
                }

                GoodsDetailSO gso = new GoodsDetailSO();
                // 01.상품기본정보 조회
                gso.setSiteNo(so.getSiteNo());
                gso.setGoodsNo(so.getGoodsNo());
                gso.setSaleYn("Y");
                gso.setDelYn("N");
                String[] goodsStatus = { "1", "2" };
                gso.setGoodsStatus(goodsStatus);
                ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(gso);

                // 10.네비게이션 조회
                CategorySO cs = new CategorySO();
                cs.setSiteNo(so.getSiteNo());
                for (int j = 0; j < goodsInfo.getData().getGoodsCtgList().size(); j++) {
                    GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(j);
                    if(j == 0) {
                    	po.setCtgNo(gcvs.getCtgNo());
                    }
                    if ("Y".equals(gcvs.getDlgtCtgYn())) {
                        po.setCtgNo(gcvs.getCtgNo());
                    }
                }

                // 중복확인
                BasketVO vo =  proxyDao.selectOne(MapperConstants.BASKET + "duplicationBasketCheck", po);
                if (vo==null) { // 등록
                    po.setBasketNo((int) (long) bizService.getSequence("BASKET_NO", po.getSiteNo()));
                    po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    if (po.getBuyQttArr() != null && po.getBuyQttArr().length > 0) {
                        po.setBuyQtt(po.getBuyQttArr()[i]);
                    } else {
                        po.setBuyQtt(1);
                    }
                    proxyDao.insert(MapperConstants.BASKET + "insertBasket", po);

                    // 장바구니 분석 데이터 등록
                    insertBasketAnls(po);
                    
                    
                } else { // 수정
                    po.setBasketNo(vo.getBasketNo());
                    int buyQtt = po.getBuyQttArr()[i];

                    if (po.getNoBuyQttArr() != null && po.getNoBuyQttArr().length > 0) {
                        String noBuyQtt = po.getNoBuyQttArr()[i];
                        if (!"Y".equals(noBuyQtt)) {
                            buyQtt = buyQtt + po.getBuyQtt();
                        }
                    }
                    po.setBuyQtt(buyQtt);
                    proxyDao.update(MapperConstants.BASKET + "updateBasket", po);
                }
                
                // 장바구니 추가옵션 등록
                if (po.getAddOptNoArr() != null && po.getAddOptNoArr().length > 0) {
                    BasketOptPO optPO = new BasketOptPO();
                    optPO.setSiteNo(po.getSiteNo());
                    optPO.setRegrNo(po.getRegrNo());
                    optPO.setUpdrNo(po.getUpdrNo());
                    for (int j = 0; j < po.getAddOptNoArr().length; j++) {
                        optPO.setOptNo(po.getAddOptNoArr()[j]);
                        optPO.setOptDtlSeq(po.getAddOptDtlSeqArr()[j]);
                        optPO.setOptVer(po.getAddOptVerArr()[j]);
                        optPO.setOptBuyQtt(po.getAddOptBuyQttArr()[j]);
                        optPO.setBasketNo(po.getBasketNo());

                        // 중복확인
                        BasketOptVO bo = proxyDao.selectOne(MapperConstants.BASKET + "duplicationBasketAddOptCheck", optPO);
                        if (bo == null) {// 등록
                            if (po.getBuyQttArr() != null && po.getBuyQttArr().length > 0) {
                                optPO.setOptBuyQtt(po.getAddOptBuyQttArr()[j]);
                            } else {
                                optPO.setOptBuyQtt(1);
                            }
                            proxyDao.insert(MapperConstants.BASKET + "insertBasketAddOpt", optPO);
                        } else {// 수정
                            optPO.setBasketNo(bo.getBasketNo());
                            optPO.setBasketAddOptNo(bo.getBasketAddOptNo());
                            int buyQtt = po.getAddOptBuyQttArr()[j];
                            String addNoBuyQtt = po.getAddNoBuyQttArr()[j];
                            if (!"Y".equals(addNoBuyQtt)) {
                                buyQtt = buyQtt + bo.getOptBuyQtt();
                            }
                            optPO.setOptBuyQtt(buyQtt);
                            proxyDao.insert(MapperConstants.BASKET + "updateBasketAddOpt", optPO);
                        }
                    }
                }
                
                po.setBasketNo(null);
            }
        }

        return result;
    }

    @Override
    public ResultModel<BasketPO> insertBasketSession(BasketPO po, HttpServletRequest request) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        HttpSession session = request.getSession();

        if ("Y".equals(po.getDelChkYn())) {
            List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
            for (int d = 0; d < basketSession.size(); d++) {
                if (po.getOldItemNo().equals(basketSession.get(d).getItemNo())) {
                    if ("Y".equals(po.getDelItemYn())) {
                        basketSession.remove(basketSession.get(d));
                    } else {
                        for (int d2 = 0; d2 < po.getDelAddOptNo().length; d2++) {
                            List<BasketOptPO> basketOptSession = basketSession.get(d).getBasketOptList();
                            int basketOptSessionCnt = basketOptSession.size();

                            for (int d3 = 0; d3 < basketOptSessionCnt; d3++) {
                                if (po.getDelAddOptNo()[d2] == basketOptSession.get(d3).getAddOptNo()
                                        && po.getDelAddOptDtlSeq()[d2] == basketOptSession.get(d3).getAddOptDtlSeq()) {
                                    basketSession.get(d).getBasketOptList().remove(d3);
                                    basketOptSessionCnt = basketOptSessionCnt - 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        GoodsItemSO so = new GoodsItemSO();
        for (int i = 0; i < po.getItemNoArr().length; i++) {
            int buyQtt = 0;
            String itemNo = po.getItemNoArr()[i];
            if (po.getBuyQttArr() != null && po.getBuyQttArr().length > 0) {
                buyQtt = po.getBuyQttArr()[i];
            } else {
                buyQtt = 1;
            }
            // 단품 버전 조회
            so.setGoodsNo(po.getGoodsNo());
            so.setItemNo(itemNo);
            so.setSiteNo(po.getSiteNo());
            GoodsItemVO goodsItemVO = new GoodsItemVO();
            goodsItemVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectItemInfo", so);

            BasketPO basketValuePO = new BasketPO();
            String dlvrMethodCd = request.getParameter("dlvrMethodCd"); // 택배/매장픽업
            String dlvrcPaymentCd = request.getParameter("dlvrcPaymentCd"); // 무료(01)/선불(02)/착불(03)

            if ("01".equals(dlvrMethodCd)) { // 택배
                basketValuePO.setDlvrcPaymentCd(dlvrcPaymentCd);
            } else if ("02".equals(dlvrMethodCd)) { // 매장픽업
                basketValuePO.setDlvrcPaymentCd("04");
            }

            if (basketValuePO.getDlvrcPaymentCd() == null || "".equals(basketValuePO.getDlvrcPaymentCd())) {
                deliverySetting(po.getGoodsNo(), basketValuePO, po.getSiteNo());
            }

            basketValuePO.setItemNo(po.getItemNoArr()[i]);
            basketValuePO.setGoodsNo(po.getGoodsNo());
            if (goodsItemVO != null) {
                basketValuePO.setAttrVer(goodsItemVO.getAttrVer());
                basketValuePO.setItemVer(goodsItemVO.getItemVer());
            }

            basketValuePO.setBuyQtt(buyQtt);

            GoodsDetailSO gso = new GoodsDetailSO();
            // 01.상품기본정보 조회
            gso.setSiteNo(po.getSiteNo());
            gso.setGoodsNo(po.getGoodsNo());
            gso.setSaleYn("Y");
            gso.setDelYn("N");
            String[] goodsStatus = { "1", "2" };
            gso.setGoodsStatus(goodsStatus);
            ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(gso);

            // 10.네비게이션 조회
            CategorySO cs = new CategorySO();
            cs.setSiteNo(so.getSiteNo());
            for (int j = 0; j < goodsInfo.getData().getGoodsCtgList().size(); j++) {
                GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(j);
                if(j == 0) {
                	basketValuePO.setCtgNo(gcvs.getCtgNo());
                }
                if ("Y".equals(gcvs.getDlgtCtgYn())) {
                    basketValuePO.setCtgNo(gcvs.getCtgNo());
                }
            }

            // 장바구니 추가옵션 등록
            List<BasketOptPO> basketOptList = new ArrayList<BasketOptPO>();
            if (i == po.getItemNoArr().length - 1) {
                if (po.getAddOptNoArr() != null && po.getAddOptNoArr().length > 0) {
                    for (int j = 0; j < po.getAddOptNoArr().length; j++) {
                        BasketOptPO optPO = new BasketOptPO();
                        optPO.setSiteNo(po.getSiteNo());
                        optPO.setAddOptNo(po.getAddOptNoArr()[j]);
                        optPO.setAddOptDtlSeq(po.getAddOptDtlSeqArr()[j]);
                        optPO.setOptVer(po.getAddOptVerArr()[j]);
                        optPO.setOptBuyQtt(po.getAddOptBuyQttArr()[j]);
                        optPO.setAddOptAmt(po.getAddOptAmtArr()[j]);
                        basketOptList.add(optPO);
                    }
                }
            }

            List<BasketPO> basketSession = new ArrayList<BasketPO>();
            int basketSessionCnt = 0;
            boolean itemNoChk = false;
            List<BasketOptPO> basketOptSession = new ArrayList<BasketOptPO>();
            int basketOptSessionCnt = 0;
            boolean addOptChk = false;
            List<Integer> tempList = new ArrayList<>(); // basketNo 갱신용 리스트

            if (session.getAttribute("basketSession") != null) {
                basketSession = (List<BasketPO>) session.getAttribute("basketSession");
                basketSessionCnt = basketSession.size();

                // po.getBasketNo()이 null이라면 메인페이지, 카테고리페이지, 상품상세에서 장바구니 등록을 시도한 것이다.
                // po.getBasketNo()이 null이 아니라면 장바구니에서 옵션변경을 시도한 것이다.
                if (po.getBasketNo() == null) {
                    for (int j = 0; j < basketSessionCnt; j++) {
                        // basketNo 갱신용
                        tempList.add(basketSession.get(j).getBasketNo());
                        // 기존 장바구니에 같은 상품이 등록되어 있다면 업데이트
                        if (itemNo.equals(basketSession.get(j).getItemNo())) {
                            itemNoChk = true;

                            // 어차피 장바구니에 등록되어 있던 상품이기때문에 수량을 무조건 더한다.
                            String[] noBuyQttArr = new String[1];
                            noBuyQttArr[0] = "N";
                            po.setNoBuyQttArr(noBuyQttArr);

                            if (po.getNoBuyQttArr() != null) {
                                String noBuyQtt = po.getNoBuyQttArr()[i];
                                if (!"Y".equals(noBuyQtt)) {
                                    buyQtt = buyQtt + basketSession.get(j).getBuyQtt();
                                }
                            }

                            basketSession.get(j).setBuyQtt(buyQtt);

                            // 배송비 기존과틀리다면 갱신
                            if (basketValuePO.getDlvrcPaymentCd() != null
                                    && basketSession.get(j).getDlvrcPaymentCd() != null) {
                                if (!basketValuePO.getDlvrcPaymentCd()
                                        .equals(basketSession.get(j).getDlvrcPaymentCd())) {
                                    basketSession.get(j).setDlvrcPaymentCd(basketValuePO.getDlvrcPaymentCd());
                                }
                            }

                            // 추가 옵션
                            if (i == po.getItemNoArr().length - 1) {
                                if (po.getAddOptNoArr() != null) {
                                    for (int k = 0; k < po.getAddOptNoArr().length; k++) {
                                        long addOptNo = po.getAddOptNoArr()[k];
                                        long addOptDtlSeq = po.getAddOptDtlSeqArr()[k];
                                        int optBuyQtt = po.getAddOptBuyQttArr()[k];

                                        basketOptSession = basketSession.get(j).getBasketOptList();

                                        if (basketOptSession != null) {
                                            basketOptSessionCnt = basketOptSession.size();

                                            for (int k2 = 0; k2 < basketOptSessionCnt; k2++) {
                                                if (addOptNo == basketOptSession.get(k2).getAddOptNo()
                                                        && addOptDtlSeq == basketOptSession.get(k2).getAddOptDtlSeq()) {
                                                    addOptChk = true;
                                                    String addNoBuyQtt = po.getAddNoBuyQttArr()[i];
                                                    if (!"Y".equals(addNoBuyQtt)) {
                                                        optBuyQtt = optBuyQtt + basketOptSession.get(k2).getOptBuyQtt();
                                                    }

                                                    if (i == po.getItemNoArr().length - 1) {

                                                        basketSession.get(j).getBasketOptList().get(k2)
                                                                .setOptBuyQtt(optBuyQtt);
                                                    }
                                                }
                                            }

                                            if (addOptChk) {
                                                addOptChk = false;
                                            } else {
                                                if (i == po.getItemNoArr().length - 1) {
                                                    BasketOptPO optPO = new BasketOptPO();
                                                    optPO.setSiteNo(po.getSiteNo());
                                                    optPO.setAddOptNo(po.getAddOptNoArr()[k]);
                                                    optPO.setAddOptDtlSeq(po.getAddOptDtlSeqArr()[k]);
                                                    optPO.setOptVer(po.getAddOptVerArr()[k]);
                                                    optPO.setOptBuyQtt(po.getAddOptBuyQttArr()[k]);
                                                    optPO.setAddOptAmt(po.getAddOptAmtArr()[k]);
                                                    basketSession.get(j).getBasketOptList().add(optPO);
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                basketSession.get(j).setBasketOptList(null);
                            }
                        }
                    }

                    // 장바구니 세션이 존재해서 for문은 돌았으나 중복상품이 없는경우 신규등록한다.
                    if (itemNoChk) {

                    } else {
                        // 신규등록시 장바구니 세션값에 제일큰 basketNo을 가져온뒤 1을 더한다.
                        Collections.sort(tempList);
                        basketValuePO.setBasketNo(tempList.get(tempList.size() - 1) + 1);

                        basketValuePO.setBasketOptList(basketOptList);
                        basketSession.add(basketValuePO);
                    }
                } else {
                    // 기존에 등록되어 있던 상품을 제거하고 새로 등록한다.
                    for (int a = 0; a < basketSession.size(); a++) {
                        BasketPO tempVo = basketSession.get(a);
                        if (tempVo.getBasketNo().equals(po.getBasketNo())) {
                            basketSession.remove(a);
                            basketValuePO.setBasketNo(po.getBasketNo());
                            basketValuePO.setBasketOptList(basketOptList);
                            basketSession.add(a, basketValuePO);
                        }
                    }
                }
            } else { // 장바구니 데이터가 존재하지 않기때문에 신규 등록
                basketValuePO.setBasketNo(0); // tempBasketSession이 null이라면 최초등록 basketNo은 무조건 0이 들어갈것이다.
                basketValuePO.setBasketOptList(basketOptList);
                basketSession.add(basketValuePO);
            }

            session.setAttribute("basketSession", basketSession);
        }

        // 비회원은 basketNo을 장바구니 리스트의 index로 사용하기 때문에 등록, 삭제이벤트가 발생하면 basketNo을 무조건 0부터 새로 부여한다.
        nonMemberInitBasketNo(request);

        return result;
    }

    @Override
    public ResultModel<BasketPO> updateBasketCnt(BasketPO po) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.BASKET + "updateBasket", po);
        /*result.setMessage(MessageUtil.getMessage("biz.common.update"));*/
        return result;
    }

    @Override
    public ResultModel<BasketPO> updateBasketCntSession(BasketPO po, HttpServletRequest request) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        HttpSession session = request.getSession();
        List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
        basketSession.get(po.getSessionIndex()).setBuyQtt(po.getBuyQtt());
        // 쿠키 장바구니 상품 수정
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    @Override
    public ResultModel<BasketPO> deleteBasket(BasketPO po) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.BASKET + "deleteBasketAddOpt", po);
        proxyDao.delete(MapperConstants.BASKET + "deleteBasket", po);

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    public ResultModel<BasketPO> deleteBasketSession(BasketPO po, HttpServletRequest request) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        HttpSession session = request.getSession();
        List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");

        if ("Y".equals(po.getAllDeleteFlag())) {
            basketSession.remove(po.getSessionIndex());
        } else {
            if (basketSession != null) {
                for (int i = 0; i < basketSession.size(); i++) {
                    // view에서 넘어온 basketNo과 세션에 담긴 basketNo이 같아야 삭제한다.
                    if (i == po.getSessionIndex()) {
                        basketSession.remove(po.getSessionIndex());
                    }
                }
            }
        }

        // 비회원은 basketNo을 장바구니 리스트의 index로 사용하기 때문에 등록, 삭제이벤트가 발생하면 basketNo을 무조건 0부터 새로 부여한다.
        nonMemberInitBasketNo(request);

        List<BasketPO> refreshBasketSession = (List<BasketPO>) session.getAttribute("basketSession");
        if (refreshBasketSession != null && refreshBasketSession.size() == 0) {
            session.removeAttribute("basketSession");
        }

        // 쿠키 장바구니 상품 삭제
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    public List<BasketVO> selectBasketByItemNo(BasketSO so) throws Exception {
        List<BasketVO> list = new ArrayList();
        list = proxyDao.selectList(MapperConstants.BASKET + "selectBasketByItemNo", so);
        return list;
    }

    /** Item 단건 조회 **/
    @Override
    public BasketVO selectItemInfo(BasketSO so) throws Exception {
        return proxyDao.selectOne(MapperConstants.BASKET + "selectItemInfo", so);
    }

    public BasketVO promotionDcInfo(BasketVO vo) throws Exception {
        // 기획전 할인정보 조회
        ExhibitionSO pso = new ExhibitionSO();
        pso.setSiteNo(vo.getSiteNo());
        pso.setGoodsNo(vo.getGoodsNo());
        pso.setPrmtBrandNo(vo.getBrandNo());
        ResultModel<ExhibitionVO> exhibitionVO = exhibitionService.selectExhibitionByGoods(pso);
        if (exhibitionVO.getData() != null) {
            vo.setPrmtDcGbCd(exhibitionVO.getData().getPrmtDcGbCd());//기획전 할인 구분 코드
            vo.setDcRate(exhibitionVO.getData().getPrmtDcValue()); // 기획전 할인율/할인금액
            vo.setFirstBuySpcPrice(exhibitionVO.getData().getFirstBuySpcPrice()); // 첫구매가격
            vo.setPrmtTypeCd(exhibitionVO.getData().getPrmtTypeCd()); // 기획전 유형 코드
        }
        return vo;
    }

    public ResultModel<BasketPO> insertBasketAnls(BasketPO po) {
        ResultModel<BasketPO> result = new ResultModel<>();

        try {
            proxyDao.insert(MapperConstants.BASKET + "insertBasketAnls", po);
            result.setSuccess(true);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
            log.error("장바구니 통계데이터 등록 ERROR {}", e.getMessage());
        }
        return result;
    }

    private void deliverySetting(String goodsNo, BasketPO bpo, Long siteNo) {
        GoodsDetailSO dso = new GoodsDetailSO();
        dso.setGoodsNo(goodsNo);
        GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo", dso);
        // 상품의 배송비 설정이 기본배송비라면 [설정]의 [배송설정메뉴] 정책을 가져와서 적용한다.
        // DLVR_SET_CD: 1:기본배송비, 2:상품별 배송비(무료), 3:상품별 배송비(유료), 4:포장단위별 배송비
        // DLVR_PAYMENT_KIND_CD: 1:선불, 2:착불, 3:선불+착불
        if ("1".equals(goodsDetailVO.getDlvrSetCd())) {
            DeliveryConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_DELIVERY + "selectDeliveryConfig",
                    siteNo);
            if ("1".equals(resultVO.getDefaultDlvrcTypeCd())) { // 무료
                bpo.setDlvrcPaymentCd("01");
            } else { // 유료
                if ("1".equals(resultVO.getDlvrPaymentKindCd()) || "3".equals(resultVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("02");
                } else if ("2".equals(resultVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("03");
                } else if ("4".equals(resultVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("04");
                }
            }
        } else { // 상품의 배송비 설정이 기본배송비가 아니라면 상품의 배송비 결제방식을 적용한다.
            if ("2".equals(goodsDetailVO.getDlvrSetCd())) { // 무료
                bpo.setDlvrcPaymentCd("01");
            } else { // 유료
                if ("1".equals(goodsDetailVO.getDlvrPaymentKindCd())
                        || "3".equals(goodsDetailVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("02");
                } else if ("2".equals(goodsDetailVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("03");
                }
            }
        }
    }

    private void nonMemberInitBasketNo(HttpServletRequest request) {
        HttpSession session = request.getSession();
        // 비회원은 항시 basketNo을 0부터 초기화 한다.
        List<BasketPO> initList = (List<BasketPO>) session.getAttribute("basketSession");
        for (int i = 0; i < initList.size(); i++) {
            BasketPO tempPo = initList.get(i);
            tempPo.setBasketNo(i);
        }
    }
}
