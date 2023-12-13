package net.danvi.dmall.biz.app.seller.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.*;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.operation.model.*;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.model.SellerVOListWrapper;
import net.danvi.dmall.biz.app.setup.delivery.model.*;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("sellerService")
@Transactional(rollbackFor = Exception.class)
public class SellerServiceImpl extends BaseService implements SellerService {

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    public ResultListModel<SellerVO> selectSellerList(SellerSO sellerSO) {

    	if (("all").equals(sellerSO.getSearchType())) {
    		sellerSO.setSearchSellerId(sellerSO.getSearchWords());
    		sellerSO.setSearchSellerNm(sellerSO.getSearchWords());
    		sellerSO.setSearchManagerTelNo(sellerSO.getSearchWords());
    		sellerSO.setSearchManagerEmail(sellerSO.getSearchWords());
        } else if (("id").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchSellerId(sellerSO.getSearchWords());
        } else if (("name").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchSellerNm(sellerSO.getSearchWords());
        } else if (("tel").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchManagerTelNo(sellerSO.getSearchWords());
        } else if (("email").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchManagerEmail(sellerSO.getSearchWords());
        }
    	
        if (sellerSO.getSidx().length() == 0) {
        	sellerSO.setSidx("REG_DTTM");
        	sellerSO.setSord("DESC");
        }        
        
        return proxyDao.selectListPage(MapperConstants.SELLER + "selectSellerPaging", sellerSO);
    }

    
    public List<SellerVO> selectSellerListExcel(SellerSO sellerSO) {

        if (("all").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchSellerId(sellerSO.getSearchWords());
            sellerSO.setSearchSellerNm(sellerSO.getSearchWords());
            sellerSO.setSearchManagerTelNo(sellerSO.getSearchWords());
            sellerSO.setSearchManagerEmail(sellerSO.getSearchWords());
        } else if (("id").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchSellerId(sellerSO.getSearchWords());
        } else if (("name").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchSellerNm(sellerSO.getSearchWords());
        } else if (("tel").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchManagerTelNo(sellerSO.getSearchWords());
        } else if (("email").equals(sellerSO.getSearchType())) {
            sellerSO.setSearchManagerEmail(sellerSO.getSearchWords());
        }

        if (sellerSO.getSidx().length() == 0) {
        	sellerSO.setSidx("REG_DTTM");
        	sellerSO.setSord("ASC");
        }

        return proxyDao.selectList(MapperConstants.SELLER + "selectSellerPaging", sellerSO);
    }
    
    
    /** 아이디 중복확인 서비스 **/
    public int checkDuplicationId(SellerSO so) throws CustomException {
        int result = 0;

        /* 가입불가 아이디 체크 */
        String[] checkId = { "admin", "administration", "administer", "master", "webmaster", "manage", "manager" };
        Boolean checkExe = true;
        for (String ex : checkId) {
            if (ex.equalsIgnoreCase(so.getSellerId())) {
                checkExe = false;
                result = 1;
            }
        }
        /* 가입불가 아이디 체크 */
        if (checkExe) {
            result = proxyDao.selectOne(MapperConstants.SELLER + "checkDuplicationId", so);
        }

        return result;
    }
    

