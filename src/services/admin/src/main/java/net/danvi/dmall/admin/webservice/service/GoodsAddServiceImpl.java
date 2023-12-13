package net.danvi.dmall.admin.webservice.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.*;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.GoodsImageHandler;
import net.danvi.dmall.admin.web.common.util.GoodsImageInfoData;
import net.danvi.dmall.admin.web.common.util.GoodsImageType;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.batch.common.model.IfExecLogVO;
import net.danvi.dmall.biz.batch.common.model.IfLogVO;
import net.danvi.dmall.biz.batch.common.service.IfService;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model.IfSbnLogVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.result.GoodsClctIfPO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.webservice.model.GoodsPO;
import net.danvi.dmall.webservice.model.GoodsVO;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.jws.WebService;
import javax.servlet.http.HttpServletRequest;
import java.awt.*;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
* http://id1.test.com/admin/service/GoodsAdd?wsdl
* http://davichmarket.co.kr/admin/service/GoodsAdd?wsdl
* http://davichmarket.com/admin/service/GoodsAdd?wsdl
* */
@Slf4j
@WebService(endpointInterface = "net.danvi.dmall.admin.webservice.service.GoodsAddService")
public class GoodsAddServiceImpl extends BaseService implements GoodsAddService {

    @Resource(name = "ifService")
    private IfService ifService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    final static String DATE_FORMAT_FOR_GOODS_NO = "yyMMddHHmm";

    @Value("#{system['system.upload.path']}")
    private String uplaodFilePath;


    @Resource(name = "goodsImageHandler")
    private GoodsImageHandler imageHandler;

    /** 상품 이미지 임시 업로드 경로 */
    @Value("#{system['system.upload.goods.temp.image.path']}")
    private String goodsTempImageFilePath;


    @Override
    public GoodsVO insertGoods(GoodsPO goodsInfo) {


        GoodsVO result = new GoodsVO();

        /*System.out.println("웹서비스호출");

        for(int i=0;i<20;i++) {
            GoodsVO goodsVo = new GoodsVO();
            goodsVo.setDeptName( goodsInfo.getSELLER_ID() + "부서명"+i);
            goodsVo.setDeptNo(i);
            goodsVo.setLocation("지역"+i);
            goodsVos.add(goodsVo);
        }*/

        long cnt1 = 0;
        long dataCnt = 0;
        long dataDtlCnt = 0;
        String step = null;
        String ifNo = null;
        String ifSno = null;

        ProcRunnerVO vo = new ProcRunnerVO();
        /*vo.setSendCompaynyId(param.getString(SabangnetConstant.SEND_COMPAYNY_ID));
        vo.setSendAuthKey(param.getString(SabangnetConstant.SEND_AUTH_KEY));
        vo.setSendDate(param.getString(SabangnetConstant.SEND_DATE));
        vo.setSiteNm(param.getString(SabangnetConstant.SITE_NM));*/
        vo.setSiteId("id1");
        vo.setSiteNo(1L);
        vo.setOrdField(SabangnetConstant.GOODS_PRT_FIELD); // 출력필드
        vo.setIfId(SabangnetConstant.IF_ID_GOODS_READ);
        vo.setIfPgmId(SabangnetConstant.IF_PGM_ID_GOODS_READ);
        vo.setIfPgmNm(SabangnetConstant.IF_PGM_NM_GOODS_READ);
        vo.setIfGbCd(SabangnetConstant.IF_GB_CD);
        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 등록자 번호
        vo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 수정자 번호
       // vo.setLang(param.getString(SabangnetConstant.LANG)); // 인코딩타입
        //String domain = param.getString(SabangnetConstant.DOMAIN);

        /**  여기서 상품등록 */

        /** 데이터 검증 */
        // 셀러 로그인 아이디와 비밀버호 체크
        LoginVO user = new LoginVO();
        user.setLoginId(goodsInfo.getSELLER_ID());
        user.setSiteNo(1L);
        user = loginService.getUser(user);
        goodsInfo.setSellerNo(String.valueOf(user.getMemberNo()));
        if (user.getPw().equals(CryptoUtil.encryptSHA512(goodsInfo.getSELLER_PW()))) {

        }else{
            result.setSTATUS("fail");
            result.setMESSAGE(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_WRONG_PASSWORD));
            return  result;
            /*throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_WRONG_PASSWORD));*/
        }

        /** 연계 테이블 등록 */
        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();
        GoodsDetailPO po = new GoodsDetailPO();

