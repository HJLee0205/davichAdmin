package net.danvi.dmall.biz.app.goods.service;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.goods.model.BrandPO;
import net.danvi.dmall.biz.app.goods.model.BrandSO;
import net.danvi.dmall.biz.app.goods.model.BrandVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 22.
 * 작성자     : dong
 * 설명       : 브랜드 정보 관리 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("brandManageService")
@Transactional(rollbackFor = Exception.class)
public class BrandManageServiceImpl extends BaseService implements BrandManageService {

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    @Transactional(readOnly = true)
    public List<BrandVO> selectBrandList(BrandSO brandSO) {
        // 브랜드 리스트 조회 - 폴더화면으로 나오는것
        return proxyDao.selectList(MapperConstants.BRAND_MANAGE + "selectBrandList", brandSO);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BrandVO> selectBrand(BrandSO so) {

        // 브랜드 정보 조회 - 폴더에서 선택된 하나의 값 조회
        BrandVO vo = proxyDao.selectOne(MapperConstants.BRAND_MANAGE + "selectBrandDtl", so);

        ResultModel<BrandVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    public ResultModel<BrandPO> updateBrand(BrandPO po) {
        ResultModel<BrandPO> result = new ResultModel<>();
        try {
            // 브랜드 수정

            File file;
            File ofile;

            // 저장할 파일경로와 명
            String newfilePathNm = DateUtil.getNowDate();
            String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)+ File.separator + newfilePathNm.substring(6);

            // 이미지 변경할것인지 구분하는 값 정의
            String brandDftImgYn = "N";
            String brandMovImgYn = "N";

            String brandListImgYn = "N";
            String brandDtlImgYn = "N";
            String brandLogoImgYn = "N";



            // 브랜드 디폴트 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getDftFilePath() != null && po.getDftFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, newfilePath,po.getDftFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getDftFilePath() + File.separator+ po.getDftFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);
                po.setBrandImgPath(newfilePathNm);
                po.setBrandImgNm(po.getDftFileName());
                brandDftImgYn = "Y";
            }

            // 브랜드 마우스오버 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getMoverFilePath() != null && po.getMoverFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, newfilePath,po.getMoverFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getMoverFilePath() + File.separator+ po.getMoverFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);

                po.setMouseoverImgPath(newfilePathNm);
                po.setMouseoverImgNm(po.getMoverFileName());
                brandMovImgYn = "Y";
            }

            // 브랜드 목록 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getListFileName() != null && po.getListFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, newfilePath,po.getListFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getListFilePath() + File.separator+ po.getListFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);

                po.setListImgPath(newfilePathNm);
                po.setListImgNm(po.getListFileName());
                brandListImgYn = "Y";
            }

            // 브랜드 상세 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getDtlFileName() != null && po.getDtlFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, newfilePath,po.getDtlFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getDtlFilePath() + File.separator+ po.getDtlFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);

