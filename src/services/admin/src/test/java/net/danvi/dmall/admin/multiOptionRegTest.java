package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.ExcelReader;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import java.io.File;
import java.io.FileInputStream;
import java.util.*;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })

public class multiOptionRegTest extends BaseService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;


    @Resource(name = "excelReader")
    private ExcelReader excelReader;


    final static String DATE_FORMAT_FOR_GOODS_NO = "yyMMddHHmm";

    @Test
    public void test() throws Exception {


        ResultListModel<GoodsDetailPO> result = new ResultListModel();
        MultipartHttpServletRequest mRequest = null;
        String goodsFileName = "options.xlsx";
        String targetPath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath("options");
        File file = new File(targetPath+ File.separator + goodsFileName);
        FileInputStream in = new FileInputStream(file);
        MultipartFile mFile = new MockMultipartFile("file",file.getName(), "text/plain", IOUtils.toByteArray(in));
        mFile.transferTo(file);
        // 엑셀 파일을 읽어 리스트 형태로 반환
        List<Map<String, Object>> plist = excelReader.convertExcelToListByMap(mFile);
        log.info("=================> kwt list : " + plist);



        List<GoodsDetailPO> list = new ArrayList<GoodsDetailPO>();
        GoodsDetailPO po = null;

        Long siteNo = 1L;
        String prevGoodsNm = null;
        String prevGoodsNo = null;

        List<String> optList = null;
        List<String> optValue1List = null;
        List<String> optValue2List = null;
        List<String> optValue3List = null;
        List<String> optValue4List = null;

        List<GoodsItemPO> optItemList = null;
        for (Map<String, Object> map : plist) {
            // 신규 GOODS_NO 취득
            String goodsNm = (String) getExcelInputValue(map.get("상품명(필수)"), "string");
            String goodsNo = (String) getExcelInputValue(map.get("상품번호"), "string");

            if (StringUtils.isEmpty(goodsNm)) {

            } else {

                if ("goodsNm".equals(goodsNm)) {
                    continue;
                }

                String optNm1 = (String) getExcelInputValue(map.get("옵션명1"), "string");
                String optNm2 = (String) getExcelInputValue(map.get("옵션명2"), "string");
                String optNm3 = (String) getExcelInputValue(map.get("옵션명3"), "string");
                String optNm4 = (String) getExcelInputValue(map.get("옵션명4"), "string");

                String optValue1 = (String) getExcelInputValue(map.get("옵션값1"), "string");
                String optValue2 = (String) getExcelInputValue(map.get("옵션값2"), "string");
                String optValue3 = (String) getExcelInputValue(map.get("옵션값3"), "string");
                String optValue4 = (String) getExcelInputValue(map.get("옵션값4"), "string");

                // 이전 상품명과 상품명이 다를 경우 새로운 상품으로 등록
                if (!goodsNm.equals(prevGoodsNm)) {
                    po = new GoodsDetailPO();
                    po.setSiteNo(siteNo);

                    // 새로운 상품번호 취득
                    /*String goodsNoSeq = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewGoodsNo", po);
                    StringBuffer sbGoodsNo = new StringBuffer().append("G").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(goodsNoSeq, "0", 4));
                    goodsNo = sbGoodsNo.toString();*/

                    // 상품 정보 설정
                    po.setGoodsNo(goodsNo);
                    po.setGoodsNm(goodsNm);

                    // 상품고시정보
                    /*String notifyNo = (String) getExcelInputValue(map.get("고시번호"), "string");
                    po.setNotifyNo(notifyNo);
                    GoodsNotifySO notifySO = new GoodsNotifySO();
                    notifySO.setNotifyNo(notifyNo);
                    List<GoodsNotifyVO> notifyList = this.selectGoodsNotifyItemList(notifySO);
                    for(int i=0;i<notifyList.size();i++) {
                    	GoodsNotifyPO notifyPO = new GoodsNotifyPO();
                    	notifyPO.setItemNo(Long.valueOf(notifyList.get(i).getItemNo()));
                    	notifyPO.setGoodsNo(po.getGoodsNo());
                    	notifyPO.setRegrNo(1000L);
                    	notifyPO.setItemValue("상품 상세설명 참조");
                    	proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsNotify", notifyPO);
                    }*/

                   /* po.setSellerNo((String) getExcelInputValue(map.get("판매자번호"), "string"));
                    po.setGoodsSaleStatusCd((String) getExcelInputValue(map.get("상품판매상태"), "string"));
                    po.setSaleStartDt((String) getExcelInputValue(map.get("판매시작일자"), "string"));
                    po.setSaleEndDt((String) getExcelInputValue(map.get("판매종료일자"), "string"));
                    po.setPrWords((String) getExcelInputValue(map.get("간단설명"), "string"));
                    po.setContent((String) getExcelInputValue(map.get("상품상세설명"), "string"));
                    po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
                    po.setMmft((String) getExcelInputValue(map.get("제조사"), "string"));
                    po.setHabitat((String) getExcelInputValue(map.get("원산지"), "string"));
                    po.setSeoSearchWord((String) getExcelInputValue(map.get("SEO검색용태그"), "string"));*/

                    // 배송 정보 설정
                    /*po.setDlvrSetCd((String) getExcelInputValue(map.get("배송정책"), "string"));
                    po.setGoodseachDlvrc((String) getExcelInputValue(map.get("상품별배송비"), "string"));
                    po.setPackMaxUnit((String) getExcelInputValue(map.get("포장최대단위"), "string"));
                    po.setPackUnitDlvrc((String) getExcelInputValue(map.get("포장별배송비"), "string"));

                    po.setDispYn("Y");
                    po.setReturnPsbYn("N");
                    po.setAdultCertifyYn("N");
                    po.setMaxOrdLimitYn("N");
                    po.setMinOrdLimitYn("N");
                    po.setGoodsContsGbCd("01");*/

                    // 상품 과세, 비과세 정보 설정
                    /*po.setTaxGbCd((String) getExcelInputValue(map.get("과세/비과세"), "string"));*/

                    // 상품 단일, 다중 옵션 정보 설정
                    String multiOptGb = (String) getExcelInputValue(map.get("상품판매정보"), "string");
                    po.setMultiOptYn(multiOptGb);

                    if (!StringUtils.isEmpty(multiOptGb)) {
                        // 다중 옵션형 상품 처리
                        if ("Y".equals(multiOptGb)) {
                            GoodsOptionPO goodsOptionPO = new GoodsOptionPO();
                            goodsOptionPO.setGoodsNo(po.getGoodsNo());
                            goodsOptionPO.setUseYn("N");
                            // 기존 단품 정보 사용 여부 'N'으로 변경
                            //proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateItemUseYnByGoodsNo", goodsOptionPO);
                            // 기존 상품 옵션 정보 삭제
                            //proxyDao.insert(MapperConstants.GOODS_MANAGE + "deleteGoodsOption", goodsOptionPO);

                            // 상품 정보 등록
                            //proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsBasicInfoMultiOptions", po);

                            // 옵션 정보 저장 Object 생성
                            optList = new ArrayList<String>();
                            optItemList = new ArrayList<>();

                            if (!StringUtils.isEmpty(optNm1)) {
                                optValue1List = new ArrayList<String>();
                            }
                            if (!StringUtils.isEmpty(optNm2)) {
                                optValue2List = new ArrayList<String>();
                            }
                            if (!StringUtils.isEmpty(optNm3)) {
                                optValue3List = new ArrayList<String>();
                            }
                            if (!StringUtils.isEmpty(optNm4)) {
                                optValue4List = new ArrayList<String>();
                            }

                            // 단일 옵션 상품 처리
                        } else {
                            // 상품 정보 등록
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsBasicInfoMultiOptions", po);

                            Long itemSeq = bizService.getSequence("ITEM_NO");
                            StringBuffer sbItem = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                            String itemNo = sbItem.toString();

                            GoodsItemPO itemPO = new GoodsItemPO();
                            itemPO.setSiteNo(siteNo);
                            itemPO.setGoodsNo(goodsNo);
                            itemPO.setItemNo(itemNo);
                            itemPO.setSepSupplyPriceYn("Y"); //별도공급가적용
                            itemPO.setSaleQtt(0L);
                            itemPO.setSupplyPrice((Long) getExcelInputValue(map.get("공급가"), "long"));
                            itemPO.setCustomerPrice((Long) getExcelInputValue(map.get("소비자가"), "long"));
                            itemPO.setSalePrice((Long) getExcelInputValue(map.get("판매가"), "long"));
                            itemPO.setStockQtt((Long) getExcelInputValue(map.get("재고"), "long"));

                            // 단품 정보 등록
                            itemPO.setItemVer(1L);
                            updateItemInfo(itemPO, false);
                            // 상품 대표 단품 번호 변경
                            po.setItemNo(itemNo);
                            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", po);
                        }
                    }

                    // 상품명이 변경되었으나 단품 리스트에 정보가 그대로 남아 있을 경우
                    // 이전 상품 정보의 다중 옵션 등록 처리를 한다.
                    if (prevGoodsNo != null && optItemList != null && optList != null) {
                        List<String> uniqueOptValue1List = null;
                        List<String> uniqueOptValue2List = null;
                        List<String> uniqueOptValue3List = null;
                        List<String> uniqueOptValue4List = null;

                        Map<String, Long> optNoMap = new HashMap<>();
                        Map<String, Long> attrNoMap = new HashMap<>();

                        long optSeq = 0L;
                        for (String option : optList) {
                            GoodsOptionPO optionPO = new GoodsOptionPO();
                            optionPO.setSiteNo(siteNo);
                            optionPO.setGoodsNo(prevGoodsNo); // (주의)현 상품이 아닌 이전
                                                              // 상품정보 처리
                            optionPO.setOptNm(option);
                            optionPO.setOptSeq(optSeq++);
                            optionPO.setUseYn("Y");
                            optionPO.setRegrNo(1000L);

                            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                            	optionPO.setOptNo(bizService.getSequence("OPT_NO"));
                            }
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", optionPO);
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", optionPO);

                            optNoMap.put(option, optionPO.getOptNo());
                        }

                        if (optValue1List != null && optValue1List.size() > 0 && optList.size() > 0) {
                            uniqueOptValue1List = new ArrayList<String>(new HashSet<String>(optValue1List));

                            String optNm = optList.get(0);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue1List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(1000L);

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }
                        if (optValue2List != null && optValue2List.size() > 0 && optList.size() > 1) {
                            uniqueOptValue2List = new ArrayList<String>(new HashSet<String>(optValue2List));

                            String optNm = optList.get(1);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue2List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(1000L);

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }
                        if (optValue3List != null && optValue3List.size() > 0 && optList.size() > 2) {
                            uniqueOptValue3List = new ArrayList<String>(new HashSet<String>(optValue3List));

                            String optNm = optList.get(2);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue3List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(1000L);

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }
                        if (optValue4List != null && optValue4List.size() > 0 && optList.size() > 3) {
                            uniqueOptValue4List = new ArrayList<String>(new HashSet<String>(optValue4List));

                            String optNm = optList.get(3);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue4List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(1000L);

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }

                        for (GoodsItemPO itemPO : optItemList) {
                            // 단품 정보 등록
                            itemPO.setItemVer(1L);
                            updateItemInfo(itemPO, false);

                            // 옵션1, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue1())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue1())) {
                                long optNo = optNoMap.get(itemPO.getOptValue1());
                                itemPO.setOptNo1(optNo);
                                itemPO.setAttrNo1(attrNoMap.get(optNo + "_" + itemPO.getAttrValue1()));
                            }
                            // 옵션2, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue2())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue2())) {
                                long optNo = optNoMap.get(itemPO.getOptValue2());
                                itemPO.setOptNo2(optNo);
                                itemPO.setAttrNo2(attrNoMap.get(optNo + "_" + itemPO.getAttrValue2()));
                            }
                            // 옵션3, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue3())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue3())) {
                                long optNo = optNoMap.get(itemPO.getOptValue3());
                                itemPO.setOptNo3(optNo);
                                itemPO.setAttrNo3(attrNoMap.get(optNo + "_" + itemPO.getAttrValue3()));
                            }
                            // 옵션4, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue4())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue4())) {
                                long optNo = optNoMap.get(itemPO.getOptValue4());
                                itemPO.setOptNo4(optNo);
                                itemPO.setAttrNo4(attrNoMap.get(optNo + "_" + itemPO.getAttrValue4()));
                            }
                            itemPO.setAttrVer(1L);
                            // 옵션 속성 정보 등록
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", itemPO);

                        }

                        // 상품 대표 단품 번호 변경
                        if (optItemList != null && optItemList.size() > 0) {
                            GoodsItemPO item = optItemList.get(0);
                            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", item);
                        }

                        // 이전 상품 정보 초기화
                        optList = null;
                        optValue1List = null;
                        optValue2List = null;
                        optValue3List = null;
                        optValue4List = null;
                        optItemList = null;
                    }

                    // 상품상세설명
                    /*GoodsDetailPO detailPO = new GoodsDetailPO();
                    detailPO.setGoodsNo(po.getGoodsNo());
                    detailPO.setSvcGbCd("01");
                    String content = (String) getExcelInputValue(map.get("상품상세설명"), "string");
                    detailPO.setContent(StringUtil.replaceAll(content, UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
                    detailPO.setMobileContent(StringUtil.replaceAll(content, UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
                    detailPO.setRegrNo(1000L);
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsDescript", detailPO);*/

                }


                if (prevGoodsNm == null || goodsNm.equals(prevGoodsNm)) {
                    if (prevGoodsNm == null) {
                        goodsNo = po.getGoodsNo();
                    } else {
                        goodsNo = prevGoodsNo;
                    }
                    po.setGoodsNo(goodsNo);
                    // 단품 정보 설정 Object 설정
                    Long itemSeq = bizService.getSequence("ITEM_NO");
                    StringBuffer sbItem = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                    String itemNo = sbItem.toString();

                    GoodsItemPO itemPO = new GoodsItemPO();
                    itemPO.setSiteNo(siteNo);
                    itemPO.setGoodsNo(goodsNo);
                    itemPO.setItemNo(itemNo);
                    itemPO.setSaleQtt(0L);
                    itemPO.setSepSupplyPriceYn("Y"); //별도공급가적용
                    itemPO.setStockQtt((Long) getExcelInputValue(map.get("옵션재고"), "long"));
                    itemPO.setSupplyPrice((Long) getExcelInputValue(map.get("옵션공급가"), "long"));
                    itemPO.setCustomerPrice((Long) getExcelInputValue(map.get("옵션소비자가"), "long"));
                    itemPO.setSalePrice((Long) getExcelInputValue(map.get("옵션판매가"), "long"));
                    itemPO.setErpItmCode((String) getExcelInputValue(map.get("다비전상품코드"), "string"));
                    if (!StringUtils.isEmpty(optNm1)) {
                        itemPO.setOptValue1(optNm1);
                        if (optList != null) {
                            optList.add(optNm1);
                        }
                    }
                    if (!StringUtils.isEmpty(optNm2)) {
                        itemPO.setOptValue2(optNm2);
                        if (optList != null) {
                            optList.add(optNm2);
                        }
                    }
                    if (!StringUtils.isEmpty(optNm3)) {
                        itemPO.setOptValue3(optNm3);
                        if (optList != null) {
                            optList.add(optNm3);
                        }
                    }
                    if (!StringUtils.isEmpty(optNm4)) {
                        itemPO.setOptValue4(optNm4);
                        if (optList != null) {
                            optList.add(optNm4);
                        }
                    }

                    if (optValue1List != null && optValue1 != null) {
                        optValue1List.add(optValue1);
                        itemPO.setAttrValue1(optValue1);
                    }
                    if (optValue2List != null && optValue2 != null) {
                        optValue2List.add(optValue2);
                        itemPO.setAttrValue2(optValue2);
                    }
                    if (optValue3List != null && optValue3 != null) {
                        optValue3List.add(optValue3);
                        itemPO.setAttrValue3(optValue3);
                    }
                    if (optValue4List != null && optValue4 != null) {
                        optValue4List.add(optValue4);
                        itemPO.setAttrValue4(optValue4);
                    }

                    if (optItemList != null) {
                        optItemList.add(itemPO);
                    }
                }
                prevGoodsNm = goodsNm;
                prevGoodsNo = goodsNo;
            }
            list.add(po);
        }

        // 이전 상품 정보가 등록이 안되었을 경우
        if (prevGoodsNo != null && optItemList != null && optList != null) {
            po.setSiteNo(siteNo);
            // 상품 정보 설정
            po.setGoodsNo(prevGoodsNo);
            po.setGoodsNm(prevGoodsNm);

            List<String> uniqueOptValue1List = null;
            List<String> uniqueOptValue2List = null;
            List<String> uniqueOptValue3List = null;
            List<String> uniqueOptValue4List = null;

            Map<String, Long> optNoMap = new HashMap<>();
            Map<String, Long> attrNoMap = new HashMap<>();

            long optSeq = 0L;
            for (String option : optList) {
                GoodsOptionPO optionPO = new GoodsOptionPO();
                optionPO.setSiteNo(siteNo);
                optionPO.setGoodsNo(prevGoodsNo); // (주의)현 상품이 아닌 이전 상품정보 처리
                optionPO.setOptNm(option);
                optionPO.setOptSeq(optSeq++);
                optionPO.setUseYn("Y");
                optionPO.setRegrNo(1000L);

                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                	optionPO.setOptNo(bizService.getSequence("OPT_NO"));
                }
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", optionPO);
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", optionPO);

                optNoMap.put(option, optionPO.getOptNo());
            }

            if (optValue1List != null && optValue1List.size() > 0 && optList.size() > 0) {
                uniqueOptValue1List = new ArrayList<String>(new HashSet<String>(optValue1List));

                String optNm = optList.get(0);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue1List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(1000L);

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }
            if (optValue2List != null && optValue2List.size() > 0 && optList.size() > 1) {
                uniqueOptValue2List = new ArrayList<String>(new HashSet<String>(optValue2List));

                String optNm = optList.get(1);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue2List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(1000L);

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }
            if (optValue3List != null && optValue3List.size() > 0 && optList.size() > 2) {
                uniqueOptValue3List = new ArrayList<String>(new HashSet<String>(optValue3List));

                String optNm = optList.get(2);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue3List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(1000L);

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }
            if (optValue4List != null && optValue4List.size() > 0 && optList.size() > 3) {
                uniqueOptValue4List = new ArrayList<String>(new HashSet<String>(optValue4List));

                String optNm = optList.get(3);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue4List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(1000L);

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }

            for (GoodsItemPO itemPO : optItemList) {
                // 단품 정보 등록
                updateItemInfo(itemPO, false);

                // 옵션1, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue1()) && !StringUtil.isEmpty(itemPO.getAttrValue1())) {
                    long optNo = optNoMap.get(itemPO.getOptValue1());
                    itemPO.setOptNo1(optNo);
                    itemPO.setAttrNo1(attrNoMap.get(optNo + "_" + itemPO.getAttrValue1()));
                }
                // 옵션2, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue2()) && !StringUtil.isEmpty(itemPO.getAttrValue2())) {
                    long optNo = optNoMap.get(itemPO.getOptValue2());
                    itemPO.setOptNo2(optNo);
                    itemPO.setAttrNo2(attrNoMap.get(optNo + "_" + itemPO.getAttrValue2()));
                }
                // 옵션3, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue3()) && !StringUtil.isEmpty(itemPO.getAttrValue3())) {
                    long optNo = optNoMap.get(itemPO.getOptValue3());
                    itemPO.setOptNo3(optNo);
                    itemPO.setAttrNo3(attrNoMap.get(optNo + "_" + itemPO.getAttrValue3()));
                }
                // 옵션4, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue4()) && !StringUtil.isEmpty(itemPO.getAttrValue4())) {
                    long optNo = optNoMap.get(itemPO.getOptValue4());
                    itemPO.setOptNo4(optNo);
                    itemPO.setAttrNo4(attrNoMap.get(optNo + "_" + itemPO.getAttrValue4()));
                }
                itemPO.setAttrVer(1L);
                // 옵션 속성 정보 등록
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", itemPO);


                List<Map<String, Object>> itmCodeMapInsList = new ArrayList<>();
                if(StringUtil.isEmpty(itemPO.getErpItmCode())) {
                    // 다비젼 상품 코드 없는 건 빼고
                    continue;
                }
                Map<String, Object> ifParam = new HashMap<>();
                ifParam.put("mallGoodsNo", po.getGoodsNo());
                ifParam.put("mallItmCode", itemPO.getItemNo());
                ifParam.put("erpItmCode", itemPO.getErpItmCode());
                if(!itmCodeMapInsList.contains(ifParam)) {
                    itmCodeMapInsList.add(ifParam);
                }

                ifParam = new HashMap<>();
            	ifParam.put("insertList", itmCodeMapInsList);

            	Map<String, Object> ifResult = InterfaceUtil.send("IF_PRD_007", ifParam);

                if ("1".equals(ifResult.get("result"))) {
                    result.setSuccess(true);
                }else{
                    throw new Exception(String.valueOf(ifResult.get("message")));
                }
            }
            // 상품 대표 단품 번호 변경
            if (optItemList != null && optItemList.size() > 0) {
                GoodsItemPO item = optItemList.get(0);
                proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", item);
            }

            // log.info("======================================> KWT po :" + po);





            list.add(po);
        }

    }

    private void updateItemInfo(GoodsItemPO po, boolean isFirstFlag) {
        po.setRegrNo(1000L);
        po.setUseYn("Y");

        String itemNo = null;
        // 기존 단품 정보의 경우
        if (!StringUtils.isEmpty(po.getItemNo())) {
            itemNo = po.getItemNo();

            GoodsItemVO vo = null;
            if (isFirstFlag) {
                po.setItemVer(1L);

            } else {
                // 이전 정보 검색용
                GoodsItemVO vo1 = new GoodsItemVO();
                vo1.setItemNo(itemNo);
                // 이전 데이터 검색
                vo = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsItem", vo1);

                if (vo != null) {
                    Long preSalePrice = vo.getSalePrice();
                    Long newSalePrice = po.getSalePrice();
                    Long preStockQtt = vo.getStockQtt();
                    Long newStockQtt = po.getStockQtt();

                    /** 필수값 이전값(vo)으로 세팅.. Start */
                    // item 명
                    if(po.getItemNm()==null)
                        po.setItemNm(vo.getItemNm());

                    //소비자가격
                    if(po.getCustomerPrice()==null)
                        po.setCustomerPrice(vo.getCustomerPrice());

                    //공급가격
                    if(po.getSupplyPrice()==null)
                        po.setSupplyPrice(vo.getSupplyPrice());

                    //별도 공급가 여부
                    if(po.getSepSupplyPriceYn()==null)
                        po.setSepSupplyPriceYn(vo.getSepSupplyPriceYn());

                    //재고
                    if(po.getStockQtt()==null)
                        po.setStockQtt(vo.getStockQtt());

                    //사용여부
                    if(po.getUseYn()==null)
                        po.setUseYn(vo.getUseYn());

                    //판매수량
                    if(po.getSaleQtt()==null)
                        po.setSaleQtt(vo.getSaleQtt());
                    /** 필수값 이전값(vo)으로 세팅.. End */


                    /** 판매가격 변경 시 */
                    if (newSalePrice != null && !newSalePrice.equals(preSalePrice)) {
                        // 가격 변경 시 ITEM_VER 을 변경
                        po.setItemVer(vo.getItemVer() + 1);
                        // 증감 코드 설정('00':인하, '01':인상)
                        if (preSalePrice > newSalePrice) {
                            po.setPriceChgCd("00");
                            po.setSaleChdPrice(preSalePrice - newSalePrice);
                        } else {
                            po.setPriceChgCd("01");
                            po.setSaleChdPrice(newSalePrice - preSalePrice);
                        }

                        // 단품 가격 변경 이력 테이블에 등록
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", po);


                    }
                    /** 재고 수량 변경 시 */
                    if (newStockQtt != null && !newStockQtt.equals(preStockQtt)) {
                        // 증감 코드 설정('00':출고, '01':입고)
                        if (preStockQtt > newStockQtt) {
                            po.setStockChgCd("00");
                            po.setStockChdQtt(preStockQtt - newStockQtt);
                        } else {
                            po.setStockChgCd("01");
                            po.setStockChdQtt(newStockQtt - preStockQtt);
                        }
                        // 단품 수량 변경 이력 테이블에 등록
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", po);
                    }
                    // 단품 정보 수정
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", po);


                } else {
                /**  신규 단품 정보의 경우 */
                    po.setItemVer(1L);
                    // 단품 정보 등록
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", po);
                    // 단품 가격 변경 이력 테이블에 등록 ("01" : 인상)
                    if (po.getSalePrice() != null) {
                        po.setPriceChgCd("01");
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", po);
                    }
                    // 단품 수량 변경 이력 테이블에 등록 ("01" : 입고)
                    if (po.getStockQtt() != null) {
                        po.setStockChgCd("01");
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", po);
                    }
                }
            }
        }
    }

    private static Object getExcelInputValue(Object value, String type) {
        Object obj = null;
        if (value instanceof Boolean && !(((Boolean) value).booleanValue())) {
            if ("string".equals(type)) {
                obj = "";
            } else if ("long".equals(type)) {
                obj = 0L;
            } else if ("double".equals(type)) {
                obj = 0D;
            }
        } else {
            if ("string".equals(type)) {
                if (value instanceof Double) {
                    obj = String.valueOf(value);
                } else {
                    obj = value;
                }
            } else if ("long".equals(type)) {
                if (value instanceof Double) {
                    obj = (long) ((double) value);
                } else if (value instanceof String) {
                    obj = Long.valueOf((String) value);
                } else {
                    obj = value;
                }
            } else if ("double".equals(type)) {
                obj = value;
            }
        }
        return obj;
    }
}