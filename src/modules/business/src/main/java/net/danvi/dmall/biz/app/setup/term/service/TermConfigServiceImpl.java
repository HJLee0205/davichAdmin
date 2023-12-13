package net.danvi.dmall.biz.app.setup.term.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.dao.ProxyErpDao;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.*;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigListVO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigPO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("termConfigService")
@Transactional(rollbackFor = Exception.class)
public class TermConfigServiceImpl extends BaseService implements TermConfigService {

    @Value("#{system['system.upload.path']}")
    private String uploadPath;

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    @Resource(name = "proxyErpDao")
    private ProxyErpDao proxyErpDao;

    @Resource(name = "bizService")
    private BizService bizService;

    /** 약관 개인정보 설정 정보 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see TermConfigService#
     * selectTermConfigList(net.danvi.dmall.biz.app.setup.term.model.
     * TermConfigSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<TermConfigListVO> selectTermConfigList(TermConfigSO so) {
        return proxyDao.selectListPage(MapperConstants.SETUP_TERM_CONFIG + "selectTermConfigListPaging", so);
    }

    /** 약관 개인정보 설정 정보 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see TermConfigService#
     * selectTermConfig(TermConfigSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<TermConfigVO> selectTermConfig(TermConfigSO so) throws Exception{
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        TermConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_TERM_CONFIG + "selectTermConfig", so);

        if(resultVO!=null) {
            resultVO.setContent(StringUtil.replaceAll(resultVO.getContent(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
            //치환자 처리...
            Map m = new HashMap();
            SiteSO siteSO = new SiteSO();
            siteSO.setSiteNo(so.getSiteNo());
            SiteVO svo = cacheService.selectBasicInfo(siteSO);
            m.put("site_info", svo);
            resultVO.setContent(TextReplacerUtil.replace(m, resultVO.getContent()));
        }
        ResultModel<TermConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 약관 개인정보 설정 정보 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see TermConfigService#
     * selectTermConfig(TermConfigSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<TermConfigVO> selectDefaultTermConfig(TermConfigSO so) {
        ClassPathResource resource = new ClassPathResource("terms/" + so.getSiteInfoCd().trim() + ".txt");
        TermConfigVO resultVO = new TermConfigVO();
        resultVO.setSiteNo(so.getSiteNo());
        resultVO.setSiteInfoCd(so.getSiteInfoCd());
        try {
            resultVO.setContent(FileUtil.readFile(resource.getFile()));

        } catch (IOException e) {
            throw new CustomException("biz.exception.setup.loadTerm", new Object[] {}, e);
        }

        ResultModel<TermConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 약관 개인정보 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see TermConfigService#
     * updateTermConfig(TermConfigPO)
     */
    @Override
    public ResultModel<TermConfigPO> updateTermConfig(TermConfigPO po) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<TermConfigPO> resultModel = new ResultModel<>();

        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        String refNo = po.getSiteInfoCd();
        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, refNo, "COMPANY_INFO");
        // 에디터 내용의 업로드 이미지 정보 변경
        // log.debug("변경전 내용 : {}", po.getContent());
        po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        // log.debug("변경한 내용 : {}", po.getContent());
        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "COMPANY_INFO", po.getAttachImages());
        // log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}",
        // po.getAttachImages());
        po.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());

        po.setUpdrNo(memberNo);

        // 수정 실행
        System.out.println("updateTermConfig dbType = " + dbType);
        System.out.println("updateTermConfig Title = " + po.getTitle() + " BeforeTitle = " + po.getBeforeTitle() + " SiteInfoCd = " + po.getSiteInfoCd() + " SiteNo = " + po.getSiteNo() + " UseYn = " + po.getUseYn());
        if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
            proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTsSiteInfoTermConfig", po);
        }else{
        	proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTermConfig", po);
        }

        if ("04".equals(po.getSiteInfoCd())) {
            TermConfigPO po2 = new TermConfigPO();
            po2.setSiteInfoNo(po.getSiteInfoNo());
            po2.setSiteNo(po.getSiteNo());
            po2.setTitle(po.getTitle());
            po2.setUseYn(po.getUseYn());
            po2.setSiteInfoCd(po.getSiteInfoCdNoMember());

            po2.setContent(StringUtil.replaceAll(po.getContentNoMember(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));
            po2.setContent(StringUtil.replaceAll(po.getContentNoMember(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

            po2.setUpdrNo(memberNo);

            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTsSiteInfoTermConfig", po2);
            }else{
            	proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTermConfig", po2);
            }
        }

        if ("11".equals(po.getSiteInfoCd())) {
            TermConfigPO po3 = new TermConfigPO();
            po3.setSiteInfoNo(po.getSiteInfoNo());
            po3.setSiteNo(po.getSiteNo());
            po3.setTitle(po.getTitle());
            po3.setUseYn(po.getUseYn());
            po3.setSiteInfoCd(po.getSiteInfoCdExchange());

            po3.setContent(StringUtil.replaceAll(po.getContentExchange(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));
            po3.setContent(StringUtil.replaceAll(po.getContentExchange(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

            po3.setUpdrNo(memberNo);


            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTsSiteInfoTermConfig", po3);
            }else{
                proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTermConfig", po3);
            }

            po3.setSiteInfoCd(po.getSiteInfoCdRefund());

            po3.setContent(StringUtil.replaceAll(po.getContentRefund(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));
            po3.setContent(StringUtil.replaceAll(po.getContentRefund(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTsSiteInfoTermConfig", po3);
            }else{
                proxyDao.update(MapperConstants.SETUP_TERM_CONFIG + "updateTermConfig", po3);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 약관 개인정보 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see TermConfigService#
     * updateTermConfig(TermConfigPO)
     */
    @Override
    public ResultModel<TermConfigPO> insertTermConfig(TermConfigPO po) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<TermConfigPO> resultModel = new ResultModel<>();

        Long siteInfoNo = bizService.getSequence("SITE_INFO_NO", po.getSiteNo());
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        po.setSiteInfoNo(siteInfoNo);
        String refNo = po.getSiteInfoCd();
        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, refNo, "COMPANY_INFO");
        // 에디터 내용의 업로드 이미지 정보 변경
        // log.debug("변경전 내용 : {}", po.getContent());
        po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        // log.debug("변경한 내용 : {}", po.getContent());
        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "COMPANY_INFO", po.getAttachImages());
        log.info("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        po.setRegrNo(memberNo);
        // 수정 실행
        System.out.println("updateTermConfig dbType = " + dbType);
        System.out.println("updateTermConfig Title = " + po.getTitle() + " BeforeTitle = " + po.getBeforeTitle() + " SiteInfoCd = " + po.getSiteInfoCd() + " SiteNo = " + po.getSiteNo() + " UseYn = " + po.getUseYn());
        if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
            proxyDao.insert(MapperConstants.SETUP_TERM_CONFIG + "insertTsSiteInfoTermConfig", po);
        }

        if ("04".equals(po.getSiteInfoCd())) {
            TermConfigPO po2 = new TermConfigPO();
            po2.setSiteInfoNo(siteInfoNo);
            po2.setSiteNo(po.getSiteNo());
            po2.setTitle(po.getTitle());
            po2.setUseYn(po.getUseYn());
            po2.setSiteInfoCd(po.getSiteInfoCdNoMember());

            po2.setContent(StringUtil.replaceAll(po.getContentNoMember(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));
            po2.setContent(StringUtil.replaceAll(po.getContentNoMember(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

            po2.setRegrNo(memberNo);

            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                proxyDao.insert(MapperConstants.SETUP_TERM_CONFIG + "insertTsSiteInfoTermConfig", po2);
            }

        }

        if ("11".equals(po.getSiteInfoCd())) {
            TermConfigPO po3 = new TermConfigPO();
            po3.setSiteInfoNo(siteInfoNo);
            po3.setSiteNo(po.getSiteNo());
            po3.setUpSiteInfoNo(siteInfoNo);
            po3.setTitle(po.getTitle());
            po3.setUseYn(po.getUseYn());
            po3.setSiteInfoCd(po.getSiteInfoCdExchange());

            po3.setContent(StringUtil.replaceAll(po.getContentExchange(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));
            po3.setContent(StringUtil.replaceAll(po.getContentExchange(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

            po3.setRegrNo(memberNo);

            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                proxyDao.insert(MapperConstants.SETUP_TERM_CONFIG + "insertTsSiteInfoTermConfig", po3);
            }

            po3.setSiteInfoCd(po.getSiteInfoCdRefund());

            po3.setContent(StringUtil.replaceAll(po.getContentRefund(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN), ""));
            po3.setContent(StringUtil.replaceAll(po.getContentRefund(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));

            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                proxyDao.insert(MapperConstants.SETUP_TERM_CONFIG + "insertTsSiteInfoTermConfig", po3);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());
        
        resultModel.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return resultModel;
    }

     @Override
    @Transactional(readOnly = true)
    public int selectTermApplyInfo(TermConfigSO so) throws Exception{


        int cnt = proxyDao.selectOne(MapperConstants.SETUP_TERM_CONFIG + "selectTermApplyInfo", so);


        return cnt;
    }


   /** 약관동의 사인 이미지 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see TermConfigService#
     * selectTermConfig(TermConfigSO)
     */
    @Override
    @Transactional(readOnly = true)
    public TermConfigVO selectTermApplySingInfo(TermConfigSO so) throws Exception{
        TermConfigVO resultVO = proxyErpDao.selectOne(MapperConstants.SETUP_TERM_CONFIG + "selectTermApplySingInfo", so);
        return resultVO;
    }

    /**
     * <pre>
     * 작성일 : 2022. 09. 22.
     * 작성자 : slims
     * 설명   : 약관/개인정보 설정 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 09. 22. slims - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public ResultModel<TermConfigPO> deleteTermConfig(TermConfigPO po) {
        ResultModel<TermConfigPO> result = new ResultModel<>();

        proxyDao.delete(MapperConstants.SETUP_TERM_CONFIG + "deleteTsSiteInfoTermConfig", po);

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        return result;
    }
}
