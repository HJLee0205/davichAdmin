package net.danvi.dmall.biz.common.service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.*;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.image.ImageType;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-05-25.
 */
@Slf4j
@Service("editorService")
@Transactional(rollbackFor = Exception.class)
public class EditorServiceImpl extends BaseService implements EditorService {

    @Value("#{system['system.upload.path']}")
    private String uploadPath;

    @Autowired
    private SiteService siteService;

    @Override
    @Transactional(readOnly = true)
    public List<CmnAtchFilePO> getCmnAtchFileList(CmnAtchFileSO so) {
        return proxyDao.selectList(MapperConstants.COMMON + "getCmnAtchFileList", so);
    }

    @Override
    public void insertCmnAtchFile(CmnAtchFilePO imagePO) {
        proxyDao.insert(MapperConstants.COMMON + "insertCmnAtchFile", imagePO);
    }

    @Override
    public void insertCmnAtchFileList(List<CmnAtchFilePO> imagePOList) {
        for (CmnAtchFilePO po : imagePOList) {
            proxyDao.insert(MapperConstants.COMMON + "insertCmnAtchFile", po);
        }
    }

    @Override
    public int deleteCmnAtchFileByFileNm(CmnAtchFilePO po) {
        return proxyDao.delete(MapperConstants.COMMON + "deleteCmnAtchFileByFileNm", po);
    }

    @Override
    public int deleteCmnAtchFileByFileNo(CmnAtchFilePO po) {
        return proxyDao.delete(MapperConstants.COMMON + "deleteCmnAtachFileByFileNo", po);
    }

    @Override
    public int deleteAllCmnAtchFile(CmnAtchFilePO po) {
        return proxyDao.delete(MapperConstants.COMMON + "deleteAllCmnAtchFile", po);
    }

    @Override
    @Transactional(readOnly = true)
    public void setCmnAtchFileToEditorVO(CmnAtchFileSO so, EditorBaseVO editorBaseVO) {
        // 이미지 디비 정보 조회
        List<CmnAtchFilePO> imageList = getCmnAtchFileList(so);

        // 디비에서 조회한 첨부 데이터를 에디터에서 사용하는 첨부파일 데이터로 변환
        List<EditorImageVO> editorImageVOList = new ArrayList<>();

        if(imageList.size() != 0) {
            for (CmnAtchFilePO image : imageList) {
                // 에디터 이미지 타입으로 세팅하면 경로와 파일명으로 이미지(+섬네일) URL 생성함
                image.setImageType(ImageType.EDITOR_IMAGE);
                editorImageVOList.add(new EditorImageVO(image));
            }

            editorBaseVO.setAttachImages(editorImageVOList);
        }
    }

    @Override
    public void setCmnAtchFileToEditorVO(List<CmnAtchFileSO> soList, MultiEditorBaseVO multiEditorBaseVO)
            throws Exception {
        List<List<EditorImageVO>> attachImageList = new ArrayList<>();
        List<CmnAtchFilePO> imageList;
        List<EditorImageVO> editorImageVOList;

        for (CmnAtchFileSO so : soList) {
            imageList = getCmnAtchFileList(so);

            editorImageVOList = new ArrayList<>();
            for (CmnAtchFilePO image : imageList) {
                // 에디터 이미지 타입으로 세팅하면 경로와 파일명으로 이미지(+섬네일) URL 생성함
                image.setImageType(ImageType.EDITOR_IMAGE);
                editorImageVOList.add(new EditorImageVO(image));
            }
            attachImageList.add(editorImageVOList);
        }

        multiEditorBaseVO.setAttachImages(attachImageList);
    }

    @Override
    public void setEditorImageToService(EditorBasePO<? extends EditorBasePO> editorBaseModel, String refNo,String fileGb) throws Exception {

        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        if(fileGb.equals("GOODS_MOBILE_CONT")){
            // 임시 경로의 이미지를 실제 서비스 경로로 복사
            FileUtil.copyEditorImageList(editorBaseModel.getMobileAttachImages());
            // 업로드 했다 에디터에서 삭제한 파일 삭제
            deleteEditorFile(refNo, fileGb, siteNo, editorBaseModel.getMobileDeletedImages());
        }
        // 임시 경로의 이미지를 실제 서비스 경로로 복사
        FileUtil.copyEditorImageList(editorBaseModel.getAttachImages());
        // 업로드 했다 에디터에서 삭제한 파일 삭제
        deleteEditorFile(refNo, fileGb, siteNo, editorBaseModel.getDeletedImages());
    }

    @Override
    public void setEditorImageToService(MultiEditorBasePO<? extends MultiEditorBasePO> multiEditorBaseModel,
            String refNo, String[] fileGbArray) throws Exception {
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        int index = 0;

        // 임시 경로의 이미지를 실제 서비스 경로로 복사
        for (List<CmnAtchFilePO> list : multiEditorBaseModel.getAttachImages()) {
            FileUtil.copyEditorImageList(list);
        }

        // 업로드 했다 에디터에서 삭제한 파일 삭제
        for (List<CmnAtchFilePO> list : multiEditorBaseModel.getDeletedImages()) {
            deleteEditorFile(refNo, fileGbArray[index], siteNo, list);
            index++;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 에디터의 임시 파일 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param refNo
     * @param fileGb
     * @param siteNo
     * @param list
     * @throws Exception
     */
    private void deleteEditorFile(String refNo, String fileGb, Long siteNo, List<CmnAtchFilePO> list) throws Exception {
        for (CmnAtchFilePO p : list) {
            if (p.getTemp()) { // 저장 등록한 이미지를 삭제
                FileUtil.deleteTempFile(p.getTempFileNm());
                FileUtil.deleteTempFile(p.getTempFileNm() + CommonConstants.IMAGE_THUMBNAIL_PREFIX);
            } else { // 수정시 이미 등록한 이미지를 삭제
                FileUtil.deleteEditorImage(p.getTempFileNm());
                FileUtil.deleteEditorImage(p.getTempFileNm() + CommonConstants.IMAGE_THUMBNAIL_PREFIX);
            }

            p.setSiteNo(siteNo);
            p.setRefNo(refNo);
            p.setFileGb(fileGb);
            p.setFileNm(p.getTempFileNm().substring(p.getTempFileNm().indexOf("_") + 1));
            deleteCmnAtchFileByFileNm(p);
        }
    }

    // @Override
    // public void deleteEditorTempImageList(String path, List<CmnAtchFilePO> list) throws Exception {
    // FileUtil.deleteEditorTempImageList(list);
    // }
    //
    // @Override
    // public void deleteMultiEditorTempImageList(String path, List<List<CmnAtchFilePO>> list) throws Exception {
    // FileUtil.deleteMultiEditorTempImageList(list);
    // }
}
