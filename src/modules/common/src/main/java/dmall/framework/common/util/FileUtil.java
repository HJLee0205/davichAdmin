package dmall.framework.common.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.DiskFullException;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.FileVO;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Slf4j
@Component("fileUtil")
public class FileUtil {

    private static String SERVER;

    /*@Value("#{system['system.server']}")
    private String _server;*/

    @PostConstruct
    public void init() {
        //SERVER = _server;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 파일 이동
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param orgFile
     * @param targetFile
     * @throws Exception
     */
    public static void move(File orgFile, File targetFile) throws Exception {
        if (targetFile.isFile()) {
            targetFile.delete();
        }
        copy(orgFile, targetFile);
        orgFile.delete();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 사이트의 이미지 경로로 파일을 이동
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param storeId
     * @param orgFilePath
     * @param targetFilePath
     * @throws Exception
     */
    // public static void move(String storeId, String orgFilePath, String
    // targetFilePath) throws Exception {
    // File orgFile = new File(orgFilePath);
    // File targetFile = new File(targetFilePath + File.separator + storeId +
    // File.separator + "img");
    //
    // if (targetFile.isFile()) {
    // targetFile.delete();
    // }
    //
    // copy(orgFile, targetFile);
    // orgFile.delete();
    // }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 파일 복사
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param orgFile
     * @param targetFile
     * @throws Exception
     */
    public static void copy(File orgFile, File targetFile) throws Exception {

        if (!targetFile.getParentFile().exists()) {
            targetFile.getParentFile().mkdirs();
        }

        try (FileInputStream inputStream = new FileInputStream(orgFile);
                FileOutputStream outputStream = new FileOutputStream(targetFile);
                FileChannel fcin = inputStream.getChannel();
                FileChannel fcout = outputStream.getChannel()) {

            long size = fcin.size();
            fcin.transferTo(0, size, fcout);
        } catch (Exception e) {
            log.error("파일 복사 오류", e);
            throw e;
        }
    }

    /**
     * 파일 삭제
     * 
     * @param targetFile
     *            : 대상 파일
     * @throws Exception
     */
    public static void delete(File targetFile) throws Exception {
        targetFile.delete();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 파일다운로드를 위해 파일을 읽어 HttpServletResponse 에 쓴다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     *
     * @param response
     * @param file
     * @throws IOException
     */
    public static void writeFileToResponse(HttpServletResponse response, File file) {

        if (!file.exists()) {
            log.warn("파일 {} 이 존재하지 않음", file);
            return;
        }

        try (OutputStream out = response.getOutputStream()) {
            Path path = file.toPath();
            Files.copy(path, out);
            out.flush();
        } catch (Exception e) {

            log.error("writeFileToResponse 에러", e);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   :리퀘스트에서 이름에 해당하는 엑셀파일을 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param mRequest
     * @param name
     * @return
     */
    public static MultipartFile getExcel(MultipartHttpServletRequest mRequest, String name) {
        MultipartFile mFile = mRequest.getFile(name);
        String fileOrgName = mFile.getOriginalFilename();
        String ext = FilenameUtils.getExtension(fileOrgName);

        String[] fileFilter = { "xls", "xlsx" };
        Long fileSize = (long) (2 * 1024 * 1024);

        Boolean checkExe = true;
        for (String ex : fileFilter) {
            if (ex.equalsIgnoreCase(ext)) {
                checkExe = false;
            }
        }

        if (checkExe) {
            throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
        }

        if (mFile.getSize() > fileSize) {
            throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
        }

        return mFile;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 에디터로 등록한 임시폴더의 이미지를 운영폴더로 복사한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param fileName
     *            파일명
     * @throws Exception
     */
    public static void copyEditorImage(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_EDITOR);
        File orgFile = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));
        File targetFile = new File(targetPath
                + FileUtil.getCombinedPath(FileUtil.getNowdatePath(), fileName.substring(fileName.indexOf("_") + 1)));
        log.debug("에디터로 등록한 이미지 파일을 임시경로에서 실제 서비스 경로로 복사 : {} -> {}", orgFile, targetFile);
        copy(orgFile, targetFile);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 에디터로 등록한 임시폴더의 이미지들을 운영폴더로 복사한다.
     *          섬네일 파일도 같이 복사한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @throws Exception
     */
    public static void copyEditorImageList(List<CmnAtchFilePO> list) throws Exception {
        if (list == null) return;

        for (CmnAtchFilePO imagePO : list) {
            // 임시파일이면
            if (imagePO.getTemp()) {
                copyEditorImage(imagePO.getTempFileNm());
                copyEditorImage(imagePO.getTempFileNm() + CommonConstants.IMAGE_THUMBNAIL_PREFIX);
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 임시경로의 상품이미지를 실제 운영 경로로 복사
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @throws Exception
     */
    public static void copyGoodsImage(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS);
        File orgFile = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));

        if (!orgFile.exists()) {
            log.debug("소스 파일 없음:{}", orgFile.getAbsolutePath());
            return;
        }
        File targetFile = new File(targetPath
                + FileUtil.getCombinedPath(FileUtil.getNowdatePath(), fileName.substring(fileName.indexOf("_") + 1)));
        log.debug("임시 경로의 이미지 파일을 실제 서비스 경로로 복사 : {} -> {}", orgFile, targetFile);
        copy(orgFile, targetFile);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 임시경로의 상품이미지를 실제 운영 경로로 복사
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @throws Exception
     */
    public static void copyGoodsItemImage(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS_ITEM);
        File orgFile = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));

        if (!orgFile.exists()) {
            log.info("소스 파일 없음:{}", orgFile.getAbsolutePath());
            return;
        }
        log.info("소스 파일 targetPath:{}", targetPath);
        File targetFile = new File(targetPath
                + FileUtil.getCombinedPath(FileUtil.getNowdatePath(), fileName.substring(fileName.indexOf("_") + 1)));
        log.info("임시 경로의 이미지 파일을 실제 서비스 경로로 복사 : {} -> {}", orgFile, targetFile);
        copy(orgFile, targetFile);
    }

    public static void copyGoodsImage(String fileName,String siteId) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath(siteId);
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS);
        File orgFile = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));

        if (!orgFile.exists()) {
            log.debug("소스 파일 없음:{}", orgFile.getAbsolutePath());
            return;
        }
        File targetFile = new File(targetPath
                + FileUtil.getCombinedPath(FileUtil.getNowdatePath(), fileName.substring(fileName.indexOf("_") + 1)));
        log.debug("임시 경로의 이미지 파일을 실제 서비스 경로로 복사 : {} -> {}", orgFile, targetFile);
        copy(orgFile, targetFile);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 임시경로의 상품이미지 목록을 실제 운영 경로로 복사
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param list
     * @throws Exception
     */
    public static void copyGoodsImageList(List<CmnAtchFilePO> list) throws Exception {
        if (list == null) return;

        for (CmnAtchFilePO imagePO : list) {
            // 임시파일이면
            if (imagePO.getTemp()) {
                copyGoodsImage(imagePO.getTempFileNm());
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 임시폴더의 이미지 파일을 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @throws Exception
     */
    public static void deleteTempFile(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        File file = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));
        log.debug("임시경로의 파일을 삭제: {}", file);
        delete(file);
    }

    public static void deleteTempFile(String fileName,String siteId) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath(siteId);
        File file = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));
        log.debug("임시경로의 파일을 삭제: {}", file);
        delete(file);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 에디터로 등록한 임시폴더의 이미지들을 삭제한다.
     *          섬네일 파일도 같이 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param list
     * @throws Exception
     */
    public static void deleteEditorTempImageList(List<CmnAtchFilePO> list) throws Exception {
        if (list == null) return;

        for (CmnAtchFilePO imagePO : list) {
            if (imagePO.getTemp()) {
                deleteTempFile(imagePO.getTempFileNm()); // 이미지 삭제
                // 섬네일 삭제
                deleteTempFile(imagePO.getTempFileNm() + CommonConstants.IMAGE_THUMBNAIL_PREFIX);
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 임시경로의 이미지 목록을 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param list
     * @throws Exception
     */
    public static void deleteTempImageList(List<CmnAtchFilePO> list) throws Exception {
        if (list == null) return;

        for (CmnAtchFilePO imagePO : list) {
            if (imagePO.getTemp()) {
                deleteTempFile(imagePO.getTempFileNm()); // 이미지 삭제
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 에디터로 등록한 임시폴더의 이미지들을 삭제한다.
     *          섬네일 파일도 같이 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param list
     * @throws Exception
     */
    public static void deleteMultiEditorTempImageList(List<List<CmnAtchFilePO>> list) throws Exception {
        if (list == null) return;

        for (List<CmnAtchFilePO> cmnAtchFilePOList : list) {
            if (cmnAtchFilePOList == null) continue;
            deleteEditorTempImageList(cmnAtchFilePOList);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 8.
     * 작성자 : dong
     * 설명   : 에디터로 등록한 이미지 파일을 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 8. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @throws Exception
     */
    public static void deleteEditorImage(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        File file = new File(path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_EDITOR,FileUtil.getDatePath(fileName)));
        log.debug("에디터로 등록한 이미지 파일을 삭제: {}", file);
        delete(file);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : model의 사이트번호, 등록자 정보와 fileGb를 CmnAtchFilePO에 추가하고, 
     *          임시파일명으로 파일 경로와 실제 파일명을 세팅한다.  
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param fileGb
     * @param rawImagePO
     */
    public static void setEditorImageList(BaseModel model, String fileGb, List<CmnAtchFilePO> rawImagePO) {
        String[] s;
        for (CmnAtchFilePO p : rawImagePO) {
            p.setSiteNo(model.getSiteNo());
            p.setFileGb(fileGb);
            p.setRegrNo(model.getRegrNo());
            s = p.getTempFileNm().split("_");
            p.setFilePath(s[0]);

            if (s.length == 3) {
                p.setFileNm(s[1] + "_" + s[2]);
            } else {
                p.setFileNm(s[1]);
            }
        }

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : MultipartHttpServletRequest 에서 첨부파일 정보를 추출하여 targetPath 에 파일을 생성하고
     *          파일 정보를 목록으로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest
     * @param targetPath
     *            파일이 복사될 경로
     * @return
     */
    public static List<FileVO> getFileListFromRequest(HttpServletRequest request, String targetPath) {
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

        try {

            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {

                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);

                    fileName = System.currentTimeMillis() + "." + extension;
                    path = File.separator + getNowdatePath();
                    file = new File(targetPath + path + File.separator + fileName);

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.info("원본파일 : {}", mFile);
                    log.info("대상파일 : {}", file);
                    mFile.transferTo(file);
                    fileVO = new FileVO();
                    fileVO.setFileExtension(extension);
                    fileVO.setFileOrgName(fileOrgName);
                    fileVO.setFileSize(mFile.getSize());
                    fileVO.setFileType(mFile.getContentType());
                    fileVO.setFilePath(path);
                    fileVO.setFileName(fileName);
                    fileVOList.add(fileVO);
                }
            }

        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            // 사이트별 파일 권한 처리
            //ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }

        return fileVOList;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명   : MultipartHttpServletRequest 에서 첨부파일 정보를 추출하여 targetPath 에 파일을 생성하고
     *          파일 정보를 목록으로 반환한다.
     *          getFileListFromRequest() 메소드와 다른 점은 날짜 디렉토리 생성을 안하고 원본파일명으로 저장함.
     *          동일파일 존재시 "_" + System.currentTimeMillis() 을 추가한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 19. dong - 최초생성
     * 2016. 10. 21  dong - dong 만 따로쓰는 업로드용 체크
     * </pre>
     *
     * @param request
     *            HttpServletRequest
     * @param targetPath
     *            파일이 복사될 경로
     * @return
     */
    public static List<FileVO> getFileListRequest(HttpServletRequest request, String targetPath) {
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
        String fileOrgNameFirst;
        String fileName;
        File file;
        List<MultipartFile> files;
        FileVO fileVO;
        String fileInfo;
        File f;
        File[] fileInfos;

        String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp", "zip" };
        Boolean checkExe;

        try {
            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {

                    fileOrgName = mFile.getOriginalFilename();
                    fileOrgNameFirst = FilenameUtils.getBaseName(fileOrgName);
                    extension = FilenameUtils.getExtension(fileOrgName);
                    fileName = System.currentTimeMillis() + "." + extension;
                    fileName = fileOrgName;

                    checkExe = true;

                    for (String ex : fileFilter) {
                        if (ex.equalsIgnoreCase(extension)) {
                            checkExe = false;
                        }
                    }

                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    fileInfo = targetPath;
                    f = new File(fileInfo);
                    fileInfos = f.listFiles();

                    if (fileInfos != null) {
                        for (int i = 0; i < fileInfos.length; i++) {
                            if (fileInfos[i].isDirectory()) {

                            } else {
                                if (fileInfos[i].getName().equals(fileOrgName)) {
                                    // log.debug(fileInfos[i].getName() +
                                    // "<=====================>" + fileOrgName);
                                    fileName = fileOrgNameFirst + "_" + System.currentTimeMillis() + "." + extension;
                                }
                            }
                        }
                    }

                    file = new File(targetPath + File.separator + fileName);

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);
                    mFile.transferTo(file);
                    fileVO = new FileVO();
                    fileVO.setFileExtension(extension);
                    fileVO.setFileOrgName(fileOrgName);
                    fileVO.setFileSize(mFile.getSize());
                    fileVO.setFileType(mFile.getContentType());
                    fileVO.setFileName(fileName);
                    fileVOList.add(fileVO);
                }
            }
        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return fileVOList;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 루트 경로에 사이트 아이디를 더한 경로를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param rootPath
     * @param siteId
     * @return
     */
    // public static String getSiteUplaodRootPath(String rootPath, String
    // siteId) {
    // StringBuilder path = new StringBuilder(rootPath);
    // path.append(File.separator).append(siteId);
    //
    // return path.toString();
    // }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 사이트 업로드 루트 경로에 추가 경로 정보를 더한 경로를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param directories
     * @return
     */
    public static String getPath(String... directories) {
        StringBuilder path = new StringBuilder(SiteUtil.getSiteUplaodRootPath());
        path.append(getCombinedPath(directories));

        return path.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 사이트 업로드 루트 경로에 사이트 아이디와 추가 경로를 더한 임시 경로를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param directories
     * @return
     */
    public static String getTempPath(String... directories) {
        StringBuilder path = new StringBuilder(SiteUtil.getSiteUplaodRootPath());
        path.append(File.separator).append(UploadConstants.PATH_TEMP);
        path.append(getCombinedPath(directories));

        return path.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 경로 정보를 받아 디렉토리 구분자를 더한 경로 문자열을 반환한다.
     *          gtCombinedPath("temp", "img", "common") -> "/temp/img/common" 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param str
     * @return
     */
    public static String getCombinedPath(String... str) {
        StringBuilder path = new StringBuilder();
        for (String d : str) {
            path.append(File.separator).append(FileUtil.getAllowedFilePath(d));
        }

        return path.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 현재 날짜로 년/월/일 경로 문자열을 반환한다.
     *          2016년 07월 07일 -> "2016/07/07"
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public static String getNowdatePath() {
        String yyyymmdd = DateUtil.getNowDate();
        return yyyymmdd.substring(0, 4) + File.separator + yyyymmdd.substring(4, 6) + File.separator
                + yyyymmdd.substring(6);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : "YYYYMMDD_ds8sdfj20j..." 형식의 문자열을 YYYY/MM/DD/ds8sdfj20j... 형식의 경로 문자열로 반환한다. 
     *          에디터 업로드 이미지 등에서 사용
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @return
     */
    public static String getDatePath(String fileName) {
        String[] temp = fileName.split("_");
        String result = fileName;

        if (temp.length > 1) { // 섬네일은 _가 뒤에 더 들어가서 1보다 크면으로 처리
            result = temp[0].substring(0, 4) + File.separator;
            result += temp[0].substring(4, 6) + File.separator;
            result += temp[0].substring(6) + File.separator;
            if (temp.length == 2) {
                result += temp[1];
            } else {
                result += fileName.substring(fileName.indexOf("_") + 1);
            }
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : 폴더 내역 삭제 안의 파일 정보까지 모든걸 삭제하는 로직 처리
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param parentPath
     * @return
     */
    public static void deleteFolder(String parentPath) {
        File file = new File(parentPath);
        String childPath;
        File f;
        if (file != null && file.exists()) {
            for (String fileName : file.list()) {
                childPath = parentPath + File.separator + fileName;
                f = new File(childPath);
                if (!f.isDirectory()) {
                    f.delete();
                } else {
                    deleteFolder(childPath);
                }
            }

            file = new File(parentPath);
            file.delete();
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 6.
     * 작성자 : dong
     * 설명   : 파일 읽어 문자열로 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 6. dong - 최초생성
     * </pre>
     *
     * @param file
     * @return
     * @throws IOException
     */
    public static String readFile(File file) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;

        if (!file.exists()) throw new FileNotFoundException();

        try (FileReader fr = new FileReader(file); BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file),"utf-8"));) {
            while ((line = br.readLine()) != null) {
                sb.append(line).append(System.lineSeparator());
            }
        } catch (Exception e) {
            log.error("파일 읽기 중 에러", e);
            throw e;
        }

        return sb.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 13.
     * 작성자 : dong
     * 설명   : 쇼핑몰별 쿼터를 조회하여 업로드 불가능시 익셉션 발생
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param mRequest
     * @return
     */
    public static void checkUploadable(MultipartHttpServletRequest mRequest) {
        Iterator<String> fileIter = mRequest.getFileNames();
        Long totalFileSize = 0L;
        List<MultipartFile> files;

        /*if (!"product".equals(SERVER)) {
            // 운영서버가 아니면 무조건 업로드 가능
            return;
        }*/

        /*while (fileIter.hasNext()) {
            files = mRequest.getMultiFileMap().get(fileIter.next());

            for (MultipartFile mFile : files) {
                log.debug("{}, {}, {}", fileIter.toString(), mFile.getName(), mFile.getSize());
                totalFileSize += mFile.getSize();
            }
        }

        Long size = ExecuteExtCmdUtil.getFreeDisk(SiteUtil.getSiteId()) * 1024;
        log.debug("{}, {}", totalFileSize, size);

        if (totalFileSize >= size) {
            throw new DiskFullException(totalFileSize);
        }*/
    }

    /*public static boolean chown(String siteId) {
        return ExecuteExtCmdUtil.chown(siteId);
    }*/

   /* public static boolean copy(String siteId, String source, String target) {
        return ExecuteExtCmdUtil.copy(siteId, source, target);
    }*/

    /**
     * <pre>
     * 작성일 : 2016. 10. 17.
     * 작성자 : dong
     * 설명 : 파일이나 폴더 저장시 특수문자 경로 문자열 제거
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 17. dong - 최초생성
     * </pre>
     *
     * @param str
     * @return 변환된 string
     * @throws
     */
    public static String replaceFileNm(String str) {
        String reStr = str;
        reStr = reStr.replaceAll("&", "");
        reStr = reStr.replaceAll("!", "");
        reStr = reStr.replaceAll("#", "");
        reStr = reStr.replaceAll("$", "");
        reStr = reStr.replaceAll("%", "");
        reStr = reStr.replaceAll("^", "");
        reStr = reStr.replaceAll("~", "");
        reStr = reStr.replaceAll("`", "");
        reStr = reStr.replaceAll("'", "");
        reStr = reStr.replaceAll(";", "");
        return reStr;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 21.
     * 작성자 : dong
     * 설명   : 파일 결로명에서 허용하지 않은 문자열을 제거 하여 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 21. dong - 최초생성
     * </pre>
     *
     * @param filePath
     * @return
     */
    public static String getAllowedFilePath(String filePath) {
        filePath = StringUtil.replaceAll(filePath, "../", "");
        filePath = StringUtil.replaceAll(filePath, "\\uc0", "");

        return filePath;
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : MultipartHttpServletRequest 에서 첨부파일 정보를 추출하여 targetPath 에 파일을 생성하고
     *          파일 정보를 목록으로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest
     * @param targetPath
     *            파일이 복사될 경로
     * @return
     */
    public static List<FileVO> getSellerFileListFromRequest(HttpServletRequest request, String targetPath) {
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

        try {

            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {

                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);

                    fileName = System.currentTimeMillis() + "." + extension;
                    path = File.separator + getNowdatePath();
                    file = new File(targetPath + path + File.separator + fileName);

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);
                    mFile.transferTo(file);
                    
                    fileVO = new FileVO();
                    fileVO.setFileExtension(extension);
                    fileVO.setFileOrgName(fileOrgName);
                    fileVO.setFileSize(mFile.getSize());
                    fileVO.setFileType(mFile.getContentType());
                    fileVO.setFilePath(path);
                    fileVO.setFileName(fileName);
                    
                    String currName = mFile.getName();
                    if ("biz_file".endsWith(currName)) {
                    	fileVO.setUserFile("biz");
                    } else if ("copy_file".endsWith(currName)) {
                    	fileVO.setUserFile("copy");
                    } else if ("etc_file".endsWith(currName)) {
                    	fileVO.setUserFile("etc");
                    } else if ("ceo_file".endsWith(currName)) {
                    	fileVO.setUserFile("ceo");
                    } else if ("ref_file".endsWith(currName)) {
                    	fileVO.setUserFile("ref");
                    }
                    fileVOList.add(fileVO);
                }
            }

        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return fileVOList;
    }    
}