        try {

        insertIfLogMain(vo, ifLogVo, ifExecLogVo);

        step = "1";
        log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), vo);

        /** 1.상품 수집테이블에 등록 */
        step = "1-1";
        // 상품수집 연계 테이블 중복 체크
        /*goodsInfo.setSiteNo(1L);
        String dupYn = proxyDao.selectOne("system.link.sabangnet." + "selecttGoodsClctIfDupYn", goodsInfo);*/
        //log.debug("{}.{} ::: 상품수집 연계 테이블 중복 체크 : {},{}", step, vo.getIfPgmNm(), dupYn);

        // 상품수집 연계 테이블에 중복자료가 없으면 - 'N'
        /*if (dupYn.equals("N")) {*/
             // ● 상품번호 생성
            step = "1-2";
            String goodsNo = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewGoodsNo");
            StringBuffer sb = new StringBuffer().append("G").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(goodsNo, "0", 4));
            goodsNo =sb.toString();
            goodsInfo.setGoodsNo(goodsNo);

            log.debug("{}.{} ::: 상품번호 생성 : {}", step, vo.getIfPgmNm(), goodsNo);

            ifExecLogVo.setExecKey(goodsInfo.getSBN_GOODS_NO()); // 사방넷상품번호
            ifService.insertIfExecLog(ifExecLogVo);
            log.debug("{}.{} ::: 연계일련번호채번, 연계실행로그 등록: {},{}", step, vo.getIfPgmNm(),ifExecLogVo.getIfSno(), goodsInfo);

            step = "1-3";
            log.debug("{}.{} ::: 연계 일련번호 셋팅 : {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(),goodsInfo);

            goodsInfo.setIfSno(ifExecLogVo.getIfSno()); // 연계일련번호
            goodsInfo.setIfNo(vo.getIfNo()); // 연계번호
            goodsInfo.setIfId(vo.getIfId()); // 연계ID
            goodsInfo.setSiteNo(vo.getSiteNo()); // 사이트번호
            goodsInfo.setRegrNo(vo.getRegrNo()); // 등록자번호

            cnt1 = cnt1 + 1;
            if (cnt1 == 1) {
                vo.setStartIfSno(ifExecLogVo.getIfSno()); // 시작연계일련번호-연계로그업데이트용
                ifLogVo.setStartIfSno(ifExecLogVo.getIfSno());
            }

            // 상품수집연계 테이블 등록
            // ----------------------------------------------------------------------
            step = "1-4";
            log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), goodsInfo);
            proxyDao.insert("system.link.sabangnet." + "insertGoodsClctIf", goodsInfo);

        /*}else{



        }*/

        /** 2.상품 정보 등록 **/
        step = "2";
        // ● 상품정보 등록 처리 - 상품수집 연계 테이블 조회
        // ======================================================================================================
        List<GoodsClctIfPO> goodsClctIfPO = proxyDao.selectList("system.link.sabangnet." + "selectGoodsClctIfList",vo);
        log.debug("{}.{} ::: 쇼핑몰 상품번호별 조회 결과 : {},{}", step, vo.getIfPgmNm(), goodsClctIfPO.size(), goodsClctIfPO);
        if (goodsClctIfPO.size() > 0) {

            for (int i = 0; i < goodsClctIfPO.size(); i++) {

                GoodsClctIfPO procDb = goodsClctIfPO.get(i);

                procDb.setRegrNo(vo.getRegrNo());
                procDb.setUpdrNo(vo.getUpdrNo());

                log.debug("{}.{} ::: 쇼핑몰 상품번호별 procDb : {}", step, vo.getIfPgmNm(), procDb);
                String orgOrdNo = "";

                // ● 상품 테이블 자료 존재여부 체크
                step = "2-1";
                String existYn = proxyDao.selectOne("system.link.sabangnet." + "selectGoodsExistYn", procDb);
                log.debug("{}.{} ::: 상품 테이블 존재여부 체크 : {},{}", step, vo.getIfPgmNm(), existYn);
                 // ◈ 상품 테이블에 자료가 존재하지 않으면(신규등록) - 'N'
                /*if (existYn.equals("N")) {*/
                    Map mapA  = new HashMap();
                    Map mapB  = new HashMap();
                    Map mapC  = new HashMap();
                    Map mapD  = new HashMap();
                    Map mapE  = new HashMap();
                    Map mapF  = new HashMap();
                    Map mapG  = new HashMap();
                    Map mapS  = new HashMap();
                    Map mapM  = new HashMap();
                    SiteSO so = new SiteSO();
                    so.setSiteNo(1L);
                    ResultModel<GoodsImageSizeVO> goodsImageSizeVO = siteInfoService.selectGoodsImageInfo(so);

                    /** 전시 이미지 정보 등록 Start..... (대표이미지를 실제경로에 다운로드 시킨후 정보를 등록한다.)*/
                     //String dlgtImgPath  ="http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";
                        String dlgtImgPath  = procDb.getDlgtImgPath();
                        mapA = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_A.jpg","DISP","A");
                        mapB = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_B.jpg","DISP","B");
                        mapC = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_C.jpg","DISP","C");
                        mapD = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_D.jpg","DISP","D");
                        mapE = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_E.jpg","DISP","E");
                        mapF = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_F.jpg","DISP","F");
                        mapG = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_G.jpg","DISP","G");
                        mapS = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_S.jpg","DISP","S");
                        mapM = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,procDb.getGoodsNo()+"_M.jpg","DISP","M");

                        List<GoodsImageUploadVO> resultListA = (List<GoodsImageUploadVO>) mapA.get("files");
                        for (GoodsImageUploadVO voa : resultListA){
                            if(voa.getImgType().equals("A")) {
                                procDb.setDispImgPathTypeA(voa.getTempFileName()!=null?voa.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeA(voa.getTempFileName()!=null?voa.getTempFileName().split("_")[1]+"_"+voa.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeA(String.valueOf(voa.getFileSize()));

                                copyTempDispImageFile(voa.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListB = (List<GoodsImageUploadVO>) mapB.get("files");
                        for (GoodsImageUploadVO vob : resultListB){
                            if(vob.getImgType().equals("B")) {
                                procDb.setDispImgPathTypeB(vob.getTempFileName()!=null?vob.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeB(vob.getTempFileName()!=null?vob.getTempFileName().split("_")[1]+"_"+vob.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeB(String.valueOf(vob.getFileSize()));
                                copyTempDispImageFile(vob.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListC = (List<GoodsImageUploadVO>) mapC.get("files");
                        for (GoodsImageUploadVO voc : resultListC){
                            if(voc.getImgType().equals("C")) {
                                procDb.setDispImgPathTypeC(voc.getTempFileName()!=null?voc.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeC(voc.getTempFileName()!=null?voc.getTempFileName().split("_")[1]+"_"+voc.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeC(String.valueOf(voc.getFileSize()));
                                copyTempDispImageFile(voc.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListD = (List<GoodsImageUploadVO>) mapD.get("files");
                        for (GoodsImageUploadVO vod : resultListD){
                            if(vod.getImgType().equals("D")) {
                                procDb.setDispImgPathTypeD(vod.getTempFileName()!=null?vod.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeD(vod.getTempFileName()!=null?vod.getTempFileName().split("_")[1]+"_"+vod.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeD(String.valueOf(vod.getFileSize()));
                                copyTempDispImageFile(vod.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListE = (List<GoodsImageUploadVO>) mapE.get("files");
                        for (GoodsImageUploadVO voe : resultListE){
                            if(voe.getImgType().equals("E")) {
                                procDb.setDispImgPathTypeE(voe.getTempFileName()!=null?voe.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeE(voe.getTempFileName()!=null?voe.getTempFileName().split("_")[1]+"_"+voe.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeE(String.valueOf(voe.getFileSize()));
                                copyTempDispImageFile(voe.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListF = (List<GoodsImageUploadVO>) mapF.get("files");
                        for (GoodsImageUploadVO vof : resultListF){
                            if(vof.getImgType().equals("F")) {
                                procDb.setDispImgPathTypeF(vof.getTempFileName()!=null?vof.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeF(vof.getTempFileName()!=null?vof.getTempFileName().split("_")[1]+"_"+vof.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeF(String.valueOf(vof.getFileSize()));
                                copyTempDispImageFile(vof.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListG = (List<GoodsImageUploadVO>) mapG.get("files");
                        for (GoodsImageUploadVO vog : resultListG){
                            if(vog.getImgType().equals("G")) {
                                procDb.setDispImgPathTypeG(vog.getTempFileName()!=null?vog.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeG(vog.getTempFileName()!=null?vog.getTempFileName().split("_")[1]+"_"+vog.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeG(String.valueOf(vog.getFileSize()));
                                copyTempDispImageFile(vog.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListS = (List<GoodsImageUploadVO>) mapS.get("files");
                        for (GoodsImageUploadVO vos : resultListS){
                            if(vos.getImgType().equals("S")) {
                                procDb.setDispImgPathTypeS(vos.getTempFileName()!=null?vos.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeS(vos.getTempFileName()!=null?vos.getTempFileName().split("_")[1]+"_"+vos.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeS(String.valueOf(vos.getFileSize()));
                                copyTempDispImageFile(vos.getTempFileName(),vo.getSiteId());
                            }
                        }

                        List<GoodsImageUploadVO> resultListM = (List<GoodsImageUploadVO>) mapM.get("files");
                        for (GoodsImageUploadVO vom : resultListM){
                            if(vom.getImgType().equals("M")) {
                                procDb.setDispImgPathTypeM(vom.getTempFileName()!=null?vom.getTempFileName().split("_")[0]:"");
                                procDb.setDispImgNmTypeM(vom.getTempFileName()!=null?vom.getTempFileName().split("_")[1]+"_"+vom.getTempFileName().split("_")[2]:"");
                                procDb.setDispImgFileSizeTypeM(String.valueOf(vom.getFileSize()));
                                copyTempDispImageFile(vom.getTempFileName(),vo.getSiteId());
                            }
                        }

                    /** 전시  이미지 정보 등록 END..... */


                    step = "2-2";
                    procDb.setGoodsNo(procDb.getGoodsNo());

                    log.debug("{}.{} ::: 상품등록 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);
                    // ● 상품등록 처리 - 상품 기본 정보, 옵션 등록 , 단품정보 , 상세내용
                    // ◈ 판매상태 3 상품테이블 인서트
                    // ----------------------------------------------------------------------
                    /** 상품 정보 등록 **/
                    proxyDao.update("system.link.sabangnet." + "procGoods", procDb);

                    /** 옵션 등록 **/
                    step = "2-3";
                    log.debug("{}.{} ::: 상품등록 처리 옵션 등록: {}", step, vo.getIfPgmNm(), procDb);
                    String multiOptYn = proxyDao.selectOne("system.link.sabangnet." + "selectMultiOptYn", procDb);
                    String itemNo = null;
                    String dlgtItemNo = null;
                    boolean isNewVersion = false;
                    // 다중 옵션의 경우
                    if ("Y".equals(multiOptYn)) {
                        step = "2-3-1";
                        log.debug("{}.{} ::: 상품등록 처리 다중 옵션 등록: {}", step, vo.getIfPgmNm(), procDb);
                        // 옵션 정보 처리
                        Map<String, Long> attrMap = new HashMap<>();
                        List<GoodsOptionPO> optionList = proxyDao.selectList("system.link.sabangnet." + "selectOptionList", procDb);

                        if (optionList != null && optionList.size() > 0) {
                            GoodsOptionPO option1 = new GoodsOptionPO();
                            option1.setGoodsNo(procDb.getGoodsNo());
                            option1.setUpdrNo(vo.getUpdrNo());
                            option1.setUseYn("N");
                            proxyDao.insert("system.link.sabangnet." + "updateOption", option1);

                             Long regSeq = -1L;
                            // 옵션 새로 생성일 경우 만 옵션 번호를 새로 취득
                            regSeq = bizService.getSequence("OPT_SEQ", new Long(0));
                            // 옵션별 처리
                            for (GoodsOptionPO option : optionList) {
                                if (option != null) {
                                    option.setRegistFlag("I");
                                    option.setSiteNo(procDb.getSiteNo());
                                    option.setGoodsNo(procDb.getGoodsNo());
                                    option.setRegrNo(vo.getRegrNo());
                                    option.setUpdrNo(vo.getUpdrNo());

                                    if (regSeq > -1) {
                                        option.setRegSeq(regSeq);
                                    }
                                    option.setUseYn("Y");
                                    isNewVersion = true;
                                    option.setOptNo(bizService.getSequence("OPT_NO"));

                                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", option);
                                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", option);

                                    // 옵션 별 속성 리스트 처리

                                    List<GoodsOptionAttrPO> optionValueList = proxyDao.selectList("system.link.sabangnet." + "selectOptionValueList", procDb);
                                    GoodsOptionAttrPO optionValue1 = new GoodsOptionAttrPO();
                                    optionValue1.setOptNo(option.getOptNo());
                                    optionValue1.setUpdrNo(vo.getUpdrNo());
                                    optionValue1.setUseYn("N");
                                    proxyDao.update("system.link.sabangnet." + "updateAttrUseYn", optionValue1);

                                    for (GoodsOptionAttrPO optionValue : optionValueList) {
                                            optionValue.setRegistFlag("I");
                                            optionValue.setOptNo(option.getOptNo());
                                            optionValue.setRegrNo(vo.getRegrNo());
                                            optionValue.setUpdrNo(vo.getUpdrNo());

                                            long attrNo = optionValue.getAttrNo();
                                            optionValue.setUseYn("Y");
                                            isNewVersion = true;
                                            String [] attrNm = optionValue.getAttrNm().split(",");
                                            for (int j=0;j<attrNm.length;j++){
                                                optionValue.setAttrNo(bizService.getSequence("ATTR_NO"));
                                                optionValue.setAttrNm(attrNm[j]);
                                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", optionValue);
                                                attrNo = optionValue.getAttrNo();

                                                attrMap.put(option.getOptNo() + "_" + attrNm[j], attrNo);
                                            }
                                    }
                                }
                            }

                            /** TODO....아이템 정보 리스트 */
                            /*List<GoodsItemPO> goodsItemList = po.getGoodsItemList();*/
                            List<GoodsItemPO> goodsItemList = proxyDao.selectList("system.link.sabangnet." + "selectGoodsItemList", procDb);

                            sb = null;
                            if (goodsItemList != null && goodsItemList.size() > 0) {
                                // 단품 삭제 처리 (사용여부를 'N'으로 수정)
                                    GoodsItemPO goodsItemPO1 = new  GoodsItemPO();
                                    goodsItemPO1.setUseYn("N");
                                    goodsItemPO1.setGoodsNo(procDb.getGoodsNo());
                                    proxyDao.insert("system.link.sabangnet." + "deleteGoodsItemOne", goodsItemPO1);

                                int idx = 0;
                                for (GoodsItemPO goodsItemPO : goodsItemList) {
                                    Long lAttrVer = null == goodsItemPO.getAttrVer() ? 0L : goodsItemPO.getAttrVer();

                                    goodsItemPO.setGoodsNo(procDb.getGoodsNo());
                                    goodsItemPO.setSiteNo(procDb.getSiteNo());
                                    goodsItemPO.setRegrNo(vo.getRegrNo());
                                    goodsItemPO.setUpdrNo(vo.getUpdrNo());

                                    //기본가격으로 세팅...
                                    goodsItemPO.setSupplyPrice(Long.valueOf(procDb.getSupplyPrice()));
                                    goodsItemPO.setSepSupplyPriceYn("N");
                                    /*
                                    goodsItemPO.setCustomerPrice(Long.valueOf(procDb.getCustomerPrice()));
                                    goodsItemPO.setSalePrice(Long.valueOf(procDb.getSalePrice()));
                                    goodsItemPO.setStockQtt(0L);
                                    */
                                    goodsItemPO.setCustomerPrice(Long.valueOf(goodsItemPO.getSalePrice()));
                                    goodsItemPO.setSalePrice(Long.valueOf(goodsItemPO.getSalePrice()));
                                    goodsItemPO.setStockQtt(Long.valueOf(goodsItemPO.getStockQtt()));
                                    goodsItemPO.setSaleQtt(0L);




                                    // 신규등록의 경우
                                    if (goodsItemPO.getItemNo() == null) {
                                        Long itemSeq = bizService.getSequence("ITEM_NO");
                                        sb = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                                        goodsItemPO.setItemNo(sb.toString());
                                        lAttrVer = 1L;
                                    } else {
                                        // 기존 속성에 추가의 경우
                                        lAttrVer = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewAttrVer",goodsItemPO.getItemNo());
                                    }
                                    goodsItemPO.setSiteNo(procDb.getSiteNo());
                                    goodsItemPO.setGoodsNo(procDb.getGoodsNo());

                                    /**  신규 단품 정보의 경우 */
                                    goodsItemPO.setRegrNo(vo.getRegrNo());
                                    goodsItemPO.setUseYn("Y");

                                    itemNo = null;
                                    if (!StringUtils.isEmpty(goodsItemPO.getItemNo())) {
                                        itemNo = goodsItemPO.getItemNo();
                                        goodsItemPO.setItemVer(1L);
                                        // 단품 정보 등록
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", goodsItemPO);
                                        // 단품 가격 변경 이력 테이블에 등록 ("01" : 인상)
                                        if (goodsItemPO.getSalePrice() != null) {
                                            goodsItemPO.setPriceChgCd("01");
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", goodsItemPO);
                                        }
                                        // 단품 수량 변경 이력 테이블에 등록 ("01" : 입고)
                                        if (goodsItemPO.getStockQtt() != null) {
                                            goodsItemPO.setStockChgCd("01");
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", goodsItemPO);
                                        }
                                    }

                                    // 상품 대표 단품 번호 설정
                                    if(idx==0) {
                                        dlgtItemNo = goodsItemPO.getItemNo();
                                    }

                                    if (isNewVersion) {


                                        if (!StringUtil.isEmpty(goodsItemPO.getAttrValue1())) {
                                            GoodsOptionPO option = optionList.get(0);
                                            if (goodsItemPO.getOptNo1() == null) {
                                                goodsItemPO.setOptNo1(option.getOptNo());
                                            }

                                            goodsItemPO.setAttrNo1(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue1()));
                                        }

                                        if (!StringUtil.isEmpty(goodsItemPO.getAttrValue2())) {
                                            GoodsOptionPO option = optionList.get(1);
                                            if (goodsItemPO.getOptNo2() == null) {
                                                goodsItemPO.setOptNo2(option.getOptNo());
                                            }

                                            goodsItemPO.setAttrNo2(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue2()));
                                        }

                                        if (!StringUtil.isEmpty(goodsItemPO.getAttrValue3())) {
                                            GoodsOptionPO option = optionList.get(2);
                                            if (goodsItemPO.getOptNo3() == null) {
                                                goodsItemPO.setOptNo3(option.getOptNo());
                                            }

                                            goodsItemPO.setAttrNo3(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue3()));
                                        }

                                        if (!StringUtil.isEmpty(goodsItemPO.getAttrValue4())) {
                                            GoodsOptionPO option = optionList.get(3);
                                            if (goodsItemPO.getOptNo4() == null) {
                                                goodsItemPO.setOptNo4(option.getOptNo());
                                            }

                                            goodsItemPO.setAttrNo4(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue4()));
                                        }
                                    }
                                    if (lAttrVer > 0) {
                                        goodsItemPO.setAttrVer(lAttrVer);
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", goodsItemPO);
                                    }
                                    idx++;
                                }

                            }
                        }

                    } else { // 단일 옵션의 경우
                        step = "2-3-2";
                        log.debug("{}.{} ::: 상품등록 처리 단일 옵션 등록: {}", step, vo.getIfPgmNm(), procDb);
                        GoodsOptionPO goodsOptionPO = new GoodsOptionPO();
                        goodsOptionPO.setGoodsNo(procDb.getGoodsNo());
                        goodsOptionPO.setUseYn("N");
                        // 기존 단품 정보 사용 여부 'N'으로 변경
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateItemUseYnByGoodsNo", goodsOptionPO);
                        // 기존 상품 옵션 정보 삭제
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "deleteGoodsOption", goodsOptionPO);

                        if (StringUtils.isEmpty(itemNo)) {
                            Long itemSeq = bizService.getSequence("ITEM_NO");
                            sb = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                            itemNo = sb.toString();
                        }

                        GoodsItemPO itemPO = new GoodsItemPO();
                        itemPO.setItemNo(itemNo);
                        // 단일 상품의 경우 단품이름에 상품 이름 셋팅
                        itemPO.setItemNm(procDb.getGoodsNm());
                        itemPO.setSiteNo(procDb.getSiteNo());
                        itemPO.setGoodsNo(procDb.getGoodsNo());

                        if (procDb.getCustomerPrice() == null) {
                            itemPO.setCustomerPrice(0L);
                        } else {
                            itemPO.setCustomerPrice(Long.valueOf(procDb.getCustomerPrice()));
                        }
                        if (procDb.getSupplyPrice() == null) {
                            itemPO.setSupplyPrice(0L);
                        } else {
                            itemPO.setSupplyPrice(Long.valueOf(procDb.getSupplyPrice()));
                        }
                        if (procDb.getSalePrice() == null) {
                            itemPO.setSalePrice(0L);
                        } else {
                            itemPO.setSalePrice(Long.valueOf(procDb.getSalePrice()));
                        }

                        List<GoodsItemPO> goodsItemList = proxyDao.selectList("system.link.sabangnet." + "selectGoodsItemList", procDb);

                        itemPO.setStockQtt(goodsItemList.get(0).getStockQtt());
                        itemPO.setSaleQtt(0L);
                        itemPO.setSepSupplyPriceYn("N");


                        /**  단품상품정보 수정 **/
                        itemPO.setRegrNo(vo.getRegrNo());
                        itemPO.setUseYn("Y");

                        itemNo = null;
                        if (!StringUtils.isEmpty(itemPO.getItemNo())) {
                            itemNo = itemPO.getItemNo();
                            dlgtItemNo = itemPO.getItemNo();
                            itemPO.setItemVer(1L);
                            // 단품 정보 등록
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", itemPO);
                            // 단품 가격 변경 이력 테이블에 등록 ("01" : 인상)
                            if (itemPO.getSalePrice() != null) {
                                itemPO.setPriceChgCd("01");
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", itemPO);
                            }
                            // 단품 수량 변경 이력 테이블에 등록 ("01" : 입고)
                            if (itemPO.getStockQtt() != null) {
                                itemPO.setStockChgCd("01");
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", itemPO);
                            }
                        }

                    }
                    /** [2] 대표단품 번호 등록 **/
                    step = "2-3-3";
                    log.debug("{}.{} ::: 상품등록 처리 대표단품 번호 등록: {}", step, vo.getIfPgmNm(), procDb);
                    if (dlgtItemNo != null) {
                        po.setGoodsNo(procDb.getGoodsNo());
                        po.setItemNo(dlgtItemNo);
                        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", po);
                    }


                    // 선택된 카테고리 정보 등록
                    List<GoodsCtgPO> goodsCtgList = proxyDao.selectList("system.link.sabangnet." + "selectGoodsCtgList", procDb);
                    int idx=0;
                    for (GoodsCtgPO goodsCtg : goodsCtgList) {
                        if(idx==0){
                            goodsCtg.setDlgtCtgYn("Y");
                        }else{
                            goodsCtg.setDlgtCtgYn("N");
                        }
                        goodsCtg.setExpsPriorRank((idx+1)+"");

                        goodsCtg.setGoodsNo(procDb.getGoodsNo());
                        goodsCtg.setSiteNo(vo.getSiteNo());
                        goodsCtg.setRegrNo(vo.getRegrNo());
                        goodsCtg.setUpdrNo(vo.getUpdrNo());
                        goodsCtg.setExpsYn("Y");
                        goodsCtg.setDelYn("N");
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsCtg", goodsCtg);

                        idx++;

                    }

                    /**  상품 고시정보 등록 **/
                    // 기존 고시항목 설정값을 삭제한다.
                    GoodsNotifyPO goodsNotify1 = new GoodsNotifyPO();
                    goodsNotify1.setGoodsNo(po.getGoodsNo());
                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsNotify", goodsNotify1);

                    List<GoodsNotifyPO> goodsNotifyList = new ArrayList<>();
                    GoodsNotifySO notifySO = new GoodsNotifySO();
                    notifySO.setGoodsNo(procDb.getGoodsNo());
                    notifySO.setNotifyNo(String.valueOf(procDb.getProp1Cd()));
                    List<GoodsNotifyVO> list = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsNotifyItemList", notifySO);


                    for(int j=0;j<list.size();j++){
                        GoodsNotifyVO notifyVO =list.get(j);
                        GoodsNotifyPO notifyPO = new GoodsNotifyPO();

                        notifyPO.setGoodsNo(procDb.getGoodsNo());
                        notifyPO.setItemNo(Long.valueOf(notifyVO.getItemNo()));

                        String methodName = "getPropVal" + (j+1);
                        Method getIdMethod = GoodsClctIfPO.class.getMethod(methodName);
                        Object methodResult = getIdMethod.invoke(procDb);
                        notifyPO.setItemValue(String.valueOf(methodResult));


                        notifyPO.setRegistFlag("I");
                        goodsNotifyList.add(notifyPO);
                    }

                    if (goodsNotifyList != null && goodsNotifyList.size() > 0) {
                        for (GoodsNotifyPO goodsNotify : goodsNotifyList) {
                             proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsNotify", goodsNotify);
                        }
                    }


                    // 이미지 정보 등록
                    // 이미지 삭제 처리를 위해 기존 이미지 정보를 취득한다.
                    List<GoodsImageDtlVO> goodsImageInfoList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsImageInfo", po);

                    if (!StringUtils.isEmpty(procDb.getGoodsNo())) {
                        proxyDao.delete("system.link.sabangnet."+ "deleteGoodsImageDtlSet", procDb.getGoodsNo());
                        proxyDao.delete("system.link.sabangnet." + "deleteGoodsImageSet", procDb.getGoodsNo());
                        // 변경 전 이미지 삭제 처리
                        if (goodsImageInfoList != null && goodsImageInfoList.size() > 0) {
                            for (GoodsImageDtlVO imageDtl : goodsImageInfoList) {
                                    // 이전 이미지 삭제 처리
                                    deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                            }
                        }
                    }


                    List<GoodsImageSetPO> goodsImageSetList = new ArrayList<>();
                    List<GoodsImageDtlPO> goodsImageDtlList = new ArrayList<>();

                    String imgPath1  = procDb.getImgPath1();
                    String imgPath2  = procDb.getImgPath2();
                    String imgPath3  = procDb.getImgPath3();
                    String imgPath4  = procDb.getImgPath4();
                    String imgPath5  = procDb.getImgPath5();

                    goodsImageSetList.add(goodsImageSetInfoList(goodsImageSizeVO,procDb.getGoodsNo(),dlgtImgPath,"GOODS","Y"));

                    goodsImageSetList.add(goodsImageSetInfoList(goodsImageSizeVO,procDb.getGoodsNo(),imgPath1,"GOODS","N"));

                    goodsImageSetList.add(goodsImageSetInfoList(goodsImageSizeVO,procDb.getGoodsNo(),imgPath2,"GOODS","N"));

                    goodsImageSetList.add(goodsImageSetInfoList(goodsImageSizeVO,procDb.getGoodsNo(),imgPath3,"GOODS","N"));

                    goodsImageSetList.add(goodsImageSetInfoList(goodsImageSizeVO,procDb.getGoodsNo(),imgPath4,"GOODS","N"));

                    goodsImageSetList.add(goodsImageSetInfoList(goodsImageSizeVO,procDb.getGoodsNo(),imgPath5,"GOODS","N"));

                    if (goodsImageSetList != null && goodsImageSetList.size() > 0) {
                        for (GoodsImageSetPO goodsImageSet : goodsImageSetList) {
                            long imgSetNo = goodsImageSet.getGoodsImgsetNo();
                            boolean isImageInfo = false;
                            goodsImageDtlList = goodsImageSet.getGoodsImageDtlList();

                            if (goodsImageDtlList != null && goodsImageDtlList.size() > 0) {
                                isImageInfo = true;
                            }


                            if (isImageInfo) {
                                //등록
                                if (!existYn.equals("N")) {

                                }else{
                                //수정

                                }



                                goodsImageSet.setGoodsImgsetNo((long) bizService.getSequence("GOODS_IMGSET_NO"));
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageSet", goodsImageSet);
                                imgSetNo = goodsImageSet.getGoodsImgsetNo();


                                for (GoodsImageDtlPO goodsImageDtl : goodsImageDtlList) {
                                    String tempFileNm = goodsImageDtl.getTempFileNm();
                                    if (!StringUtils.isEmpty(tempFileNm)) {
                                        String tempThumFileNm = tempFileNm.substring(0, tempFileNm.lastIndexOf("_")) + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

                                        goodsImageDtl.setGoodsImgsetNo(imgSetNo);
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageDtl", goodsImageDtl);

                                        // 임시 경로의 이미지를 실제 서비스 경로로 복사
                                        FileUtil.copyGoodsImage(tempFileNm,vo.getSiteId());
                                        FileUtil.copyGoodsImage(tempThumFileNm,vo.getSiteId());

                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm,vo.getSiteId());
                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempThumFileNm,vo.getSiteId());

                                    }
                                }
                            }
                        }
                    }

                    /** 상세내용 등록 **/
                    step = "3";
                    log.debug("{}.{} ::: 상품등록 처리 상세내용 등록: {}", step, vo.getIfPgmNm(), procDb);

                    po.setGoodsNo(procDb.getGoodsNo());
                    po.setSvcGbCd("01");
                    po.setContent(procDb.getGoodsDtlDscrt());
                    int cnt = proxyDao.selectOne("checkGoodsDescriptCnt", po);
                    if (cnt > 0) {
                        po.setUpdrNo(vo.getUpdrNo());
                        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsDescript", po);
                    } else {
                        po.setRegrNo(vo.getRegrNo());
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsDescript", po);
                    }

                    dataCnt = dataCnt + 1;

               /* } else {
                    // 상품 테이블에 자료가 있으면 처리 안함
                    log.debug("{}.{} ::: 사방넷연계-주문 테이블에 자료가 있으면 처리 안함 End : {}", step, vo.getIfPgmNm(),ifLogVo);
                }*/

            }


        }

        // 연계결과 건수
        step = "4";
        ifLogVo.setDataCnt(dataCnt);
        ifLogVo.setDataTotCnt(dataDtlCnt);
        log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

        // 연계 사방넷 배치 로그 수정
        // ----------------------------------------------------------------------
        step = "5";
        proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogUpd", ifLogVo);

        // 연계 로그, 연계 사방넷 로그 수정
        // ------------------------------------------------------
        step = "6";
        ifLogVo.setEndIfSno(ifExecLogVo.getIfSno()); // 종료연계일련번호
        log.debug("{}.{} ::: 연계 로그 수정 : {}", step, vo.getIfPgmNm(), ifLogVo);
        // proxyDao.update("system.link.ifLog.updateIfLog",ifLogVo);
        ifService.updateIfLog(ifLogVo);
        updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정

        } catch (Exception e) {

            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            result.setSTATUS("fail");
            result.setMESSAGE(MessageUtil.getMessage("biz.exception.common.error"));
            return  result;
        }

        result.setSTATUS("OK");
        result.setGOODSNO(goodsInfo.getGoodsNo());
        result.setMESSAGE("정상적으로 처리되었습니다.");
        return result;

    }

    /*
     * 연계 로그 등록
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    private void insertIfLogMain(ProcRunnerVO vo, IfLogVO ifLogVo, IfExecLogVO ifExecLogVo) throws Exception {

        // 1.연계 로그 VO 정보 셋팅 <- ProcRunnerVO
        setIfLogVoByVo(vo, ifLogVo, ifExecLogVo);

        // 2.연계 로그 등록 (연계번호 채번)
        ifService.insertIfLog(ifLogVo);
        log.debug("{}-Start ::: 연계 로그 등록 vo:{}, IfLogVO:{}", vo.getIfPgmNm(), vo, ifLogVo);

        if (ifLogVo.getIfNo() != null) {

            // -->
            // String ifNo = proxyDao.selectOne("system.link.ifLog.selectIfNo",
            // ifLogVo);
            // // IfLogVO 에 연계 번호 셋팅
            // ifLogVo.setIfNo(ifNo);
            // proxyDao.insert("system.link.ifLog.insertIfLog", ifLogVo); // <--

            vo.setIfNo(ifLogVo.getIfNo());
            ifExecLogVo.setIfNo(ifLogVo.getIfNo());

            // 3.연계 사방넷 로그 등록
            log.debug("{} ::: 연계 사방넷 로그 등록 ifNo:{},vo:{}, IfLogVO:{}", vo.getIfPgmNm(), vo.getIfNo(), vo, ifLogVo);
            insertIfSbnLog(vo);

        } else {
            String ifNo = proxyDao.selectOne("system.link.sabangnet." + "selectNewIfNo", ifLogVo);
            vo.setIfNo(ifNo);
            ifExecLogVo.setIfNo(ifNo);
            proxyDao.insert("system.link.sabangnet." + "insertNewIfLog", ifLogVo);
            insertIfSbnLog(vo);
        }

    }

    /*
     * 연계 로그 VO 셋팅 <- ProcRunnerVO
     */
    private void setIfLogVoByVo(ProcRunnerVO vo, IfLogVO ifLogVo, IfExecLogVO ifExecLogVo) {

        ifLogVo.setSiteNo(vo.getSiteNo()); // 사이트번호
        ifLogVo.setSiteId(vo.getSiteId()); // 사이트ID
        ifLogVo.setSiteNm(vo.getSiteNm()); // 사이트명
        ifLogVo.setIfId(vo.getIfId()); // 연계ID
        ifLogVo.setIfPgmId(vo.getIfPgmId()); // 연계프로그램ID
        ifLogVo.setIfPgmNm(vo.getIfPgmNm()); // 연계프로그램명
        ifLogVo.setIfGbCd(vo.getIfGbCd()); // 연계구분
        ifLogVo.setRegrNo(vo.getRegrNo()); // 등록자번호 - 사방넷 연계
        ifLogVo.setUpdrNo(vo.getUpdrNo()); // 수정자번호 - 사방넷 연계

        ifExecLogVo.setIfPgmNm(vo.getIfPgmNm());
        ifExecLogVo.setSiteNo(vo.getSiteNo()); // 사이트번호
        ifExecLogVo.setRegrNo(vo.getRegrNo());
        ifExecLogVo.setUpdrNo(vo.getUpdrNo());

        log.debug("● {} ::: 연계 로그 VO 셋팅 ProcRunnerVO:{}, ", vo.getIfPgmNm(), vo);
        log.debug("● {} ::: 연계 로그 VO 셋팅 IfLogVO:{}", vo.getIfPgmNm(), ifLogVo);
        log.debug("● {} ::: 연계 로그 VO 셋팅 IfExecLogVO:{}", vo.getIfPgmNm(), vo, ifExecLogVo);
    }

    /*
     * 연계 사방넷 로그 등록
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    private void insertIfSbnLog(ProcRunnerVO vo) {

        IfSbnLogVO ifSbnLogVo = new IfSbnLogVO();
        ifSbnLogVo.setIfNo(vo.getIfNo()); // 연계번호
        ifSbnLogVo.setIfId(vo.getIfId()); // 연계아이디
        ifSbnLogVo.setIfPgmNm(vo.getIfPgmNm()); // 연계프로그램명
        ifSbnLogVo.setSiteNo(vo.getSiteNo()); // 사이트번호
        ifSbnLogVo.setGoodsCdReturnYn(vo.getSendGoodsCdRt()); // 상품코드반환여부
        ifSbnLogVo.setSrchStartDt(vo.getStDate()); // 검색시작일자
        ifSbnLogVo.setSrchEndDt(vo.getEdDate()); // 검색종료일자

        log.debug("{} ::: 연계 사방넷 로그 등록 ProcRunnerVO : {}", vo.getIfPgmNm(), vo);
        if (vo.getOrdField() != null) {
            ifSbnLogVo.setPrtFieldList(vo.getOrdField()); // 주문출력필드리스트
        } else if (vo.getClmField() != null) {
            ifSbnLogVo.setPrtFieldList(vo.getClmField()); // 클레임출력필드리스트
        }
        // log.debug("0-4.2.연계 사방넷 로그 등록 ProcRunnerVO : {}", vo);
        ifSbnLogVo.setSalesCalculateCheckYn(vo.getJungChkYn2()); // 매출정산확인여부
        ifSbnLogVo.setOrdNo(vo.getOrderId()); // 주문번호
        ifSbnLogVo.setSpmallCd(vo.getMallId()); // 쇼핑몰코드
        ifSbnLogVo.setOrdDlvrStatusCd(vo.getOrderStatus()); // 주문배송상태
        ifSbnLogVo.setInvoiceInfoUpdYn(vo.getSendInvEditYn()); // 송장정보수정여부
        ifSbnLogVo.setSrchPrcGbCd(vo.getCsStatus()); // 001:신규접수,002:답변저장,003:답변전송,004:강제완료,NULL:전체
        ifSbnLogVo.setRegrNo(vo.getRegrNo()); // 등록자번호

        log.debug("{} ::: 연계 사방넷 로그 등록 ifSbnLogVo : {}", vo.getIfPgmNm(), ifSbnLogVo);
        proxyDao.insert("system.link.sabangnet." + "insertIfSbnLog", ifSbnLogVo);

    }

    /*
     * 연계 사방넷 로그 수정
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    private void updateIfSbnLog(IfLogVO ifLogVo) {

        log.debug("{} ::: 연계 사방넷 로그 수정 ProcRunnerVO : {}", ifLogVo.getIfPgmNm(), ifLogVo);
        IfSbnLogVO ifSbnLogVo = new IfSbnLogVO();
        ifSbnLogVo.setIfNo(ifLogVo.getIfNo()); // 연계번호
        ifSbnLogVo.setIfId(ifLogVo.getIfId()); // 연계ID
        ifSbnLogVo.setIfPgmNm(ifLogVo.getIfPgmNm()); // 연계프로그램명
        ifSbnLogVo.setResultContent(ifLogVo.getResultContent()); // 결과내용
        ifSbnLogVo.setUpdrNo(ifLogVo.getUpdrNo()); // 수정자번호

        log.debug("{} ::: 연계 사방넷 로그 수정 ifSbnLogVo : {}", ifLogVo.getIfPgmNm(), ifSbnLogVo);
        proxyDao.update("system.link.sabangnet." + "updateIfSbnLog", ifSbnLogVo);
    }

    private String getTempRootPath() {
        return uplaodFilePath + File.separator + "id1" + File.separator + UploadConstants.PATH_TEMP;
    }

   private Map goodsImageUploadResult(ResultModel<GoodsImageSizeVO> goodsImageSizeVO,String imgUrl, String fileOrgName,String imageKind,String imageType) throws Exception {
        GoodsImageUploadVO result;
            List<GoodsImageUploadVO> resultList = new ArrayList<>();
            Map map = new HashMap();

            if(imgUrl == null){
                return map;
            }

            String extension;
            String fileName;
            File file;
            String filePath;
            String path;
            // 상품 이미지는 이하 5가지 확장자만 가능
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            Boolean checkExe;
            GoodsImageInfoData imageInfoData;
            // 업로드된 이미지 종류(GOODS : 상품 이미지, DISP : 전시 이미지)
            //String imageKind = "DISP";
            // 이미지 유형
            // (상품이미지 - A Type, B Type, 전시이미지 - A Type, B Type, C Type, D Type, E Type, F Type, G Type, S Type, M Type)
            //String imageType = "";
            try  {
            URL url = new URL((String) imgUrl);
            Image image = ImageIO.read(url);
            BufferedInputStream in = new BufferedInputStream(url.openStream());
            extension = FilenameUtils.getExtension(fileOrgName);
            checkExe = true;
            for (String ex : fileFilter) {
                if (ex.equalsIgnoreCase(extension)) {
                    checkExe = false;
                }
            }
            if (checkExe) {
                throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
            }
            // 업로드 등록할 이미지 파일명
            fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
            // 파일 경로
            path = FileUtil.getNowdatePath();
            filePath = getTempRootPath() + File.separator + path + File.separator + fileName;

            file = new File(filePath);

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

               MultipartFile mFile = new MockMultipartFile("file",file.getName(), "text/plain", IOUtils.toByteArray(in));

               /*FileOutputStream fileOutputStream = new FileOutputStream(filePath);

                byte dataBuffer[] = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
                    fileOutputStream.write(dataBuffer, 0, bytesRead);
                }*/
                mFile.transferTo(file);



            // 리사이징 정보등을 담은 이미지 객체 생성
            imageInfoData = new GoodsImageInfoData();

            // 업로드 이미지 정보에 따라 이미지 객체에 이미지 유형 설정
            if ("GOODS".equals(imageKind)) {
                switch (imageType) {
                case "02":
                    imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE_TYPE_A);
                    break;
                case "03":
                    imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE_TYPE_B);
                    break;
                default:
                    imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE);
                    break;
                }
            } else {
                switch (imageType) {
                case "A":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_A);
                    break;
                case "B":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_B);
                    break;
                case "C":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_C);
                    break;
                case "D":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_D);
                    break;
                case "E":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_E);
                    break;
                case "F":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_F);
                    break;
                case "G":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_G);
                    break;
                case "S":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_S);
                    break;
                case "M":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_M);
                    break;
                default:
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE);
                    break;
                }
            }

            // 사이트 설정에서 취득한 상품 이미지 설정 정보를 세팅
            imageInfoData.setWidthForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgWidth()));
            imageInfoData.setHeightForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgHeight()));

            imageInfoData.setWidthForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgWidth()));
            imageInfoData.setHeightForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgHeight()));

            imageInfoData.setWidthForDispTypeA(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeAWidth()));
            imageInfoData.setHeightForDispTypeA(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeAHeight()));

            imageInfoData.setWidthForDispTypeB(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeBWidth()));
            imageInfoData.setHeightForDispTypeB(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeBHeight()));

            imageInfoData.setWidthForDispTypeC(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeCWidth()));
            imageInfoData.setHeightForDispTypeC(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeCHeight()));

            imageInfoData.setWidthForDispTypeD(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeDWidth()));
            imageInfoData.setHeightForDispTypeD(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeDHeight()));

            imageInfoData.setWidthForDispTypeE(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeEWidth()));
            imageInfoData.setHeightForDispTypeE(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeEHeight()));

            imageInfoData.setWidthForDispTypeF(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeFWidth()));
            imageInfoData.setHeightForDispTypeF(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeFHeight()));

            imageInfoData.setWidthForDispTypeG(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeGWidth()));
            imageInfoData.setHeightForDispTypeG(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeGHeight()));

            imageInfoData.setWidthForDispTypeS(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeSWidth()));
            imageInfoData.setHeightForDispTypeS(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeSHeight()));

            imageInfoData.setWidthForDispTypeM(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeMWidth()));
            imageInfoData.setHeightForDispTypeM(0);

            imageInfoData.setOrgImgPath(file.getAbsolutePath());
            // 이미지 리사이징 실행
            imageHandler.job(imageInfoData);

            // 이미지 업로드 결과로 반환 할 결과 목록객체 생성
            List<File> destFileList = imageInfoData.getDestFileList();

            for (File destFile : destFileList) {
                // 화면에 반환할 정보 설정
                String targetFileName = destFile.getName();
                String[] fileInfoArr = targetFileName.split("_");
                String[] sizeArr = fileInfoArr[1].split("x");

                result = new GoodsImageUploadVO();
                result.setFileName(fileOrgName);
                result.setImageWidth(sizeArr[0]);
                result.setImageHeight(sizeArr[1]);
                result.setImgType(targetFileName.substring(targetFileName.lastIndexOf("x") + 1,targetFileName.length()));
                result.setTempFileName(DateUtil.getNowDate() + "_" + destFile.getName());
                result.setFileSize(mFile.getSize());
                // 이미지 미리보기 URL
                result.setImageUrl(UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_"+ targetFileName);
                // 이미지 썸네일 URL
                result.setThumbUrl(UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_"+ (targetFileName).substring(0, targetFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
                resultList.add(result);
            }


            } catch (IOException e) {
                // handle exception
            }

             // 반환 정보 설정
                map.put("files", resultList);
                // JSON 형태로 반환
                return map;

    }

   private void copyTempDispImageFile(String tempFileName,String siteId) throws Exception {
        if (!StringUtils.isEmpty(tempFileName)) {
            String tempThumFileNm = tempFileName.substring(0, tempFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
            // 임시 경로의 이미지를 실제 서비스 경로로 복사
            FileUtil.copyGoodsImage(tempFileName,siteId);
            FileUtil.copyGoodsImage(tempThumFileNm,siteId);

            FileUtil.deleteTempFile(tempFileName,siteId); // 이미지 삭제
            FileUtil.deleteTempFile(tempThumFileNm,siteId); // 이미지 삭제
        }
    }

    private static void deleteTempGoodsImageFile(String path, String tempFileNm,String siteId) throws Exception {
        FileUtil.deleteTempFile(tempFileNm,siteId); // 이미지 삭제
    }

    private List<GoodsImageDtlPO> goodsImageDtlInfoList(ResultModel<GoodsImageSizeVO> goodsImageSizeVO,String goodsNo,String imgPath,String fileOrgName,String imageKind , String imageType) throws Exception {
         List<GoodsImageDtlPO> goodsImageDtlList = new ArrayList<>();
         Map ImgPathMap  = new HashMap();

         ImgPathMap = goodsImageUploadResult(goodsImageSizeVO,imgPath,fileOrgName,imageKind,imageType);
         if(ImgPathMap != null && ImgPathMap.size() >0 ) {
             List<GoodsImageUploadVO> list = (List<GoodsImageUploadVO>) ImgPathMap.get("files");
             for (GoodsImageUploadVO vo : list) {
                 GoodsImageDtlPO goodsImageDtlPO = new GoodsImageDtlPO();
                 goodsImageDtlPO.setGoodsNo(goodsNo);
                 goodsImageDtlPO.setTempFileNm(vo.getTempFileName());
                 goodsImageDtlPO.setImgPath(vo.getTempFileName() != null ? vo.getTempFileName().split("_")[0] : "");
                 goodsImageDtlPO.setImgNm(vo.getTempFileName() != null ? vo.getTempFileName().split("_")[1] + "_" + vo.getTempFileName().split("_")[2] : "");
                 goodsImageDtlPO.setGoodsImgType(vo.getImgType());
                 goodsImageDtlPO.setImgWidth(Integer.parseInt(vo.getImageWidth()));
                 goodsImageDtlPO.setImgHeight(Integer.parseInt(vo.getImageHeight()));
                 goodsImageDtlPO.setImgSize(Long.valueOf(vo.getFileSize()).intValue());
                 goodsImageDtlPO.setImgUrl(vo.getImageUrl());
                 goodsImageDtlList.add(goodsImageDtlPO);
             }
         }
        return goodsImageDtlList;
    }

    private GoodsImageSetPO goodsImageSetInfoList(ResultModel<GoodsImageSizeVO> goodsImageSizeVO,String goodsNo,String imgPath,String imageKind , String dltgImgYn) throws Exception {
        GoodsImageSetPO goodsImageSetPo = new GoodsImageSetPO();
        List<GoodsImageDtlPO> goodsImageDtlList = new ArrayList<>();
        goodsImageSetPo.setGoodsNo(goodsNo);
        goodsImageSetPo.setDlgtImgYn(dltgImgYn);

        goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,goodsNo,imgPath,goodsNo+".jpg",imageKind,"01"));
        goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,goodsNo,imgPath,goodsNo+".jpg",imageKind,"02"));
        goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,goodsNo,imgPath,goodsNo+".jpg",imageKind,"03"));
        goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);

        return goodsImageSetPo;
    }

    private static void deleteGoodsImg(String goodsFilePath, String goodsFileName) throws Exception {
        StringBuffer sbPath = new StringBuffer().append(SiteUtil.getSiteUplaodRootPath())
                .append(FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS))
                .append(File.separator).append(goodsFilePath.substring(0, 4)).append(File.separator)
                .append(goodsFilePath.substring(4, 6)).append(File.separator).append(goodsFilePath.substring(6));
        // log.info("[########## FILE DELETE #########] deleteGoodsImg :" +
        // sbPath.toString());
        File file = new File(sbPath.toString() + File.separator + goodsFileName);
        if (file.exists()) { // 존재한다면 삭제
            FileUtil.delete(file);
        }

        // 이미지 디렉토리에 같은 이름을 가진 이미지 파일이 없을 경우, 썸네일 이미지도 삭제한다.
        File directory = new File(sbPath.toString());
        // 이미지 디렉토리의 파일리스트 취득
        File[] tempFile = directory.listFiles();
        String goodsFileNm = goodsFileName.substring(0, goodsFileName.indexOf("_"));
        boolean doDelete = true;
        if (goodsFileNm != null && tempFile != null && tempFile.length > 0) {
            for (int i = 0; i < tempFile.length; i++) {
                if (tempFile[i].isFile()) {
                    String tempFileNm = tempFile[i].getName();
                    // 썸네일 파일이 아닌 파일을 대상으로 같은 파일명의 이미지 파일이 있나 확인한다.
                    if (tempFileNm.indexOf(CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX) < 0
                            && goodsFileNm.equals(tempFileNm.substring(0, tempFileNm.indexOf("_")))) {
                        doDelete = false;
                        break;
                    }
                }
            }
            if (doDelete) {
                File prefixFile = new File(sbPath.toString() + File.separator + goodsFileNm+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
                // log.info("[########## FILE DELETE #########] deleteGoodsImg -
                // PREFIX :" + sbPath.toString()
                // + File.separator + goodsFileNm +
                // CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);

                if (prefixFile.exists()) { // 존재한다면 삭제
                    FileUtil.delete(prefixFile);
                }
            }
        }
    }

}
