package net.danvi.dmall.biz.example.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.example.model.EditorVO;
import net.danvi.dmall.biz.example.model.MultiEditorPO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.example.model.EditorPO;
import net.danvi.dmall.biz.example.model.MultiEditorVO;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.StringUtil;

/**
 * Created by dong on 2016-05-25.
 */
@Service("editorExampleService")
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class EditorExampleServiceImpl implements EditorExampleService {

    @Value("#{system['system.upload.image.path']}")
    private String imageFilePath;

    @Value("#{system['system.upload.temp.image.path']}")
    private String tempImageFilePath;

    @Resource(name = "editorService")
    private EditorService editorService;

    @Override
    public ResultModel saveEditor(EditorPO po) throws Exception {
        ResultModel resultModel = new ResultModel();
        /**
         * po 에서 에디터에서 등록한 이미지를 가져와서 임시 테이블의 이미지를 실제 경로로 복사
         * po 에서 에디터에서 등록했지만 삭제된 이미지 삭제
         * po 에서 에디터의 내용중 "/admin/common/tempImage.do?" 문자열을 "/admin/common/image.do?" 로 모두 치환
         * po를 디비로 저장
         * 임시 이미지 파일 삭제
         * (여기선 편의를 위해 뷰단에 모델(PO)을 생성하였습니다.)
         */

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, "참조번호", "FILE_GB컬럼의 값"); // 맨 뒤의 참조 번호, 파일 구분값은 직접 세팅해주세요

        // 에디터 내용의 업로드 이미지 정보 변경
        log.debug("변경전 내용 : {}", po.getContent());
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,
                UploadConstants.IMAGE_EDITOR_URL));
        // TODO: PO에 따라 에디터가 여러개면 추가해주세요...
        log.debug("변경한 내용 : {}", po.getContent());

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "TEST", po.getAttachImages()); // tempFileName 에서 경로 정보를 빼서 fileName 에 세팅한다
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // TODO: PO에 대한 디비 저장... 구현해주세요..

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                // TODO: 참조 번호를 세팅해주세요
                p.setRefNo("1"); // 참조의 번호(게시판 번호, 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        return resultModel;
    }

    @Override
    public ResultModel saveMultiEditor(MultiEditorPO po) throws Exception {
        ResultModel resultModel = new ResultModel();
        /**
         * po 에서 에디터에서 등록한 이미지를 가져와서 임시 테이블의 이미지를 실제 경로로 복사
         * po 에서 에디터에서 등록했지만 삭제된 이미지 삭제
         * po 에서 에디터의 내용중 "/image/preview?" 문자열을 "/image/editor-image-view?" 로 모두 치환
         * po를 디비로 저장
         * 임시 이미지 파일 삭제
         */

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        // 화면의 에디터 수와 파일 구분 값의 갯수는 같아야 합니다.
        // 파일 구분 값은 테이블.컬럼명 등으로 정의합니다.
        editorService.setEditorImageToService(po, "참조 번호",
                new String[] { "TB_BBS.TOP_HTML_SET", "TB_BBS.BOTTOM_HTML_SET" });

        // 에디터 내용의 업로드 이미지 정보 변경
        log.debug("변경전 내용 : {}", po.getContent1());
        po.setContent1(StringUtil.replaceAll(po.getContent1(), UploadConstants.IMAGE_TEMP_EDITOR_URL,
                UploadConstants.IMAGE_EDITOR_URL));
        po.setContent2(StringUtil.replaceAll(po.getContent2(), UploadConstants.IMAGE_TEMP_EDITOR_URL,
                UploadConstants.IMAGE_EDITOR_URL));
        // TODO: PO에 따라 에디터가 더 있으면 추가해주세요...
        log.debug("변경한 내용 : {}", po.getContent1());

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "TB_BBS.TOP_HTML_SET", po.getAttachImages().get(0)); // tempFileName
        FileUtil.setEditorImageList(po, "TB_BBS.BOTTOM_HTML_SET", po.getAttachImages().get(1)); // tempFileName
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // TODO: PO에 대한 디비 저장... 구현해주세요..

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages().get(0)) {
            if (p.getTemp()) {
                p.setFileGb("TB_BBS.TOP_HTML_SET"); // 테이블명.컬럼명
                p.setRefNo("참조번호"); // 참조의 번호(게시판 번호, 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }
        }
        for (CmnAtchFilePO p : po.getAttachImages().get(1)) {
            if (p.getTemp()) {
                p.setFileGb("TB_BBS.BOTTOM_HTML_SET"); // 테이블명.컬럼명
                p.setRefNo("참조번호"); // 참조의 번호(게시판 번호, 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }
        }

        // 임시 경로의 이미지 삭제,
        // 단일 에디터는 deleteEditorTempImageList
        // 복수 에디터는 deleteMultiEditorTempImageList
        FileUtil.deleteMultiEditorTempImageList(po.getAttachImages());

        return resultModel;
    }

    @Override
    public ResultModel selectEditor(EditorVO vo) throws Exception {
        ResultModel<EditorVO> resultModel = new ResultModel<>();

        // TODO: 데이터 조회후 EditorBaseVO를 상속받아 만든 모델에 담기
        // 여기선 입력받은 VO에 그대로 담음

        // 이미지 디디 정보 조회 조건 세팅
        CmnAtchFileSO so = new CmnAtchFileSO();
        so.setSiteNo(1L);
        so.setRefNo("1");
        so.setFileGb("TEST");

        // 공통 첨부 파일 조회하여 VO에 담는다.
        editorService.setCmnAtchFileToEditorVO(so, vo);
        resultModel.setData(vo); // 잊

        return resultModel;
    }

    @Override
    public ResultModel selectMultiEditor(MultiEditorVO vo) throws Exception {
        ResultModel<MultiEditorVO> result = new ResultModel<>(vo);

        // 첨부파일 조회 조건 정보를 담을 목록
        List<CmnAtchFileSO> soList = new ArrayList<>();

        // 첫번째 에디터의 첨부파일 정보
        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(vo.getSiteNo());
        s.setRefNo("참조번호");
        s.setFileGb("TB_BBS.TOP_HTML_SET");
        soList.add(s);

        s = new CmnAtchFileSO();
        s.setSiteNo(vo.getSiteNo());
        s.setRefNo("참조번호");
        s.setFileGb("TB_BBS.BOTTOM_HTML_SET");
        soList.add(s);

        // 공통 첨부 파일 조회
        editorService.setCmnAtchFileToEditorVO(soList, vo);
        result.setData(vo);

        return result;
    }
}
