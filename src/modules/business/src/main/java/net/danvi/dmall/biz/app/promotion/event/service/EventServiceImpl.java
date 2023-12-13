package net.danvi.dmall.biz.app.promotion.event.service;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.*;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventSO;
import net.danvi.dmall.biz.common.service.EditorService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettVO;
import net.danvi.dmall.biz.app.promotion.event.model.EventPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventPOListWrapper;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 이벤트 서비스임플
 * </pre>
 */
@Slf4j
@Service("eventService")
@Transactional(rollbackFor = Exception.class)
public class EventServiceImpl extends BaseService implements EventService {

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    // 이벤트 목록 조회
    @Override
    public ResultListModel<EventVO> selectEventList(EventSO so) {
        List<EventVO> list = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectEventList", so);
        ResultListModel<EventVO> result = new ResultListModel<>();
        log.debug("=========== list : {}", list.toString());
        if (list == null || list.size() < 1) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        } else {
            result.setResultList(list);
        }

        return result;
    }

    // 이벤트 목록 조회 페이징
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<EventVO> selectEventListPaging(EventSO so) {
        return proxyDao.selectListPage(MapperConstants.PROMOTION_EVENT + "selectEventListPaging", so);
    }

    // 이벤트 등록
    @Override
    public ResultModel<EventPO> insertEvent(EventPO po, HttpServletRequest request) throws Exception {
        /*----------이미지 업로드 정보 start-----------*/
        List<FileVO> fileList = FileUtil.getFileListFromRequest(request, FileUtil.getPath(UploadConstants.PATH_EVENT));
        if(fileList != null) {
            for (FileVO fileVO : fileList) {
                po.setEventWebBannerImgPath(fileVO.getFilePath());
                po.setEventWebBannerImg(fileVO.getFileName());
                po.setDlgtImgOrgNm(fileVO.getFileOrgName());
            }
        }
        /*----------이미지 업로드 정보 end-----------*/

        /*----------이벤트 등록 start-----------*/
        ResultModel<EventPO> result = new ResultModel<>();

        // 이벤트 기간
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());
        // 당첨자 발표
        po.setEventWngDttm(po.getWngFrom() + " " + po.getWngFromHour() + ":" + po.getWngFromMinute());

        // 에디터 내용의 업로드 이미지 정보 변경
        log.debug("변경전 내용 : {}", po.getEventContentHtml());
        po.setEventContentHtml(StringUtil.replaceAll(po.getEventContentHtml(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setEventContentHtml(StringUtil.replaceAll(po.getEventContentHtml(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        log.debug("변경한 내용 : {}", po.getEventContentHtml());

        try {
            proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertEventInfo", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            e.printStackTrace();
            throw new CustomException("biz.exception.common.exist", new Object[] { "이벤트등록" }, e);
        } catch (Exception e){
            e.printStackTrace();
            throw new CustomException("이벤트 등록 중 오류가 발생하였습니다.", e);
        }
        /*----------이벤트 등록 end-----------*/

        /*----------에디터 처리 start-----------*/
        String refNo = String.valueOf(po.getEventNo());

        editorService.setEditorImageToService(po, refNo, "TP_EVENT");
        FileUtil.setEditorImageList(po, "TP_EVENT", po.getAttachImages());
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                p.setFileGb("TP_EVENT");
                editorService.insertCmnAtchFile(p);
            }
        }
        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());
        /*----------에디터 처리 end-----------*/

        return result;
    }

    // 이벤트 수정
    @Override
    public ResultModel<EventPO> updateEvent(EventPO po, HttpServletRequest request) throws Exception {
        /*---------------이미지 업로드 start-----------------*/
        EventSO so = new EventSO();
        so.setSiteNo(po.getSiteNo());
        so.setEventNo(po.getEventNo());
        so.setDelYn("N");

        EventVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectEventInfo", so);
        if (!po.getDlgtImgOrgNm().equals(vo.getDlgtImgOrgNm())) {
            String delFilePath = FileUtil.getPath(UploadConstants.PATH_EVENT) + vo.getEventWebBannerImgPath() + File.separator + vo.getEventWebBannerImg();
            File file = new File(delFilePath);
            file.delete();

            List<FileVO> fileList = FileUtil.getFileListFromRequest(request, FileUtil.getPath(UploadConstants.PATH_EVENT));
            if(fileList != null) {
                for (FileVO fileVO : fileList) {
                    po.setEventWebBannerImgPath(fileVO.getFilePath().replace("\\", "/"));
                    po.setEventWebBannerImg(fileVO.getFileName());
                    po.setDlgtImgOrgNm(fileVO.getFileOrgName());
                }
            }
        } else {
            po.setDlgtImgOrgNm("");
        }
        /*---------------이미지 업로드 end-----------------*/

        /*----------이벤트 등록 start-----------*/
        ResultModel<EventPO> result = new ResultModel<>();

        // 이벤트 기간
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());
        // 당첨자 발표
        po.setEventWngDttm(po.getWngFrom() + " " + po.getWngFromHour() + ":" + po.getWngFromMinute());

        // 에디터 내용의 업로드 이미지 정보 변경
        log.debug("변경전 내용 : {}", po.getEventContentHtml());
        po.setEventContentHtml(StringUtil.replaceAll(po.getEventContentHtml(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setEventContentHtml(StringUtil.replaceAll(po.getEventContentHtml(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        log.debug("변경한 내용 : {}", po.getEventContentHtml());

        try {
            proxyDao.update(MapperConstants.PROMOTION_EVENT + "updateEventInfo", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이벤트수정" }, e);
        } catch (Exception e){
            e.printStackTrace();
            throw new CustomException("이벤트 수정 중 오류가 발생하였습니다.", e);
        }
        /*----------이벤트 등록 end-----------*/

        /*----------에디터 처리 start-----------*/
        String refNo = String.valueOf(po.getEventNo());

        editorService.setEditorImageToService(po, refNo, "TP_EVENT");
        FileUtil.setEditorImageList(po, "TP_EVENT", po.getAttachImages());
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                p.setFileGb("TP_EVENT");
                editorService.insertCmnAtchFile(p);
            }
        }
        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());
        /*----------에디터 처리 end-----------*/

        return result;
    }

    // 이벤트 상세 조회(단건)
    @Override
    @Transactional(readOnly = true)
    public ResultModel<EventVO> selectEventInfo(EventSO so) throws Exception {
        EventVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectEventInfo", so);

        if (vo.getEventContentHtml() != null) {
            HttpServletRequest request = HttpUtil.getHttpServletRequest();
            vo.setEventContentHtml(StringUtil.replaceAll(vo.getEventContentHtml(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        }

        ResultModel<EventVO> result = new ResultModel<>();

        // 에디터 파일 조회
        CmnAtchFileSO cmnAtchFileSO = new CmnAtchFileSO();
        cmnAtchFileSO.setSiteNo(so.getSiteNo());
        cmnAtchFileSO.setRefNo(String.valueOf(vo.getEventNo()));
        cmnAtchFileSO.setFileGb("TP_EVENT");
        editorService.setCmnAtchFileToEditorVO(cmnAtchFileSO, vo);

        result.setData(vo);

        if (vo == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        }

        return result;
    }

    // 이벤트 삭제
    @Override
    public ResultModel<EventPO> deleteEvent(EventPOListWrapper wrapper) throws Exception {
        ResultModel<EventPO> result = new ResultModel<>();

        String deletePath = FileUtil.getPath(UploadConstants.PATH_EVENT);
        for (EventPO po : wrapper.getList()) {
            // 이벤트 당첨내용 삭제
            wrapper.setEventNo(po.getEventNo());
            proxyDao.delete(MapperConstants.PROMOTION_EVENT + "deleteWngContent", wrapper);

            // 이벤트 댓글/댓글이력 삭제
            String eventCmntUseYn = po.getEventCmntUseYn();
            if (eventCmntUseYn.equals("Y")) {
                proxyDao.delete(MapperConstants.PROMOTION_EVENT + "deleteEventLettHist", wrapper);
                proxyDao.delete(MapperConstants.PROMOTION_EVENT + "deleteEventLett", wrapper);
            }

            // 대표이미지 삭제
            EventSO so = new EventSO();
            so.setSiteNo(wrapper.getSiteNo());
            so.setEventNo(po.getEventNo());
            so.setDelYn("N");
            EventVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectEventInfo", so);
            File file = new File(deletePath + vo.getEventWebBannerImgPath() + File.separator + vo.getEventWebBannerImg());
            if(file.exists()) {
                file.delete();
            }
        }

        // 이벤트 삭제
        proxyDao.delete(MapperConstants.PROMOTION_EVENT + "deleteEventInfo", wrapper);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(wrapper.getSiteNo(), request.getServerName());*/

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    // 출석체크이벤트 등록
    @Override
    public ResultModel<EventPO> insertAttendanceCheck(EventPO po) throws CustomException {
        // 출석이벤트 조건 01:조건완성형, 02:추가지급형

        log.debug("eventCndtCd 확인 ::::::::::::::::::::::::::::::::::::: " + po.getEventCndtCd());

        if (po.getEventCndtCd().equals("01")) {
            po.setEventTotPartdtCndt(Integer.parseInt(po.getEventTotPartdtCndt01()));
        }
        if (po.getEventCndtCd().equals("02")) {
            po.setEventTotPartdtCndt(Integer.parseInt(po.getEventTotPartdtCndt02()));
        }

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 일 + 시 + 분 : 포인트유효기간코드가 기간이면
        if (po.getEventPointApplyCd().equals("01")) {
        	if(StringUtil.isNotEmpty(po.getPointFrom()) && StringUtil.isNotEmpty(po.getPointFromHour()) && StringUtil.isNotEmpty(po.getPointFromMinute())) {
        		po.setPointApplyStartDttm(po.getPointFrom() + " " + po.getPointFromHour() + ":" + po.getPointFromMinute());
        	}
            po.setPointApplyEndDttm(po.getPointTo() + " " + po.getPointToHoure() + ":" + po.getPointToMinute());
            po.setEventApplyIssueAfPeriod(0);
        }

        // null 설정 : 포인트유효기간코드가 적립일로부터 몇개월이면
        if (po.getEventPointApplyCd().equals("02")) {
            po.setPointApplyStartDttm(null);
            po.setPointApplyEndDttm(null);
        }

        ResultModel<EventPO> result = new ResultModel<>();
        try {
            proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertAttendanceCheck", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "출석 이벤트등록" }, e);
        } catch (Exception e) {
            throw new CustomException("출석 이벤트등록 중 오류가 발생하였습니다.", e);
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }

    // 출석체크이벤트 수정
    @Override
    public ResultModel<EventPO> updateAttendanceCheck(EventPO po) {
        // 출석이벤트 조건 01:조건완성형, 02:추가지급형

        log.debug("eventCndtCd 확인 ::::::::::::::::::::::::::::::::::::: " + po.getEventCndtCd());

        if (po.getEventCndtCd().equals("01")) {
            po.setEventTotPartdtCndt(Integer.parseInt(po.getEventTotPartdtCndt01()));
        }

        if (po.getEventCndtCd().equals("02")) {
            po.setEventTotPartdtCndt(Integer.parseInt(po.getEventTotPartdtCndt02()));
        }

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 일 + 시 + 분 : 포인트유효기간코드가 기간이면
        if (po.getEventPointApplyCd().equals("01")) {
        	if(StringUtil.isNotEmpty(po.getPointFrom()) && StringUtil.isNotEmpty(po.getPointFromHour()) && StringUtil.isNotEmpty(po.getPointFromMinute())) {
        		po.setPointApplyStartDttm(po.getPointFrom() + " " + po.getPointFromHour() + ":" + po.getPointFromMinute());
        	}
            po.setPointApplyEndDttm(po.getPointTo() + " " + po.getPointToHoure() + ":" + po.getPointToMinute());
            po.setEventApplyIssueAfPeriod(0);
        }

        // null 설정 : 포인트유효기간코드가 적립일로부터 몇개월이면
        if (po.getEventPointApplyCd().equals("02")) {
            po.setPointApplyStartDttm(null);
            po.setPointApplyEndDttm(null);
        }

        ResultModel<EventPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.PROMOTION_EVENT + "updateAttendanceCheckInfo", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "출석 이벤트등록" }, e);
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }

    // 이벤트 댓글목록 조회 페이징
    @Override
    public ResultListModel<EventLettVO> selectEventLettListPaging(EventLettSO so) {
        ResultListModel<EventLettVO> result = proxyDao.selectListPage(MapperConstants.PROMOTION_EVENT + "selectEventLettListPaging", so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 8.
     * 작성자 : KMS
     * 설명   : 출석체크 이벤트 중복 체크
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 8. KMS - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public int selectAttendanceEventLettCnt(EventLettSO so) {
        int cnt = 0;
        cnt = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectAttendanceEventLettCnt", so);
        return cnt;
    }

    // 이벤트댓글 블라인드 수정
    @Override
    public ResultModel<EventLettPO> updateEventCmntBlind(EventLettPO po) {
        ResultModel<EventLettPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.PROMOTION_EVENT + "updateEventCmntBlind", po);
            proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertEventCmntBlindHist", po);

            result.setData(po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이벤트댓글 블라인드 수정" }, e);
        }
        return result;
    }

    // 이벤트댓글 처리이력목록 조회
    @Override
    public List<EventLettVO> selectEventCmntProcHistList(EventLettSO so) {
        List<EventLettVO> result = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectEventCmntProcHistList", so);
        return result;
    }

    // 이벤트당첨 수정
    @Override
    public ResultModel<EventLettPO> updateEventWng(EventLettPO po) {
        ResultModel<EventLettPO> result = new ResultModel<>();

        try {
            proxyDao.update(MapperConstants.PROMOTION_EVENT + "updateEventWng", po);
            proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertEventWngHist", po);

            result.setData(po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이벤트당첨 수정" }, e);
        }
        return result;
    }

    // 이벤트당첨목록 조회 페이징
    @Override
    public ResultListModel<EventLettVO> selectEventWngListPaging(EventLettSO so) {
        ResultListModel<EventLettVO> result = proxyDao.selectListPage(MapperConstants.PROMOTION_EVENT + "selectEventWngListPaging", so);
        return result;
    }

    // 이벤트 당첨처리이력 조회
    @Override
    public List<EventLettVO> selectEventWngProcHistList(EventLettSO so) {
        List<EventLettVO> result = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectEventWngProcHistList", so);
        return result;
    }

    // 이벤트당첨내용 등록
    @Override
    public ResultModel<EventPO> insertWngContent(EventPO po) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        /*----------에디터 처리 start-----------*/
        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        String refNo = String.valueOf(po.getEventNo());
        editorService.setEditorImageToService(po, refNo, "TP_EVENT");

        // 에디터 내용의 업로드 이미지 정보 변경
        log.debug("변경전 내용 : {}", po.getWngContentHtml());
        po.setWngContentHtml(StringUtil.replaceAll(po.getWngContentHtml(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setWngContentHtml(StringUtil.replaceAll(po.getWngContentHtml(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        log.debug("변경한 내용 : {}", po.getWngContentHtml());

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "TP_EVENT", po.getAttachImages());
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        /*----------에디터 처리 end-----------*/
        ResultModel<EventPO> result = new ResultModel<EventPO>();
        proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertWngContent", po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    // 모든 이벤트 당첨내용목록을 조회(이벤트목록화면에서 ‘당첨내용등록’ 당첨내용수정’ 버튼을 결정)
    @Override
    public ResultListModel<EventVO> selectWngContentList(EventSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultListModel<EventVO> wngResult = new ResultListModel<EventVO>();

        List<EventVO> wngContentList = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectWngContentList");

        wngResult.put("wngContentList", wngContentList);

        // 첨부파일 조회 조건 세팅
        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(so.getSiteNo());
        EventVO eventVo = new EventVO();
        for (int i = 0; i < wngContentList.size(); i++) {
            eventVo = (EventVO) wngContentList.get(i);
            s.setRefNo(Integer.toString(wngContentList.get(i).getEventNo()));
            s.setFileGb("TP_EVENT_WNG_CONTENT.WNG_CONTENT_HTML");
            eventVo.setWngContentHtml(StringUtil.replaceAll(eventVo.getWngContentHtml(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
            // 공통 첨부 파일 조회
            editorService.setCmnAtchFileToEditorVO(s, wngContentList.get(i));
            wngResult.put("extra", wngContentList.get(i));
        }

        return wngResult;
    }

    // 당첨내용 수정
    @Override
    public ResultModel<EventPO> updateWngContent(EventPO po) throws Exception {
        /*----------에디터 처리 start-----------*/

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        String refNo = String.valueOf(po.getEventNo());
        editorService.setEditorImageToService(po, refNo, "TP_EVENT");

        // 에디터 내용의 업로드 이미지 정보 변경
        log.debug("변경전 내용 : {}", po.getWngContentHtml());
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        po.setWngContentHtml(StringUtil.replaceAll(po.getWngContentHtml(),(String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
        po.setWngContentHtml(StringUtil.replaceAll(po.getWngContentHtml(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        log.debug("변경한 내용 : {}", po.getWngContentHtml());

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "TP_EVENT", po.getAttachImages());
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        /*----------에디터 처리 end-----------*/

        ResultModel<EventPO> result = new ResultModel<EventPO>();
        proxyDao.update(MapperConstants.PROMOTION_EVENT + "updateWngContent", po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    // 다른 출석체크이벤트 시작일시와 종료일시를 조회(출석체크이벤트 중복방지)
    @Override
    public ResultListModel<EventVO> selectOtherEventDttm(EventSO so) {
        ResultListModel<EventVO> resultListModel = new ResultListModel<>();
        List<EventVO> list = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectOtherEventDttm", so);
        resultListModel.setResultList(list);
        return resultListModel;
    }
    
    public int insertImoticonInfo(EventLettPO po) throws Exception {
    	return proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertImoticonInfo", po);
    }

    @Override
    public ResultModel<EventVO> selectWngContent(EventPO po) {
        ResultModel<EventVO> result = new ResultModel<>();

        HttpServletRequest request = HttpUtil.getHttpServletRequest();

        EventVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectWngContent", po);
        if(vo != null) {
            vo.setWngContentHtml(StringUtil.replaceAll(vo.getWngContentHtml(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));

            CmnAtchFileSO s = new CmnAtchFileSO();
            s.setSiteNo(po.getSiteNo());
            s.setRefNo(String.valueOf(vo.getEventNo()));
            s.setFileGb("TP_EVENT");
            editorService.setCmnAtchFileToEditorVO(s, vo);

            result.setData(vo);
        }

        return result;
    }
}
