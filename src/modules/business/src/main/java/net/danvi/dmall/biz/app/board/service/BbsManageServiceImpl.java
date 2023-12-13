package net.danvi.dmall.biz.app.board.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManagePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageSO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageVO;
import net.danvi.dmall.biz.app.board.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.board.model.BbsManagePO;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.board.model.BbsManageVO;
import net.danvi.dmall.biz.app.board.model.BbsTitleManagePO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.common.model.FileDownloadSO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.service.SiteService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.EditorBasePO;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.MultiEditorBasePO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import dmall.framework.common.util.image.ImageHandler;
import dmall.framework.common.util.image.ImageInfoData;
import dmall.framework.common.util.image.ImageType;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("bbsManageService")
@Transactional(rollbackFor = Exception.class)
public class BbsManageServiceImpl extends BaseService implements BbsManageService {
    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Value("#{system['system.upload.path']}")
    private String filePath;

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "imageHandler")
    private ImageHandler imageHandler;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Resource(name = "sellerService")
    private SellerService sellerService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BbsManageVO> selectBbsListPaging(BbsManageSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        // 게시판 리스트 조회
        return proxyDao.selectListPage(MapperConstants.BBS + "selectBbsListPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BbsManageVO> selectBbsDtl(BbsManageSO so) throws Exception {
        ResultModel<BbsManageVO> result =null;

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시판 단건 정보 조회
        BbsManageVO vo = proxyDao.selectOne(MapperConstants.BBS + "selectBbsDtl", so);
        // 게시판 타이틀 리스트 조회
        List<BbsManageVO> temp = proxyDao.selectList(MapperConstants.BBS_TITLE + "selectBbsTitleList", so);
        if(vo !=null) {
            vo.setTitleNmArr(temp);

            result = new ResultModel<>(vo);

            // 첨부파일 조회 조건 목록
            List<CmnAtchFileSO> soList = new ArrayList<>();

            // 첨부파일 조회 조건 세팅
            CmnAtchFileSO s = new CmnAtchFileSO();
            s.setSiteNo(so.getSiteNo());
            s.setRefNo(so.getBbsId());
            s.setFileGb("TB_BBS.TOP_HTML_SET");
            soList.add(s);
            s = new CmnAtchFileSO();
            s.setSiteNo(so.getSiteNo());
            s.setRefNo(so.getBbsId());
            s.setFileGb("TB_BBS.BOTTOM_HTML_SET");
            soList.add(s);

            // 공통 첨부 파일 조회
            editorService.setCmnAtchFileToEditorVO(soList, vo);
            result.setData(vo);
        }

        return result;
    }

    @Override
    public ResultModel<BbsManagePO> insertBbs(BbsManagePO po) throws Exception {
        ResultModel<BbsManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        try {
            // 상단,하단 디자인 내용에 아무런 값이 없을경우에도 <p><br></p>태그는 불필요하게 계속 남아있기때문에 강제로 replace시킨다.
            // 해당내용과 관련하여 결함이 올라와서 처리(운영기 결함번호: 12838)
            po.setTopHtmlSet(po.getTopHtmlSet().replace("<p><br></p>", ""));
            po.setBottomHtmlSet(po.getBottomHtmlSet().replace("<p><br></p>", ""));

            // 게시판 정보 등록
            proxyDao.insert(MapperConstants.BBS + "insertBbs", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
            // 게시판 TOP, BOTTOM HTML 파일 등록
            insertCmnAtchFile(po, po.getBbsId(), new String[] { "TB_BBS.TOP_HTML_SET", "TB_BBS.BOTTOM_HTML_SET" });
            // 게시판 타이틀 리스트 등록
            insertBbsTitle(po);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "게시판아이디" }, e);
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }

    @Override
    public ResultModel<BbsManagePO> updateBbs(BbsManagePO po) throws Exception {
        ResultModel<BbsManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        try {
            // 상단,하단 디자인 내용에 아무런 값이 없을경우에도 <p><br></p>태그는 불필요하게 계속 남아있기때문에 강제로 replace시킨다.
            // 해당내용과 관련하여 결함이 올라와서 처리(운영기 결함번호: 12838)
            po.setTopHtmlSet(po.getTopHtmlSet().replace("<p><br></p>", ""));
            po.setBottomHtmlSet(po.getBottomHtmlSet().replace("<p><br></p>", ""));

            // 게시판 정보 수정
            proxyDao.update(MapperConstants.BBS + "updateBbs", po);
            // 게시판 TOP, BOTTOM HTML 파일 등록
            insertCmnAtchFile(po, po.getBbsId(), new String[] { "TB_BBS.TOP_HTML_SET", "TB_BBS.BOTTOM_HTML_SET" });
            // 게시판 타이틀 리스트 등록
            insertBbsTitle(po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "게시판아이디" }, e);
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BbsLettManageVO> selectBbsLettPaging(BbsLettManageSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        if (("searchBbsLettRegr").equals(so.getSearchKind()) || ("all").equals(so.getSearchKind())) {
            so.setRegrNm(so.getSearchVal());
        }

        if (so.getSearchVal() != null && !so.getSearchVal().trim().isEmpty()) {
            so.setSearchValEncrypt(so.getSearchVal());
        }

        BbsLettManageVO bbsLettManageVO  = new BbsLettManageVO();
        // 게시글 리스트 조회 ( 공지사항, 자유게시판, 1:1문의, 상품 문의&후기, FAQ )
        ResultListModel<BbsLettManageVO> result = proxyDao.selectListPage(getLettXmlName(so.getBbsId()) + "selectBbsLettPaging", so);
        if(result.getResultList()!=null) {
            for (int i = 0; i < result.getResultList().size(); i++) {
                bbsLettManageVO = (BbsLettManageVO) result.getResultList().get(i);
                bbsLettManageVO.setContent(StringUtil.replaceAll(bbsLettManageVO.getContent(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
            }
        }

        return result;
    }



    @Override
    @Transactional(readOnly = true)
    public ResultModel<BbsLettManageVO> selectBbsLettDtl(BbsLettManageSO so) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시글 단건 정보 조회
        BbsLettManageVO vo = proxyDao.selectOne(getLettXmlName(so.getBbsId()) + "selectBbsLettDtl", so);
        log.info("{}", vo);
        if(vo.getContent()!=null) {
            vo.setContent(StringUtil.replaceAll(vo.getContent(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
            vo.setReplyContent(StringUtil.replaceAll(vo.getReplyContent(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        }

        // 게시글 파일 리스트 조회
        List<AtchFileVO> atchFileTemp = proxyDao.selectList(MapperConstants.BBS_ATCH_FILE + "selectAtchFileList", so);
        if (atchFileTemp.size() > 0) {
            vo.setAtchFileArr(atchFileTemp);
        }
        // 게시판 상품 조회
        if(so.getBbsId().equals("vote") || so.getBbsId().equals("pick") || so.getBbsId().equals("collection")) {
            List<BbsLettManageVO> goodsTemp = proxyDao.selectList(MapperConstants.BBS_STYLE_LETT + "selectBbsGoods", so);
            if (goodsTemp.size() > 0) {
                vo.setStyleGoodsArr(goodsTemp);
            }
        }

        ResultModel<BbsLettManageVO> result = new ResultModel<BbsLettManageVO>(vo);

        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(so.getSiteNo());
        if (("faq").equals(so.getBbsId()) ||
                ("notice").equals(so.getBbsId()) ||
                ("eyetest").equals(so.getBbsId()) ||
                ("sellNotice").equals(so.getBbsId())) {
            s.setRefNo(vo.getLettNo());
        }
        if (("inquiry").equals(so.getBbsId()) ||
                ("question").equals(so.getBbsId())) {
            s.setRefNo(vo.getReplyLettNo());
        }
        if (("sellQuestion").equals(so.getBbsId())) {
            if(SessionDetailHelper.getDetails().getSession().getSellerNo() != null && so.getRegrNo() == SessionDetailHelper.getDetails().getSession().getSellerNo()) {
                s.setRefNo(vo.getLettNo());
            } else {
                s.setRefNo(vo.getReplyLettNo());
            }
        }
        s.setFileGb(getLettDbName(so.getBbsId()));

        // 공통 첨부 파일 조회
        editorService.setCmnAtchFileToEditorVO(s, vo);
        result.setData(vo);
        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> insertBbsLett(BbsLettManagePO po, HttpServletRequest request) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        String dlgtDomain = "";

        if(!po.getBbsId().equals("collection")) {
            String lettNo = selectNewLettNo(po.getBbsId());
            po.setLettNo(lettNo);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        po.setContent(StringUtil.replaceAll(po.getContent(),(String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

        try {
            // 게시글 정보 등록
            proxyDao.insert(getLettXmlName(po.getBbsId()) + "insertBbsLett", po);
            // 게시글 파일 등록
            insertCmnAtchFile(po, po.getLettNo(), getLettDbName(po.getBbsId()));
            insertAtchFile(request, po);
            if(po.getRecommendNo() != null && po.getRecommendNo().length > 0 && (po.getBbsId().equals("pick") || po.getBbsId().equals("collection"))) {
                insertLettGoods(po);
            }
            result.setData(po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }
        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> updateBbsLett(BbsLettManagePO po, HttpServletRequest request) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        try {
            // 게시글 정보 수정
            proxyDao.update(getLettXmlName(po.getBbsId()) + "updateBbsLett", po);
            // 게시글 파일 등록
            insertCmnAtchFile(po, po.getLettNo(), getLettDbName(po.getBbsId()));
            insertAtchFile(request, po);
            if(po.getBbsId().equals("pick") || po.getBbsId().equals("collection")) {
                proxyDao.delete(MapperConstants.BBS_STYLE_LETT + "deleteBbsGoods", po);
                if(po.getRecommendNo() != null && po.getRecommendNo().length > 0) {
                    insertLettGoods(po);
                }
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (Exception e) {
        	e.printStackTrace();
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }
        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> deleteBbsLett(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();

        BbsLettManageSO so = new BbsLettManageSO();
        so.setLettNo(po.getLettNo());
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId(po.getBbsId());
        so.setDelrNo(po.getDelrNo());

        if (getLettXmlName(po.getBbsId()).equals(MapperConstants.BBS_INQUIRY_LETT)
                || getLettXmlName(po.getBbsId()).equals(MapperConstants.BBS_LETT)
                || getLettXmlName(po.getBbsId()).equals(MapperConstants.BBS_GOODS_LETT)) {
            // 게시글 답변 삭제 여부 수정
            BbsLettManageVO vo = proxyDao.selectOne(getLettXmlName(po.getBbsId()) + "selectBbsLettDtl", so);
            if (vo != null) {
                BbsLettManagePO replyPo = new BbsLettManagePO();
                replyPo.setGrpNo(vo.getGrpNo());
                replyPo.setLettLvl(vo.getLettLvl());
                replyPo.setDelrNo(po.getDelrNo());
                replyPo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                proxyDao.update(getLettXmlName(po.getBbsId()) + "deleteBbsLettReply", replyPo);
            }
        }

        // 게시글 삭제 여부 수정
        proxyDao.update(getLettXmlName(po.getBbsId()) + "deleteBbsLett", po);

        // 첨부파일 조회 및 삭제 여부 수정
        List<AtchFileVO> temp = proxyDao.selectList(MapperConstants.BBS_ATCH_FILE + "selectAtchFileList", so);
        for (int i = 0; i < temp.size(); i++) {
            AtchFilePO atchPo = new AtchFilePO();
            atchPo.setFileNo(temp.get(i).getFileNo());
            atchPo.setDelrNo(po.getDelrNo());
            deleteAtchFile(atchPo);
        }

        if(po.getBbsId().equals("vote") || po.getBbsId().equals("pick") || po.getBbsId().equals("collection")) {
            // 게시글 상품 정보 삭제 여부 수정
            proxyDao.update(MapperConstants.BBS_STYLE_LETT + "updateBbsGoods", so);

            // 게시글 댓글 삭제
            BbsCmntManagePO cmntPo = new BbsCmntManagePO();
            cmntPo.setLettNo(po.getLettNo());
            cmntPo.setBbsId(po.getBbsId());
            proxyDao.delete(MapperConstants.BBS_STYLE_LETT + "deleteBbsComment", cmntPo);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> updateBbsLettExpsYn(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 상품 후기 노출&비노출 상태 수정
        proxyDao.update(getLettXmlName(po.getBbsId()) + "updateBbsLettExpsYn", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> insertBbsReply(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date today = new Date();
        // 조회(검색)용 객체 생성
        BbsLettManageSO so = new BbsLettManageSO();
        so.setLettNo(po.getLettNo());
        so.setBbsId(po.getBbsId());
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        BbsLettManageVO vo = proxyDao.selectOne(getLettXmlName(so.getBbsId()) + "selectBbsLettDtl", so);

        // 사이트명, 주소, 번호 등 조회
        SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", so);

        // 답변 title 설정
        po.setTitle(po.getReplyTitle());
        // 답변 content 설정
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        // 답변 content url 수정
        po.setReplyContent(StringUtil.replaceAll(po.getReplyContent(),(String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
        po.setContent(StringUtil.replaceAll(po.getReplyContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        // sms 발송 여부 Y 일때 SMS 발송
        if ("Y".equals(po.getSmsSendYn())) {
            // sms 치환코드 set
            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            smsReplaceVO.setGoodsNm(po.getGoodsNm());
            smsReplaceVO.setMypageUrl(AdminConstants.MYPAGE_URL);

            // send 객체 set
            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            if ("inquiry".equals(so.getBbsId())) {
                smsSendSo.setSendTypeCd("20"); // ERD 발송 유형 코드 참조 ex)1:1문의 답변 코드 20
                smsSendSo.setMemberTemplateCode("mk039");
            } else if ("question".equals(so.getBbsId())) {
                smsSendSo.setSendTypeCd("16"); // ERD 발송 유형 코드 참조 ex)1:1문의 답변 코드
                smsSendSo.setMemberTemplateCode("mk037");
            } else if ("sellQuestion".equals(so.getBbsId())) {
                smsSendSo.setSendTypeCd("40");
                smsSendSo.setSellerTemplateCode("mk053");
            }
            smsSendSo.setMemberNo(po.getMemberNo());
            smsSendSo.setSellerNo(po.getSellerNo());

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);
        }
        // EMAIL 발송 여부 Y 일때 EMAIL 발송
        if ("Y".equals(po.getEmailSendYn())) {
            String receiverId = "";
            String receiverNm = "";
            long receiverNo = 0L;
            String receiverEmail = "";
            String memberEmailRecvYn = "";

            // 1:1 문의 답변일 때 통과함
            if(vo.getMemberNo() != null && !vo.getMemberNo().equals("")) {
                MemberManageVO memberVO = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "viewMemInfoDtl", po);
                receiverId = memberVO.getLoginId();
                receiverNm = memberVO.getMemberNm();
                receiverNo = memberVO.getMemberNo();
                receiverEmail = memberVO.getEmail();
                memberEmailRecvYn = memberVO.getEmailRecvYn();
            }
            // 판매자 문의 답변일 때 통과함
            if(vo.getSellerNo() != null && !vo.getSellerNo().equals("")) {
                SellerVO sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", po);
                receiverId = sellerVO.getSellerId();
                receiverNm = sellerVO.getSellerNm();
                receiverNo = Long.parseLong(sellerVO.getSellerNo());
                receiverEmail = sellerVO.getManagerEmail();
            }

            /* 변경할 치환 코드 설정 */
            ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
            emailReplaceVO.setInqueryTitle(vo.getTitle());
            emailReplaceVO.setInqueryContent(vo.getContent());
            emailReplaceVO.setInqueryRegrDtm(df.format(vo.getRegDttm()));
            emailReplaceVO.setInqueryReplyTitle(po.getTitle());
            emailReplaceVO.setInqueryReplyContent(po.getContent());
            emailReplaceVO.setInqueryReplyRegrDtm(df.format(today));
            emailReplaceVO.setMemberNm(receiverNm);

            emailReplaceVO.setShopName(siteVO.getSiteNm());
            emailReplaceVO.setCustCtEmail(siteVO.getCustCtEmail());
            emailReplaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
            // 23.05.25 test server domain
            emailReplaceVO.setDlgtDomain("devnewmarket.fittingmonster.com");
//            emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteVO.getDlgtDomain()));
            emailReplaceVO.setLogoPath(siteVO.getLogoPath());

            /* 이메일 자동 발송 기본 설정 */
            EmailSendSO emailSendSo = new EmailSendSO();
            emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            /* 이메일 자동 발송 기본 설정 */
            if ("inquiry".equals(so.getBbsId())) {
                emailSendSo.setMailTypeCd("23"); // ERD 메일 유형 코드 참조 ex)1:1문의 답변
            } else if ("sellQuestion".equals(so.getBbsId())) {
                emailSendSo.setMailTypeCd("35"); // ERD 메일 유형 코드 참조 ex)1:1문의 답변
            } else if ("question".equals(so.getBbsId())) {
                emailSendSo.setMailTypeCd("19");
            }
            emailSendSo.setReceiverId(receiverId);
            emailSendSo.setReceiverNo(receiverNo);
            emailSendSo.setReceiverNm(receiverNm);
            emailSendSo.setReceiverEmail(receiverEmail);

            if(!memberEmailRecvYn.equals("N")) {
                emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);
            }
        }

        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        po.setGrpNo(po.getLettNo());
        String lettNo = (String) proxyDao.selectOne(getLettXmlName(po.getBbsId()) + "selectNewLettNo", po);
        po.setLettNo(lettNo);

        // 게시글 답변 등록
        proxyDao.insert(getLettXmlName(po.getBbsId()) + "insertBbsLett", po);
        // 게시글 답변 파일 등록
        insertCmnAtchFile(po, po.getLettNo(), getLettDbName(po.getBbsId()));

        po.setLettNo(po.getGrpNo());
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 원본 게시글 답변 상태 변경
        proxyDao.update(getLettXmlName(po.getBbsId()) + "updateBbsLettReplyStatus", po);

        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> updateBbsReply(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();

        // 답변 수정을 위해 po 객체 수정
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        po.setGrpNo(po.getLettNo());
        po.setLettNo(po.getReplyLettNo());
        po.setTitle(po.getReplyTitle());

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date today = new Date();
        // 조회(검색)용 객체 생성
        BbsLettManageSO so = new BbsLettManageSO();
        so.setLettNo(po.getGrpNo());
        so.setBbsId(po.getBbsId());
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        BbsLettManageVO vo = proxyDao.selectOne(getLettXmlName(so.getBbsId()) + "selectBbsLettDtl", so);

        // 사이트명, 주소, 번호 등 조회
        SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", so);

        // 답변 title 설정
        po.setTitle(po.getReplyTitle());
        // 답변 content 설정
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        // 답변 content url 수정
        po.setReplyContent(StringUtil.replaceAll(po.getReplyContent(),(String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
        po.setContent(StringUtil.replaceAll(po.getReplyContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        // SMS 발송 여부 Y 일때 SMS 발송
        if ("Y".equals(po.getSmsSendYn())) {
            // sms 치환코드 set
            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            smsReplaceVO.setGoodsNm(po.getGoodsNm());
            smsReplaceVO.setMypageUrl(AdminConstants.MYPAGE_URL);

            // send 객체 set
            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            if ("inquiry".equals(so.getBbsId())) {
                smsSendSo.setSendTypeCd("20"); // ERD 발송 유형 코드 참조 ex)1:1문의 답변 코드 20
                smsSendSo.setMemberTemplateCode("mk039");
            } else if ("question".equals(so.getBbsId())) {
                smsSendSo.setSendTypeCd("16"); // ERD 발송 유형 코드 참조 ex)1:1문의 답변 코드
                smsSendSo.setMemberTemplateCode("mk037");
            } else if ("sellQuestion".equals(so.getBbsId())) {
                smsSendSo.setSendTypeCd("40");
                smsSendSo.setSellerTemplateCode("mk053");
            }
            smsSendSo.setMemberNo(po.getMemberNo());
            smsSendSo.setSellerNo(po.getSellerNo());

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);
        }
        // EMAIL 발송 여부 Y 일때 EMAIL 발송
        if ("Y".equals(po.getEmailSendYn())) {
            String receiverId = "";
            String receiverNm = "";
            long receiverNo = 0L;
            String receiverEmail = "";
            String memberEmailRecvYn = "";

            // 1:1 문의 답변일 때 통과함
            if(vo.getMemberNo() != null && !vo.getMemberNo().equals("")) {
                MemberManageVO memberVO = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "viewMemInfoDtl", po);
                receiverId = memberVO.getLoginId();
                receiverNm = memberVO.getMemberNm();
                receiverNo = memberVO.getMemberNo();
                receiverEmail = memberVO.getEmail();
                memberEmailRecvYn = memberVO.getEmailRecvYn();
            }
            // 판매자 문의 답변일 때 통과함
            if(vo.getSellerNo() != null && vo.getSellerNo().equals("")) {
                SellerVO sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", po);
                receiverId = sellerVO.getSellerId();
                receiverNm = sellerVO.getSellerNm();
                receiverNo = Long.parseLong(sellerVO.getSellerNo());
                receiverEmail = sellerVO.getManagerEmail();
            }

            /* 변경할 치환 코드 설정 */
            ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
            emailReplaceVO.setInqueryTitle(vo.getTitle());
            emailReplaceVO.setInqueryContent(vo.getContent());
            emailReplaceVO.setInqueryRegrDtm(df.format(vo.getRegDttm()));
            emailReplaceVO.setInqueryReplyTitle(po.getTitle());
            emailReplaceVO.setInqueryReplyContent(po.getContent());
            emailReplaceVO.setInqueryReplyRegrDtm(df.format(today));
            emailReplaceVO.setMemberNm(receiverNm);

            emailReplaceVO.setShopName(siteVO.getSiteNm());
            emailReplaceVO.setCustCtEmail(siteVO.getCustCtEmail());
            emailReplaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
            // 23.05.25 test server domain
            emailReplaceVO.setDlgtDomain("devnewmarket.fittingmonster.com");
//            emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteVO.getDlgtDomain()));
            emailReplaceVO.setLogoPath(siteVO.getLogoPath());

            /* 이메일 자동 발송 기본 설정 */
            EmailSendSO emailSendSo = new EmailSendSO();
            emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            /* 이메일 자동 발송 기본 설정 */
            if ("inquiry".equals(so.getBbsId())) {
                emailSendSo.setMailTypeCd("23"); // ERD 메일 유형 코드 참조 ex)1:1문의 답변
            } else if ("question".equals(so.getBbsId())) {
                emailSendSo.setMailTypeCd("19"); // ERD 메일 유형 코드 참조 ex)1:1문의 답변
            } else if ("sellQuestion".equals(so.getBbsId())) {
                emailSendSo.setMailTypeCd("35");
            }
            emailSendSo.setReceiverId(receiverId);
            emailSendSo.setReceiverNo(receiverNo);
            emailSendSo.setReceiverNm(receiverNm);
            emailSendSo.setReceiverEmail(receiverEmail);

            if(!memberEmailRecvYn.equals("N")) {
                emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);
            }
        }

        // 게시글 답변 수정
        proxyDao.update(getLettXmlName(po.getBbsId()) + "updateBbsLett", po);
        // 게시글 답변 파일 등록
        insertCmnAtchFile(po, po.getLettNo(), getLettDbName(po.getBbsId()));

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> deleteBbsReply(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시글 답변 삭제 여부 변경
        proxyDao.update(getLettXmlName(po.getBbsId()) + "deleteBbsLettReply", po);
        
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BbsCmntManageVO> selectBbsCmntList(BbsCmntManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        // 게시글 댓글 리스트 조회
        return proxyDao.selectListPage(MapperConstants.BBS_STYLE_LETT + "selectBbsCmntList", so);
    }

    @Override
    public ResultModel<BbsCmntManagePO> insertBbsComment(BbsCmntManagePO po) throws Exception {
        ResultModel<BbsCmntManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        try {
            // 게시글 댓글 정보 등록
            proxyDao.insert(MapperConstants.BBS_CMNT + "insertBbsComment", po);
            result.setMessage(MessageUtil.getMessage("biz.exception.operation.cmnt.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<BbsCmntManagePO> deleteBbsComment(BbsCmntManagePO po) throws Exception {
        ResultModel<BbsCmntManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }
        try {
            // 게시글 댓글 삭제
            proxyDao.delete(MapperConstants.BBS_STYLE_LETT + "deleteBbsComment", po);
            result.setMessage(MessageUtil.getMessage("biz.exception.operation.cmnt.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BbsManageVO> selectBbsTitleList(BbsManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        // 게시판 타이틀 리스트 조회
        return proxyDao.selectListPage(MapperConstants.BBS_TITLE + "selectBbsTitleList", so);
    }

    @Override
    public ResultModel<BbsManagePO> insertBbsTitle(BbsManagePO po) throws Exception {
        ResultModel<BbsManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시판 타이틀 리스트 등록
        if (po.getTitleNmArr() != null || po.getTitleNmArr().length != 0) {
            BbsTitleManagePO titlePo = new BbsTitleManagePO();
            titlePo.setBbsId(po.getBbsId());
            titlePo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            titlePo.setTitleNmArr(po.getTitleNmArr());

            String[] titleNmArr = po.getTitleNmArr();
            for (int i = 0; i < titleNmArr.length; i++) {
                po.setTitleNm(titleNmArr[i]);
                proxyDao.insert(MapperConstants.BBS_TITLE + "insertBbsTitle", po);
                result.setMessage(MessageUtil.getMessage("biz.common.insert"));
            }
        }
        return result;
    }

    @Override
    public ResultModel<BbsTitleManagePO> deleteBbsTitle(BbsTitleManagePO po) throws Exception {
        ResultModel<BbsTitleManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        try {
            // 게시판 타이틀 삭제 여부 변경
            proxyDao.update(MapperConstants.BBS_TITLE + "deleteBbsTitle", po);
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BbsLettManageVO> goodsBbsInfo(BbsLettManageSO so) throws Exception {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        BbsLettManageVO vo = proxyDao.selectOne(MapperConstants.BBS_GOODS_LETT + "goodsBbsInfo", so);
        ResultModel<BbsLettManageVO> result = new ResultModel<BbsLettManageVO>(vo);
        result.setData(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public String selectBbsLettLvl(BbsLettManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        String result = "";
        String lvl = proxyDao.selectOne(getLettXmlName(so.getBbsId()) + "selectBbsLettLvl", so);
        // 게시글 레벨 정보 셋팅
        if (StringUtils.equals("", so.getLettLvl()) || so.getLettLvl() == null) {
            result = so.getLettLvl() + lvl;
        } else {
            result = so.getLettLvl() + '-' + lvl;
        }
        return result;
    }

    @Override
    public ResultModel<BbsLettManagePO> updateInqCnt(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시글 조회수 수정
        proxyDao.update(getLettXmlName(po.getBbsId()) + "updateInqCnt", po);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BbsLettManageVO> nextBbsLettNo(BbsLettManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // nextBbsLettNo 정보 조회
        BbsLettManageVO vo = proxyDao.selectOne(getLettXmlName(so.getBbsId()) + "nextBbsLettNo", so);
        ResultModel<BbsLettManageVO> result = new ResultModel<BbsLettManageVO>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BbsLettManageVO> preBbsLettNo(BbsLettManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // preBbsLettNo 정보 조회
        BbsLettManageVO vo = proxyDao.selectOne(getLettXmlName(so.getBbsId()) + "preBbsLettNo", so);
        ResultModel<BbsLettManageVO> result = new ResultModel<BbsLettManageVO>(vo);
        return result;
    }

    @Override
    public String getLettXmlName(String bbsId) {
        // 게시글 종류 xml 조회
        String xmlMapperName = "";
        if (bbsId.equals("inquiry") || bbsId.equals("sellQuestion")) {
            xmlMapperName = MapperConstants.BBS_INQUIRY_LETT;
        } else if (bbsId.equals("review") || bbsId.equals("question")) {
            xmlMapperName = MapperConstants.BBS_GOODS_LETT;
        } else if (bbsId.equals("faq")) {
            xmlMapperName = MapperConstants.BBS_FAQ_LETT;
        } else if (bbsId.equals("vote") || bbsId.equals("pick") || bbsId.equals("collection")) {
            xmlMapperName = MapperConstants.BBS_STYLE_LETT;
        } else {
            xmlMapperName = MapperConstants.BBS_LETT;
        }

        return xmlMapperName;
    }

    @Override
    public String getLettDbName(String bbsId) {
        // 게시글 종류 db테이블 조회
        String mapperName = "";
        if (bbsId.equals("inquiry") || bbsId.equals("sellQuestion")) {
            mapperName = "TB_MTM_INQUIRY_BBS_LETT";
        } else if (bbsId.equals("review") || bbsId.equals("question")) {
            mapperName = "TB_GOODS_BBS_LETT";
        } else if (bbsId.equals("faq")) {
            mapperName = "TB_FAQ";
        } else if (bbsId.equals("vote") || bbsId.equals("pick") || bbsId.equals("collection")) {
            mapperName = "TB_STYLE_BBS_LETT";
        } else {
            mapperName = "TB_BBS_LETT";
        }

        return mapperName;
    }

    @Override
    public ResultModel<AtchFilePO> insertCmnAtchFile(EditorBasePO<? extends EditorBasePO> po, String refNo,
            String fileGb) throws Exception {
        ResultModel<AtchFilePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시글 에디터 단건 파일 등록
        try {
            editorService.setEditorImageToService(po, refNo, fileGb);
            FileUtil.setEditorImageList(po, fileGb, po.getAttachImages()); // tempFileName

            for (CmnAtchFilePO p : po.getAttachImages()) {
                if (p.getTemp()) {
                    p.setFileGb(fileGb);
                    p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                    editorService.insertCmnAtchFile(p);
                }
            }
            // 임시 경로의 이미지 삭제
            FileUtil.deleteEditorTempImageList(po.getAttachImages());

            result.setMessage("success");
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "파일 정보" }, e);
        }
        return result;
    }

    private ResultModel<AtchFilePO> insertCmnAtchFile(MultiEditorBasePO<? extends MultiEditorBasePO> po, String refNo,
            String[] fileGbArray) throws Exception {
        ResultModel<AtchFilePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        int index = 0;
        List<CmnAtchFilePO> list;
        // 게시글 에디터 여러 파일 등록
        try {
            editorService.setEditorImageToService(po, refNo, fileGbArray);
            if (po.getAttachImages().size() > 0) {
                for (String fileGb : fileGbArray) {
                    list = po.getAttachImages().get(index);
                    FileUtil.setEditorImageList(po, fileGb, list); // tempFileName

                    for (CmnAtchFilePO p : list) {
                        if (p.getTemp()) {
                            p.setFileGb(fileGb);
                            p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                            editorService.insertCmnAtchFile(p);
                        }
                    }
                    // 임시 경로의 이미지 삭제
                    FileUtil.deleteEditorTempImageList(list);
                    if (po.getAttachImages().size() == 1) {
                        break;
                    } else {
                        index++;
                    }
                }
            }
            result.setMessage("success");
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "파일 정보" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<AtchFilePO> insertAtchFile(HttpServletRequest request, BbsLettManagePO po) throws Exception {
        String filePath = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_BBS;
        List<FileVO> fileList = getFileListFromRequest(request, filePath, po.getImgYn());
        ResultModel<AtchFilePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        int i = 0;
        // 게시글 첨부 파일 등록
        if (fileList != null) {
            try {
                for (FileVO p : fileList) {

                    AtchFilePO filePo = new AtchFilePO();
                    filePo.setBbsId(po.getBbsId());
                    filePo.setSiteNo(po.getSiteNo());
                    filePo.setLettNo(po.getLettNo());
                    filePo.setFileGb(getLettDbName(po.getBbsId()));
                    filePo.setFilePath(p.getFilePath());
                    filePo.setOrgFileNm(p.getFileOrgName());
                    filePo.setFileNm(p.getFileName());
                    filePo.setExtsn(p.getFileExtension());
                    filePo.setFileSize(p.getFileSize());
                    filePo.setRegrNo(po.getRegrNo());
                    if (StringUtil.nvl(po.getImgYn(), "N").equals("Y") && i == 0) {
                        filePo.setImgYn(po.getImgYn());
                    } else {
                        filePo.setImgYn("N");
                    }
                    filePo.setDlgtImgYn(StringUtil.nvl(p.getDlgtImgYn(), "N"));
                    proxyDao.insert(MapperConstants.BBS_ATCH_FILE + "insertAtchFile", filePo);
                    i++;
                }
                result.setMessage("success");
            } catch (DuplicateKeyException e) {
                throw new CustomException("biz.exception.common.exist", new Object[] { "파일 정보" }, e);
            }
        } else {
            result.setMessage("success");
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public FileVO selectAtchFileDtl(AtchFilePO po) throws Exception {
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 게시글 첨부 파일 조회
        FileVO vo = proxyDao.selectOne(MapperConstants.BBS_ATCH_FILE + "selectAtchFileDtl", po);

        vo.setFilePath(SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_BBS + File.separator
                + vo.getFilePath() + File.separator + vo.getFileName());

        return vo;
    }

    @Override
    public ResultModel<AtchFilePO> deleteAtchFile(AtchFilePO po) throws Exception {
        ResultModel<AtchFilePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        FileVO vo = proxyDao.selectOne(MapperConstants.BBS_ATCH_FILE + "selectAtchFileDtl", po);
        String fileNm = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_BBS + File.separator
                + vo.getFilePath() + File.separator + vo.getFileName();

        File file = new File(fileNm);
        file.delete();

        if ("Y".equals(vo.getImgYn())) {
            File file2 = new File(fileNm + "_" + UploadConstants.BBS_IMG_SIZE_TYPE);
            file2.delete();
        }
        // 게시글 파일 정보 삭제
        try {
            proxyDao.update(MapperConstants.BBS_ATCH_FILE + "deleteAtchFile", po);
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    public List<FileVO> getFileListFromRequest(HttpServletRequest request, String targetPath, String gb) {
        // 다중 파일 정보 조회
        MultipartHttpServletRequest mRequest;
        if (request instanceof MultipartHttpServletRequest) {
            mRequest = (MultipartHttpServletRequest) request;
        } else {
            return null;
        }

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        Iterator<String> fileIter = mRequest.getFileNames();
        List<FileVO> fileVOList = new ArrayList<>();
        String fileOrgName;
        String extension;
        String fileName;
        File file;
        String path;
        List<MultipartFile> files;
        FileVO fileVO;
        ImageInfoData imageInfoData;
        String fieldName;

        try {
            int index = 0;
            while (fileIter.hasNext()) {
                fieldName = fileIter.next();
                files = mRequest.getMultiFileMap().get(fieldName);
                for (MultipartFile mFile : files) {
                    if (!"".equals(mFile.getOriginalFilename())) {
                        fileOrgName = mFile.getOriginalFilename();
                        extension = FilenameUtils.getExtension(fileOrgName);

                        fileName = System.currentTimeMillis() + "_" + fieldName.charAt(fieldName.length() - 1);
                        path = File.separator + FileUtil.getNowdatePath();
                        file = new File(targetPath + path + File.separator + fileName);

                        if (!file.getParentFile().exists()) {
                            file.getParentFile().mkdirs();
                        }

                        log.debug("원본파일 : {}", mFile);
                        log.debug("대상파일 : {}", file);
                        mFile.transferTo(file);

                        if ("Y".equals(gb) && index == 0) {
                            index++;
                            imageInfoData = new ImageInfoData();
                            imageInfoData.setImageType(ImageType.EDITOR_IMAGE_BBS);
                            imageInfoData.setOrgImgPath(file.getAbsolutePath());
                            imageHandler.job(imageInfoData);
                        }
                        fileVO = new FileVO();
                        fileVO.setFileExtension(extension);
                        fileVO.setFileOrgName(fileOrgName);
                        fileVO.setFileSize(mFile.getSize());
                        fileVO.setFileType(mFile.getContentType());
                        fileVO.setFilePath(path);
                        fileVO.setFileName(fileName);
                        if(fieldName.equals("file0")) {
                            fileVO.setDlgtImgYn("Y");
                        }
                        fileVOList.add(fileVO);
                    }
                }
            }

        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }

        return fileVOList;
    }

    @Override
    public int fileSizeCheck(HttpServletRequest request) {
        // 다중 파일 정보 조회
        MultipartHttpServletRequest mRequest;
        if (request instanceof MultipartHttpServletRequest) {
            mRequest = (MultipartHttpServletRequest) request;
        } else {
            return 0;
        }

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        Iterator<String> fileIter = mRequest.getFileNames();
        List<MultipartFile> files;
        int fileSize = 0;
        try {
            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {
                    if (!"".equals(mFile.getOriginalFilename())) {
                        String filePath = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_BBS;
                        String fileName = System.currentTimeMillis() + "";
                        String path = File.separator + FileUtil.getNowdatePath();
                        File file = new File(filePath + path + File.separator + fileName);

                        if (!file.getParentFile().exists()) {
                            file.getParentFile().mkdirs();
                        }
                        mFile.transferTo(file);

                        fileSize = (int) mFile.getSize();
                        file.delete();
                    }
                }
            }

        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return fileSize;
    }
    
    @Override
    public BbsLettManageVO getSvmnPay(BbsLettManagePO po) {
        return proxyDao.selectOne(getLettXmlName(po.getBbsId()) + "selectSvmnPay", po);
    }

    public void insertLettGoods(BbsLettManagePO po) throws Exception {
        for(String recommendNo : po.getRecommendNo()) {
            BbsLettManagePO temp = new BbsLettManagePO();
            temp.setLettNo(po.getLettNo());
            temp.setGoodsNo(recommendNo);
            temp.setRegrNo(po.getRegrNo());
            proxyDao.insert(MapperConstants.BBS_STYLE_LETT + "insertBbsGoods", temp);
        }
    }

    @Override
    public String selectNewLettNo(String bbsId) {
        return (String) proxyDao.selectOne(getLettXmlName(bbsId) + "selectNewLettNo");
    }
}
