package net.danvi.dmall.biz.common.service;

import dmall.framework.common.model.*;

import java.util.List;

/**
 * Created by dong on 2016-05-25.
 */
public interface EditorService {
    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    List<CmnAtchFilePO> getCmnAtchFileList(CmnAtchFileSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 첨부 파일 하나 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param imagePO
     */
    void insertCmnAtchFile(CmnAtchFilePO imagePO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 첨부 파일 등록
     *          목록으로 받아서 한번에 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param imagePOList
     */
    void insertCmnAtchFileList(List<CmnAtchFilePO> imagePOList);

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 사이트 번호와 참조 번호, 파일 명 해당하는 첨부 파일 하나를 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public int deleteCmnAtchFileByFileNm(CmnAtchFilePO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 사이트 번호와 파일 번호에 해당하는 첨부 파일 하나를 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public int deleteCmnAtchFileByFileNo(CmnAtchFilePO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 사이트 번호와 참조 번호에 해당하는 첨부 파일을 모두 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public int deleteAllCmnAtchFile(CmnAtchFilePO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : 사이트 번호와 참조 번호에 해당하는 첨부 파일을 모두 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param so
     *            공통 첨부 파일 조회 조건 SO
     * @param editorBaseVO
     *            공통 첨부 파일 정보를 세팅할 VO
     * @return
     */
    public void setCmnAtchFileToEditorVO(CmnAtchFileSO so, EditorBaseVO editorBaseVO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 사이트 번호와 참조 번호에 해당하는 첨부 파일을 모두 삭제
     *          에디터가 복수개 있는 데이터 처리
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param soList
     * @param editorBaseVO
     * @throws Exception
     */
    public void setCmnAtchFileToEditorVO(List<CmnAtchFileSO> soList, MultiEditorBaseVO editorBaseVO) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : 임시 경로의 이미지를 서비스 경로로 복사하고, 에디터에서 삭제한 파일을 삭제한다.
     *          서비스 경로에는 사이트 번호를 붙이므로 targetPath에는 사이트 번호를 붙이지 않는다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @param editorBaseModel
     * @param refNo
     * @param fileGb
     * @throws Exception
     */
    public void setEditorImageToService(EditorBasePO<? extends EditorBasePO> editorBaseModel,
            String refNo, String fileGb) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param editorBaseModel
     * @param refNo
     * @param fileGbArray
     * @throws Exception
     */
    public void setEditorImageToService(MultiEditorBasePO<? extends MultiEditorBasePO> editorBaseModel,
            String refNo, String[] fileGbArray) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : dong
     * 설명   : 입력받은 경로의 이미지 삭제한다.
     *          서비스 경로에는 사이트 번호를 붙이므로 targetPath에는 사이트 번호를 붙이지 않는다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @param list
     *            삭제 파일 정보 목록
     * @throws Exception
     */
//    public void deleteEditorTempImageList(List<CmnAtchFilePO> list) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 입력받은 경로의 이미지 삭제한다.
     *          서비스 경로에는 사이트 번호를 붙이므로 targetPath에는 사이트 번호를 붙이지 않는다.
     *          다음 에디터가 복수개일 경우 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param list
     * @throws Exception
     */
//    public void deleteMultiEditorTempImageList(List<List<CmnAtchFilePO>> list) throws Exception;
}
