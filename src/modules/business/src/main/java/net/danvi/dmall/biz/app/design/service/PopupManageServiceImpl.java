package net.danvi.dmall.biz.app.design.service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.HttpUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.design.model.*;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

import java.io.File;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5 9.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("popupManageService")
@Transactional(rollbackFor = Exception.class)
public class PopupManageServiceImpl extends BaseService implements PopupManageService {
    @Value("#{system['system.upload.editor.image.path']}")
    private String imageFilePath;

    @Value("#{system['system.upload.editor.temp.image.path']}")
    private String tempImageFilePath;

/*    @Resource(name = "editorService")
    private EditorService editorService;*/

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<PopManageVO> selectPopManagePaging(PopManageSO so) {
        // 기본 정렬 처리 값 없을시
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        ResultListModel<PopManageVO>  list =  proxyDao.selectListPage("design.popupManage.selectPopManagePaging", so);
        log.info("list = "+list);
        // 팝업 리스트 페이징 처리
        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<PopManageVO> selectPopManage(PopManageSO so) throws Exception {
        //HttpServletRequest request = HttpUtil.getHttpServletRequest();
        // 팝업 상세 조회
        PopManageVO vo = proxyDao.selectOne("design.popupManage.selectPopManage", so);

        log.info("vo = "+vo);
        ResultModel<PopManageVO> result = new ResultModel<PopManageVO>(vo);
        /*vo.setContent(StringUtil.replaceAll(vo.getContent(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));


        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(so.getSiteNo());
        s.setRefNo("" + so.getPopupNo());
        s.setFileGb("TD_POPUP");

        // 공통 첨부 파일 조회
        editorService.setCmnAtchFileToEditorVO(s, vo);
        result.setData(vo);*/

        return result;
    }

    @Override
    public ResultModel<PopManagePO> insertPopManage(PopManagePO po) throws Exception {
        // 팝업 등록
        ResultModel<PopManagePO> result = new ResultModel<>();

        try {
            // 팝업 등록시 구분값 없을시 피씨로 지정
            if (po.getPcGbCd() == null || po.getPcGbCd().equals("")) {
                po.setPcGbCd("C");
            }

            // 팝업번호 시퀀시 조회
            Long popupNo = bizService.getSequence("POPUP", po.getSiteNo());

            po.setPopupNo(popupNo);

            /*// 에디터 플러스 공통 서비스 호출
            editorService.setEditorImageToService(po, "" + popupNo, "TD_POPUP");
            HttpServletRequest request = HttpUtil.getHttpServletRequest();
            po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
            po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

            // 공통 처리 이미지 리스트 처리
            FileUtil.setEditorImageList(po, "TD_POPUP", po.getAttachImages());

            // 공통 처리 이미지 정보 등록
            for (CmnAtchFilePO p : po.getAttachImages()) {
                p.setFileGb("TD_POPUP");
                p.setRefNo(po.getSiteNo() + "&&" + popupNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }

            // 임시 경로의 이미지 삭제
            FileUtil.deleteEditorTempImageList(po.getAttachImages());*/

            // 팝업 등록 데이터 처리
            proxyDao.insert("design.popupManage.insertPopManage", po);
            // 정상처리 메세지
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "팝업관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<PopManagePO> updatePopManage(PopManagePO po) throws Exception {
        ResultModel<PopManagePO> result = new ResultModel<>();
        // 팝업 수정
        try {
            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            PopManageVO voVal = new PopManageVO();
            if (po.getFileSize() != null && po.getFileSize() > 0) {
                // 데이터 조회
                voVal = proxyDao.selectOne("design.popupManage.selectPopManage", po);
            }
            /*// 에디터 플러스 공통 서비스 호출
            editorService.setEditorImageToService(po, "" + po.getPopupNo(), "TD_POPUP");
            HttpServletRequest request = HttpUtil.getHttpServletRequest();
            po.setContent(StringUtil.replaceAll(po.getContent(),  (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
            po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

            // 공통 처리 이미지 리스트 처리
            FileUtil.setEditorImageList(po, "TD_POPUP", po.getAttachImages());

            // 공통 처리 이미지 정보 등록
            for (CmnAtchFilePO p : po.getAttachImages()) {
                if (p.getTemp()) {
                    // 임시 파일이면 등록
                    p.setFileGb("TD_POPUP");
                    p.setRefNo("" + po.getPopupNo()); // 참조의 번호(게시판 번호, 팝업번호 등...)
                    editorService.insertCmnAtchFile(p);
                }
            }
            // 임시 경로의 이미지 삭제
            FileUtil.deleteEditorTempImageList(po.getAttachImages());*/

            // 팝업 수정 데이터 처리
            proxyDao.update("design.popupManage.updatePopManage", po);

            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            if (po.getFileSize() != null && po.getFileSize() > 0) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getFilePath())) && !"".equals(StringUtil.nvl(voVal.getFileNm()))) {
                    // 이미지 삭제
                    String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_POPUP);
                    File file = new File(deletePath + voVal.getFilePath() + File.separator + voVal.getFileNm());
                    if (file.exists()) { // 존재한다면 삭제
                        FileUtil.delete(file);
                    }
                }
            }

            // 정상처리 메세지 호출
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "팝업관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<PopManagePO> deletePopManage(PopManagePOListWrapper wrapper) throws Exception {
        ResultModel<PopManagePO> result = new ResultModel<>();
        // 팝업 삭제
        try {
            String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_POPUP);
            for (PopManagePO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                // 이미지 삭제
                File file = new File(deletePath + po.getFilePath() + File.separator + po.getFileNm());
                if (file.exists()) { // 존재한다면 삭제
                    FileUtil.delete(file);
                }
                if (po.getPcGbCd() == null || po.getPcGbCd().equals("")) {
                    po.setPcGbCd("C");
                }
                // 팝업 삭제
                proxyDao.delete("design.popupManage.deletePopManage", po);
            }

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "팝업관리" }, e);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : 팝업 에디터 이미지 파일 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    private void deletePopEditImage(PopManagePO po) throws Exception {
        /*CmnAtchFileSO cso = new CmnAtchFileSO();
        cso.setSiteNo(po.getSiteNo());
        cso.setRefNo(po.getSiteNo() + "&&"+po.getPopupNo());
        cso.setFileGb("TD_POPUP");
        List<CmnAtchFilePO> atchFileList = editorService.getCmnAtchFileList(cso);

        for (int i = 0; i < atchFileList.size(); i++) {
            CmnAtchFilePO tempPo = atchFileList.get(i);
            tempPo.setRefNo(po.getSiteNo() + "&&"+po.getPopupNo());
            tempPo.setSiteNo(po.getSiteNo());
            editorService.deleteAllCmnAtchFile(tempPo);
            FileUtil.deleteEditorImage(tempPo.getFilePath() + "_" + tempPo.getFileNm()); // 원본이미지
            FileUtil.deleteEditorImage(tempPo.getFilePath() + "_" + tempPo.getFileNm() + CommonConstants.IMAGE_THUMBNAIL_PREFIX); // 썸네일이미지
        }*/
    }

    @Override
    public ResultModel<PopManagePO> updatePopManageView(PopManagePOListWrapper wrapper) throws Exception {
        ResultModel<PopManagePO> result = new ResultModel<>();

        // 리스트 화면에서 전시 미전시 처리 loop
        for (PopManagePO po : wrapper.getList()) {
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            // 넘어온 값에 따라 전시/미전시 데이터 처리
            proxyDao.update("design.popupManage.updatePopManageView", po);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

}