    public ResultModel<SellerVO> saveSeller(SellerPO po) {
    	
        ResultModel<SellerVO> result = new ResultModel<>();
        
        try {
        	
        	if (!StringUtils.isEmpty(po.getPw())) {
                po.setPw(CryptoUtil.encryptSHA512(po.getPw()));
        	}
        	
        	// 판매자 상세정보
    		SellerVO sellerVO = new SellerVO();

        	if(po.getFarmIntro()!=null)
                po.setFarmIntro(po.getFarmIntro().replaceAll("(\r\n|\r|\n|\n\r)", "<br>"));
        	
        	if ("UPDATE".equals(po.getInputGbn())) {
                SellerPO temp = new SellerPO();
                temp.setSiteNo(po.getSiteNo());
                temp.setSellerNo(po.getSellerNo());
                sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", temp);

                proxyDao.update(MapperConstants.SELLER + "updateSellerInfo", po);
                result.setMessage(MessageUtil.getMessage("biz.common.update"));
        	} else {
        		proxyDao.insert(MapperConstants.SELLER + "insertSellerInfo", po);
                result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        	}
        	
        	if(sellerVO != null) {
	        	// 판매자의 수수율이 변경될경우의 처리
	        	if (po.getSellerCmsRate() > 0) {
	        		
	        		// 판매수수료율이 변경되었을 경우
	        		if (po.getSellerCmsRate() != sellerVO.getSellerCmsRate()) {
	        			// 변경이력	
	            		proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHistBySeller", po);
	            		// 판매자 상품 공급가액 변경
	            		proxyDao.update(MapperConstants.GOODS_MANAGE + "updateSupplyPriceBySeller", po);
	        		}
	        	} else if (po.getSellerCmsRate() == 0) {
	        		
	        		// 판매수수료율이 변경되었을 경우
	        		if (po.getSellerCmsRate() != sellerVO.getSellerCmsRate()) {
	        			// 변경이력	
	            		proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHistByCtg", po);
	            		// 판매자 상품 공급가액 변경
	            		proxyDao.update(MapperConstants.GOODS_MANAGE + "updateSupplyPriceByCtg", po);
	        		}
	        	}
        	}
        	
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "판매자등록" }, e);
        } 
    	
        return result;
    }    
    
    public ResultModel<SellerVO> selectSellerInfo(SellerSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
    	so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 판매자 정보 조회
        SellerVO sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", so);
        if(sellerVO != null && sellerVO.getStoreInquiryReply() != null) {
            sellerVO.setStoreInquiryReply(StringUtil.replaceAll(sellerVO.getStoreInquiryReply(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        }

        // 판매자 변경 이력 조회
        List<SellerVO> chgLog = proxyDao.selectList(MapperConstants.SELLER + "selectChgLog", so);
        if(sellerVO != null) {
            sellerVO.setChgLog(chgLog);
        }

        ResultModel<SellerVO> result = new ResultModel<SellerVO>(sellerVO);

        // 공통 첨부파일 조회
        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(so.getSiteNo());
        s.setRefNo(so.getSellerNo());
        s.setFileGb("TS_SELLER");

        editorService.setCmnAtchFileToEditorVO(s, sellerVO);
        result.setData(sellerVO);

        return result;
    }
    
    
    public List<SellerVO> getSellerList(SellerSO sellerSO) {

        if (sellerSO.getSidx().length() == 0) {
        	sellerSO.setSidx("REG_DTTM");
        	sellerSO.setSord("ASC");
        }

        sellerSO.setStatusCds(new String[]{"02"});
        
        return proxyDao.selectList(MapperConstants.SELLER + "selectSellerList", sellerSO);
    }    
    
    
    @Override
    public ResultModel<AtchFilePO> deleteAtchFile(SellerVO vo) throws Exception {
        ResultModel<AtchFilePO> result = new ResultModel<>();
        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        FileVO fo = proxyDao.selectOne(MapperConstants.SELLER + "selectAtchFile", vo);
        String fileNm = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_ATTACH + File.separator 
        		+ UploadConstants.PATH_SELLER + fo.getFilePath() + File.separator + fo.getFileName();

        File file = new File(fileNm);
        file.delete();
      
        // 게시글 파일 정보 삭제
        try {
        	
            proxyDao.update(MapperConstants.SELLER + "deleteAtchFile", vo);
            
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }
    
    
    @Override
    @Transactional(readOnly = true)
    public FileVO selectAtchFileDtl(SellerVO vo) throws Exception {
        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        
        FileVO fo = proxyDao.selectOne(MapperConstants.SELLER + "selectAtchFile", vo);
        
        fo.setFilePath(SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_ATTACH + File.separator 
        		+ UploadConstants.PATH_SELLER + fo.getFilePath() + File.separator + fo.getFileName());

        return fo;
    }
    
    
    @Override
    public ResultModel<SellerVO> updateSellerSt(SellerVOListWrapper wrapper) throws Exception {
        ResultModel<SellerVO> result = new ResultModel<>();

        for (SellerVO vo : wrapper.getList()) {
            vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            vo.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            // 판매자 정보 조회
            SellerVO sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", vo);
            // 승인요청으로 변경하려는 경우 sms 전송
            if ("N".equals(sellerVO.getAprvYn()) && "N".equals(vo.getAprvYn()) && !StringUtils.isEmpty(sellerVO.getManagerMobileNo())) {
                ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

                SmsSendSO smsSendSO = new SmsSendSO();
                smsSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                smsSendSO.setSendTypeCd("36");
                smsSendSO.setSellerNo(Long.parseLong(vo.getSellerNo()));
                smsSendSO.setSellerTemplateCode("mk049");

                smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);
            }

            proxyDao.update(MapperConstants.SELLER + "updateSellerSt", vo);
        }

        result.setMessage(MessageUtil.getMessage("admin.web.seller.approval"));
        return result;
    }
    
    
    @Override
    public ResultModel<SellerVO> deleteSellerSt(SellerVOListWrapper wrapper) throws Exception {
        ResultModel<SellerVO> result = new ResultModel<>();

        for (SellerVO vo : wrapper.getList()) {
            vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            vo.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            proxyDao.update(MapperConstants.SELLER + "deleteSeller", vo);
        }

        result.setMessage(MessageUtil.getMessage("admin.web.seller.delete"));
        return result;
    }
    
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SellerVO> viewMemInfoDtl(MemberManageSO memberManageSO) {
    	SellerVO vo = proxyDao.selectOne(MapperConstants.SELLER + "viewMemInfoDtl", memberManageSO);
        ResultModel<SellerVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<DeliveryConfigVO> selectDeliveryConfig(SellerPO po) {
        DeliveryConfigVO resultVO = proxyDao.selectOne(MapperConstants.SELLER + "selectDeliveryConfig", po);
        ResultModel<DeliveryConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

     /** 배송 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see
     * DeliveryManageService#
     * updateDeliveryConfig(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryConfigPO)
     */
    @Override
    public ResultModel<DeliveryConfigPO> updateDeliveryConfig(DeliveryConfigPO po) throws Exception {
        ResultModel<DeliveryConfigPO> result = new ResultModel<>();
        if (po.getDefaultDlvrc() != null && po.getDefaultDlvrc().trim().length() < 1) {
            po.setDefaultDlvrc(null);
        }
        if (po.getDefaultDlvrMinAmt() != null && po.getDefaultDlvrMinAmt().trim().length() < 1) {
            po.setDefaultDlvrMinAmt(null);
        }
        if (po.getDefaultDlvrMinDlvrc() != null && po.getDefaultDlvrMinDlvrc().trim().length() < 1) {
            po.setDefaultDlvrMinDlvrc(null);
        }

        if (StringUtils.isEmpty(po.getCouriUseYn())) {
            po.setCouriUseYn("N");
        }
        if (StringUtils.isEmpty(po.getDirectVisitRecptYn())) {
            po.setDirectVisitRecptYn("N");
        }

        po.setSiteNo(po.getSiteNo()); // 사이트 번호 세팅
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        proxyDao.update(MapperConstants.SELLER + "updateDeliveryConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

     @Override
    @Transactional(readOnly = true)
    public ResultListModel<DeliveryAreaVO> selectDeliveryListPaging(DeliveryAreaSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        so.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        return proxyDao.selectListPage(MapperConstants.SELLER + "selectDeliveryListPaging", so);
    }

     @Override
    public ResultModel<DeliveryAreaPO> insertDeliveryArea(DeliveryAreaPO po) throws Exception {
        ResultModel<DeliveryAreaPO> result = new ResultModel<>();
        po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        int cnt = proxyDao.selectOne(MapperConstants.SELLER + "selectCountDeliveryArea", po);
        if (cnt > 0) {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.exist", new Object[] { "우편번호" }));
        } else {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.update(MapperConstants.SELLER + "updateDeliveryArea", po);
            result.setMessage(MessageUtil.getMessage("biz.common.save"));
        }
        return result;
    }

    @Override
    public ResultModel<DeliveryAreaPO> updateDeliveryArea(DeliveryAreaPO po) throws Exception {
        ResultModel<DeliveryAreaPO> result = new ResultModel<>();
        po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SELLER + "updateDeliveryArea", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    @Override
    public ResultModel<DeliveryAreaPO> updateApplyDefaultDeliveryArea(DeliveryAreaPO po) throws Exception {
        ResultModel<DeliveryAreaPO> result = new ResultModel<>();
        po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SELLER + "updateApplyDefaultDeliveryArea", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    @Override
    public ResultModel<DeliveryAreaPO> deleteDeliveryArea(DeliveryAreaPOListWrapper wrapper) {
        ResultModel<DeliveryAreaPO> resultModel = new ResultModel<>();

        for (DeliveryAreaPO po : wrapper.getList()) {
            po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.delete(MapperConstants.SELLER + "deleteDeliveryArea", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return resultModel;
    }

    public ResultModel<DeliveryAreaPO> deleteAllDeliveryArea(DeliveryAreaPO po) {
        ResultModel<DeliveryAreaPO> resultModel = new ResultModel<>();
        po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.delete(MapperConstants.SELLER + "deleteAllDeliveryArea", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<HscdVO> selectHscdListPaging(HscdSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.SETUP_DELIVERY + "selectHscdListPaging", so);
    }

    /** HS코드 정보 등록, 수정 처리 서비스 **/
    @Override
    public ResultModel<HscdPO> updateHscd(HscdPO po) throws Exception {
        ResultModel<HscdPO> result = new ResultModel<>();
        if (po.getHscdSeq() == null) {
            Long hscdSeq = bizService.getSequence("HSCD_SEQ", po.getSiteNo());
            po.setHscdSeq(hscdSeq);
        }
        proxyDao.insert(MapperConstants.SETUP_DELIVERY + "updateHscd", po);
        result.setMessage(MessageUtil.getMessage("biz.common.save"));
        return result;
    }

    /** HS코드 정보 삭제 처리 서비스 **/
    @Override
    public ResultModel<HscdPO> deleteHscd(HscdPO po) throws Exception {
        ResultModel<HscdPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.SETUP_DELIVERY + "deleteHscd", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    public ResultModel<SellerPO> insertSellerReply(SellerPO po, HttpServletRequest request) throws Exception {
        ResultModel<SellerPO> result = new ResultModel<>();

        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        po.setStoreInquiryReply(StringUtil.replaceAll(po.getStoreInquiryReply(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

        try {
            SellerVO vo = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", po);

            vo.setStoreInquiryContent(StringUtil.replaceAll(vo.getStoreInquiryContent(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));

            // sms 발송
            if (vo.getManagerMobileNo() != null && !("").equals(vo.getManagerMobileNo())) {
                ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

                SmsSendSO smsSendSO = new SmsSendSO();
                smsSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                smsSendSO.setSendTypeCd("30");
                smsSendSO.setSellerNo(Long.parseLong(vo.getSellerNo()));
                smsSendSO.setSellerTemplateCode("mk041");

                smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);
            }

            // 이메일 발송
            if (vo.getManagerEmail() != null && !vo.getManagerEmail().equals("")) {
                SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", vo);

                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Date today = new Date();

                // 메일 내용에 따른 치환코드 설정 필요
                ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
                emailReplaceVO.setShopName(siteVO.getSiteNm());
                emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteVO.getDlgtDomain()));
                emailReplaceVO.setInqueryTitle("");
                emailReplaceVO.setInqueryContent(vo.getStoreInquiryContent());
                emailReplaceVO.setInqueryRegrDtm(df.format(vo.getRegDttm()));
                emailReplaceVO.setInqueryReplyTitle("");
                emailReplaceVO.setInqueryReplyContent(po.getStoreInquiryReply());
                emailReplaceVO.setInqueryReplyRegrDtm(df.format(today));

                // 메일발송객체 set
                EmailSendSO emailSendSO = new EmailSendSO();
                emailSendSO.setSiteNo(po.getSiteNo());
                emailSendSO.setMailTypeCd("29");
                emailSendSO.setReceiverId(vo.getSellerId());
                emailSendSO.setReceiverNo(Long.parseLong(vo.getSellerNo()));
                emailSendSO.setReceiverNm(vo.getSellerNm());
                emailSendSO.setReceiverEmail(vo.getManagerEmail());

                emailSendService.emailAutoSend(emailSendSO, emailReplaceVO);
            }

            po.setStoreInquiryReply(StringUtil.replaceAll(po.getStoreInquiryReply(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));

            // 입점 문의 답변 등록
            proxyDao.update(MapperConstants.SELLER + "insertSellerReply", po);
            // 에디터 파일 등록
            try {
                String fileGb = "TS_SELLER";
                editorService.setEditorImageToService(po, po.getSellerNo(), fileGb);
                FileUtil.setEditorImageList(po, fileGb, po.getAttachImages());

                for(CmnAtchFilePO p : po.getAttachImages()) {
                    if(p.getTemp()) {
                        p.setFileGb(fileGb);
                        p.setRefNo(po.getSellerNo());
                        editorService.insertCmnAtchFile(p);
                    }
                }
                FileUtil.deleteEditorTempImageList(po.getAttachImages());
            } catch (DuplicateKeyException e) {
                throw new CustomException("biz.exception.common.exist", new Object[] { "파일 정보" }, e);
            }

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }

        return result;
    }
}
