package net.danvi.dmall.biz.batch.link.sabangnet.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.xml.parsers.ParserConfigurationException;

import net.danvi.dmall.biz.batch.common.model.IfLogVO;
import net.danvi.dmall.biz.batch.common.service.IfService;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetReader;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetWriter;
import net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model.SabangnetTargetCompanyVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.*;
import net.danvi.dmall.biz.batch.link.sabangnet.model.result.*;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.xml.sax.SAXException;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.batch.common.model.IfExecLogVO;
import net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model.IfSbnLogVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetResult;
import net.danvi.dmall.biz.common.service.BizService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;

@Service("sabangnetService")
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class SabangnetServiceImpl extends BaseService implements SabangnetService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "ifService")
    private IfService ifService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    public List<SabangnetTargetCompanyVO> selectTargetCompany(String ifPgmNo) {
        return proxyDao.selectList("system.link.sabangnet." + "selectSabangnetCompany", ifPgmNo);
    }

    private final Charset CHARSET_EUCKR = Charset.forName("EUC-KR");

    /*
     * 연계 데이터 송신 등록 ServiceImpl
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.batch.link.sabangnet.service#
     * registGoods(net.danvi.dmall.biz.batch.link.sabangnet.model.
     * ProcRunnerVO, String domain)
     *
     * 1. 연계로그 등록
     * ... 1) 연계로그 VO 정보 셋팅 <- ProcRunnerVO
     * ... 2) 연계로그 등록 (연계번호 채번) ..................... insert TI_IF_LOG
     * ... 3) 연계사방넷로그 등록 ............................. insert TI_IF_SBN_LOG
     *
     * 2. 프로시져 호출 - 연계 테이블에 전송데이터 등록
     * ... 1) 연계사방넷배치 로그 등록 ......................... insert TI_IF_SBN_BTCH_LOG
     * ....2) 연계실행로그 등록, 수정 ..................... insert,update TI_IF_EXEC_LOG
     * ... 3) 연계로그 수정 .... 시작/종료 연계일련번호, 데이터건수 . update TI_IF_LOG
     * ... 4) 연계사방넷배치로그 수정 .......................... update TI_IF_SBN_BTCH_LOG
     *
     * 3. 사방넷 연계 처리
     * ... 1) 전송 데이터 XML 파일 생성
     * ... 2) 연계 테이블에 등록된 데이터 조회 (사이트번호, 연계번호)
     * ... 4) 연계 결과 처리
     * ...... 연계 테이블 사방넷연계여부 Y, 결과내용 수정 .......... update TI_XXXXX_XXXXX_IF
     * ...... 연계실행로그 수정 ............................... update TI_IF_EXEC_LOG
     *
     * 4. 연계로그, 연계사방넷 로그 수정 .................. update TI_IF_LOG, TI_IF_SBN_LOG
     */

    // 1.사방넷 상품등록&수정
    @Override
    public void registGoods(ProcRunnerVO vo, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        long totCnt = 0;
        String ifSno = null;
        String step = null;
        String srchKey = null;
        String resultContent = null;
        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();

        try {
            // 1-1.연계로그 등록 (연계번호 채번)
            step = "1-1";

            insertIfLogMain(vo, ifLogVo, ifExecLogVo);

            // 1-3.상품등록&수정 프로시저 호출
            // ----------------------------------------------------------------
            step = "1-3";
            proxyDao.update("system.link.sabangnet." + "spIf01GoodsRegUpd", vo);

            // 1-4.등록된 상품 목록 조회
            step = "1-4";
            GoodsRequest selectList = proxyDao.selectOne("system.link.sabangnet." + "selectGoodsRegi", vo);
            log.debug("{}:{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), selectList.getData().size(), vo);

            if (selectList.getData().size() > 0) {

                // 1-5.상품 목록으로 요청 XML 생성
                step = "1-5";
                selectGoodsListSet(selectList, vo);

                // 1-6. 연계 등록 요청 XML 파일, 연계 실행 url 생성
                String sbnUrl = createGoodsRequestXml(selectList, vo, step, domain);

                step = "1-9";
                log.debug("{}:{} ::: API URL 호출 : {}", step, vo.getIfPgmNm(), sbnUrl);

                // 1-9.사방넷 상품 등록 API 호출
                // ----------------------------------------------------------------
                String sbn_result = HttpUtil.getXmlByRestTemplate(sbnUrl, CHARSET_EUCKR);

                // String[] resultArray = sbn_result.split("\r\n");
                String[] resultArray = sbn_result.split("<br>"); // 결과html을n행으로split

                log.debug("{}:{} ::: 사방넷 상품 등록 결과:{},{}", step, vo.getIfPgmNm(), resultArray, vo.getLang());

                // ##### 사방넷URL 리턴 결과 처리
                ArrayList<String> sbn_resultList = new ArrayList<String>(Arrays.asList(resultArray));
                log.debug("{}:{} ::: 사방넷 리턴 결과:{},{}", step, vo.getIfPgmNm(), sbn_resultList.size(), vo.getLang());

                // 1-10.사방넷 상품등록 결과 성공여부 상품등록연계 테이블에 업데이트
                // ----------------------------------------------------------------
                if (sbn_resultList.size() > 1) {
                    for (String resultData : sbn_resultList) {

                        // 1-10-1.연계결과 수정 (결과내용)
                        step = "1-10";
                        log.debug("{}:{} ::: 사방넷 상품 등록 결과 resultData :{}", step, vo.getIfPgmNm(), resultData);
                        resultData = resultData.replaceAll("<br>", "");

                        if (resultData.contains("성공") && !resultData.contains("수정 성공")) {

                            // [1] <font color="blue"> 성공 : 100000  [I1607121106_0960-1]</font><br>
                            srchKey = resultData.substring(resultData.lastIndexOf("[") + 1, resultData.lastIndexOf("]")) + "-1"; // 신규등록
                            log.debug("1-10-1.# {} 성공 ### 조회키:{}", vo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:
                            ifExecLogVo.setExecConts("1"); // 실행내용 1:신규등록 2:수정
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(">") + 1, resultData.lastIndexOf("]"));
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("0");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);

                            // 연계 테이블 결과 수정 - TI_GOODS_REG_UPD_IF
                            proxyDao.update("system.link.sabangnet." + "updateGoodsRegSbnIfYn", ifExecLogVo);
                            dataCnt = dataCnt + 1;

                        } else if (resultData.contains("수정 성공")) {

                            // [70] <font color="blue">수정 성공 : 100044 [I1608041936_1181-0]</font><br>
                            srchKey = resultData.substring(resultData.lastIndexOf("[") + 1, resultData.lastIndexOf("]")) + "-2"; // 상품 수정등록
                            log.debug("1-10-2.# {} 성공 ### 조회키:{}", vo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:srchKey
                            ifExecLogVo.setExecConts("2"); // 실행내용 1:신규등록 2:수정
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(">") + 1, resultData.lastIndexOf("]") + 1);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("0");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계 테이블 결과 수정 - TI_GOODS_REG_UPD_IF
                            proxyDao.update("system.link.sabangnet." + "updateGoodsRegSbnIfYn", ifExecLogVo);
                            dataCnt = dataCnt + 1;

                        } else if (resultData.contains("총건수")) {

                            // 총건수 : 71 <br>
                            totCnt = Long.parseLong(resultData.substring(resultData.lastIndexOf(": ") + 1).trim());
                            ifLogVo.setErrCd("0");

                            log.debug("1-10-0.# {} 총건수 ###,{} ", totCnt);

                        } else {
                            // <font color="#993300">판매가 </font> 누락 [I1607211505_1033-1]<br>
                            srchKey = resultData.substring(resultData.lastIndexOf("[") + 1, resultData.lastIndexOf("]"));
                            log.debug("1-10-3.# {} 실패 ### 조회키:{}", vo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:srchKey
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(">") + 1, resultData.lastIndexOf("]") + 1);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("-990");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계 테이블 결과 수정 - TI_GOODS_REG_UPD_IF
                            proxyDao.update("system.link.sabangnet." + "updateGoodsRegSbnIfYn", ifExecLogVo);
                        }
                    } // <- for loop
                    ifLogVo.setEndIfSno(ifSno);
                    if (ifLogVo.getErrCd().equals("0")) {
                        ifLogVo.setSucsYn("Y");
                        ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                    } else {
                        ifLogVo.setSucsYn("N");
                        ifLogVo.setResultContent("Interface has failed data !!!!!"); // 사방넷연계-실패!!!!!
                    }

                } else {
                    ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음
                }
                // 1-10-2.연계결과 건수
                step = "1-10-2";
                ifLogVo.setDataCnt(dataCnt);
                ifLogVo.setDataTotCnt(totCnt);
                log.debug("{}:{} ::: 결과 수정 : {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo());

            } else {
                step = "1-11";
                ifLogVo.setResultContent("Not found for new Data"); // 신규등록-연계할-데이터가-없음
                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                log.debug("{}:{} ::: DATA cnt : {}", step, ifLogVo.getIfPgmNm(), selectList.getData().size());
            }
            log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

            // 1-12.연계 로그, 연계 사방넷 로그 수정
            // ------------------------------------------------------
            step = "1-12";
            // ifService.updateIfLog(ifLogVo);
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            log.debug("{}:{} ::: 로그 수정 DATA : {}", step, ifLogVo.getIfPgmNm(), selectList.getData().size());

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            ifLogVo.setResultContent("Sabangnet interface Exception ERROR"); // 사방넷연계Exception
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 2.사방넷 상품요약수정
    @Override
    public void smrUpdGoods(ProcRunnerVO vo, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        long totCnt = 0;
        String ifSno = null;
        String step = null;
        String srchKey = null;
        String resultContent = null;
        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();

        try {
            // 2-1.연계로그 등록 (연계번호 채번)
            step = "2-1";

            insertIfLogMain(vo, ifLogVo, ifExecLogVo);

            // 2-3.상품요약수정 프로시저 호출
            // ----------------------------------------------------------------
            step = "2-3";
            proxyDao.update("system.link.sabangnet." + "spIf02GoodsSmrUpd", vo);

            // 2-4.상품요약수정 목록 조회
            step = "2-4";
            String maxIfNo = proxyDao.selectOne("system.link.sabangnet." + "selectMaxIfNo", ifLogVo);
            if (Long.parseLong(maxIfNo) > Long.parseLong(ifLogVo.getIfNo())) {
                ifLogVo.setIfNo(maxIfNo.toString());
                ifExecLogVo.setIfNo(maxIfNo.toString());
                vo.setIfNo(maxIfNo.toString());
            }

            GoodsSmrUpdRequest selectList = proxyDao.selectOne("system.link.sabangnet." + "selectGoodsSmrUpd", vo);
            log.debug("{}:{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), selectList.getData().size(), vo);

            if (selectList.getData().size() > 0) {

                // 2-5.상품요약수정 목록으로 요청 XML 생성
                step = "2-5";
                selectGoodsSmrUpdListSet(selectList, vo);

                // 2-6. 연계 등록 요청 XML 파일, 연계 실행 url 생성
                String sbnUrl = createGoodsSmrUpdRequestXml(selectList, vo, step, domain);

                step = "2-9";
                log.debug("{}:{} ::: API URL 호출 : {}", step, vo.getIfPgmNm(), sbnUrl);

                // 2-9.사방넷 상품요약수정 API 호출
                // ---------------------------------------------------------------------
                String sbn_result = HttpUtil.getXmlByRestTemplate(sbnUrl, CHARSET_EUCKR);

                // String[] resultArray = sbn_result.split("\r\n");
                String[] resultArray = sbn_result.split("<br>"); // 결과html을n행으로split

                log.debug("{}:{} ::: 사방넷 상품 요약수정 결과:{},{}", step, vo.getIfPgmNm(), resultArray, vo.getLang());

                // ##### 사방넷URL 리턴 결과 처리
                ArrayList<String> sbn_resultList = new ArrayList<String>(Arrays.asList(resultArray));
                log.debug("{}:{} ::: 사방넷 {} 결과:{},{}", step, vo.getIfPgmNm(), sbn_resultList.size(), vo);

                // 2-10.사방넷 상품요약수정 결과 성공여부 상품요약수정연계 테이블에 업데이트
                // ----------------------------------------------------------------
                if (sbn_resultList.size() > 1) {
                    for (String resultData : sbn_resultList) {

                        // 2-10-1.연계결과 수정 (결과내용)
                        step = "2-10";
                        log.debug("{}:{} ::: 사방넷 상품요약수정 결과 resultData :{}", step, vo.getIfPgmNm(), resultData);

                        if (resultData.contains("성공")) {

                            // [1] <font color="blue">성공 : 100000 [I1607121106_0960-1]</font><br>
                            srchKey = resultData.substring(resultData.lastIndexOf("[") + 1, resultData.lastIndexOf("]")) + "-2"; // 상품 요약수정등록
                            log.debug("2-10-1.# {} 성공 ### 조회키:{}", ifExecLogVo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:srchKey
                            ifExecLogVo.setExecConts("2"); // 실행내용 2:수정
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(">") + 1, resultData.lastIndexOf("]"));
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("0");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계 테이블 결과 수정
                            proxyDao.update("system.link.sabangnet." + "updateGoodsSmrUpdSbnIfYn", ifExecLogVo);
                            dataCnt = dataCnt + 1;

                        } else if (resultData.contains("총건수")) {

                            // 총건수 : 71 <br>
                            totCnt = Long.parseLong(resultData.substring(resultData.lastIndexOf(": ") + 1).trim());
                            ifLogVo.setErrCd("0");

                            log.debug("2-10-1.# {} 총건수 ###,{} ", resultData.substring(resultData.lastIndexOf(": ") + 1).trim());

                        } else {

                            // [17] <font color='#993300'>판매가 </font> 누락 [I1607211505_1033-1]<br>
                            srchKey = resultData.substring(resultData.lastIndexOf("[") + 1,
                                    resultData.lastIndexOf("]"));
                            log.debug("2-10-1.# {} 실패 ### 조회키:{}", ifExecLogVo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:srchKey
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(">") + 1, resultData.lastIndexOf("]"));
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("-990");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계 테이블 결과 수정
                            proxyDao.update("system.link.sabangnet." + "updateGoodsSmrUpdSbnIfYn", ifExecLogVo);
                        }
                    } // <- for loop
                    ifLogVo.setEndIfSno(ifSno);
                    if (ifLogVo.getErrCd().equals("0")) {
                        ifLogVo.setSucsYn("Y");
                        ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                    } else {
                        ifLogVo.setSucsYn("N");
                        ifLogVo.setResultContent("Interface has failed data !!!!!"); // 사방넷연계-실패!!!!!
                    }
                } else {
                    ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음
                }
                // 2-10-2.연계결과 건수
                step = "2-10-2";
                ifLogVo.setDataCnt(dataCnt);
                ifLogVo.setDataTotCnt(totCnt);
                log.debug("{}:{} ::: 결과 수정 : {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo());

            } else {
                step = "2-11";
                ifLogVo.setResultContent("Not found for new Data"); // 신규등록-연계할-데이터가-없음
                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                log.debug("{}:{} ::: DATA cnt : {}", step, ifLogVo.getIfPgmNm(), selectList.getData().size());
            }
            log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

            // 2-12.연계 로그, 연계 사방넷 로그 수정
            // ----------------------------------------------------------------
            step = "2-12";
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            log.debug("{}:{} ::: 로그 수정 DATA : {}", step, ifLogVo.getIfPgmNm(), selectList.getData().size());

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            ifLogVo.setResultContent("Sabangnet interface Exception ERROR"); // 사방넷연계Exception
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 3.사방넷 주문수집 요청XML 생성
    @Override
    public String createOrderRequestXml(OrderRequest orderRequest, List<Order> list, ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        String step = null;

        try {
            // 3-1.주문수집 요청 XML 생성
            // ----------------------------------------------------------------
            step = "3-1";
            String xmlFileName = SabangnetConstant.XML_NM_ORDER_REQUEST;

            // 3-2.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
            String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId()) + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

            step = "3-2";
            log.debug("{}.{} SabangnetWriter.writeOrder : {},{}", step, vo.getIfPgmNm(), xmlFileName, list);
            SabangnetWriter.writeOrder(orderRequest, filePath, list, vo.getLang());

            return xmlFileName;

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            // result.setSuccess(false);
            throw new CustomException("biz.exception.common.error");
        }
    }

    // 3.사방넷 주문수집
    @Override
    public void getherOrder(String domain, String xmlFileName, ProcRunnerVO vo)
            throws ParserConfigurationException, SAXException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        long dataDtlCnt = 0;
        String step = null;
        String ifNo = null;
        String ifSno = null;

        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();

        try {
            // 3-3.XML 외부 접속 경로 생성
            step = "3-3";
            log.debug("{}.{} XML File Name : {}", step, vo.getIfPgmNm(), xmlFileName);

            String siteUrl = "http://" + domain;
            // 테스트 URL
            //String siteUrl = "http://id1.test.com";
            StringBuilder xmlURI = new StringBuilder(siteUrl);
            xmlURI.append("/resource/");
            xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
            xmlURI.append("/").append(xmlFileName);
            // 테스트 XML 파일
            //xmlURI.append("/").append("xml_ordResult.xml");

            String url = SabangnetConstant.XML_READ_ORDER_URL + xmlURI.toString();

            step = "3-4";
            log.debug("{}.{} ::: API 호출 : {}", step, vo.getIfPgmNm(), url);
            log.debug("{}.{} ::: xmlURI : {}", step, vo.getIfPgmNm(), xmlURI);

            // 3-4.사방넷 주문수집 API 호출 후 반환된 XML을 데이터로 변환
            // -----------------------------------------------------------------------------------
            //SabangnetResult<OrderResult> resultList = SabangnetReader.readOrder(url, vo.getLang());
            // 테스트용
            SabangnetResult<OrderResult> resultList = SabangnetReader.readOrderXml(xmlURI.toString(), vo.getLang());
            log.debug("{}.{} ::: 조회 결과 resultList :{}", step, vo.getIfPgmNm(), resultList);



            // TODO: 결과 처리
            if (resultList.getData().size() > 0) {

                OrderResult resultDb = new OrderResult();

                insertIfLogMain(vo, ifLogVo, ifExecLogVo);

                // 3-5.주문수집 연계 테이블 등록 <- 주문 조회 결과
                // ------------------------------------------------------------------
                step = "3-5";
                log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), vo);
                for (Object resultObj : resultList.getData()) {

                    resultDb = (OrderResult) resultObj;

                    if (resultDb.getOrderStatus().equals("신규주문") || resultDb.getOrderStatus().equals("취소완료")
                            || resultDb.getOrderStatus().equals("반품완료") || resultDb.getOrderStatus().equals("교환완료")) {

                        // 3-5-1.연계실행로그 등록(연계 일련번호 채번)
                        step = "3-5-1";
                        // 3-5-1.주문수집 연계 테이블 중복 체크
                        resultDb.setSiteNo(vo.getSiteNo());
                        String dupYn = proxyDao.selectOneNolog("system.link.sabangnet." + "selectOrdClctIfDupYn", resultDb);
                        log.debug("{}.{} ::: 주문수집 연계 테이블 중복 체크 : {},{}", step, vo.getIfPgmNm(), dupYn);

                        // 주문 연계 테이블에 중복자료가 없으면 - 'N'
                        if (dupYn.equals("N")) {

                            ifExecLogVo.setExecKey(resultDb.getIdx()); // 사방넷주문번호
                            ifService.insertIfExecLog(ifExecLogVo);
                            log.debug("{}.{} ::: 연계일련번호채번, 연계실행로그 등록: {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(), resultObj);

                            step = "3-5-2";
                            log.debug("{}.{} ::: 연계 일련번호 셋팅 : {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(), resultDb);

                            resultDb.setIfSno(ifExecLogVo.getIfSno()); // 연계일련번호
                            resultDb.setIfNo(vo.getIfNo()); // 연계번호
                            resultDb.setIfId(vo.getIfId()); // 연계ID
                            resultDb.setSiteNo(vo.getSiteNo()); // 사이트번호
                            resultDb.setRegrNo(vo.getRegrNo()); // 등록자번호
                            // resultDb.setOrdNo(ordNo.toString()); // 주문번호

                            cnt1 = cnt1 + 1;
                            if (cnt1 == 1) {
                                vo.setStartIfSno(ifExecLogVo.getIfSno()); // 시작연계일련번호-연계로그업데이트용
                                ifLogVo.setStartIfSno(ifExecLogVo.getIfSno());
                            }

                            // 3-5-4.주문수집연계 테이블 등록
                            // ----------------------------------------------------------------------
                            step = "3-5-4";
                            log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), resultDb);

                            proxyDao.insert("system.link.sabangnet." + "insertOrdClctIf", resultDb);
                        }
                    }
                } // <- for loop

                step = "3-6";
                // ● 3-6.주문 처리 - 주문수집 연계 테이블 조회
                // ======================================================================================================
                List<OrdClctIfPO> ordClctIfPO = proxyDao.selectList("system.link.sabangnet." + "selectOrdClctIfList", vo);
                log.debug("{}.{} ::: 쇼핑몰 주문번호별 조회 결과 : {},{}", step, vo.getIfPgmNm(), ordClctIfPO.size(), ordClctIfPO);

                if (ordClctIfPO.size() > 0) {

                    // 연계 사방넷 배치 로그 등록
                    // ----------------------------------------------------------------------
                    proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogReg", ifLogVo);

                    for (int i = 0; i < ordClctIfPO.size(); i++) {

                        OrdClctIfPO procDb = ordClctIfPO.get(i);

                        procDb.setRegrNo(vo.getRegrNo());
                        procDb.setUpdrNo(vo.getUpdrNo());

                        log.debug("{}.{} ::: 쇼핑몰 주문번호별 procDb : {}", step, vo.getIfPgmNm(), procDb);
                        String orgOrdNo = "";

                        // ♣ 3-6.신규주문 수집 주문자료 처리
                        if (procDb.getOrdDlvrStatus().equals("신규주문")) {

                            // ● 3-6-0.주문 테이블 자료 존재여부 체크
                            step = "3-6-0";
                            String existYn = proxyDao.selectOne("system.link.sabangnet." + "selectOrdExistYn", procDb);
                            log.debug("{}.{} ::: 주문 테이블 존재여부 체크 : {},{}", step, vo.getIfPgmNm(), existYn);

                            // ◈ 주문 테이블에 자료가 존재하지 않으면(신규주문) - 'N'
                            if (existYn.equals("N")) {

                                // ◈ 주문번호생성-> 원본주문번호조회->
                                // ◈ 주문상태20, 주문배송지, 결제상태02 인서트, 주문상세상태20, 배송 인서트
                                // =====================================================================================

                                // ● 3-6-1.주문번호 생성
                                step = "3-6-1";
                                Long ordNo = orderService.createOrdNo(vo.getSiteNo());
                                log.debug("{}.{} ::: 주문번호 생성 : {}", step, vo.getIfPgmNm(), ordNo);

                                // ● 3-6-2.원본 주문번호 조회 (사방넷 원본 주문번호가 있는 경우)
                                if (procDb.getSbnOrgOrdNo().length() > 0) {
                                    step = "3-6-2";
                                    orgOrdNo = proxyDao.selectOne("system.link.sabangnet." + "selectOrgOrdNo", procDb);
                                    log.debug("{}.{} ::: 원본 주문번호 조회 : {}", step, vo.getIfPgmNm(), orgOrdNo);
                                }

                                step = "3-6-3";
                                procDb.setOrdNo(ordNo.toString());
                                procDb.setOrgOrdNo(orgOrdNo);
                                log.debug("{}.{} ::: 주문 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);

                                // ● 3-6-3.주문 처리 - 주문, 주문배송지, 결제테이블 등록:
                                // ◈ 주문상태 20 주문테이블, 결제상태 02 결제테이블 인서트
                                // ----------------------------------------------------------------------
                                proxyDao.update("system.link.sabangnet." + "procOrd", procDb);
                                dataCnt = dataCnt + 1;

                                step = "3-6-4";

                                // ● 3-6-4.주문 상세 조회
                                List<OrdClctIfDtlPO> ordClctIfDtlPO = proxyDao.selectList("system.link.sabangnet." + "selectOrdClctIfDtlList", procDb);

                                if (ordClctIfDtlPO != null) {

                                    Integer ordDtlSeq = 0;
                                    for (int j = 0; j < ordClctIfDtlPO.size(); j++) {

                                        OrdClctIfDtlPO procDtlDb = ordClctIfDtlPO.get(j);
                                        procDtlDb.setSiteNo(vo.getSiteNo());

                                        if (procDtlDb.getOrdDlvrStatus().equals("신규주문")) {

                                            ordDtlSeq = ordDtlSeq + 1;

                                            log.debug("{}.{}### ::: 주문 상세 조회 procDtlDb : {}, {}, {}", step, vo.getIfPgmNm(), procDtlDb.getOrdNo(), ordDtlSeq, procDtlDb);

                                            procDtlDb.setOrdNo(procDb.getOrdNo()); // 주문번호
                                            procDtlDb.setOrdDtlSeq(ordDtlSeq.toString()); // 주문상세순번
                                            procDtlDb.setRegrNo(procDb.getRegrNo()); // 등록자번호
                                            procDtlDb.setUpdrNo(procDb.getUpdrNo()); // 수정자번호

                                            // 3-6-5.주문 상세 처리
                                            // ----------------------------------------------------------------------
                                            step = "3-6-5";
                                            log.debug("{}.{} ::: 주문 상세 처리 procDtlDb 조회 : {}", step, vo.getIfPgmNm(), procDtlDb);

                                            // ● 주문상세처리- 주문상세, 배송 테이블등록, 단품재고 차감
                                            // ◈ 주문상세상태 20 주문상세테이블, 배송테이블 인서트
                                            proxyDao.update("system.link.sabangnet." + "procOrdDtl", procDtlDb);
                                            dataDtlCnt = dataDtlCnt + 1;

                                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                                            ifExecLogVo.setIfSno(procDtlDb.getIfSno());
                                            ifExecLogVo.setSucsYn("Y");
                                            ifExecLogVo.setErrCd("0");
                                            ifLogVo.setErrCd("0");
                                            ifExecLogVo.setExecConts(procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString());
                                            ifExecLogVo.setResultContent("주문수집 성공 : " + procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString()); // 사방넷리턴-결과내용
                                            ifService.updateIfExecLog(ifExecLogVo);
                                            log.debug("{}.{} ::: 연계실행로그 수정 End : {}", step, vo.getIfPgmNm(), ifExecLogVo);
                                        } else {
                                            ifLogVo.setSucsYn("N");
                                            ifLogVo.setErrCd("-900");
                                            ifLogVo.setResultContent("Not Order Status data !!!!!"); // 주문상태가아님!!!!!
                                            log.debug("{}.{} ::: 주문상태가 아닌 데이터!!!!! End : {}", step, vo.getIfPgmNm(), ifLogVo);
                                        }
                                    } // <- for loop

                                    // ◈ 주문, 결제 테이블 결제금액 업데이트
                                    proxyDao.update("system.link.sabangnet." + "procOrdPaymentUpdate", procDb);

                                } else {
                                    ifLogVo.setSucsYn("N");
                                    ifLogVo.setErrCd("-900");
                                    ifLogVo.setResultContent("No data from ordClctIfDtlPO !!!!!"); // 사방넷연계-주문상세데이터가-없음
                                    log.debug("{}.{} ::: 사방넷연계-주문상세데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                                }
                            } else {
                                // 주문 테이블에 자료가 있으면 처리 안함
                                log.debug("{}.{} ::: 사방넷연계-주문 테이블에 자료가 있으면 처리 안함 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                            }
                        } else if ((procDb.getOrdDlvrStatus().equals("취소완료") || procDb.getOrdDlvrStatus().equals("반품완료")
                                || procDb.getOrdDlvrStatus().equals("교환완료"))) {

                            // ♣ 3.7.클레임완료 주문자료 처리
                            // =============================================================================================
                            // ● 3-7-0.클레임완료 주문자료 - 주문 테이블 주문번호 조회
                            step = "3-7-0";
                            String ordNo = proxyDao.selectOne("system.link.sabangnet." + "selectClaimCmpltOrdNo", procDb);
                            log.debug("{}.{} ::: 클레임완료 - 주문 테이블 주문번호 조회 : {},{}", step, vo.getIfPgmNm(), ordNo);

                            // ♣ 클레임완료 주문자료 - 주문 테이블에 자료가 있으면
                            // ◈ 주문상세상태 21,66,74, 반품코드 12
                            // ◈ 클레임완료코드~클레임메모, 주문상세업데이트
                            // ◈ 부분 클레임완료시 결제차수+1 결제테이블 인서트
                            // ◈ 전체 클레임완료시 주문상태 21,결제상태 03 주문테이블, 결제테이블 업데이트
                            if (ordNo!= null && ordNo.length() > 0) {

                                procDb.setOrdNo(ordNo);

                                // ● 3-6-4.클레임완료 - 주문 상세 자료 조회
                                step = "3-6-4";
                                List<OrdClctIfDtlPO> ordClctIfDtlPO = proxyDao.selectList("system.link.sabangnet." + "selectOrdClctIfDtlList", procDb);

                                // 3-6-4.클레임완료 - 주문상세자료 - 주문상세 테이블에 자료가 있으면
                                if (ordClctIfDtlPO != null) {

                                    Integer ordDtlSeq = 0;
                                    for (int j = 0; j < ordClctIfDtlPO.size(); j++) {

                                        OrdClctIfDtlPO procDtlDb = ordClctIfDtlPO.get(j);

                                        procDtlDb.setRegrNo(procDb.getRegrNo());
                                        procDtlDb.setUpdrNo(procDb.getUpdrNo());

                                        log.debug("{}.{} ::: 클레임완료 - 주문 상세 처리 procDtlDb 조회 : {}", step, vo.getIfPgmNm(), procDtlDb);

                                        if (procDtlDb.getOrdDlvrStatus().equals("취소완료")
                                                || procDtlDb.getOrdDlvrStatus().equals("반품완료")
                                                || procDtlDb.getOrdDlvrStatus().equals("교환완료")) {

                                            // ● 클레임완료 - 주문 상세 테이블 업데이트
                                            // ◈ 주문상세상태 21,66,74, 반품코드 12
                                            // ◈ 클레임완료코드~클레임메모, 주문상세업데이트
                                            proxyDao.update("system.link.sabangnet." + "procClaimCmpltOrdDtl", procDtlDb);

                                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                                            ifExecLogVo.setIfSno(procDtlDb.getIfSno());
                                            ifExecLogVo.setSucsYn("Y");
                                            ifExecLogVo.setErrCd("0");
                                            ifLogVo.setErrCd("0");
                                            ifExecLogVo.setResultContent("클레임완료 - 주문상세 처리 성공 : " + procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString()); // 사방넷리턴-결과내용
                                        }
                                        ifExecLogVo.setExecConts(procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString());
                                        ifService.updateIfExecLog(ifExecLogVo);
                                        log.debug("{}.{} ::: 클레임완료 - 연계실행로그 수정 End : {}", step, vo.getIfPgmNm(), ifExecLogVo);
                                    } // <- for loop
                                }

                                // ● ◈ 클레임완료시 결제차수+1 결제테이블 인서트
                                // ◈ 최종결제금액 - 클레임 주문금액 + 클레임완료 제외한 배송비합계
                                // ==============================================================================
                                proxyDao.update("system.link.sabangnet." + "insertClaimCmpltPayment", procDb);

                                log.debug("{}.{} ::: 클레임완료 - 결제 테이블 인서트 +1차수 증가 : {}", step, vo.getIfPgmNm(), procDb);

                                // ● 주문상세 전체 클레임완료 여부 조회
                                // ==============================================================================
                                String allClaimCmpltYn = proxyDao.selectOne("system.link.sabangnet." + "selectAllClaimCmpltCheck", procDb);

                                log.debug("{}.{} ::: 클레임완료 - 주문상세 전체 클레임완료 여부 조회 allClaimCmpltYn: {},{}", step, vo.getIfPgmNm(), allClaimCmpltYn, procDb);

                                if (allClaimCmpltYn.equals("Y")) {
                                    // ● ◈ 전체 클레임완료시 주문상태 21, 결제상태 03
                                    // ◈ 주문테이블, 결제테이블 업데이트
                                    proxyDao.update("system.link.sabangnet." + "procClaimCmpltOrdPayment", procDb);

                                    log.debug("{}.{} ::: 전체 클레임완료 - 주문, 결제 테이블 업데이트 : {}", step, vo.getIfPgmNm(), procDb);

                                }
                                // ♣ 3-9.클레임완료 교환완료 재주문 처리
                                // ==========================================================================================
                                if (procDb.getOrdDlvrStatus().equals("교환완료")) {

                                    step = "3-9-3";

                                    procDb.setOrgOrdNo(ordNo); // ● 원본주문번호->주문번호

                                    // ● 3-9-3.재주문번호 생성
                                    ordNo = String.valueOf(orderService.createOrdNo(vo.getSiteNo()));
                                    log.debug("{}.{} ::: 재주문번호 생성 : {}", step, vo.getIfPgmNm(), ordNo);
                                    procDb.setOrdNo(ordNo);

                                    // ● 클레임완료 - 교환 재주문 처리
                                    // ◈ 주문상태 20, 결제상태 02 - 주문, 주문배송지, 결제 테이블등록
                                    // ---------------------------------------------------------------------------------
                                    proxyDao.update("system.link.sabangnet." + "procClaimReOrder", procDb); // 재주문처리
                                    dataCnt = dataCnt + 1;

                                    // ● 3-6-4.주문 상세 조회
                                    step = "3-6-4";
                                    ordClctIfDtlPO = proxyDao.selectList("system.link.sabangnet." + "selectOrdClctIfDtlList", procDb);

                                    if (ordClctIfDtlPO != null) {

                                        Integer ordDtlSeq = 0;
                                        for (int j = 0; j < ordClctIfDtlPO.size(); j++) {

                                            OrdClctIfDtlPO procDtlDb = ordClctIfDtlPO.get(j);

                                            if (procDtlDb.getOrdDlvrStatus().equals("교환완료")) {

                                                procDtlDb.setOrdNo(procDb.getOrdNo());
                                                procDtlDb.setOrdDtlSeq(ordDtlSeq.toString());

                                                // 5-6-5.클레임완료 - 재주문상세순번
                                                step = "5-6-5";
                                                log.debug("{}.{} ::: 재주문상세순번 : {},{}", step, vo.getIfPgmNm(), procDtlDb.getOrdDtlSeq(), procDtlDb);

                                                // ● 클레임처리 - 교환 재주문상세 처리
                                                // ◈ 주문상세상태 20 주문상세,배송 테이블등록
                                                // ---------------------------------------------------------------------------------
                                                proxyDao.update("system.link.sabangnet." + "procClaimReOrderDtl", procDtlDb); // 재주문상세처리
                                            }
                                        } // <- for loop

                                        // ● 클레임완료 - 교환 재주문 처리
                                        // - ◈ 결제,판매,할인,환불 금액 - 주문,결제 테이블 업데이트
                                        proxyDao.update("system.link.sabangnet." + "procOrdPaymentUpdate", procDb);
                                    }
                                }
                            } else {
                                // ♣ 클레임완료 NoOrd 주문자료 - 주문 테이블에 자료가 없으면
                                // ◈ 클레임완료 - 주문 테이블에 자료가 없으면(취소완료등 상태변경된 자료)
                                // ◈ 주문상태 21, 결제상태 03, 주문,주문배송지,결제 테이블 인서트
                                // ◈ 주문상세상태 21,66,74 주문상세,배송 테이블 인서트
                                // =====================================================================================

                                step = "3-9-1";
                                // ● ◈ 3-9-1.클레임완료 NoOrd 주문번호 생성
                                Long ordNo1 = orderService.createOrdNo(vo.getSiteNo());
                                procDb.setOrdNo(ordNo1.toString());
                                log.debug("{}.{} ::: 클레임완료 NoOrd 주문번호 생성 : {}", step, vo.getIfPgmNm(), ordNo1);

                                step = "3-9-2";
                                // ● ◈ 3-9-2.클레임완료 NoOrd 원본 주문번호 조회
                                orgOrdNo = proxyDao.selectOne("system.link.sabangnet." + "selectOrgOrdNo", procDb);
                                procDb.setOrgOrdNo(orgOrdNo);
                                log.debug("{}.{} ::: 클레임완료 NoOrd 원본 주문번호 조회 : {}", step, vo.getIfPgmNm(), orgOrdNo);

                                step = "3-9-3";
                                procDb.setRegrNo(vo.getRegrNo());
                                procDb.setUpdrNo(vo.getUpdrNo());
                                log.debug("{}.{} ::: 클레임완료 NoOrd 주문 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);

                                // 3-9-3.클레임완료 NoOrd 주문 처리
                                // ◈ 주문상태 21, 결제상태 03, 주문,주문배송지,결제 테이블 인서트
                                // ----------------------------------------------------------------------
                                proxyDao.update("system.link.sabangnet." + "procClaimCmpltNoOrd", procDb);
                                dataCnt = dataCnt + 1;

                                // ● 3-9-4.클레임완료 NoOrd 주문 상세 조회
                                step = "3-9-4";
                                List<OrdClctIfDtlPO> ordClctIfDtlPO = proxyDao.selectList("system.link.sabangnet." + "selectOrdClctIfDtlList", procDb);

                                if (ordClctIfDtlPO != null) {

                                    Integer ordDtlSeq = 0;
                                    for (int j = 0; j < ordClctIfDtlPO.size(); j++) {

                                        OrdClctIfDtlPO procDtlDb = ordClctIfDtlPO.get(j);

                                        ordDtlSeq = ordDtlSeq + 1;

                                        log.debug("{}.{}### ::: 클레임완료 NoOrd 주문 상세 조회 procDtlDb : {}, {}", step, vo.getIfPgmNm(), procDtlDb.getOrdNo(), procDtlDb);

                                        procDtlDb.setOrdNo(procDb.getOrdNo());
                                        procDtlDb.setOrdDtlSeq(ordDtlSeq.toString());
                                        procDtlDb.setRegrNo(procDb.getRegrNo());
                                        procDtlDb.setUpdrNo(procDb.getUpdrNo());

                                        step = "3-9-5";
                                        log.debug("{}.{} ::: 클레임완료 NoOrd 주문 상세 처리 procDtlDb 조회 : {}", step, vo.getIfPgmNm(), procDtlDb);

                                        // 3-9-5.클레임완료 NoOrd 주문 상세 처리
                                        // ● 클레임완료 NoOrd 주문상세처리
                                        // ◈ 주문상세상태 21,66,74 주문상세, 배송 테이블등록
                                        // ----------------------------------------------------------------------
                                        proxyDao.update("system.link.sabangnet." + "procClaimCmpltOrdDtlNoOrd", procDtlDb);
                                        dataDtlCnt = dataDtlCnt + 1;

                                        // 연계실행로그 수정 - TI_IF_EXEC_LOG
                                        ifExecLogVo.setIfSno(procDtlDb.getIfSno());
                                        ifExecLogVo.setSucsYn("Y");
                                        ifExecLogVo.setErrCd("0");
                                        ifLogVo.setErrCd("0");
                                        ifExecLogVo.setExecConts(procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString());
                                        ifExecLogVo.setResultContent("클레임완료 NoOrd 성공 : " + procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString()); // 사방넷리턴-결과내용
                                        ifService.updateIfExecLog(ifExecLogVo);
                                        log.debug("{}.{} ::: 연계실행로그 수정 End : {}", step, vo.getIfPgmNm(), ifExecLogVo);

                                    } // <- for loop

                                    // ● 클레임완료 NoOrd
                                    // - ◈ 결제,판매,할인,환불 금액 - 주문,결제 테이블 업데이트
                                    proxyDao.update("system.link.sabangnet." + "updateClaimCmpltReOrdAmt", procDb);

                                } else {
                                    ifLogVo.setSucsYn("N");
                                    ifLogVo.setErrCd("-900");
                                    ifLogVo.setResultContent("No data from ordClctIfDtlPO !!!!!"); // 사방넷연계-주문상세데이터가-없음
                                    log.debug("{}.{} ::: 사방넷연계-주문상세데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                                }
                            }

                            // 주문수집연계 테이블 최종 IF_SNO 만 남기고 모두 삭제
                           // proxyDao.update("system.link.sabangnet." + "deleteOrdClctIfPastData",vo.getSiteNo());

                            if (ifLogVo.getErrCd() == "0") {
                                ifLogVo.setSucsYn("Y");
                                ifLogVo.setErrCd("0");
                                ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                                log.debug("{}.{} ::: 사방넷연계-성공!!!!! End : {}", step, vo.getIfPgmNm(), ifLogVo);
                            } else {
                                ifLogVo.setSucsYn("Y");
                                ifLogVo.setErrCd("0");
                                ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                                log.debug("{}.{} ::: 사방넷연계-성공!!!!! End : {}", step, vo.getIfPgmNm(), ifLogVo);
                            }
                        } else {
                            ifLogVo.setSucsYn("N");
                            ifLogVo.setErrCd("-900");
                            ifLogVo.setResultContent("No data from ordClctIfPO !!!!!"); // 사방넷연계-주문데이터가-없음
                            log.debug("{}.{} ::: 사방넷연계-주문데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                        }
                    } // <- for loop

                    // 3-7.연계결과 건수
                    step = "3-7";
                    ifLogVo.setDataCnt(dataCnt);
                    ifLogVo.setDataTotCnt(dataDtlCnt);
                    log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

                    // 3-8.연계 사방넷 배치 로그 수정
                    // ----------------------------------------------------------------------
                    step = "3-8";
                    proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogUpd", ifLogVo);

                    // 3-9.연계 로그, 연계 사방넷 로그 수정
                    // ------------------------------------------------------
                    step = "3-9";
                    ifLogVo.setEndIfSno(ifExecLogVo.getIfSno()); // 종료연계일련번호
                    log.debug("{}.{} ::: 연계 로그 수정 : {}", step, vo.getIfPgmNm(), ifLogVo);
                    // proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
                    ifService.updateIfLog(ifLogVo);
                    updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
                }


            } else {
                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                ifLogVo.setSucsYn("N");
                ifLogVo.setErrCd("-930");
                ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음
                log.debug("{}:{} ::: DATA cnt : {}", step, ifLogVo.getIfPgmNm(), resultList.getData().size());
                ifService.updateIfLog(ifLogVo);
                updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            ifLogVo.setResultContent("Sabangnet interface Exception ERROR"); // 사방넷연계Exception
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 4.사방넷 송장등록
    @Override
    public void registInvoice(ProcRunnerVO vo, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        long totCnt = 0;
        String ifSno = null;
        String step = null;
        String srchKey = null;
        String resultContent = null;
        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();

        try {
            // 4-1.연계로그 등록 (연계번호 채번)
            step = "4-1";

            insertIfLogMain(vo, ifLogVo, ifExecLogVo);

            // 4-3.송장등록 프로시저 호출
            // ----------------------------------------------------------------
            step = "4-3";
            proxyDao.update("system.link.sabangnet." + "spIf04InvoiceReg", vo);

            // 4-4.등록된 송장 목록 조회
            step = "4-4";
            InvoiceRequest selectList = proxyDao.selectOne("system.link.sabangnet." + "selectInvoiceRegi", vo);
            log.debug("{}:{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), selectList.getData().size(), vo);

            if (selectList.getData().size() > 0) {

                // 4-5.송장등록 목록으로 요청 XML 생성
                step = "4-5";
                selectInvoiceListSet(selectList, vo);

                // 4-6. 연계 등록 요청 XML 파일, 연계 실행 url 생성
                String sbnUrl = createInvoiceRequestXml(selectList, vo, step, domain);

                step = "4-9";
                log.debug("{}:{} ::: API URL 호출 : {}, {}", step, vo.getIfPgmNm(), sbnUrl);

                // 4-9.사방넷 송장등록 API 호출
                // ---------------------------------------------------------------------
                String sbn_result = HttpUtil.getXmlByRestTemplate(sbnUrl, CHARSET_EUCKR);

                String[] resultArray = sbn_result.split("<br>"); // 결과html을n행으로split

                log.debug("{}:{} ::: 사방넷 송장등록 결과:{},{}", step, vo.getIfPgmNm(), resultArray, vo.getLang());

                // ##### 사방넷URL 리턴 결과 처리
                ArrayList<String> sbn_resultList = new ArrayList<String>(Arrays.asList(resultArray));
                log.debug("{}:{} ::: 사방넷 {} 결과:{},{}", step, vo.getIfPgmNm(), sbn_resultList.size(), vo.getLang());

                // 4-10.사방넷 송장등록 결과 성공여부 송장등록연계 테이블에 업데이트
                // ----------------------------------------------------------------
                if (sbn_resultList.size() > 1) {
                    for (String resultData : sbn_resultList) {

                        // 4-10-1.연계결과 수정 (결과내용)
                        step = "4-10-1";
                        log.debug("4-10-1.사방넷 송장등록 결과:{}", resultData);

                        if (resultData.contains("성공") && !resultData.contains("수정 성공")) {

                            // [1] 성공 : 22287764
                            srchKey = resultData.substring(resultData.lastIndexOf(": ") + 2, resultData.indexOf(": ") + 10).trim();
                            //srchKey = srchKey.substring(0, srchKey.lastIndexOf("("));
                            log.debug("2-10-1.# {} 성공 ### 조회키:{}", vo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:운송장번호
                            ifExecLogVo.setExecConts("1"); // 실행내용 1:신규등록 2:수정
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(": ") + 2);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("0");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계테이블 결과 수정
                            proxyDao.update("system.link.sabangnet." + "updateInvoiceRegSbnIfYn", ifExecLogVo);
                            dataCnt = dataCnt + 1;

                        } else if (resultData.contains("수정 성공")) {

                            // [1] 수정 성공 : 60299883(출고대기)
                            srchKey = resultData.substring(resultData.lastIndexOf(": ") + 2, resultData.indexOf(": ") + 10).trim();
                            //srchKey = srchKey.substring(0, srchKey.lastIndexOf("("));
                            log.debug("2-10-1.# {} 성공 ### 조회키:{}", vo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:운송장번호
                            ifExecLogVo.setExecConts("2"); // 실행내용 1:신규등록 2:수정
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            resultContent = resultData.substring(resultData.indexOf(": ") + 2);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("0");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계테이블 결과 수정
                            proxyDao.update("system.link.sabangnet." + "updateInvoiceRegSbnIfYn", ifExecLogVo);
                            dataCnt = dataCnt + 1;

                        } else if (resultData.contains("총건수")) {

                            // "총건수 : 71" :
                            totCnt = Long.parseLong(resultData.substring(resultData.lastIndexOf(": ") + 1).trim());
                            ifLogVo.setErrCd("0");

                            log.debug("2-10-1.# {} 총건수 ###,{} ", resultData.substring(resultData.lastIndexOf(": ") + 1).trim());

                        } else {

                            // [2] 실패 : 22287761 - 주문이 존재하지 않습니다.주문번호를 확인해주세요
                            // [3] 실패 : 21290850 (출고완료) - 송장번호를 입력가능한 상태가 아닙니다.
                            // [4] 실패 : 21290851 - 택배사 코드 또는 송장번호가 비었습니다.

                            srchKey = resultData.substring(resultData.lastIndexOf(": ") + 2, resultData.indexOf(": ") + 10).trim();
                            /*srchKey = srchKey.substring(0, srchKey.lastIndexOf("("));*/
                            log.debug("2-10-1.# {} 실패 ### 조회키:{}", vo.getIfPgmNm(), srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:운송장번호
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            //resultContent = resultData.substring(resultData.indexOf(": ") + 2,resultData.indexOf(": ") + 9);
                            resultContent = resultData.substring(resultData.indexOf(": ") + 2);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultContent); // 사방넷리턴-결과내용
                            ifLogVo.setErrCd("-990");
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                        }
                    } // <- for loop
                    ifLogVo.setEndIfSno(ifSno);
                    if (ifLogVo.getErrCd().equals("0")) {
                        ifLogVo.setSucsYn("Y");
                        ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                    } else {
                        ifLogVo.setSucsYn("N");
                        ifLogVo.setResultContent("Interface has failed data !!!!!"); // 사방넷연계-실패!!!!!
                    }

                } else {
                    ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음
                }
                // 4-10-3.연계결과 수정 (결과내용)
                step = "4-10-3";
                ifLogVo.setDataCnt(dataCnt);
                ifLogVo.setDataTotCnt(totCnt);
                log.debug("{}:{} ::: 결과 수정 : {}", step, vo.getIfPgmNm(), ifLogVo.getIfNo());

            } else {
                step = "4-11";
                ifLogVo.setResultContent("Not found for new Data"); // 신규등록-연계할-데이터가-없음
                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                log.debug("{}:{} ::: DATA cnt : {}", step, vo.getIfPgmNm(), selectList.getData().size());
            }
            log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

            // 1-12.연계 로그, 연계 사방넷 로그 수정
            step = "4-12";
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            log.debug("{}:{} ::: 로그 수정 DATA : {}", step, vo.getIfPgmNm(), selectList.getData().size());

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            ifLogVo.setResultContent("Sabangnet interface Exception ERROR"); // 사방넷연계Exception
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 5.사방넷 클레임수집 요청XML 생성
    @Override
    public String createClaimRequestXml(ClaimRequest claimRequest, List<Claim> list, ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        String step = null;

        try {
            // 5-1.클레임수집 요청 XML 생성
            step = "5-1";
            String xmlFileName = SabangnetConstant.XML_NM_CLAIM_REQUEST;

            // 5-2.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
            String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId()) + FileUtil
                    .getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

            step = "5-2";
            log.debug("{}.{} SabangnetWriter.writeClaim : {},{}", step, vo.getIfPgmNm(), xmlFileName, list);
            SabangnetWriter.writeClaim(claimRequest, filePath, list, vo.getLang());

            return xmlFileName;

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            // result.setSuccess(false);
            throw new CustomException("biz.exception.common.error");
        }
    }

    // 5.사방넷 클레임수집
    @Override
    public void getherClaim(String domain, String xmlFileName, ProcRunnerVO vo)
            throws ParserConfigurationException, SAXException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        long dataDtlCnt = 0;
        String step = null;
        String ifNo = null;
        String ifSno = null;
        String ordNo = null;
        String claimNo = null;

        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();

        try {
            // 5-3.XML 외부 접속 경로 생성
            step = "5-3";
            log.debug("{}.{} XML File Name : {}", step, vo.getIfPgmNm(), xmlFileName);
            String siteUrl = "http://" + domain;
            // 테스트 URL
            //String siteUrl = "http://id1.test.com";

            StringBuilder xmlURI = new StringBuilder(siteUrl);
            xmlURI.append("/resource/");
            xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
            xmlURI.append("/").append(xmlFileName);
            // 테스트 XML 파일
            //xmlURI.append("/").append("xml_claimResult.xml");

            String url = SabangnetConstant.XML_READ_CLAIM_URL + xmlURI.toString();

            step = "5-4";
            log.debug("{}.{} ::: API 호출 : {}", step, vo.getIfPgmNm(), url);
            log.debug("{}.{} ::: xmlURI : {}", step, vo.getIfPgmNm(), xmlURI);

            // 5-4.사방넷 클레임수집 API 호출 후 반환된 XML을 데이터로 변환
            // -----------------------------------------------------------------------------------
            //SabangnetResult<ClaimResult> resultList = SabangnetReader.readClaim(url, vo.getLang());
            // 테스트용
            SabangnetResult<ClaimResult> resultList = SabangnetReader.readClaimXml(xmlURI.toString(), vo.getLang());
            log.debug("{}.{} ::: 조회 결과 resultList :{}", step, vo.getIfPgmNm(), resultList);

            // TODO: 결과 처리
            if (resultList.getData().size() > 0) {

                ClaimResult resultDb = new ClaimResult();

                insertIfLogMain(vo, ifLogVo, ifExecLogVo);

                // 5-5.클레임수집 연계 테이블 등록 <- 클레임 조회 결과
                // ------------------------------------------------------------------
                step = "5-5";
                log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), vo);
                for (Object resultObj : resultList.getData()) {

                    resultDb = (ClaimResult) resultObj;

                    if (resultDb.getOrderStatus().equals("취소접수") || resultDb.getOrderStatus().equals("반품접수")
                            || resultDb.getOrderStatus().equals("교환접수")) {

                        // 5-5-1.연계실행로그 등록(연계 일련번호 채번)
                        step = "5-5-1";
                        // 5-5-1.클레임 연계 테이블 중복 체크
                        String dupYn = proxyDao.selectOneNolog("system.link.sabangnet." + "selectClaimClctIfDupYn", resultDb);
                        log.debug("{}.{} ::: 클레임 연계 테이블 중복 체크 : {},{}", step, vo.getIfPgmNm(), dupYn);

                        // 클레임 연계 테이블에 중복자료가 없으면 - 'N'
                        if (dupYn.equals("N")) {

                            ifExecLogVo.setExecKey(resultDb.getIdx()); // 사방넷  주문번호
                            ifService.insertIfExecLog(ifExecLogVo);
                            log.debug("{}.{} ::: 연계 일련번호 채번 : {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(), resultObj);

                            step = "5-5-2";
                            log.debug("{}.{} ::: 연계 일련번호 셋팅 : {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(), resultDb);

                            resultDb.setIfSno(ifExecLogVo.getIfSno()); // 연계일련번호
                            resultDb.setIfNo(vo.getIfNo()); // 연계번호
                            resultDb.setIfId(vo.getIfId()); // 연계ID
                            resultDb.setSiteNo(vo.getSiteNo()); // 사이트번호
                            resultDb.setRegrNo(vo.getRegrNo()); // 등록자번호
                            // resultDb.setOrdNo(ordNo.toString()); // 주문번호

                            cnt1 = cnt1 + 1;
                            if (cnt1 == 1) {
                                vo.setStartIfSno(ifExecLogVo.getIfSno()); // 시작연계일련번호- 연계로그 업데이트용
                                ifLogVo.setStartIfSno(ifExecLogVo.getIfSno());
                            }

                            // 5-5-4.클레임수집연계 테이블 등록
                            // ----------------------------------------------------------------------
                            step = "5-5-4";
                            log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), resultDb);

                            proxyDao.insert("system.link.sabangnet." + "insertClaimClctIf", resultDb);
                        }
                    }
                } // <- for loop

                // ----------------------------------------------------------------------
                // 클레임 테스트
                // vo.setSiteNo(1L);
                // vo.setIfNo("201608310000004");
                // ifLogVo.setIfNo(vo.getIfNo());
                // ifExecLogVo.setIfNo(vo.getIfNo());
                // ----------------------------------------------------------------------

                step = "5-6";

                // ● 5-6.클레임 처리 - 클레임수집 연계 테이블 조회
                List<ClaimClctIfPO> claimClctIfPO = proxyDao.selectList("system.link.sabangnet." + "selectClaimClctIfList", vo);
                log.debug("{}.{} ::: 쇼핑몰 주문번호별 클레임 조회 결과 : {},{}", step, vo.getIfPgmNm(), claimClctIfPO.size(), claimClctIfPO);

                if (claimClctIfPO.size() > 0) {

                    // 연계 사방넷 배치 로그 등록
                    // ----------------------------------------------------------------------
                    proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogReg", ifLogVo);

                    for (int i = 0; i < claimClctIfPO.size(); i++) {

                        ClaimClctIfPO procDb = claimClctIfPO.get(i);
                        log.debug("{}.{} ::: 쇼핑몰 주문번호별 procDb : {}", step, vo.getIfPgmNm(), procDb);

                        if (procDb.getOrdDlvrStatus().equals("취소접수") || procDb.getOrdDlvrStatus().equals("반품접수")
                                || procDb.getOrdDlvrStatus().equals("교환접수")) {

                            step = "5-6-1";
                            log.debug("{}.{} ::: 클레임 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);

                            // 5.7.클레임접수 주문자료 처리
                            // =============================================================================================
                            // ● 5-7-0.클레임접수 주문자료 - 주문 테이블 주문번호 조회
                            step = "5-7-0";
                            ordNo = proxyDao.selectOne("system.link.sabangnet." + "selectClaimAcceptOrdNo", procDb);
                            log.debug("{}.{} ::: 클레임접수 - 주문 테이블 주문번호 조회 : {},{}", step, vo.getIfPgmNm(), ordNo);

                            // ♣ 클레임접수 주문자료 - 주문 테이블에 자료가 있으면
                            if (ordNo!= null && ordNo.length() > 0) {
                                procDb.setOrdNo(ordNo);

                                dataCnt = dataCnt + 1;

                                // ● 5-6-2.클레임 상세 조회
                                // ----------------------------------------------------------------------
                                step = "5-6-2";
                                List<ClaimClctIfDtlPO> claimClctIfDtlPO = proxyDao.selectList("system.link.sabangnet." + "selectClaimClctIfDtlList", procDb);

                                if (claimClctIfDtlPO != null) {

                                    for (int j = 0; j < claimClctIfDtlPO.size(); j++) {

                                        ClaimClctIfDtlPO procDtlDb = claimClctIfDtlPO.get(j);

                                        if (procDtlDb.getOrdDlvrStatus().equals("취소접수")
                                                || procDtlDb.getOrdDlvrStatus().equals("반품접수")
                                                || procDtlDb.getOrdDlvrStatus().equals("교환접수")) {

                                            // 취소접수 불가능
                                            if (procDtlDb.getOrdDlvrStatus().equals("취소접수")
                                                    && (procDtlDb.getLocalOrdDtlStatusCd().equals("10") || // 주문무효
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("11") || // 주문취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("21") || // 결제취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("22") || // 결제실패
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("23") || // 결제취소신청
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("30") || // 배송준비중
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("40") || // 배송중
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("50") || // 배송완료
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("60") || // 교환신청
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("61") || // 교환취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("66") || // 교환완료
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("70") || // 반품신청
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("71") || // 반품취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("74") || // 반품완료
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("90"))) { // 구매확정

                                                log.debug("{}.{} :::### 취소접수 불가능 :{}, {}", step, vo.getIfPgmNm(), procDtlDb.getLocalOrdDtlStatusCd(), procDtlDb);

                                                // 반품접수 불가능
                                            } else if (procDtlDb.getOrdDlvrStatus().equals("반품접수")
                                                    && (procDtlDb.getLocalOrdDtlStatusCd().equals("10") || // 주문무효
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("11") || // 주문취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("21") || // 결제취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("22") || // 결제실패
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("30") || // 배송준비중
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("40") || // 배송중
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("60") || // 교환신청
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("61") || // 교환취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("66") || // 교환완료
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("90"))) { // 구매확정

                                                log.debug("{}.{} :::### 반품, 교환 불가능 : {}, {}", step, vo.getIfPgmNm(), procDtlDb.getLocalOrdDtlStatusCd(), procDtlDb);

                                                // 교환접수 불가능
                                            } else if (procDtlDb.getOrdDlvrStatus().equals("교환접수")
                                                    && (procDtlDb.getLocalOrdDtlStatusCd().equals("10") || // 주문무효
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("11") || // 주문취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("21") || // 결제취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("22") || // 결제실패
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("30") || // 배송준비중
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("40") || // 배송중
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("70") || // 반품신청
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("71") || // 반품취소
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("74") || // 반품완료
                                                    procDtlDb.getLocalOrdDtlStatusCd().equals("90"))) { // 구매확정

                                                log.debug("{}.{} :::### 반품, 교환 불가능 : {}, {}", step, vo.getIfPgmNm(), procDtlDb.getLocalOrdDtlStatusCd(), procDtlDb);

                                            } else { // 클레임 상세 처리
                                                procDtlDb.setRegrNo(vo.getRegrNo());
                                                procDtlDb.setUpdrNo(vo.getUpdrNo());

                                                // ● 5-6-4.클레임 상세 처리 - 클레임번호 채번
                                                step = "5-6-4";
                                                //claimNo = String.valueOf(proxyDao.selectOne("system.link.sabangnet.selectClaimNo"));
                                                claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));

                                                procDtlDb.setClaimNo(claimNo);
                                                log.debug("{}.{} ::: 클레임 상세 처리 - 클레임번호 채번 : {}", step, vo.getIfPgmNm(), procDtlDb);

                                                // ● 5-6-4.클레임 상세 처리
                                                // ◈ 주문상세상태 23,60,70 주문상세테이블업데이트
                                                // ==================================================================
                                                proxyDao.update("system.link.sabangnet." + "procClaimDtl", procDtlDb); // 클레임상세처리

                                                log.debug("{}.{} ::: 클레임 상세 처리 End : {}", step, vo.getIfPgmNm(), procDtlDb);

                                                // 연계실행로그 수정 - TI_IF_EXEC_LOG
                                                step = "5-6-5";
                                                log.debug("{}.{} ::: 연계실행로그 수정 Start : {}", step, vo.getIfPgmNm(), procDtlDb);
                                                ifExecLogVo.setIfSno(procDtlDb.getIfSno());
                                                ifExecLogVo.setSucsYn("Y");
                                                ifExecLogVo.setErrCd("0");
                                                ifLogVo.setErrCd("0");
                                                ifExecLogVo.setExecConts(procDtlDb.getOrdNo() + "-" + procDtlDb.getOrdDtlSeq());
                                                ifExecLogVo.setResultContent("클레임수집 성공 : " + procDtlDb.getOrdNo() + "-" + procDtlDb.getOrdDtlSeq()); // 사방넷리턴-결과내용
                                                ifService.updateIfExecLog(ifExecLogVo);
                                                log.debug("{}.{} ::: 연계실행로그 수정 End : {}", step, vo.getIfPgmNm(), ifExecLogVo);
                                            }
                                        } else {
                                            ifLogVo.setSucsYn("N");
                                            ifLogVo.setErrCd("-900");
                                            ifLogVo.setResultContent("Not Claim Status data !!!!!"); // 클레임상태가아님!!!!!
                                            log.debug("{}.{} ::: 취소,반품,교환상태가 아닌 데이터!!!!! End : {}", step, vo.getIfPgmNm(), ifLogVo);
                                        }
                                    } // <- for loop
                                } else {
                                    ifLogVo.setSucsYn("N");
                                    ifLogVo.setErrCd("-900");
                                    ifLogVo.setResultContent("No data from claimClctIfDtlPO !!!!!"); // 사방넷연계-클레임상세데이터가-없음
                                    log.debug("{}.{} ::: 사방넷연계-클레임상세데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                                }
                            } else {
                                // ♣ 클레임접수 NoOrd 주문자료 - 주문 테이블에 자료가 없으면
                                // =========================================================================================

                                // ● 5-6-1.클레임접수 NoOrd 주문번호 생성
                                step = "5-6-1";
                                Long ordNo1 = orderService.createOrdNo(vo.getSiteNo());
                                procDb.setOrdNo(ordNo1.toString());
                                log.debug("{}.{} ::: 주문번호 생성 : {}", step, vo.getIfPgmNm(), ordNo1);

                                // ● 5-6-2.클레임접수 NoOrd 원본 주문번호 조회 (사방넷 원본 주문번호가 있는 경우)
                                step = "5-6-2";
                                String orgOrdNo = proxyDao.selectOne("system.link.sabangnet." + "selectClaimOrgOrdNo", procDb);
                                procDb.setOrgOrdNo(orgOrdNo);
                                log.debug("{}.{} ::: 클레임접수 NoOrd 원본 주문번호 조회 : {}", step, vo.getIfPgmNm(), orgOrdNo);

                                step = "5-6-3";
                                procDb.setRegrNo(vo.getRegrNo());
                                procDb.setUpdrNo(vo.getUpdrNo());
                                log.debug("{}.{} ::: 클레임접수 NoOrd 주문 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);

                                // 5-6-3.클레임접수 주문 처리 - 주문, 주문 배송지, 결제 테이블 등록
                                // ● 클레임접수 주문처리 - 주문, 주문배송지, 결제 테이블등록
                                // ◈ 주문상태 20, 결제상태 02
                                // ----------------------------------------------------------------------
                                proxyDao.update("system.link.sabangnet." + "procClaimAcceptNoOrd", procDb);
                                dataCnt = dataCnt + 1;

                                // ● 5-6-4.클레임접수 NoOrd 주문 상세 조회
                                step = "5-6-4";
                                List<ClaimClctIfDtlPO> claimClctIfDtlPO = proxyDao.selectList("system.link.sabangnet." + "selectClaimClctIfDtlList", procDb);

                                if (claimClctIfDtlPO != null) {

                                    Integer ordDtlSeq = 0;
                                    for (int j = 0; j < claimClctIfDtlPO.size(); j++) {

                                        ClaimClctIfDtlPO procDtlDb = claimClctIfDtlPO.get(j);

                                        //claimNo = String.valueOf(proxyDao.selectOne("system.link.sabangnet.selectClaimNo"));
                                        claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));

                                        procDtlDb.setClaimNo(claimNo);
                                        log.debug("{}.{} ::: 클레임 상세 처리 - 클레임번호 채번 : {}", step, vo.getIfPgmNm(), procDtlDb);

                                        ordDtlSeq = ordDtlSeq + 1; // 주문상세순번

                                        log.debug("{}.{}### ::: 클레임접수 NoOrd 주문 상세 조회 procDtlDb : {}, {}, {}", step, vo.getIfPgmNm(), procDtlDb.getOrdNo(), ordDtlSeq, procDtlDb);

                                        procDtlDb.setOrdNo(procDb.getOrdNo());
                                        procDtlDb.setOrdDtlSeq(ordDtlSeq.toString()); // 주문상세순번
                                        procDtlDb.setRegrNo(procDb.getRegrNo());
                                        procDtlDb.setUpdrNo(procDb.getUpdrNo());

                                        step = "5-6-5";
                                        log.debug("{}.{} ::: 클레임접수 NoOrd 주문 상세 처리 procDtlDb 조회 : {}", step, vo.getIfPgmNm(), procDtlDb);

                                        // 5-6-5.클레임접수 주문 상세 처리
                                        // ● 클레임접수 주문상세처리- 주문상세, 배송 테이블등록
                                        // ◈ 주문상세상태 23,60,70
                                        // ----------------------------------------------------------------------
                                        proxyDao.update("system.link.sabangnet." + "procClaimAcceptNoOrdDtl", procDtlDb);
                                        dataDtlCnt = dataDtlCnt + 1;

                                        // 연계실행로그 수정 - TI_IF_EXEC_LOG
                                        ifExecLogVo.setIfSno(procDtlDb.getIfSno());
                                        ifExecLogVo.setSucsYn("Y");
                                        ifExecLogVo.setErrCd("0");
                                        ifLogVo.setErrCd("0");
                                        ifExecLogVo.setExecConts(procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString());
                                        ifExecLogVo.setResultContent("클레임접수 NoOrd 성공 : " + procDtlDb.getOrdNo() + "-" + ordDtlSeq.toString()); // 사방넷리턴-결과내용
                                        ifService.updateIfExecLog(ifExecLogVo);
                                        log.debug("{}.{} ::: 연계실행로그 수정 End : {}", step, vo.getIfPgmNm(), ifExecLogVo);

                                    } // <- for loop

                                    // ◈ 클레임접수 NoOrd 주문, 결제 테이블 결제금액 업데이트
                                    // -----------------------------------------------------------------------------
                                    proxyDao.update("system.link.sabangnet." + "procClaimNoOrdPaymentUpdate", procDb);

                                } else {
                                    ifLogVo.setSucsYn("N");
                                    ifLogVo.setErrCd("-900");
                                    ifLogVo.setResultContent("No data from ordClctIfDtlPO !!!!!"); // 사방넷연계-주문상세데이터가-없음
                                    log.debug("{}.{} ::: 사방넷연계-주문상세데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                                }
                            } // // ♣ 클레임접수 주문자료 - 주문 테이블 자료 존재여부
                        }
                        if (ifLogVo.getErrCd() == "0") {
                            ifLogVo.setSucsYn("Y");
                            ifLogVo.setErrCd("0");
                            ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                            log.debug("{}.{} ::: 사방넷연계-성공!!!!! End : {}", step, vo.getIfPgmNm(), ifLogVo);
                        }
                    } // <- for loop

                    // 클레임수집연계 테이블 최종 IF_SNO 만 남기고 모두 삭제
                    proxyDao.update("system.link.sabangnet." + "deleteClaimClctIfPastData", vo.getSiteNo());

                } else {
                    ifLogVo.setSucsYn("N");
                    ifLogVo.setErrCd("-900");
                    ifLogVo.setResultContent("No data from claimClctIfPO !!!!!"); // 사방넷연계-클레임데이터가-없음
                    log.debug("{}.{} ::: 사방넷연계-클레임데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                }
                // 5-7.연계결과 건수
                step = "5-7";
                ifLogVo.setDataCnt(dataCnt);
                ifLogVo.setDataTotCnt(dataDtlCnt);
                log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

                // 5-8.연계 사방넷 배치 로그 수정
                // ----------------------------------------------------------------------
                step = "5-8";
                proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogUpd", ifLogVo);

                // 5-9.연계 로그 수정, 연계 사방넷 로그 수정
                // ------------------------------------------------------
                step = "5-9";
                ifLogVo.setEndIfSno(ifExecLogVo.getIfSno()); // 종료연계일련번호
                log.debug("{}.{} ::: 연계 로그 수정 : {}", step, vo.getIfPgmNm(), ifLogVo);
                // proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
                ifService.updateIfLog(ifLogVo);
                updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정

            } else {
                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                ifLogVo.setSucsYn("N");
                ifLogVo.setErrCd("-930");
                ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음

                ifService.updateIfLog(ifLogVo);
                updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정

                log.debug("{}:{} ::: DATA cnt : {}", step, ifLogVo.getIfPgmNm(), resultList.getData().size());

            }
        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            ifLogVo.setResultContent("Sabangnet interface Exception ERROR"); // 사방넷연계Exception
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            //result.setSuccess(false);
            //throw new CustomException("biz.exception.common.error");
        }
    }

    // 6.사방넷 문의사항수집 요청XML 생성
    @Override
    public String createInquiryRequestXml(InquiryRequest inquiryRequest, List<Inquiry> list, ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        String step = null;

        try {
            // 6-1.문의사항수집 요청 XML 생성 : CS_STATUS = 001:신규등록(SabangnetConstant)
            // ---------------------------------------------------------------------
            step = "6-1";
            String xmlFileName = SabangnetConstant.XML_NM_CS_REQUEST;

            // 6-2.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
            String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId()) + FileUtil
                    .getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

            step = "6-2";
            log.debug("{}.{} SabangnetWriter.writeInquiry : {},{}", step, vo.getIfPgmNm(), xmlFileName, list);
            SabangnetWriter.writeInquiry(inquiryRequest, filePath, list, vo.getLang());

            return xmlFileName;

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            // result.setSuccess(false);
            throw new CustomException("biz.exception.common.error");
        }
    }

    // 6.사방넷 문의사항수집
    @Override
    public void getherInquiry(String domain, String xmlFileName, ProcRunnerVO vo)
            throws ParserConfigurationException, SAXException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        String step = null;
        String ifNo = null;
        String ifSno = null;

        try {
            // 6-3.XML 외부 접속 경로 생성
            step = "6-3";
            log.debug("{}.{} XML File Name : {}", step, vo.getIfPgmNm(), xmlFileName);
            String siteUrl = "http://" + domain;
            // 테스트용
            //String siteUrl = "http://id1.test.com";
            StringBuilder xmlURI = new StringBuilder(siteUrl);
            xmlURI.append("/resource/");
            xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
            xmlURI.append("/").append(xmlFileName);

            // 테스트용
            //xmlURI.append("/").append("xml_csResult.xml");

            String url = SabangnetConstant.XML_READ_INQUIRY_URL + xmlURI.toString();

            step = "6-4";
            log.debug("{}.{} ::: API 호출 : {}", step, vo.getIfPgmNm(), url);
            log.debug("{}.{} ::: xmlURI : {}", step, vo.getIfPgmNm(), xmlURI);

            // 6-4.사방넷 문의사항수집 API 호출 후 반환된 XML을 데이터로 변환
            // -----------------------------------------------------------------------------------
            //SabangnetResult<CsResult> resultList = SabangnetReader.readCs(url, vo.getLang());
            // 테스트용
            SabangnetResult<CsResult> resultList = SabangnetReader.readCsXml(xmlURI.toString(), vo.getLang());
            log.debug("{}.{} ::: 조회 결과 resultList :{}", step, vo.getIfPgmNm(), resultList);

            IfLogVO ifLogVo = new IfLogVO();
            IfExecLogVO ifExecLogVo = new IfExecLogVO();

            // TODO: 결과 처리
            if (resultList.getData().size() > 0) {

                CsResult resultDb = new CsResult();

                insertIfLogMain(vo, ifLogVo, ifExecLogVo);

                // 6-5.문의사항수집 연계 테이블 등록 <- 문의사항 조회 결과
                // ------------------------------------------------------------------
                step = "6-5";
                log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), vo);
                for (Object resultObj : resultList.getData()) {

                    resultDb = (CsResult) resultObj;

                    if (resultDb.getCsStatus().equals("001") || resultDb.getCsStatus().equals("002") || resultDb.getCsStatus().equals("003")) { // 001:신규접수,002:답변등록,003:답변전송,004:강제완료

                        // ● 6-5-1.문의사항수집 연계 테이블 중복 체크
                        step = "6-5-0";
                        String mallUserId = resultDb.getMallUserId();
                        resultDb.setSiteNo(1L);
                        String dupYn = proxyDao.selectOne("system.link.sabangnet." + "selectInquiryClctIfDupYn", resultDb);
                        log.debug("{}.{} ::: 문의사항 연계 테이블 중복 체크 : {},{}", step, vo.getIfPgmNm(), dupYn);

                        // 문의사항 연계 테이블에 중복자료가 없으면 - 'N'
                        if (dupYn.equals("N")) {

                            // 6-5-1.연계실행로그 등록(연계 일련번호 채번)
                            step = "6-5-1";
                            ifExecLogVo.setExecKey(resultDb.getNum()); // 문의등록(수집시)사방넷유니크번호
                            ifService.insertIfExecLog(ifExecLogVo);
                            log.debug("{}.{} ::: 연계 일련번호 채번 : {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(), resultObj);

                            step = "6-5-2";
                            log.debug("{}.{} ::: 연계 일련번호 셋팅 : {},{}", step, vo.getIfPgmNm(), ifExecLogVo.getIfSno(), resultDb);

                            resultDb.setIfSno(ifExecLogVo.getIfSno()); // 연계일련번호
                            resultDb.setIfNo(vo.getIfNo()); // 연계번호
                            resultDb.setIfId(vo.getIfId()); // 연계ID
                            resultDb.setSiteNo(vo.getSiteNo()); // 사이트번호
                            resultDb.setRegrNo(vo.getRegrNo()); // 등록자번호
                            resultDb.setMallUserId(mallUserId);
                            // resultDb.setOrdNo(ordNo.toString()); // 주문번호

                            cnt1 = cnt1 + 1;
                            if (cnt1 == 1) {
                                vo.setStartIfSno(ifExecLogVo.getIfSno()); // 시작연계일련번호-연계로그업데이트용
                                ifLogVo.setStartIfSno(ifExecLogVo.getIfSno());
                            }

                            // ● 6-5-4.문의사항수집연계 테이블 등록
                            // ----------------------------------------------------------------------
                            step = "6-5-4";
                            log.debug("{}.{} ::: 연계 테이블 등록 : {}", step, vo.getIfPgmNm(), resultDb);

                            proxyDao.insert("system.link.sabangnet." + "insertInquiryClctIf", resultDb);
                        }
                    }
                } // <- for loop

                step = "6-6";
                // ● 6-6.문의사항 처리 - 문의사항수집 연계 테이블 조회
                // ----------------------------------------------------------------------
                List<InquiryClctIfPO> inquiryClctIfPO = proxyDao.selectList("system.link.sabangnet." + "selectInquiryClctIfList", vo);
                log.debug("{}.{} ::: 문의사항수집연계 조회 결과 : {},{}", step, vo.getIfPgmNm(), inquiryClctIfPO.size(), inquiryClctIfPO);

                if (inquiryClctIfPO.size() > 0) {

                    // 연계 사방넷 배치 로그 등록
                    // ----------------------------------------------------------------------
                    proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogReg", ifLogVo);

                    for (int i = 0; i < inquiryClctIfPO.size(); i++) {

                        InquiryClctIfPO procDb = inquiryClctIfPO.get(i);
                        log.debug("{}.{} ::: 문의사항수집연계 조회 결과 procDb : {}", step, vo.getIfPgmNm(), procDb);

                        // ● 6-6-0.상품게시판글 테이블 존재여부 체크
                        step = "3-6-0";
                        String existYn = proxyDao.selectOne("system.link.sabangnet." + "selectGoodsBbsExistYn", procDb);
                        log.debug("{}.{} ::: 상품게시판글 테이블 존재여부 체크 : {},{}", step, vo.getIfPgmNm(), existYn);

                        // 상품게시판글 테이블에 자료가 없으면(신규접수) - 'N'
                        if (existYn.equals("N")) {
                            if (procDb.getPrcGb().equals("001")) { // 001:신규접수

                                // ● 6-6-1.글번호 채번
                                step = "6-6-1";

                                String lettNo = (String) proxyDao.selectOne("operation.bbsGoodsLettManage." + "selectNewLettNo");

                                log.debug("{}.{} ::: 글번호 채번 : {}", step, vo.getIfPgmNm(), lettNo);

                                step = "6-6-3";

                                procDb.setLettNo(lettNo);
                                procDb.setRegrNo(vo.getRegrNo());
                                procDb.setUpdrNo(vo.getUpdrNo());
                                log.debug("{}.{} ::: 문의사항 등록 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);

                                // ● 6-6-3.문의사항 등록 처리 - 테이블 등록
                                // ----------------------------------------------------------------------
                                proxyDao.update("system.link.sabangnet." + "procInquiry", procDb); // 문의사항처리
                                dataCnt = dataCnt + 1;
                            }
                        } else {
                            // 상품게시판글 테이블에 자료가 있으면(답변등록,답변전송) - 'Y'
                            if (procDb.getPrcGb().equals("002") || procDb.getPrcGb().equals("003")) { // 003:답변등록,003:답변전송

                                // ● 6-7-1.상품게시판 글번호 조회
                                step = "6-7-1";
                                String grpNo = (String) proxyDao.selectOne("system.link.sabangnet." + "selectGoodsBbsLettNo", procDb);
                                log.debug("{}.{} ::: 상품게시판 글번호 조회 : {}", step, vo.getIfPgmNm(), grpNo);

                                if (grpNo.length() > 0) {
                                    step = "6-7-2";

                                    // ● 6-6-1.글번호 채번
                                    step = "6-6-1";
                                    String lettNo = (String) proxyDao.selectOne("operation.bbsGoodsLettManage." + "selectNewLettNo");

                                    log.debug("{}.{} ::: 글번호 채번 : {}", step, vo.getIfPgmNm(), lettNo);

                                    procDb.setLettNo(lettNo);
                                    procDb.setGrpNo(grpNo);
                                    procDb.setRegrNo(vo.getRegrNo());
                                    procDb.setUpdrNo(vo.getUpdrNo());
                                    log.debug("{}.{} ::: 문의사항 등록 처리 procDb 조회 : {}", step, vo.getIfPgmNm(), procDb);

                                    // ● 6-7-2.문의사항 답변 등록 처리 - 테이블 등록
                                    // ----------------------------------------------------------------------
                                    proxyDao.update("system.link.sabangnet." + "procInquiryReply", procDb); // 문의사항답변등록처리
                                    dataCnt = dataCnt + 1;
                                }
                            }
                        }
                    } // <- for loop
                    if (ifLogVo.getErrCd() == "0") {
                        ifLogVo.setSucsYn("Y");
                        ifLogVo.setErrCd("0");
                        ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                        log.debug("{}.{} ::: 사방넷연계-성공!!!!! End : {}", step, vo.getIfPgmNm(), ifLogVo);
                    }
                } else {
                    ifLogVo.setSucsYn("N");
                    ifLogVo.setErrCd("-900");
                    ifLogVo.setResultContent("No data from inquiryClctIfPO !!!!!"); // 사방넷연계-문의사항데이터가-없음
                    log.debug("{}.{} ::: 사방넷연계-문의사항데이터가-없음 End : {}", step, vo.getIfPgmNm(), ifLogVo);
                }
                // 6-7.연계결과 건수
                step = "6-7";
                ifLogVo.setDataCnt(dataCnt);
                ifLogVo.setDataTotCnt(dataCnt);
                log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

                // 6-8.연계 사방넷 배치 로그 수정
                // ----------------------------------------------------------------------
                step = "6-8";
                proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogUpd", ifLogVo);

                // 6-9.연계 로그, 연계 사방넷 로그 수정
                // ------------------------------------------------------
                step = "6-9";
                ifLogVo.setEndIfSno(ifExecLogVo.getIfSno()); // 종료연계일련번호
                log.debug("{}.{} ::: 연계 로그 수정 : {}", step, vo.getIfPgmNm(), ifLogVo);
                // proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
                ifService.updateIfLog(ifLogVo);
                updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정

            } else {
                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                ifLogVo.setSucsYn("N");
                ifLogVo.setErrCd("-930");
                ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음

                proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogUpd", ifLogVo);

                log.debug("{}:{} ::: DATA cnt : {}", step, ifLogVo.getIfPgmNm(), resultList.getData().size());
                ifService.updateIfLog(ifLogVo);
                updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            }
        } catch (Exception e) {
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            result.setSuccess(false);
            //throw new CustomException("biz.exception.common.error");
        }
    }

    // 7.사방넷 문의답변등록
    @Override
    public void registInquiryReply(ProcRunnerVO vo, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        long dataCnt = 0;
        long totCnt = 0;
        String ifSno = null;
        String step = null;
        String srchKey = null;
        String resultContent = null;
        IfLogVO ifLogVo = new IfLogVO();
        IfExecLogVO ifExecLogVo = new IfExecLogVO();

        try {
            // 7-1.연계로그 등록 (연계번호 채번)
            step = "7-1";

            insertIfLogMain(vo, ifLogVo, ifExecLogVo);

            // 7-3.문의답변등록 프로시저 호출
            // ----------------------------------------------------------------
            step = "7-3";
            log.debug("7-3.{} 프로시저 호출 : {}", vo.getIfPgmNm(), vo);
            proxyDao.update("system.link.sabangnet." + "spIf07InquiryReplyReg", ifLogVo);

            // 7-4.문의답변등록 목록 조회
            step = "7-4";
            InquiryReplyRequest selectList = proxyDao.selectOne("system.link.sabangnet." + "selectInquiryReplyRegi", vo);
            log.debug("{}:{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), selectList.getData().size(), vo);

            if (selectList.getData().size() > 0) {

                // 7-5.문의답변등록 목록으로 요청 XML 생성
                step = "7-5";
                selectInquiryReplyListSet(selectList, vo);

                // 7-6. 연계 등록 요청 XML 파일, 연계 실행 url 생성
                String sbnUrl = createInquiryReplyRequestXml(selectList, vo, step, domain);

                step = "7-9";
                log.debug("{}:{} ::: API URL 호출 : {}, {}", step, vo.getIfPgmNm(), sbnUrl);

                // 7-9.사방넷 문의답변등록 API 호출
                // ---------------------------------------------------------------------
                String sbn_result = HttpUtil.getXmlByRestTemplate(sbnUrl, CHARSET_EUCKR);

                String[] resultArray = sbn_result.split("<br>"); // 결과html을n행으로split

                log.debug("{}:{} ::: 사방넷 상품 등록 결과:{},{}", step, vo.getIfPgmNm(), resultArray, vo.getLang());

                // ##### 사방넷URL 리턴 결과 처리
                ArrayList<String> sbn_resultList = new ArrayList<String>(Arrays.asList(resultArray));
                log.debug("{}:{} ::: 사방넷 {} 결과:{},{}", step, vo.getIfPgmNm(), sbn_resultList.size(), vo.getLang());

                // 7-10.사방넷 문의답변등록 결과 성공여부 문의답변등록 연계 테이블에 업데이트
                // ----------------------------------------------------------------
                if (sbn_resultList.size() > 1) {
                    for (String resultData : sbn_resultList) {

                        // 7-10-1.연계결과 수정 (결과내용)
                        step = "7-10";
                        log.debug("{}:{} ::: 사방넷 문의답변등록 결과 resultData :{}", step, vo.getIfPgmNm(), resultData);

                        if (resultData.contains("성공")) {

                            // [1] 성공 : 100000 [2-G1609282001_0133-I1609282001_0098-1]
                            srchKey = resultData.substring(resultData.lastIndexOf(": ") + 2, resultData.lastIndexOf(" ["));
                            log.debug("7-10-1.### 성공 ### 조회키:{}", srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:글번호
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultData); // 사방넷리턴-결과내용
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                            // 연계테이블 결과 수정
                            proxyDao.update("system.link.sabangnet." + "updateInquiryReplyRegSbnIfYn", ifExecLogVo);
                            dataCnt = dataCnt + 1;

                        } else if (resultData.contains("총건수")) {

                            // "총건수 : 71" :
                            totCnt = Long.parseLong(resultData.substring(resultData.lastIndexOf(": ") + 1).trim());

                            log.debug("7-10-1.### 총건수 ###,{} ", resultData.substring(resultData.lastIndexOf(": ") + 1).trim());

                        } else {

                            // [2] 실패 : 182904
                            srchKey = resultData.substring(resultData.lastIndexOf(": ") + 2);
                            log.debug("7-10-1.### 성공 ### 조회키:{}", srchKey);

                            ifExecLogVo.setSrchKey(srchKey); // 조회키:srchKey
                            ifSno = proxyDao.selectOne("system.link.ifLog.selectIfExecLogBySrchKey", ifExecLogVo);
                            ifExecLogVo.setIfSno(ifSno);
                            // 연계실행로그 수정 - TI_IF_EXEC_LOG
                            ifExecLogVo.setResultContent(resultData); // 사방넷리턴-결과내용
                            proxyDao.update("system.link.ifLog.updateIfExecLogBySrchKey", ifExecLogVo);
                        }
                    } // <- for loop
                    ifLogVo.setEndIfSno(ifSno);
                    if (ifLogVo.getErrCd().equals("0")) {
                        ifLogVo.setSucsYn("Y");
                        ifLogVo.setResultContent("Success interface!!!!!"); // 사방넷연계-성공!!!!!
                    } else {
                        ifLogVo.setSucsYn("N");
                        ifLogVo.setResultContent("Interface has failed data !!!!!"); // 사방넷연계-실패!!!!!
                    }

                } else {
                    ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음
                }
                // 7-10-2.연계결과 건수
                step = "7-10-2";
                ifLogVo.setDataCnt(dataCnt);
                ifLogVo.setDataTotCnt(totCnt);
                log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

            } else {
                step = "7-11";

                ifLogVo.setDataCnt(0L);
                ifLogVo.setDataTotCnt(0L);
                ifLogVo.setSucsYn("N");
                ifLogVo.setErrCd("-930");
                ifLogVo.setResultContent("No data from Sabangnet"); // 사방넷연계-리턴데이터가-없음

                proxyDao.update("system.link.sabangnet." + "spIf004SbnBtchLogUpd", ifLogVo);

                log.debug("{}:{} ::: DATA cnt : {}", step, ifLogVo.getIfPgmNm(), selectList.getData().size());
            }
            log.debug("◈{}:{} ::: 연계결과 건수 : {}, {}", step, ifLogVo.getIfPgmNm(), ifLogVo.getIfNo(), ifLogVo);

            // 7-12.연계 로그, 연계 사방넷 로그 수정
            step = "7-12";
            ifService.updateIfLog(ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            log.debug("{}:{} ::: 로그 수정 DATA : {}", step, vo.getIfPgmNm(), selectList.getData().size());

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            ifLogVo.setResultContent("Sabangnet interface Exception ERROR"); // 사방넷연계Exception
            proxyDao.update("system.link.ifLog.updateIfLog", ifLogVo);
            updateIfSbnLog(ifLogVo); // 연계 사방넷 로그 수정
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    /**
     * 1-5.상품 등록 Request XML 항목 셋팅
     */
    private void selectGoodsListSet(GoodsRequest selectList, ProcRunnerVO vo) {

        selectList.setSendCompaynyId(vo.getSendCompaynyId());
        selectList.setSendAuthKey(vo.getSendAuthKey());
        selectList.setSendDate(vo.getSendDate()); // 전송일자
        selectList.setSendGoodsCdRt(vo.getSendGoodsCdRt()); // 상품코드반환여부

        log.debug("● {} ::: 조회목록 셋팅 selectList.getData():{}", vo.getIfPgmNm(), selectList.getData());
    }

    /**
     * 2-5.상품요약수정 등록 Request XML 항목 셋팅
     */
    private void selectGoodsSmrUpdListSet(GoodsSmrUpdRequest selectList, ProcRunnerVO vo) {

        selectList.setSendCompaynyId(vo.getSendCompaynyId());
        selectList.setSendAuthKey(vo.getSendAuthKey());
        selectList.setSendDate(vo.getSendDate()); // 전송일자
        selectList.setSendGoodsCdRt(vo.getSendGoodsCdRt()); // 상품코드반환여부

        log.debug("● {} ::: 조회목록 셋팅 selectList.getData():{}", vo.getIfPgmNm(), selectList.getData());
    }

    /**
     * 4-5.송장 등록 Request XML 항목 셋팅
     */
    private void selectInvoiceListSet(InvoiceRequest selectList, ProcRunnerVO vo) {

        selectList.setSendCompaynyId(vo.getSendCompaynyId());
        selectList.setSendAuthKey(vo.getSendAuthKey());
        selectList.setSendDate(vo.getSendDate()); // 전송일자
        selectList.setSendInvEditYn(vo.getSendInvEditYn()); // 송장정보수정여부

        log.debug("● {} ::: 조회목록 셋팅 selectList.getData():{}", vo.getIfPgmNm(), selectList.getData());
    }

    /**
     * 7-5.문의답변 등록 Request XML 항목 셋팅
     */
    private void selectInquiryReplyListSet(InquiryReplyRequest selectList, ProcRunnerVO vo) {

        selectList.setSendCompaynyId(vo.getSendCompaynyId());
        selectList.setSendAuthKey(vo.getSendAuthKey());
        selectList.setSendDate(vo.getSendDate()); // 전송일자

        log.debug("● {} ::: 조회목록 셋팅 selectList.getData():{}", vo.getIfPgmNm(), selectList.getData());
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 2.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 2. dong - 최초생성
     * </pre>
     *
     * @param selectList
     * @param vo
     * @param url
     * @param step
     * @param domain
     * @throws IOException
     * @throws InvocationTargetException
     * @throws NoSuchMethodException
     * @throws IllegalAccessException
     */
    /**
     * 1-6. 상품 등록 연계 요청 XML 파일, 연계 실행 url 생성 *
     *
     * @return String url
     */
    private String createGoodsRequestXml(GoodsRequest selectList, ProcRunnerVO vo, String step, String domain)
            throws IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException {

        String xmlFileName = SabangnetConstant.XML_NM_GOODS;
        log.debug("{}.{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), xmlFileName, vo);

        // 1-6.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
        step = "1-6";
        String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId())
                + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

        // 1-7.xml 생성
        step = "1-7";
        log.debug("{}.{} ::: 목록 조회 xml 생성 : {},{}", step, vo.getIfPgmNm(), filePath, vo);

        // 1-7.연계 데이터를 사방넷API 호출을 위한 XML 파일로 변환
        // ---------------------------------------------------------------
        SabangnetWriter.writeGoods(selectList, filePath, vo.getLang());

        // 1-8.XML 외부 접속 경로 생성
        step = "1-8";
        String siteUrl = "http://" + domain;
        StringBuilder xmlURI = new StringBuilder(siteUrl);
        xmlURI.append("/resource/");
        xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
        xmlURI.append("/").append(xmlFileName);

        String url = SabangnetConstant.XML_GOODS_REG_UPD_URL + xmlURI.toString();
        log.debug("{}.{} ::: URL 생성 : {},{}", vo.getIfPgmNm(), step, url, vo);
        return url;
    }

    /**
     * 2-6. 상품 요약수정 연계 요청 XML 파일, 연계 실행 url 생성 *
     *
     * @return String url
     */
    private String createGoodsSmrUpdRequestXml(GoodsSmrUpdRequest selectList, ProcRunnerVO vo, String step,
                                               String domain)
            throws IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException {

        String xmlFileName = SabangnetConstant.XML_NM_GOODS_SMR_UPD;
        log.debug("{}.{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), xmlFileName, vo);

        // 2-6.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
        step = "2-6";
        String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId())
                + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

        // 2-7.xml 생성
        step = "2-7";
        log.debug("{}.{} ::: 목록 조회 xml 생성 : {},{}", step, vo.getIfPgmNm(), filePath, vo);

        // 2-7.연계 데이터를 사방넷API 호출을 위한 XML 파일로 변환
        // ---------------------------------------------------------------
        SabangnetWriter.writeGoodsSmrUpd(selectList, filePath, vo.getLang());

        // 2-8.XML 외부 접속 경로 생성
        step = "2-8";
        String siteUrl = "http://" + domain;
        StringBuilder xmlURI = new StringBuilder(siteUrl);
        xmlURI.append("/resource/");
        xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
        xmlURI.append("/").append(xmlFileName);

        String url = SabangnetConstant.XML_GOODS_SMR_UPD_URL + xmlURI.toString();
        log.debug("{}.{} ::: URL 생성 : {},{}", step, vo.getIfPgmNm(), url, vo);
        return url;
    }

    /**
     * 4-6. 송장 등록 연계 요청 XML 파일, 연계 실행 url 생성 *
     *
     * @return String url
     */
    private String createInvoiceRequestXml(InvoiceRequest selectList, ProcRunnerVO vo, String step, String domain)
            throws IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException {

        String xmlFileName = SabangnetConstant.XML_NM_INVOICE;
        log.debug("{}.{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), xmlFileName, vo);

        // 4-6.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
        step = "4-6";
        String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId())
                + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

        // 4-7.xml 생성
        step = "4-7";
        log.debug("{}.{} ::: 목록 조회 xml 생성 : {},{}", step, vo.getIfPgmNm(), filePath, vo);

        // 4-7.연계 데이터를 사방넷API 호출을 위한 XML 파일로 변환
        // ---------------------------------------------------------------
        SabangnetWriter.writeInvoice(selectList, filePath, vo.getLang());

        // 4-8.XML 외부 접속 경로 생성
        step = "4-8";
        String siteUrl = "http://" + domain;
        StringBuilder xmlURI = new StringBuilder(siteUrl);
        xmlURI.append("/resource/");
        xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
        xmlURI.append("/").append(xmlFileName);

        String url = SabangnetConstant.XML_INVOICE_REG_URL + xmlURI.toString();
        log.debug("{}.{} ::: URL 생성 : {},{}", vo.getIfPgmNm(), step, url, vo);
        return url;
    }

    /**
     * 7-6. 문의답변 등록 연계 요청 XML 파일, 연계 실행 url 생성 *
     *
     * @return String url
     */
    private String createInquiryReplyRequestXml(InquiryReplyRequest selectList, ProcRunnerVO vo, String step,
                                                String domain)
            throws IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException {

        String xmlFileName = SabangnetConstant.XML_NM_CS_REPLY;
        log.debug("{}.{} ::: 목록 XML 생성 : {}, {}", step, vo.getIfPgmNm(), xmlFileName, vo);

        // 7-6.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
        step = "7-6";
        String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId())
                + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

        // 7-7.xml 생성
        step = "7-7";
        log.debug("{}.{} ::: 목록 조회 xml 생성 : {},{}", step, vo.getIfPgmNm(), filePath, vo);

        // 7-7.연계 데이터를 사방넷API 호출을 위한 XML 파일로 변환
        // ---------------------------------------------------------------
        SabangnetWriter.writeInquiryReply(selectList, filePath, vo.getLang());

        // 7-8.XML 외부 접속 경로 생성
        step = "7-8";
        String siteUrl = "http://" + domain;
        StringBuilder xmlURI = new StringBuilder(siteUrl);
        xmlURI.append("/resource/");
        xmlURI.append(UploadConstants.PATH_INTERFACE).append("/").append(UploadConstants.PATH_SABANGNET);
        xmlURI.append("/").append(xmlFileName);

        String url = SabangnetConstant.XML_INQUIRY_REPLY_URL + xmlURI.toString();
        log.debug("{}.{} ::: URL 생성 : {},{}", vo.getIfPgmNm(), step, url, vo);
        return url;
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

            // String ifNo = proxyDao.selectOne("system.link.ifLog.selectIfNo", ifLogVo);
            // IfLogVO 에 연계 번호 셋팅
            // ifLogVo.setIfNo(ifNo);
            // proxyDao.insert("system.link.ifLog.insertIfLog", ifLogVo);

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

    // 8.사방넷 상품수집 요청XML 생성
    @Override
    public String createGoodsRequestXml(GoodsRequest goodsRequest, List<Goods> list, ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        long cnt1 = 0;
        String step = null;

        try {
            // 8-1.상품수집 요청 XML 생성
            // ----------------------------------------------------------------
            step = "8-1";
            String xmlFileName = SabangnetConstant.XML_NM_GOODS_READ;

            // 3-2.XML 저장 경로, 필요에 따라 API별로 서브 디렉토리를 생성하던가 할것
            String filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId()) + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, UploadConstants.PATH_SABANGNET, xmlFileName);

            step = "8-2";
            log.debug("{}.{} SabangnetWriter.writeGoods : {},{}", step, vo.getIfPgmNm(), xmlFileName, list);
            SabangnetWriter.writeGoods(goodsRequest, filePath, list, vo.getLang());

            return xmlFileName;

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {}-ERROR.{} Exception : {}", step, vo.getIfPgmNm(), e.toString());
            // result.setSuccess(false);
            throw new CustomException("biz.exception.common.error");
        }
    }

}