                po.setDtlImgPath(newfilePathNm);
                po.setDtlImgNm(po.getDtlFileName());
                brandDtlImgYn = "Y";
            }

            // 브랜드 로고 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getLogoFileName() != null && po.getLogoFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, newfilePath,po.getLogoFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getLogoFilePath() + File.separator+ po.getLogoFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);

                po.setLogoImgPath(newfilePathNm);
                po.setLogoImgNm(po.getLogoFileName());
                brandLogoImgYn = "Y";
            }

            // 이미지 정보가 등록된것이 있을경우 기존이미지 정보 불러오기
            BrandVO voVal = new BrandVO();
            if (brandDftImgYn.equals("Y") || brandMovImgYn.equals("Y") || brandListImgYn.equals("Y") || brandDtlImgYn.equals("Y") || brandLogoImgYn.equals("Y") ) {
                voVal = proxyDao.selectOne(MapperConstants.BRAND_MANAGE + "selectBrandDtl", po);
            }

            // 브랜드 정보 수정
            if(po.getMainDispYn()==null || po.getMainDispYn().equals("")){
                po.setMainDispYn("N");
            }
            proxyDao.update(MapperConstants.BRAND_MANAGE + "updateBrand", po);

            // 이미지 정보가 등록된것이 있을경우 기존이미지 파일 삭제
            // 브랜드 기본이미지 삭제처리
            if (brandDftImgYn.equals("Y")) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getBrandImgPath())) && !"".equals(StringUtil.nvl(voVal.getBrandImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getBrandImgPath() + "_" + voVal.getBrandImgNm());
                    File imgFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }
            // 브랜드 마우스오버 이미지 삭제처리
            if (brandMovImgYn.equals("Y")) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getMouseoverImgPath())) && !"".equals(StringUtil.nvl(voVal.getMouseoverImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getMouseoverImgPath() + "_" + voVal.getMouseoverImgNm());
                    File imgFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }

            // 브랜드 목록 이미지 삭제처리
            if (brandListImgYn.equals("Y")) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getListImgPath())) && !"".equals(StringUtil.nvl(voVal.getListImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getListImgPath() + "_" + voVal.getListImgNm());
                    File imgFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }

            // 브랜드 상세 이미지 삭제처리
            if (brandDtlImgYn.equals("Y")) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getDtlImgPath())) && !"".equals(StringUtil.nvl(voVal.getDtlImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getDtlImgPath() + "_" + voVal.getDtlImgNm());
                    File imgFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }

            // 브랜드 로고 이미지 삭제처리
            if (brandLogoImgYn.equals("Y")) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getLogoImgPath())) && !"".equals(StringUtil.nvl(voVal.getLogoImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getLogoImgPath() + "_" + voVal.getLogoImgNm());
                    File imgFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "브랜드관리" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "브랜드관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<BrandPO> insertBrand(BrandPO po) {
        ResultModel<BrandPO> result = new ResultModel<>();
        Long brandNo = (long) 0;
        try {
            // 브랜드 등록
            // 브랜드 시퀀스 조회
            brandNo = bizService.getSequence("BRAND_NO");

            // 브랜드 등록시 기본값 정의
            po.setBrandNo(brandNo);
            po.setBrandNm(po.getNewBrandNm());
            po.setBrandExhbtionTypeCd("1");

            // 브랜드 등록 데이터 처리
            proxyDao.insert(MapperConstants.BRAND_MANAGE + "insertBrand", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "브랜드관리" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<BrandPO> deleteBrand(BrandPO po) {
        ResultModel<BrandPO> result = new ResultModel<>();
        try {

            // 브랜드 삭제

            // 브랜드 기본정보 조회
            BrandVO voVal = new BrandVO();
            voVal = proxyDao.selectOne(MapperConstants.BRAND_MANAGE + "selectBrandDtl", po);

            // 브랜드 삭제
            // 브랜드 삭제는 값만 disp__yn 만 값 업데이트 처리 실제 삭제 되지 않으나
            // 이미지는 삭제할거고 그래서 이미지가 있든 없든 이미지 null 처리 및 브랜드 명만 보여주는 값 처리 함
            proxyDao.delete(MapperConstants.BRAND_MANAGE + "deleteBrand", po);

            // 이미지 정보가 등록된것이 있을경우 기존이미지 파일 삭제
            // 브랜드 기본이미지 삭제처리
            if (voVal != null) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getBrandImgPath()))
                        && !"".equals(StringUtil.nvl(voVal.getBrandImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getBrandImgPath() + "_" + voVal.getBrandImgNm());
                    File imgFile = new File(
                            FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }
            // 브랜드 마우스오버 이미지 삭제처리
            if (voVal != null) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getMouseoverImgPath()))
                        && !"".equals(StringUtil.nvl(voVal.getMouseoverImgNm()))) {
                    String filePathNm = FileUtil
                            .getDatePath(voVal.getMouseoverImgPath() + "_" + voVal.getMouseoverImgNm());
                    File imgFile = new File(
                            FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "브랜드관리" }, e);
        }
        return result;
    }

}
