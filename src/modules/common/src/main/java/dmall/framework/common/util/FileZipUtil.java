package dmall.framework.common.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.CustomException;

@Slf4j
public class FileZipUtil {

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 압축풀기 메소드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param zipFileName
     *            압축파일
     * @param directory
     *            압축 풀 폴더
     * @throws Exception
     */
    public static void decompress(String zipFileName, String directory) throws Throwable {
        File zipFile = new File(zipFileName);
        FileInputStream fis = null;
        ZipInputStream zis = null;
        ZipEntry zipentry = null;
        try {
            // 파일 스트림
            fis = new FileInputStream(zipFile);
            // Zip 파일 스트림
            zis = new ZipInputStream(fis);
            // entry가 없을때까지 뽑기
            while ((zipentry = zis.getNextEntry()) != null) {
                String filename = FileUtil.replaceFileNm(zipentry.getName());
                File file = new File(directory, filename);
                // entiry가 폴더면 폴더 생성
                if (zipentry.isDirectory()) {
                    file.mkdirs();
                } else {
                    // 파일이면 파일 만들기
                    createFile(file, zis);
                }
            }
        } catch (Throwable e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            if (zis != null) zis.close();
            if (fis != null) fis.close();
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 파일 만들기 메소드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param file
     *            파일
     * @param zis
     *            Zip스트림
     * @throws Exception
     */
    private static void createFile(File file, ZipInputStream zis) throws Throwable {
        // 디렉토리 확인
        File parentDir = new File(file.getParent());
        // 디렉토리가 없으면 생성하자
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }
        // 파일 스트림 선언
        try (FileOutputStream fos = new FileOutputStream(file)) {
            byte[] buffer = new byte[256];
            int size = 0;
            // Zip스트림으로부터 byte뽑아내기
            while ((size = zis.read(buffer)) > 0) {
                // byte로 파일 만들기
                fos.write(buffer, 0, size);
            }
        } catch (Throwable e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 압축 메소드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param path
     *            경로
     * @param outputFileName
     *            출력파일명
     * @throws Exception
     */
    public static void compress(String path, String outputFileName) throws Throwable {
        File file = new File(path);
        int pos = outputFileName.lastIndexOf(".");
        if (!outputFileName.substring(pos).equalsIgnoreCase(".zip")) {
            outputFileName += ".zip";
        }
        // 압축 경로 체크
        if (!file.exists()) {
            throw new Exception("Not File!");
        }
        // 출력 스트림
        FileOutputStream fos = null;
        // 압축 스트림
        ZipOutputStream zos = null;
        try {
            fos = new FileOutputStream(new File(outputFileName));
            zos = new ZipOutputStream(fos);
            // 디렉토리 검색
            searchDirectory(file, zos);
        } catch (Throwable e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            if (zos != null) zos.close();
            if (fos != null) fos.close();
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 다형성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param file
     *            파일
     * @param zos
     *            Zip스트림
     * @throws Exception
     */
    private static void searchDirectory(File file, ZipOutputStream zos) throws Throwable {
        searchDirectory(file, file.getPath(), zos);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 디렉토리 탐색
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param file
     *            현재 파일
     * @param root
     *            루트 경로
     * @param zos
     *            압축 스트림
     * @throws Exception
     */
    private static void searchDirectory(File file, String root, ZipOutputStream zos) throws Exception {
        // 지정된 파일이 디렉토리인지 파일인지 검색
        if (file.isDirectory()) {
            // 디렉토리일 경우 재탐색(재귀)
            File[] files = file.listFiles();
            for (File f : files) {
                searchDirectory(f, root, zos);
            }
        } else {
            // 파일일 경우 압축을 한다.
            compressZip(file, root, zos);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 압축 메소드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param file
     * @param root
     * @param zos
     * @throws Exception
     */
    private static void compressZip(File file, String root, ZipOutputStream zos) throws Exception {
        FileInputStream fis = null;
        try {
            String zipName = file.getPath().replace(root + "\\", "");
            // 파일을 읽어드림
            fis = new FileInputStream(file);
            // Zip엔트리 생성(한글 깨짐 버그)
            ZipEntry zipentry = new ZipEntry(zipName);
            // 스트림에 밀어넣기(자동 오픈)
            zos.putNextEntry(zipentry);
            int length = (int) file.length();
            byte[] buffer = new byte[length];
            // 스트림 읽어드리기
            fis.read(buffer, 0, length);
            // 스트림 작성
            zos.write(buffer, 0, length);
            // 스트림 닫기
            zos.closeEntry();

        } catch (Throwable e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            if (fis != null) fis.close();
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 디렉토리 복사 메서드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param dir
     *            원본폴더
     * @param toDir
     *            대상폴더
     * @throws Exception
     */
    public static void copyDir(File dir, File toDir) throws Exception {
        // 복사할 위치에 같은 이름의 폴더 생성
        if (!toDir.exists()) {
            toDir.mkdir();
        }
        // 폴더 검색해서 리스트 생성
        File[] fList = dir.listFiles();
        // 리스트 요소들을 검색
        for (File result : fList) { // 폴더의 내용이 있을때만 검색
            File oldDir = new File(result.getAbsolutePath());
            File newDir = new File(toDir.getAbsolutePath() + FileUtil.getCombinedPath(result.getName())); // 복사될
            // 요소
            if (result.isDirectory()) { // 폴더이면
                copyDir(oldDir, newDir); // 이 이름의 폴더에서 같은 내용 반복
            } else if (result.isFile()) { // 파일이면
                // 복사하기 위해 생성된 폴더로 파일 복사
                FileUtil.copy(result, newDir);
            }
        } // end for
    }// end copyDir()

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 파일 카피 메서드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param oldFile
     *            원본파일
     * @param newDir
     *            대상파일
     * @throws Exception
     */
    // 파일 카피 메서드
    public static boolean copyFile(File oldFile, File newDir) {
        boolean result = false; // 완료여부
        if (oldFile.exists()) { // 복사 원본 파일 존재시
            FileInputStream fis = null;
            FileOutputStream fos = null;
            try {
                fis = new FileInputStream(oldFile.getAbsolutePath());
                fos = new FileOutputStream(newDir.getAbsolutePath());
                int input = 0; // 읽어들이는 데이터
                while ((input = fis.read()) != -1) {
                    fos.write(input); // 읽어들인 값 대상 파일에 쓰기
                    result = true; // 정상복사
                }
                fis.close(); // 사용완료
                fos.close(); // 사용완료
            } catch (Exception e) {
                result = false;
            } finally {
                if (fis != null) {
                    try {
                        fis.close();
                    } catch (Exception e) {
                        throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
                    }
                }
                if (fos != null) {
                    try {
                        fis.close();
                    } catch (Exception e) {
                        throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
                    }
                }
            }

        } else { // 복사 원본 파일 존재하지 않으면
        }
        return result;
    }// end copyFile()

    /**
     * <pre>
     * 작성일 : 2016. 7 27.
     * 작성자 : dong
     * 설명   : 파일 압축.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param dir
     *            원본파일
     * @param toDir
     *            대상파일
     * @throws Exception
     */
    // 파일 압축처리
    // 버퍼 사이즈를 정한다. 한번에 1024byte를 읽어온다.
    private static final byte[] buf = new byte[1024];

    public static void createZipFile(String targetPath, String zipPath) throws Exception {
        createZipFile(targetPath, zipPath, false);
    }

    public static void createZipFile(String targetPath, String zipPath, boolean isDirCre) throws Exception {

        File fTargetPath = new File(targetPath);
        File[] files = null;

        // targetPath가 디렉토리일경우...
        if (fTargetPath.isDirectory()) {
            files = fTargetPath.listFiles();
        }
        // targetPath가 파일일경우
        else {
            files = new File[1];
            files[0] = fTargetPath;
        }

        File path = new File(zipPath);
        File dir = null;
        dir = new File(path.getParent());
        if (isDirCre) {
            // 디렉토리가 없을경우 생성
            dir.mkdirs();
        }

        ZipOutputStream zipOut = null;
        try {
            // ZIP파일의 output Stream
            zipOut = new ZipOutputStream(new FileOutputStream(path));

            // zip파일 압축
            makeZipFile(files, zipOut, "");

            // stream을 닫음으로서 zip파일 생성
            zipOut.close();

        } finally {
            // 처리가 안되거나 문제가있을 경우 이고 널이 아니면 무조건 닫음
            if (zipOut != null) {
                zipOut.close();
            }
        }
    }

    public static void createZipFile(String[] targetFiles, String zipPath) throws Exception {
        createZipFile(targetFiles, zipPath, false);
    }

    public static void createZipFile(String[] targetFiles, String zipPath, boolean isDirCre) throws Exception {

        File[] files = new File[targetFiles.length];
        for (int i = 0; i < files.length; i++) {
            files[i] = new File(targetFiles[i]);
        }

        File path = new File(zipPath);
        File dir = null;
        dir = new File(path.getParent());
        if (isDirCre) {
            // 디렉토리가 없을경우 생성
            dir.mkdirs();
        }

        ZipOutputStream zipOut = null;
        try {
            // ZIP파일의 output Stream
            zipOut = new ZipOutputStream(new FileOutputStream(path));

            // zip파일 압축
            makeZipFile(files, zipOut, "");

            // stream을 닫음으로서 zip파일 생성
            zipOut.close();

        } finally {
            // 처리가 안되거나 문제가있을 경우 이고 널이 아니면 무조건 닫음
            if (zipOut != null) {
                zipOut.close();
            }
        }

    }

    // zip파일로 압축
    private static void makeZipFile(File[] files, ZipOutputStream zipOut, String targetDir) throws Exception {

        // 디렉토리 내의 파일들을 읽어서 zip Entry로 추가합니다.
        for (int i = 0; i < files.length; i++) {

            File compPath = new File(files[i].getPath());

            // 목록에서 디렉토리가 존재할경우 재귀호출하여 하위디렉토리까지 압축한다.(머리아픔... 생각많이함.. ㅠ.ㅠ)
            if (compPath.isDirectory()) {
                File[] subFiles = compPath.listFiles();
                makeZipFile(subFiles, zipOut, targetDir + compPath.getName() + "/");
                continue;
            }

            FileInputStream in = null;

            try {
                in = new FileInputStream(compPath);
                // ZIP OutputStream에 ZIP entry를 추가
                // ZIP파일 내의 압축될 파일이 저장되는 경로이다...(주의!!!)
                zipOut.putNextEntry(new ZipEntry(targetDir + FileUtil.getCombinedPath(files[i].getName())));

                // 파일을 Zip에 쓴다.
                int data;

                while ((data = in.read(buf)) > 0) {
                    zipOut.write(buf, 0, data);
                }

                // 하나의 파일을 압축하였다.
                zipOut.closeEntry();
                in.close();

            } finally {
                // 처리가 안되거나 문제가있을 경우 이고 널이 아니면 무조건 닫음
                if (zipOut != null) {
                    zipOut.closeEntry();
                }
                if (in != null) {
                    in.close();
                }
            }

        }

    }

    public static void unZipFile(String targetZip, String completeDir) throws Exception {
        unZipFile(targetZip, completeDir, false);
    }

    public static void unZipFile(String targetZip, String completeDir, boolean isDirCre) throws Exception {

        ZipInputStream in = null;
        FileOutputStream out = null;

        try {

            File fCompleteDir = null;
            fCompleteDir = new File(completeDir);
            if (isDirCre) {
                // 디렉토리가 없을경우 생성
                fCompleteDir.mkdirs();
            }

            // zip파일의 input stream을 읽어들인다.
            in = new ZipInputStream(new FileInputStream(targetZip));
            ZipEntry entry = null;

            // input stream내의 압축된 파일들을 하나씩 읽어온다.
            while ((entry = in.getNextEntry()) != null) {

                // zip파일의 구조와 동일하게 가기위해 로컬의 디렉토리구조를 만든다.(entry.isDirectory()
                // 안먹음.. 젠장~!)
                String entryName = entry.getName();
                if (entry.getName().lastIndexOf('/') > 0) {
                    String mkDirNm = entryName.substring(0, entryName.lastIndexOf('/'));
                    new File(completeDir + FileUtil.replaceFileNm(mkDirNm)).mkdirs();
                }

                // 해제할 각각 파일의 output stream을 생성
                out = new FileOutputStream(completeDir + FileUtil.replaceFileNm(entry.getName()));

                int bytes_read;
                while ((bytes_read = in.read(buf)) != -1)
                    out.write(buf, 0, bytes_read);

                // 하나의 파일이 압축해제되었다.
                out.close();
            }

        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            // out 정보가 있을시 stream 닫는다
            if (out != null) {
                out.close();
            }
            // 모든파일의 압축이 해제되면 input stream을 닫는다.
            if (in != null) {
                in.close();
            }
        }

    }

    public static byte[] compressToZip(byte[] src) throws Exception {

        byte[] retSrc = null;
        ByteArrayOutputStream baos = null;

        try {

            // ZIP파일의 output Stream
            ByteArrayInputStream bais = new ByteArrayInputStream(src);
            baos = new ByteArrayOutputStream();
            ZipOutputStream zos = new ZipOutputStream(baos);

            zos.putNextEntry(new ZipEntry("temp.tmp"));

            int bytes_read = 0;
            // 전달받은 src를 압축하여 파일에다 쓴다.
            while ((bytes_read = bais.read(buf)) != -1) {
                zos.write(buf, 0, bytes_read);
            }
            bais.close();
            zos.close();

            // 스트림을 닫은후 byte배열을 얻어온다...(닫기전에 수행하면 정상적으로 얻어오지 못한다.)
            retSrc = baos.toByteArray();

        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            if (baos != null) {
                baos.close();
            }
        }

        return retSrc;

    }

    // 압축된 byte배열을 받아서 zipPath위치에 zip파일을 생성한다.
    private static void makeZipFile(byte[] src, String zipPath) throws Exception {

        FileOutputStream fos = null;
        ByteArrayInputStream bais = null;

        try {
            fos = new FileOutputStream(zipPath);
            bais = new ByteArrayInputStream(src);

            int bytes_read = 0;
            while ((bytes_read = bais.read(buf)) != -1) {
                fos.write(buf, 0, bytes_read);
            }

        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            if (fos != null) {
                fos.close();
            }
            if (bais != null) {
                bais.close();
            }
        }
    }

    public static byte[] unZip(byte[] src) throws Exception {

        byte[] retSrc = null;
        ByteArrayOutputStream baos = null;
        ZipInputStream zis = null;
        int bytes_read = 0;

        try {
            zis = new ZipInputStream(new ByteArrayInputStream(src));
            baos = new ByteArrayOutputStream();

            zis.getNextEntry(); // entry는 하나밖에 없음을 보장한다.

            while ((bytes_read = zis.read(buf)) != -1) {
                baos.write(buf, 0, bytes_read);
            }

            retSrc = baos.toByteArray();

        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            if (baos != null) {
                baos.close();
            }
            if (zis != null) {
                zis.close();
            }
        }

        return retSrc;
    }

    public static byte[] compressToZip(String src) throws Exception {
        return compressToZip(src.getBytes("UTF-8"));
    }

    public static void srcToZipFile(byte[] src, String zipPath) throws Exception {
        byte[] retSrc = null;

        // 압축한다.
        retSrc = compressToZip(src);

        // 파일로 만든다.
        makeZipFile(retSrc, zipPath);
    }

    public static void srcToZipFile(String src, String zipPath) throws Exception {
        byte[] retSrc = null;

        // 압축한다.
        retSrc = compressToZip(src.getBytes("UTF-8"));

        // 파일로 만든다.
        makeZipFile(retSrc, zipPath);
    }

    public static byte[] zipFileToSrc(String zipPath) throws Exception {
        byte[] retSrc = null;

        return retSrc;
    }

}
