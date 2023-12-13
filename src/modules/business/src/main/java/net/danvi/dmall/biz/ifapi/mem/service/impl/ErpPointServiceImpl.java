package net.danvi.dmall.biz.ifapi.mem.service.impl;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.manage.model.*;
import net.danvi.dmall.biz.ifapi.mem.dto.*;
import net.danvi.dmall.biz.ifapi.mem.service.ErpPointService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 2023-05-28 210
 * erp 와 포인트 통합 관련 따로 빼서 관리
 * **/

@Slf4j
@Service("erpPointService")
@Transactional(rollbackFor = Exception.class)
public class ErpPointServiceImpl extends BaseService implements ErpPointService {

    /**
     * 2023-05-29 210
     * 어드민에서 설정된 포인트값 가져오기, 기본배송정책도..
     * **/
    @Override
    public AdminPointConfigVO selectPointConfig() {
        long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        AdminPointConfigVO resultVO = proxyDao.selectOne("erp.point.selectAdminPointSetting", siteNo);
        return resultVO;
    }

    /**
     * 2023-05-28 210
     * 가맹점 포인트 조회
     */
    @Override
    public int getfranchiseePoint(String f_sCdCust) throws Exception {
        OffPointSearchReqDTO param = new OffPointSearchReqDTO();
        param.setCdCust(f_sCdCust);
        return proxyDao.selectOne("erp.point.selectOfflineAvailPoint", param);
    }

    /**
     * 2023-05-31 210
     * 이알피에서 회원의 디포인트 하나 조회
     **/
    @Override
    public MemberDPointErpDTO getErpMemberDPointOne(String f_sCdCust) throws Exception {
        Map map = new HashMap();
        map.put("cd_cust", f_sCdCust);      /* erp회원번호 */
        /**
         * erp 포인트 조회할때 함수 FNC_POINT_CAL_NEW00@DAVISION 여기서 받아옷값이 맵핑할때가 문제인건지
         * 오류가 생긴다.. 어차피 몰쪽에서 로그를 쌓고 있기때문에 일단 쿼리에주석을 쳐놧다.. 이건 한차장님과 이야기 해봐야함
         * 원인 찾앗다.. pm2 로 아파치 실행해서 그럼..참내.. java -jar 로 해야됨 os나 환경에 따라 추가 옵션이 필요할수도잇음
         * **/
        MemberDPointErpDTO memberDPointErpDTO = proxyDao.selectOne("erp.point.getErpMemberDPointList", map);
        return memberDPointErpDTO;
    }

