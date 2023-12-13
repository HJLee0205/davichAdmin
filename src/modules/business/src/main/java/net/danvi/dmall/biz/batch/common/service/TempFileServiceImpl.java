package net.danvi.dmall.biz.batch.common.service;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;

@Service("tempFileService")
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class TempFileServiceImpl extends BaseService implements TempFileService {

    /** 사이트별 디렉토리가 생성되는 상위 경로 */
    @Value(value = "#{system['system.site.root.path']}")
    private String siteRootPath;

    // 1. 임시 폴더 삭제
    @Override
    public void tempFileDel()
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        // 삭제할 파일경로와 명
        // 날짜 경로로 가져오기
        String filePathAgo5 = DateUtil.getDateAgo(-5); // 5일전 날짜 가져오기
        String filePathDel5 = File.separator + filePathAgo5.substring(0, 4) + File.separator
                + filePathAgo5.substring(4, 6) + File.separator + filePathAgo5.substring(6);
        String filePathAgo4 = DateUtil.getDateAgo(-4); // 4일전 날짜 가져오기
        String filePathDel4 = File.separator + filePathAgo4.substring(0, 4) + File.separator
                + filePathAgo4.substring(4, 6) + File.separator + filePathAgo4.substring(6);
        String filePathAgo3 = DateUtil.getDateAgo(-3); // 3일전 날짜 가져오기
        String filePathDel3 = File.separator + filePathAgo3.substring(0, 4) + File.separator
                + filePathAgo3.substring(4, 6) + File.separator + filePathAgo3.substring(6);

        File rootFolder;
        File tempFolder;
        File dateFolder5;
        File dateFolder4;
        File dateFolder3;

        // 기본 아이디별 경로 가져오기
        rootFolder = new File(siteRootPath);
        // 템프폴더 기본 정의
        String temp = File.separator + "temp";

        // 파일 폴더가 존재하는지 확인
        if (rootFolder != null) {

            // 파일이나 폴더가 존재하는지. 그리고 폴더인지 확인
            if (rootFolder.exists() && rootFolder.isDirectory()) {
                // 생성아이디별 템프 폴더를 찾기 위한 값 정의
                // 생상아이디마다 템프를 삭제하기 위하 loop 되어야함
                File[] idFolder = rootFolder.listFiles();
                for (int i = 0; i < idFolder.length; i++) {
                    // 폴더가 있을시 폴더별 디렉토리가 존재할때만 처리 가능
                    if (idFolder[i].isDirectory()) {
                        // 각 아이디별 템프 폴더 가져오기
                        tempFolder = new File(siteRootPath + File.separator + idFolder[i].getName() + temp);
                        File[] tempListFolder = tempFolder.listFiles();
                        if (tempListFolder != null && tempListFolder.length > 0) {
                            for (int j = 0; j < tempListFolder.length; j++) {
                                if (tempListFolder[j].isFile()) {
                                    File delfile = new File(siteRootPath + File.separator + idFolder[i].getName() + temp
                                            + File.separator + tempListFolder[j].getName());
                                    // 파일이 널이 아니고 파일이 있을때만 삭제처리
                                    if (delfile != null && delfile.exists()) {
                                        try {
                                            FileUtil.delete(delfile);
                                        } catch (Exception e) {
                                            // TODO Auto-generated catch block
                                            throw new CustomException("biz.exception.common.error",
                                                    new Object[] { "파일 저장 오류" }, e);
                                        }
                                    }
                                }
                            }
                        }

                        // 각 아이디별 템프 폴더 및 날짜 폴더 가져오기
                        // 5일전 데이터 처리
                        FileUtil.deleteFolder(
                                siteRootPath + File.separator + idFolder[i].getName() + temp + filePathDel5);
                        // dateFolder5 = new File(
                        // siteRootPath + File.separator + idFolder[i].getName()
                        // + temp + filePathDel5);
                        // dateFolder5);
                        // File[] dateListFolder5 = dateFolder5.listFiles();
                        //
                        // if (dateListFolder5 != null && dateListFolder5.length
                        // > 0) {
                        // for (int k = 0; k < dateListFolder5.length; k++) {
                        // if (dateListFolder5[k].isFile()) {
                        // }
                        // }
                        // }

                        // 각 아이디별 템프 폴더 및 날짜 폴더 가져오기
                        // 4일전 데이터 처리
                        FileUtil.deleteFolder(
                                siteRootPath + File.separator + idFolder[i].getName() + temp + filePathDel4);

                        // 각 아이디별 템프 폴더 및 날짜 폴더 가져오기
                        // 3일전 데이터 처리
                        FileUtil.deleteFolder(
                                siteRootPath + File.separator + idFolder[i].getName() + temp + filePathDel3);

                    }
                }
            }
        }

    }

}