    /**
     * 2023-06-01 210
     * 우리쪽에 쌓은 디포인트 로그 회원의 디포인트 페이징 조회
     * 이알피에 쌓은 포인트 로그는 어떤이유의 포인트인지 알수없어 마켓쪽에서 따로쌓게 만들어놧다 그걸로 조회하면됨
     * 마켓 멤버 넘버로 해도되지만 원본은 이알피에 있는거라 나중에 이중체크 하기 쉽게 그냥 이알피 회원 번호로 조회한다.
     **/
    @Override
    public ResultListModel<MemberDPointErpVO> getErpMemberDPointPaging(MemberDPointErpSO so) throws Exception {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("ASC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        ResultListModel<MemberDPointErpVO> list = proxyDao.selectListPage("erp.point.getErpMemberDPointListPaging", so);
        return list;
    }

    /**
     * 2023-07-02 210
     * 지점별 적립된 총 포인트
     * **/
    private List<MemberStoreGroupDPointErpVO> getErpMemberStoreGroupDPoint(MemberStoreGroupDPointErpSO so) throws Exception {
        List<MemberStoreGroupDPointErpVO> list = proxyDao.selectList("erp.point.getErpMemberStoreGroupDPoint", so);
        return list;
    }
    /**
     * 2023-07-03 210
     * 선입 선출을 위한 선입지점리스트
     * **/
    private List<MemberStoreGroupDPointErpVO> getErpMemberStoreDetalHeadDPoint(MemberStoreGroupDPointErpSO so) throws Exception {
        List<MemberStoreGroupDPointErpVO> list = proxyDao.selectList("erp.point.getErpMemberStoreDetalHeadDPoint", so);
        return list;
    }
    /**
     * 2023-07-02 210
     * 취소시 지점별 원복해줘야할 포인트 로그
     * **/
    public List<MemberDPointErpVO> getOrdStoreUseDPoint(MemberDPointErpSO so) throws Exception {
        List<MemberDPointErpVO> list = proxyDao.selectList("erp.point.getOrdStoreUseDPoint", so);
        return list;
    }

    /**
     * 2023-05-29 210
     * 구매한상품 즉 구매완료상태인(취소나 환불등의 것들은 제외해야됨) 상품들의 내가 쓴리뷰개수와 차이를 비교하여
     * 포인트를 지급 할것인지
     * **/
    public int getGoodsReviewIsPoint(long f_sMemberNo, String f_sGoodsNo) throws Exception {
        Map map = new HashMap();
        map.put("memberno", f_sMemberNo);      /* 리뷰회원번호 */
        map.put("goodsno", f_sGoodsNo);    /* 리뷰작성하는 상품 번호 */
        Integer isCnt = proxyDao.selectOne("erp.point.getGoodsReviewIsPoint", map);
        int fm_nIsPoint = 0;
        if(isCnt != null && isCnt > 0){
            fm_nIsPoint = isCnt;
        }else{
            fm_nIsPoint = 0;
        }
        return fm_nIsPoint;
    }

    /**
     * 2023-05-28 210
     * 회원 통합 DPoint 컨트롤
     * **/
    @Override
    public void ErpMemberDPoint(MemberDPointErpVO param) throws Exception {
        Map map = new HashMap();
        map.put("a_dates", param.getDates());      /* 영업일자 */
        map.put("a_cd_cust", param.getCdcust());    /* 회원번호 */
        map.put("a_in_flag", param.getInflag());    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
        map.put("a_pdate", param.getPdate());      /* 적용일자 */
        map.put("a_str_code",param.getStrcode());   /* 가맹점코드 */
        map.put("a_canc_type",param.getCanctype());  /* 0:정상/2:반품 */
        map.put("a_sal_amt", param.getSalamt());    /* 구매총금액 */
        map.put("a_payamt01", param.getPayamt01());   /* [현금]정산금액 */
        map.put("a_payamt02", param.getPayamt02());   /* [카드]정산금액 */
        map.put("a_payamt03", param.getPayamt03());   /* 포인트사용 금액 */
        map.put("a_sal_point", param.getSalpoint());  /* 발생포인트*/
        map.put("a_cd_no", param.getCdno());      /* 카드번호 */
        map.put("a_str_code_to", param.getStr_code_to());/* 포인트 사용 체인점 코드 */

        //210 dubug210 테스트라서 아래 두줄 은 erp에서 구분하기위해 나중에없애야함
//        map.put("a_str_code", "8888");   /* 가맹점코드 */
//        map.put("a_str_code_to", "0000");/* 포인트 사용 체인점 코드 */

        //로그용 데이터
        map.put("dtype", param.getDtype());      /* 이벤트종류 */
        map.put("goodsno", param.getGoodsno());      /* 리뷰상품번호 */
        map.put("ordno", param.getOrdno());      /* 주문번호 */
        map.put("memberno", param.getMemberno());      /* 포인트발생 회원번호 */
        map.put("ordseq", param.getOrdSeq());

        try {
            proxyDao.selectOne("erp.point.ErpMemberDPoint", map);
            //몰쪽에서 이벤트발생 통합 디포인트 로그를 쌓아 erp 와 문제가 발생시 추적용
            /**
             * 2023-07-05 210
             * 변경내용
             * 오프라인에서 만약 포인트를 적립하거나 사용시 우리쪽에 오는 신호가 없어 seq가 꼬일수있음
             * 이알피에데이터를 넣고 바로 넣은 데이터의 시퀀스를 조회해서 우리쪽에적용함 날짜+멤버넘버 +1 로 들어가고 가져올땐 이걸그냥 가져와서 적용하면됨
             * 이전에 뭐가 쌓이던 우리쪽에 없다면 오프라인용으로 취급
             * **/
            int fm_nErpSeq = proxyDao.selectOne("erp.point.selectERPDPointSeqCreate", map);
            map.put("erpseqno", fm_nErpSeq);
            proxyDao.insert("erp.point.insertMallDPointLog", map);
        }catch(Exception e){
            e.printStackTrace();
            throw new CustomException("포인트 컨트롤러 오류");
        }
//        if(map.get("o_RETURN").toString().compareTo("0") == 0){
//            //정상 입력됨.
//
//        }else{
//            throw new CustomException(map.get("o_MESSAGE").toString());
//        }
//        return map;
    }

    /**
     * 2023-05-28 210
     * 회원가입 포인트 제공
     */
    @Override
    public void RegisterMemberPoint(MemberDPointCtVO user) throws Exception{
        if(user.getCdCust() == null || user.getCdCust().equals("")
                || user.getMemberCardNo() == null || user.getMemberCardNo().equals("")){
            throw new CustomException("회원가입 포인트 지급 오류");
        }
        AdminPointConfigVO adminPointConfigVO = this.selectPointConfig();//어드민 포인트 조회
        int fm_nFirstSignup = Integer.parseInt(adminPointConfigVO.getFirstSignupPoint());
        MemberDPointErpVO param = new MemberDPointErpVO();
        param.setDtype(MemberDPointErpVO.DE_MEMBER_REGISTER);      /* 포인트 이벤트발생 종류 */
        param.setCdcust(user.getCdCust());    /* 회원번호 */
        param.setInflag("0");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
        param.setCanctype("0");  /* 0:정상/2:반품 */
        param.setSalamt(fm_nFirstSignup);    /* 구매총금액 */
        param.setPayamt01(0);   /* [현금]정산금액 */
        param.setPayamt02(0);   /* [카드]정산금액 */
        param.setPayamt03(0);   /* 포인트사용 금액 */
        param.setSalpoint(fm_nFirstSignup);  /* 발생포인트*/
        param.setCdno(Integer.parseInt(user.getMemberCardNo()));      /* 카드번호 */
//        param.setStrcode(user.getStrCode());   /* 가맹점코드 */
        param.setStrcode("0000");   /* 가맹점코드 */// 2023-07-02 210 마켓 적립은 본사 매출이라 0000으로 잡으면됨
        param.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */
        param.setMemberno(Long.toString(user.getMemberNo()));
        this.ErpMemberDPoint(param);
    }

    /**
     * 2023-05-28 210
     * 상품 후기작성
     * 지금은 후기를 한상품에 한번만 사용할수있게 되어있다 하지만 이상품을 구매했다는 체크는 그전에는 하지않고있어서
     * 구매한 상품에 리뷰를 작성하지않은 조건을 맞춘 상품만 포인트를 지급한다.
     * 나중에 리뷰는 구매하지않은 상품(버그)에 여러개를 쓰더라도 예외처리를 할수있다.
     */
    @Override
    public void GoodsWritePoint(MemberDPointCtVO memberDPointCtVO) throws Exception {

        if (memberDPointCtVO.getCdCust() == null || memberDPointCtVO.getCdCust().equals("")
                || memberDPointCtVO.getMemberCardNo() == null || memberDPointCtVO.getMemberCardNo().equals("")) {
            throw new CustomException("상품 리뷰 포인트 지급 오류");
        }
        int isPoint = this.getGoodsReviewIsPoint(memberDPointCtVO.getMemberNo(), memberDPointCtVO.getGoodsNo());//리뷰를 작성할때 포인트를 받을 남아있는 개수
        if (isPoint > 0) {//리뷰를 작성하고 포인트를 받을수있는 횟수 isPoint개가 남아있다
            AdminPointConfigVO adminPointConfigVO = this.selectPointConfig();//어드민 포인트 조회
            MemberDPointErpVO param = new MemberDPointErpVO();
            param.setDtype(memberDPointCtVO.getDType());      /* 포인트 이벤트발생 종류 */
            param.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
            param.setInflag("0");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
            param.setCanctype("0");  /* 0:정상/2:반품 */
            param.setSalamt(0);    /* 구매총금액 */
            param.setPayamt01(0);   /* [현금]정산금액 */
            param.setPayamt02(0);   /* [카드]정산금액 */
            param.setPayamt03(0);   /* 포인트사용 금액 */
            if (memberDPointCtVO.getDType().equals(MemberDPointErpVO.DE_BUY_EPLG_WRITE_POINT)) {
                param.setSalpoint(Integer.parseInt(adminPointConfigVO.getBuyEplgWritePoint()));  /* 일반후기발생포인트*/
            } else if (memberDPointCtVO.getDType().equals(MemberDPointErpVO.DE_BUY_EPLG_WRITE_PM_POINT)) {
                param.setSalpoint(Integer.parseInt(adminPointConfigVO.getBuyEplgWritePmPoint()));  /* 프리미엄후기발생포인트*/
            }
            param.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
//            param.setStrcode(memberDPointCtVO.getStrCode());   /* 가맹점코드 */
            param.setStrcode("0000");   /* 가맹점코드 */// 2023-07-02 210 마켓 적립은 본사 매출이라 0000으로 잡으면됨
            param.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */
            param.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
            param.setGoodsno(memberDPointCtVO.getGoodsNo());//적립된 후기 상품
            this.ErpMemberDPoint(param);
        }
    }

    /**
     * 2023-05-28 210
     * 회원탈퇴시 포인트 소멸
     **/
    @Override
    public void MemberLeaveDeletePoint(MemberDPointCtVO memberDPointCtVO) throws Exception {
        //마켓과 erp 매장에서 회원탈퇴 두군대서 오는곳임..세션을 받을수없고 이전단 에서 값을 최종적으로 받아와야함
        //어차피 탈퇴를 하기위해 전처리가다 되기 때문에 갠찮
        //그리고 아직 DPoint 조회 erp 쿼리가 없기 때문에 얼마를 최종으로 처리 해야할지모른다. 그래서 아직 그부분은 0으로 넣어놧다 밑에
        //나중에 한차장님한테 쿼리 받으면 총 포인트 조회후 모두 소멸

        //2023-05-31 210 이알피에서 디포인트 조회 받음
        MemberDPointErpDTO memberDPointErpDTO = this.getErpMemberDPointOne(memberDPointCtVO.getCdCust());
        if(memberDPointErpDTO != null){
            MemberDPointErpVO param = new MemberDPointErpVO();
            param.setDtype(MemberDPointErpVO.DE_MEMBER_LEAVE);      /* 포인트 이벤트발생 종류 */
            param.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
            param.setInflag("4");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 *///2로 소멸시켰는데 왠지 모르겠지만 이알피에서 포인트가 안사라지네.. 그래서 4번인 사용으로 변경
            param.setCanctype("0");  /* 0:정상/2:반품 */
            param.setSalamt(Integer.parseInt(memberDPointErpDTO.getPOINTTOTAL3()));    /* 구매총금액 */
            param.setPayamt01(0);   /* [현금]정산금액 */
            param.setPayamt02(0);   /* [카드]정산금액 */
            param.setPayamt03(Integer.parseInt(memberDPointErpDTO.getPOINTTOTAL3()));   /* 포인트사용 금액 */
            param.setSalpoint(Integer.parseInt(memberDPointErpDTO.getPOINTTOTAL3()));  /*회원 보유 총포인트*/
            param.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
//            param.setStrcode(memberDPointCtVO.getStrCode());   /* 가맹점코드 */
            param.setStrcode("0000");   /* 가맹점코드 */// 2023-07-02 210 마켓 적립은 본사 매출이라 0000으로 잡으면됨
            param.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */
            param.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
            this.ErpMemberDPoint(param);
        }
    }

    /**
     * 2023-06-02 210
     * 결제 포인트, 사용,취소
     * 2023-07-02 210
     * 결제 사용,취소 포인트 정책 변경에 따른 알고리즘 변경
     * EX)
     * 보유 포인트지점
     * 0000	1000
     * 2000	20000
     * 3000	50000
     * 1000	11000
     *
     * 사용 포인트 37500
     *
     * 사용 지점 집계
     * 0000	1000
     * 2000	20000
     * 3000	23500
     * 1000	0
     *
     * 선입선출 구조로 적립된 순서로 사용한 포인트 만큼 차감하는 방식
     * 취소도 반대로 사용했던지점에게 취소하면 그대로 돌려줘야함..
     * **/
    @Override
    public void PaymentDPoint(MemberDPointCtVO memberDPointCtVO) throws Exception{
        //f_nType = 1:사용,2:취소
        MemberDPointErpDTO memberDPointErpDTO = this.getErpMemberDPointOne(memberDPointCtVO.getCdCust());
        log.info("memberDPointErpDTO ::::::::::::::::::::::::::::::::::: "+memberDPointErpDTO);
        int fm_nMyDPoint = 0;
        if(memberDPointErpDTO != null){
            fm_nMyDPoint = Integer.parseInt(memberDPointErpDTO.getPOINTTOTAL3());
        }
        if((memberDPointErpDTO == null || fm_nMyDPoint == 0) && memberDPointCtVO.getSubType() == 1){
            throw new CustomException("사용가능한 포인트가 없습니다.");
        }
        try {
            List<OrderGoodsPO> orderGoodsPOS = memberDPointCtVO.getOrderGoodsPOS();
            if (memberDPointCtVO.getSubType() == 1) {//포인트결제후 사용
                MemberStoreGroupDPointErpSO memberStoreGroupDPointErpSO = new MemberStoreGroupDPointErpSO();
                memberStoreGroupDPointErpSO.setCdCust(memberDPointCtVO.getCdCust());
                for (int i = 0; i < orderGoodsPOS.size(); i++) {
                    OrderGoodsPO orderGoodsPO = orderGoodsPOS.get(i);
                    MemberDPointErpVO PointParamHeader = new MemberDPointErpVO();//포인트 사용후 지불한 카드,현금 금액 로그만
                    long fm_lGoodsLSaleAmt = (orderGoodsPO.getSaleAmt() - orderGoodsPO.getDcAmt() - orderGoodsPO.getGoodsDmoneyUseAmt()) + orderGoodsPO.getDlvrAmt() + orderGoodsPO.getDlvrAddAmt();
                    PointParamHeader.setSalamt((int) fm_lGoodsLSaleAmt);    /* 구매총금액 */
                    if (memberDPointCtVO.getPaymentWayCd().equals("23")) {//카드
                        PointParamHeader.setPayamt02((int) fm_lGoodsLSaleAmt);   /* [카드]정산금액 */
                    } else {
                        PointParamHeader.setPayamt01((int) fm_lGoodsLSaleAmt);   /* [현금]정산금액 */
                    }
                    PointParamHeader.setPayamt03(0);   /* 포인트사용 금액 */ //이건 밑에꺼와다그게 결제 했을때 포인트사용을 얼마했냐고만 적는거지 나중에 합산할때 계산은 밑에껄로함 그냥 로그용
                    PointParamHeader.setSalpoint(0);  /* 적용할 포인트*/ //이게 포인트 사용했으면 이걸로 계산에서 나중에 합산나옴
                    PointParamHeader.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_USE);      /* 포인트 이벤트발생 종류 */
                    PointParamHeader.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
                    PointParamHeader.setInflag("0");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
                    PointParamHeader.setCanctype("0");  /* 0:정상/2:반품 */
                    PointParamHeader.setStrcode("0000");   /* 가맹점코드 */
                    PointParamHeader.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
                    PointParamHeader.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
                    PointParamHeader.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
                    PointParamHeader.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
                    PointParamHeader.setGoodsno(orderGoodsPO.getGoodsNo());
                    PointParamHeader.setOrdSeq(orderGoodsPO.getOrdDtlSeq());
                    this.ErpMemberDPoint(PointParamHeader);

                    //각 지점별 총포인트를 가져온다, 여기서 조회하는이유는 한상품씩 포인트를 사용하고 다시 지점별 적립 총 포인트를 계산해와야 다음 상품 포인트 계산이 맞기 때
//                    List<MemberStoreGroupDPointErpVO> memberStoreGroupDPointErpVO = this.getErpMemberStoreGroupDPoint(memberStoreGroupDPointErpSO);
                    //적립된 지점리스트를 가져온다 기준은 선입선출 이기 때문에 먼저들어온 적립스토어부터.. 단, 쿼리에서 해당지점에서 사용한 포인트도 같이 가져와야한다. 따로가져오면 로스가 너무 심함
                    List<MemberStoreGroupDPointErpVO> memberStoreGroupDPointErpVO = this.getErpMemberStoreDetalHeadDPoint(memberStoreGroupDPointErpSO);
                    if(memberStoreGroupDPointErpVO == null || memberStoreGroupDPointErpVO.size() <= 0){
                        //각 지점별로 쌓인 0이상의 포인트가 없을경우
                        throw new CustomException("사용가능한 포인트가 없습니다문");
                    }
                    Map<String, Integer> StorePoint = new HashMap();//선입선출로 나온 스토어별 적립 포인트를 저장할 맵..
                    Map<String, Integer> StoreUsePoint = new HashMap();//선입선출로 나온 스토어별 사용 포인트를 저장할 맵..
                    int fm_nUsePoint = (int)orderGoodsPO.getGoodsDmoneyUseAmt();//결제 할때 해당 상품에 사용된 포인트
                    for (int j = 0; j < memberStoreGroupDPointErpVO.size(); j++) {//결제시 사용한 포인를 어떤 지점에서 꺼내 쓸건 지정함
                        Integer fm_nStoreSalPoint = (int)memberStoreGroupDPointErpVO.get(j).getSalPoint();//내가 적립한 지점에 갖고 있는 포인트
                        int fm_nStoreUsePoint = (int)memberStoreGroupDPointErpVO.get(j).getStrUseTotal();//내가 적립한 지점에 사용한 [총] 포인트
                        String fm_sUseStore = memberStoreGroupDPointErpVO.get(j).getStrCode();//위 포인트들의 지점 코드
                        if(!StorePoint.containsKey(fm_sUseStore)){//맵에 스토어가 없으면추가
                            StorePoint.put(fm_sUseStore, fm_nStoreSalPoint);
                        }else{//맵에 이미 계산된 스토어가 있으면 해당 지점에 적립된 포인트 더해줌
                            Integer fm_nMapStoreSalPoint = StorePoint.get(fm_sUseStore);
                            StorePoint.put(fm_sUseStore, (fm_nMapStoreSalPoint + fm_nStoreSalPoint));
                        }
                        if(!StoreUsePoint.containsKey(fm_sUseStore)){
                            //맵에 스토어가 없으면추가
                            //사용 포인트는 스토어가맵에 있다 하더라도 여기서 계속 추가하면안됨 아래에서 사용된 포인트만 스토어맵에 더해주면됨
                            StoreUsePoint.put(fm_sUseStore, fm_nStoreUsePoint);
                        }
                        int fm_nStorePoint = StorePoint.get(fm_sUseStore) - StoreUsePoint.get(fm_sUseStore);//해당 지점의 총포인트에서 사용된 총포인트를 미리 빼준다 이 변수가 사용할 포인트가 되는거임
                        if(fm_nUsePoint <= 0){//만약 다음 사용할 포인트가 0이라면 더이상 사용할필요없음
                            break;
                        }else if(fm_nStorePoint <= 0){
                            //포인트가 0인 지점은 생략
                            continue;
                        }else if(fm_nStorePoint == fm_nUsePoint){//이럴경우는 잘없지만(원단위라)해당 지점포인트랑 사용포인트가 같을경우
                            //다음포인트 계산할필요없이 그대로 사용
                            fm_nUsePoint = 0;//해당 지점의 포인트로 결제를 다 했기때문에 다음 포문에서 빠져나오기 위해 0으로 셋팅
                        }else if(fm_nStorePoint < fm_nUsePoint){//사용할 포인트가 해당 스토어에 가지고있는 포인트포다 크다면
                            fm_nUsePoint -= fm_nStorePoint;//fm_nStorePoint:지금 스토어에 사용할 포인트,fm_nUsePoint:다음루프에 사용할 남은 포인트
                        }else if(fm_nStorePoint > fm_nUsePoint){//사용할 포인트 보다 스토어 포인트가 크다면
                            //사용한포인트보다 해당지점 포인트가 많기때문에
                            fm_nStorePoint = fm_nUsePoint;
                            fm_nUsePoint = 0;//해당 지점의 포인트로 결제를 다 했기때문에 다음 포문에서 빠져나오기 위해 0으로 셋팅
                        }
                        //사용한 맵 포인트는 위 에서 계산된 포인트로 여기서 마무리로 더해주면됨
                        Integer fm_nMapStoreUsePoint = StoreUsePoint.get(fm_sUseStore);
                        StoreUsePoint.put(fm_sUseStore, (fm_nMapStoreUsePoint + fm_nStorePoint));

                        MemberDPointErpVO PointParamBody = new MemberDPointErpVO();//포인트 로그만
                        PointParamBody.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_USE);      /* 포인트 이벤트발생 종류 */
                        PointParamBody.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
                        PointParamBody.setInflag("4");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
                        PointParamBody.setCanctype("0");  /* 0:정상/2:반품 */
//                    param.setSalamt((int) orderInfoPO.getPaymentAmt());    /* 구매총금액 */
//                    if (orderPayPO.getPaymentWayCd().equals("23")) {//카드
//                        param.setPayamt02((int) orderPayPO.getPaymentAmt());   /* [카드]정산금액 */
//                    } else {
//                        param.setPayamt01((int) orderPayPO.getPaymentAmt());   /* [현금]정산금액 */
//                    }
                        PointParamBody.setSalamt((int) fm_nStorePoint);    /* 구매총금액 */
                        PointParamBody.setPayamt03((int) fm_nStorePoint);   /* 포인트사용 금액 */ //이건 밑에꺼와다그게 결제 했을때 포인트사용을 얼마했냐고만 적는거지 나중에 합산할때 계산은 밑에껄로함 그냥 로그용
                        PointParamBody.setSalpoint((int) fm_nStorePoint);  /* 적용할 포인트*/ //이게 포인트 사용했으면 이걸로 계산에서 나중에 합산나옴
                        PointParamBody.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
                        PointParamBody.setStrcode(fm_sUseStore);   /* 가맹점코드 */
                        PointParamBody.setStr_code_to(fm_sUseStore);/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
                        PointParamBody.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
                        PointParamBody.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
                        PointParamBody.setGoodsno(orderGoodsPO.getGoodsNo());
                        PointParamBody.setOrdSeq(orderGoodsPO.getOrdDtlSeq());
                        this.ErpMemberDPoint(PointParamBody);
                    }
                }
            }else if (memberDPointCtVO.getSubType() == 2) {//결제후 사용햇던 포인트 돌려받기,getOrdStoreUseDPoint
                MemberDPointErpSO memberDPointErpSO = new MemberDPointErpSO();
                for (int i = 0; i < orderGoodsPOS.size(); i++) {
                    OrderGoodsPO orderGoodsPO = orderGoodsPOS.get(i);

                    MemberDPointErpVO PointParamHeader = new MemberDPointErpVO();
                    PointParamHeader.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_CANCEL);      /* 포인트 이벤트발생 종류 */
                    PointParamHeader.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
                    PointParamHeader.setInflag("0");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
                    PointParamHeader.setCanctype("0");  /* 0:정상/2:반품 */
                    long fm_lGoodsLSaleAmt = (orderGoodsPO.getSaleAmt() - orderGoodsPO.getDcAmt() - orderGoodsPO.getGoodsDmoneyUseAmt()) + orderGoodsPO.getDlvrAmt() + orderGoodsPO.getDlvrAddAmt();
                    fm_lGoodsLSaleAmt *= -1;
                    PointParamHeader.setSalamt((int) fm_lGoodsLSaleAmt);    /* 구매총금액 */
                    if (memberDPointCtVO.getPaymentWayCd().equals("23")) {//카드
                        PointParamHeader.setPayamt02((int) fm_lGoodsLSaleAmt);   /* [카드]정산금액 */
                    } else {
                        PointParamHeader.setPayamt01((int) fm_lGoodsLSaleAmt);   /* [현금]정산금액 */
                    }
                    PointParamHeader.setPayamt03(0);   /* 포인트사용 금액 */ //이건 밑에꺼와다그게 결제 했을때 포인트사용을 얼마했냐고만 적는거지 나중에 합산할때 계산은 밑에껄로함 그냥 로그용
                    PointParamHeader.setSalpoint(0);  /* 적용할 포인트*/ //이게 포인트 사용했으면 이걸로 계산에서 나중에 합산나옴
                    PointParamHeader.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
                    PointParamHeader.setStrcode("0000");   /* 가맹점코드 */
                    PointParamHeader.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
                    PointParamHeader.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
                    PointParamHeader.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
                    PointParamHeader.setGoodsno(orderGoodsPO.getGoodsNo());
                    PointParamHeader.setOrdSeq(orderGoodsPO.getOrdDtlSeq());
                    this.ErpMemberDPoint(PointParamHeader);

                    memberDPointErpSO.setCdCust(memberDPointCtVO.getCdCust());
                    memberDPointErpSO.setOrdNo(Long.toString(memberDPointCtVO.getOrdNo()));
                    memberDPointErpSO.setOrdSeq(orderGoodsPO.getOrdDtlSeq());
                    memberDPointErpSO.setGoodsNo(orderGoodsPO.getGoodsNo());
                    List<MemberDPointErpVO> ordDPorintErpVO = this.getOrdStoreUseDPoint(memberDPointErpSO);
                    if(ordDPorintErpVO == null || ordDPorintErpVO.size() <= 0){
                        //상품에 포인트를 사용한 지점목록
                        throw new CustomException("사용가능한 포인트가 없습니다문");
                    }
                    for (int j = 0; j < ordDPorintErpVO.size(); j++) {//결제시 사용한 포인를 어떤 지점에다가 원복할껀지
                        String fm_sUseStoreCode = ordDPorintErpVO.get(j).getStrcode();
                        int fm_nUseStorePoint = ordDPorintErpVO.get(j).getSalpoint();
                        MemberDPointErpVO PointParamBody = new MemberDPointErpVO();
                        PointParamBody.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_CANCEL);      /* 포인트 이벤트발생 종류 */
                        PointParamBody.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
                        PointParamBody.setInflag("0");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
                        PointParamBody.setCanctype("0");  /* 0:정상/2:반품 */
//                    param.setSalamt((int) orderInfoPO.getPaymentAmt());    /* 구매총금액 */
//                    if (orderPayPO.getPaymentWayCd().equals("23")) {//카드
//                        param.setPayamt02((int) orderPayPO.getPaymentAmt());   /* [카드]정산금액 */
//                    } else {
//                        param.setPayamt01((int) orderPayPO.getPaymentAmt());   /* [현금]정산금액 */
//                    }
//                        long fm_lGoodsLSaleAmt = (orderGoodsPO.getSaleAmt() - orderGoodsPO.getDcAmt() - orderGoodsPO.getGoodsDmoneyUseAmt()) + orderGoodsPO.getDlvrAmt() + orderGoodsPO.getDlvrAddAmt();
//                        param.setSalamt((int) fm_lGoodsLSaleAmt);    /* 구매총금액 */
//                        if (memberDPointCtVO.getPaymentWayCd().equals("23")) {//카드
//                            param.setPayamt02((int) fm_lGoodsLSaleAmt);   /* [카드]정산금액 */
//                        } else {
//                            param.setPayamt01((int) fm_lGoodsLSaleAmt);   /* [현금]정산금액 */
//                        }
                        PointParamBody.setSalamt((int) fm_nUseStorePoint);    /* 구매총금액 */
                        PointParamBody.setPayamt03(fm_nUseStorePoint);   /* 포인트사용 금액 */ //이건 밑에꺼와다그게 결제 했을때 포인트사용을 얼마했냐고만 적는거지 나중에 합산할때 계산은 밑에껄로함 그냥 로그용
                        PointParamBody.setSalpoint(fm_nUseStorePoint);  /* 적용할 포인트*/ //이게 포인트 사용했으면 이걸로 계산에서 나중에 합산나옴
                        PointParamBody.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
                        PointParamBody.setStrcode(fm_sUseStoreCode);   /* 가맹점코드 */
                        PointParamBody.setStr_code_to(fm_sUseStoreCode);/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
                        PointParamBody.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
                        PointParamBody.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
                        PointParamBody.setGoodsno(orderGoodsPO.getGoodsNo());
                        PointParamBody.setOrdSeq(orderGoodsPO.getOrdDtlSeq());
                        this.ErpMemberDPoint(PointParamBody);
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            throw new CustomException("결제 포인트 사용,취소 "+e.getMessage());
        }
    }

    /**
     * 2023-06-02 210
     * 상품 적립, 회수
     * **/
    @Override
    public void PaymentDPointPvdSvMn(MemberDPointCtVO memberDPointCtVO) throws Exception{
        //f_nType = 1:적립,2:회수
        MemberDPointErpDTO memberDPointErpDTO = this.getErpMemberDPointOne(memberDPointCtVO.getCdCust());
        try {
            //if (!orderPayPO.getPaymentWayCd().equals("22")) {//가상계좌가 아니라면
            List<OrderGoodsPO> orderGoodsPOS = memberDPointCtVO.getOrderGoodsPOS();
            if (memberDPointCtVO.getSubType() == 1) {//포인트결제후 적립
                for (int i = 0; i < orderGoodsPOS.size(); i++) {
                    OrderGoodsPO orderGoodsPO = orderGoodsPOS.get(i);
                    MemberDPointErpVO param = new MemberDPointErpVO();
                    param.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_ACCUMULATE);      /* 포인트 이벤트발생 종류 */
                    param.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
                    param.setInflag("0");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
                    param.setCanctype("0");  /* 0:정상/2:반품 */
                    long fm_lGoodsLSaleAmt = (orderGoodsPO.getSaleAmt() - orderGoodsPO.getDcAmt() - orderGoodsPO.getGoodsDmoneyUseAmt()) + orderGoodsPO.getDlvrAmt() + orderGoodsPO.getDlvrAddAmt();
                    param.setSalamt((int)fm_lGoodsLSaleAmt) ;    /* 구매총금액 */
                    if (memberDPointCtVO.getPaymentWayCd().equals("23")) {//카드
                        param.setPayamt02((int) fm_lGoodsLSaleAmt);   /* [카드]정산금액 */
                    } else {
                        param.setPayamt01((int) fm_lGoodsLSaleAmt);   /* [현금]정산금액 */
                    }
                    param.setPayamt03((int) orderGoodsPO.getGoodsSvmnAmt());   /* 포인트사용 금액 */
                    param.setSalpoint((int) orderGoodsPO.getGoodsSvmnAmt());  /* 적용할 포인트*/
                    param.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
                    param.setStrcode("0000");   /* 가맹점코드 */
                    param.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
                    param.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
                    param.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
                    param.setGoodsno(orderGoodsPO.getGoodsNo());
                    this.ErpMemberDPoint(param);
                }
            }else if (memberDPointCtVO.getSubType() == 2) {//적립한 포인트 회수
                for (int i = 0; i < orderGoodsPOS.size(); i++) {
                    OrderGoodsPO orderGoodsPO = orderGoodsPOS.get(i);
                    MemberDPointErpVO param = new MemberDPointErpVO();
                    param.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_ACCUMULATE_CANCEL);      /* 포인트 이벤트발생 종류 */
                    param.setCdcust(memberDPointCtVO.getCdCust());    /* 회원번호 */
                    param.setInflag("4");    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
                    param.setCanctype("0");  /* 0:정상/2:반품 */
                    long fm_lGoodsLSaleAmt = (orderGoodsPO.getSaleAmt() - orderGoodsPO.getDcAmt() - orderGoodsPO.getGoodsDmoneyUseAmt()) + orderGoodsPO.getDlvrAmt() + orderGoodsPO.getDlvrAddAmt();
                    param.setSalamt((int)fm_lGoodsLSaleAmt) ;    /* 구매총금액 */
                    if (memberDPointCtVO.getPaymentWayCd().equals("23")) {//카드
                        param.setPayamt02((int) fm_lGoodsLSaleAmt);   /* [카드]정산금액 */
                    } else {
                        param.setPayamt01((int) fm_lGoodsLSaleAmt);   /* [현금]정산금액 */
                    }
                    param.setPayamt03((int) orderGoodsPO.getGoodsSvmnAmt());   /* 포인트사용 금액 */
                    param.setSalpoint((int) orderGoodsPO.getGoodsSvmnAmt());  /* 적용할 포인트*/
                    param.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));      /* 카드번호 */
                    param.setStrcode("0000");   /* 가맹점코드 */
                    param.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
                    param.setMemberno(Long.toString(memberDPointCtVO.getMemberNo()));
                    param.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
                    param.setGoodsno(orderGoodsPO.getGoodsNo());
                    this.ErpMemberDPoint(param);
                }
            }
            //}
        }catch (Exception e){
            throw new CustomException("결제 포인트 적립,회수 "+e.getMessage());
        }
    }

    /**
     * 2023-06-24
     * 구매확정 포인트 적립
     * **/
    @Override
    public void ordConfirmDPointPvdSvMn(MemberDPointCtVO memberDPointCtVO) throws Exception{
        try {
            log.debug("memberDPointCtVO :::::::::::::: "+memberDPointCtVO);
            MemberDPointErpVO param = new MemberDPointErpVO();
            param.setDtype(MemberDPointErpVO.DE_MEMBER_PAYMENT_ACCUMULATE);       //포인트 이벤트발생 종류
            param.setCdcust(memberDPointCtVO.getCdCust());     //회원번호
            param.setInflag("0");     //입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용
            param.setCanctype("0");   //0:정상/2:반품
            param.setSalamt((int)memberDPointCtVO.getSaleAmt()) ;     //구매총금액
            if (memberDPointCtVO.getPaymentWayCd().equals("23")) {//카드
                param.setPayamt02((int) memberDPointCtVO.getSaleAmt());    //[카드]정산금액
            } else {
                param.setPayamt01((int) memberDPointCtVO.getSaleAmt());    //[현금]정산금액
            }
            param.setPayamt03((int) memberDPointCtVO.getGoodsSvmnAmt());    //포인트사용 금액
            param.setSalpoint((int)memberDPointCtVO.getSalDpoint());   //적용할 포인트
            param.setCdno(Integer.parseInt(memberDPointCtVO.getMemberCardNo()));       //카드번호
            param.setStrcode("0000");   /* 가맹점코드 */
            param.setStr_code_to("0000");/* 포인트 사용 체인점 코드 */ //2023-06-03 210 한차장님께서 0000으로 넣어도된다고 하심
            param.setMemberno(String.valueOf(memberDPointCtVO.getMemberNo()));
            param.setOrdno(Long.toString(memberDPointCtVO.getOrdNo()));
            param.setGoodsno(memberDPointCtVO.getGoodsNo());
            log.debug("ordConfirmDPointPvdSvMn :::::::::::::::: param "+param);
            this.ErpMemberDPoint(param);
        }catch (Exception e){
            throw new CustomException("구매확정, 결제 포인트 적립"+e.getMessage());
        }
    }

    /**
     * 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (쇼핑몰 회원번호 기준)
     */
    @Override
    public void deleteMemberMapByMall(String mallMemberNo) throws Exception {
        proxyDao.update("erp.mapping.deleteMemberMapByMall", mallMemberNo);
    }
}
