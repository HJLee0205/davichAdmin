package net.danvi.dmall.biz.app.design.service;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.*;
import net.danvi.dmall.biz.app.design.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7 21.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("skinConfigService")
@Transactional(rollbackFor = Exception.class)
public class SkinConfigServiceImpl extends BaseService implements SkinConfigService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Value("#{system['system.html.editor.path']}")
    private String editPath;

    /** 원본 스킨 경로 */
    @Value("#{system['system.origin.skin.path']}")
    private String orgSkinPath;

    /** d-mall 제공 기본 스킨 경로 */
    @Value("#{core['system.site.init.bell.base.skin.path']}")
    private String bellBaseSkinPath;

    /** 쇼핑몰 생성시 기본 스킨 ID */
    @Value("#{core['system.site.init.default.skin.id']}")
    private String defaultSkinId;

    @Override
    @Transactional(readOnly = true)
    public List<SkinVO> selectSkinList(SkinSO so) {
        // 스킨리스트 조회
        return proxyDao.selectList(MapperConstants.DESIGN_SKIN + "selectSkinList", so);
    }

    @Override
    public ResultModel<SkinPO> updateRealSkin(SkinPO po) throws Exception {
        // 스킨 실제적용스킨 처리
        ResultModel<SkinPO> result = new ResultModel<>();

        try {
            // 실제 적용스킨이 아니라고 스킨 데이터 업데이트
            proxyDao.update(MapperConstants.DESIGN_SKIN + "updateRealResetSkin", po);
            // 내가 선택한 스킨을 실제 적용스킨이라고 데이터 업데으트
            proxyDao.update(MapperConstants.DESIGN_SKIN + "updateRealSkin", po);

            // 정상일때 메세지 처리
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

            // 실제 적용한 스킨정보를 조회
            SkinVO skinVO = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSkin", po);

            // 조회된 데이터에서 스킨아이디값을 가져온다. 이 값으로 스킨 폴더가 정해져 있어서
            // 이 값을 통해 폴더 정보를 조회해서 리얼스킨에 복사할때 사용하려한다.
            String skinId = skinVO.getSkinId();

            // siteId 가져오기
            String siteId = SiteUtil.getSiteId();
            // String realPath = editPath + "/" + siteId + "/__SKIN";

            // 리얼스킨 패스정보 가져오기
            String realPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("__SKIN");

            // 0. __SKIN 스킨 폴더 실제 적용될 폴더 스킨 삭제
            FileUtil.deleteFolder(realPath);

            // 1. 리얼스킨 폴더 없을시 생성 __SKIN 스킨 폴더 체크
            File skinDir = new File(realPath); // 복사 원본 폴더
            if (!skinDir.exists()) {
                skinDir.mkdir();
            }

            // 2. 실제 적용스킨 정볼르 진행스킨에 등록처리
            // String savePath = editPath + "/" + siteId + "/skins/" + skinId;
            // 복사할 스킨 정보 조회
            String savePath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins", skinId);
            File dir = new File(savePath); // 복사 원본 폴더
            File toDir = new File(realPath); // 복사 대상 폴더

            // 안의 있는 값 복사
            FileZipUtil.copyDir(dir, toDir);

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }

    @Override
    public ResultModel<SkinPO> updateWorkSkin(SkinPO po) throws Exception {
        // 스킨 작업스킨 처리
        ResultModel<SkinPO> result = new ResultModel<>();

        try {
            // 쇼핑몰이 가지고 있는 모든 스킨에 대해 작업스킨을 초기화 하는 데이터 업데이트 처리
            int cnt = proxyDao.update(MapperConstants.DESIGN_SKIN + "updateWorkResetSkin", po);
            // 선택한 스킨에 대해서 작업스킨으로 하는 데이터 업데이트 처리
            int cnt2 = proxyDao.update(MapperConstants.DESIGN_SKIN + "updateWorkSkin", po);
            // 정상 결과 메세지
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<SkinPO> insertZipUpload(SkinPO po) throws Exception {
        ResultModel<SkinPO> result = new ResultModel<>();

        try {
            // 스킨번호 만들기 시퀀스
            Long skinNo = bizService.getSequence("SKIN", po.getSiteNo());

            String skinId = "up_skin_" + skinNo;

            // 스킨명정의 가운데 이름으로 정의함. 다운로드할때나 업로드 할때 파일을 skin_00
            // skin만 가져와서 up_skin_시퀀스 처리함
            String[] skinNmSpl = po.getFileNm().split("_");
            String skinNm = "";
            if (skinNmSpl.length > 2) {
                skinNm = "up_" + skinNmSpl[1] + "_" + +skinNo;
            } else {
                skinNm = "up_" + po.getFileNm().substring(0, po.getFileNm().length() - 4) + "_" + +skinNo;
            }

            po.setSkinNo(skinNo);
            po.setSkinId(skinId);
            // siteId 가져오기
            String siteId = SiteUtil.getSiteId();

            // 스킨 관련 폴더 압축풀기
            // 1. 업로드 파일 경로를 넣는다
            String tempPath = FileUtil.getTempPath("");
            // 1.1 저장될 경로 원본 스킨정보
            // String saveOrgPath = orgSkinPath + "/" + siteId + "/skins/" +
            // skinId;
            String saveOrgPath = orgSkinPath + FileUtil.getCombinedPath(siteId, skinId);
            // 1.2 1.1 저장될 경로 사용 스킨정보
            // String savePath = editPath + "/" + siteId + "/skins/";
            String savePath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");

            // 2. 압축된파일 압축을 푼다.
            try {
                // 원본폴더에 압축을 푼다.
                // FileZipUtil.decompress(tempPath + "/" + po.getFileNm(),
                // saveOrgPath);
                FileZipUtil.decompress(tempPath + FileUtil.getCombinedPath(po.getFileNm()), saveOrgPath);
            } catch (Throwable e) {
                // TODO Auto-generated catch block
                throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
            }

            // 3. 압축된 파일 압축을 푼다
            try {
                // 작업 폴더에 압축을 푼다.
                // FileZipUtil.decompress(tempPath + "/" + po.getFileNm(),
                // savePath + skinId);
                FileZipUtil.decompress(tempPath + FileUtil.getCombinedPath(po.getFileNm()),
                        savePath + FileUtil.getCombinedPath(skinId));
            } catch (Throwable e) {
                // TODO Auto-generated catch block
                throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
            }

            // 4. 업로드한 압축파일 삭제
            // File delFile = new File(tempPath + "/" + po.getFileNm());
            File delFile = new File(tempPath + FileUtil.getCombinedPath(po.getFileNm()));
            FileUtil.delete(delFile);

            // 5. 데이터 등록
            po.setSkinNm(skinNm);
            po.setImgNm("skin_info.jpg");
            // po.setImgPath("/skins/" + skinId);
            po.setImgPath(FileUtil.getCombinedPath("skins", skinId));
            // po.setFolderPath("/" + siteId + "/skins/" + skinId);
            po.setFolderPath(FileUtil.getCombinedPath(siteId, "skins", skinId));
            // po.setOrgFolderPath("/" + siteId + "/skins/" + skinId);
            po.setOrgFolderPath(FileUtil.getCombinedPath(siteId, skinId));
            po.setDefaultSkinYn("A");
            po.setApplySkinYn("N");
            po.setWorkSkinYn("N");

            // 스킨 정보 데이터 등록
            proxyDao.insert(MapperConstants.DESIGN_SKIN + "insertSkin", po);
            // 정상 처리 메세지 값
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return result;
    }

    @Override
    public ResultModel<SkinPO> insertCopySkin(SkinPO po) throws Exception {
        ResultModel<SkinPO> result = new ResultModel<>();

        try {
            // siteId 가져오기
            String siteId = SiteUtil.getSiteId();
            // 복사할 기준 스킨아이디 정보 가져오기
            String orgSkinId = po.getSkinId();
            Long orgSkinNo = po.getSkinNo();

            SkinVO skinVO = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSkin", po);

            // 스킨번호 만들기 시퀀스
            Long skinNo = bizService.getSequence("SKIN", po.getSiteNo());

            // 스킨명정의 가운데 이름으로 정의함. 다운로드할때나 업로드 할때 파일을 skin_00
            // skin만 가져와서 cp_skin_시퀀스 처리함
            String[] skinNmSpl = skinVO.getSkinNm().split("_");
            String skinNm = "";
            if (skinNmSpl.length > 2) {
                skinNm = "cp_" + skinNmSpl[1] + "_" + skinNo;
            } else {
                skinNm = "cp_" + skinVO.getSkinNm() + "_" + skinNo;
            }

            String skinId = "cp_skin_" + skinNo;
            po.setSkinNo(skinNo);
            po.setSkinId(skinId);

            // 스킨 관련 폴더 복사 기능으로 처리
            // 1.1 저장될 경로 원본 스킨정보
            // String saveOrgPath = orgSkinPath + "/" + siteId + "/skins/" +
            // skinId;
            String saveOrgPath = orgSkinPath + FileUtil.getCombinedPath(siteId, skinId);

            // 1.2 1.1 저장될 경로 사용 스킨정보
            // String savePath = editPath + "/" + siteId + "/skins/";
            String savePath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");

            // 2. 저장된 원본 파일을 사용 폴더로 복사
            // 복사원본폴더
            File dir = new File(savePath + FileUtil.getCombinedPath(orgSkinId));
            // 복사 대상폴더 - 스킨 작업폴더
            File toDir = new File(savePath + FileUtil.getCombinedPath(skinId));
            // 복사 대상폴더 - 원본폴더
            File toDir2 = new File(saveOrgPath); // 복사 대상 폴더

            // 2.1 작업폴더 스킨 복사 기능
            FileZipUtil.copyDir(dir, toDir);
            // 2.2 원본폴더 스킨 복사 기능
            FileZipUtil.copyDir(dir, toDir2);

            // 5. 데이터 등록
            po.setOrgSkinNo(orgSkinNo);
            po.setSkinNm(skinNm);
            po.setImgNm("skin_info.jpg");
            // po.setImgPath("/skins/" + skinId);
            po.setImgPath(FileUtil.getCombinedPath("skins", skinId));
            // po.setFolderPath("/" + siteId + "/skins/" + skinId);
            po.setFolderPath(FileUtil.getCombinedPath(siteId, "skins", skinId));
            // po.setOrgFolderPath("/" + siteId + "/skins/" + skinId);
            po.setOrgFolderPath(FileUtil.getCombinedPath(siteId, skinId));
            po.setDefaultSkinYn("C");
            po.setApplySkinYn("N");
            po.setWorkSkinYn("N");

            // 스킨 정보 데이터 등록
            proxyDao.insert(MapperConstants.DESIGN_SKIN + "insertSkin", po);
            // 정상 처리 메세지 값
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return result;
    }

    @Override
    public ResultModel<SkinPO> deleteSkin(SkinPO po) throws Exception {
        // 스킨삭제
        ResultModel<SkinPO> result = new ResultModel<>();

        // siteId 가져오기
        String siteId = SiteUtil.getSiteId();
        // 복사할 기준 스킨아이디 정보 가져오기
        // String skinId = po.getSkinId();
        String skinId = po.getSkinId();

        try {

            if (skinId == null || skinId.equals("")) {
                result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
            } else {
                // 스킨 관련 폴더 압축해서 풀기 기능으로 처리
                // 1.1 저장될 경로 원본 스킨정보
                // String saveOrgPath = orgSkinPath + "/" + siteId + "/skins/" +
                // skinId;
                String saveOrgPath = orgSkinPath + FileUtil.getCombinedPath(siteId, skinId);
                // 1.2 1.1 저장될 경로 작업 스킨정보
                // String savePath = editPath + "/" + siteId + "/skins/" +
                // skinId;
                String savePath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins", skinId);

                FileUtil.deleteFolder(saveOrgPath); // 원본 스킨 삭제
                FileUtil.deleteFolder(savePath); // 작업 스킨 삭제

                // 스킨 삭제 데이터 처리
                proxyDao.delete(MapperConstants.DESIGN_SKIN + "deleteSkin", po);
                // 삭제 메세지 값 담기
                result.setMessage(MessageUtil.getMessage("biz.common.delete"));
            }

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<SkinPO> updateRealMobileSkin(SkinPO po) throws Exception {
        // 모바일 리얼스킨 처리
        ResultModel<SkinPO> result = new ResultModel<>();

        try {

            // 실제 적용스킨이 아니라고 스킨 데이터 업데이트
            proxyDao.update(MapperConstants.DESIGN_SKIN + "updateRealResetSkin", po);
            // 내가 선택한 스킨을 실제 적용스킨이라고 데이터 업데으트
            proxyDao.update(MapperConstants.DESIGN_SKIN + "updateRealSkin", po);
            // 정상일때 메세지 처리
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

            // 적용한 스킨정보 가져오기
            SkinVO skinVO = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSkin", po);

            // 실제 적용할 스킨아이디값을 가져오기 위해 처리 하는것임
            String skinId = skinVO.getSkinId();
            // siteId 가져오기
            String siteId = SiteUtil.getSiteId();
            // String realPath = editPath + "/" + siteId + "/__SKIN";
            String realPath = SiteUtil.getSiteRootPath(siteId,"m") + FileUtil.getCombinedPath("__MSKIN");

            // 0. 스킨 폴더 삭제
            FileUtil.deleteFolder(realPath); // 진행 스킨 삭제

            // 0. 스킨 폴더 없을시 생성
            File skinDir = new File(realPath); // 복사 원본 폴더
            if (!skinDir.exists()) {
                skinDir.mkdir();
            }

            // 2. 실제 적용스킨 정볼르 진행스킨에 등록처리
            // String savePath = editPath + "/" + siteId + "/skins/" + skinId;
            String savePath = SiteUtil.getSiteRootPath(siteId,"m") + FileUtil.getCombinedPath("skins", skinId);
            File dir = new File(savePath); // 복사 원본 폴더
            File toDir = new File(realPath); // 복사 대상 폴더

            FileZipUtil.copyDir(dir, toDir);

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨관리" }, e);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/
        return result;
    }

    @Override
    public void insertDefaultSkin(SkinPO po) throws Exception {
        // 기본스킨 만들기 메소드 외부에서 호출함 홈페이지 개설때 호출됨
        if (po.getSiteId() == null || po.getSiteId().equals("")) {
            // Check Point 1
            // 없을경우 에러처리로 바꿔야 함
            throw new Exception("사이트 아이디 존재 안함");
        }

        if (po.getPcGbCd() == null || po.getPcGbCd().equals("")) {
            // Check Point 2
            // 없을경우 에러처리로 바꿔야 함
            throw new Exception("피씨 구분코드 존재 안함");
        }

        if (po.getSiteNo() == null || po.getSiteNo().equals("")) {
            // Check Point 3
            // 없을경우 에러처리로 바꿔야 함
            throw new Exception("사이트번호 존재 안함");
        }

        po.setSkinBasicYn("Y");
        insertSkinChk(po);
    }

    @Override
    public void insertBuySkin(SkinPO po) throws Exception {
        // 구매스킨 정보 일경우 호출되는 메소드
        if (po.getSiteId() == null || po.getSiteId().equals("")) {
            // Check Point 1
            // 없을경우 에러처리로 바꿔야 함
            throw new Exception("사이트 아이디 존재 안함");
        }

        if (po.getPcGbCd() == null || po.getPcGbCd().equals("")) {
            // Check Point 2
            // 없을경우 에러처리로 바꿔야 함
            throw new Exception("피씨 구분코드 존재 안함");
        }

        if (po.getSiteNo() == null || po.getSiteNo().equals("")) {
            // Check Point 3
            // 없을경우 에러처리로 바꿔야 함
            throw new Exception("사이트번호 존재 안함");
        }

        po.setSkinBasicYn("N");
        insertSkinChk(po);
    }

    public void insertSkinChk(SkinPO po) throws Exception {
        // 기본스킨이건 구매스킨이건 공통처리 스킨만들때 사용되는 메소드

        // 피씨구분코드 가져오기
        String pcGbCd = po.getPcGbCd();

        // pcGbCd 구분값에 따른 처리
        // 1. 세트상품인경우
        if (pcGbCd.equals("S")) {

            String skinId = po.getSkinId();
            String skinIdM = po.getSkinId() + "_m";
            // 먼저 스킨구분을 세트이므로 컴퓨터를 등록한다

            int resultCount = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSkinCountBySkinId", po);

            // 스킨 정보가 있는지 확인
            if (resultCount == 0) {
                po.setPcGbCd("C");
                po.setSkinId(skinId);
                insertSkin(po);
                // 두번째는 스킨구분을 세트이므로 모바일로 등록한다
                po.setPcGbCd("M");
                po.setSkinId(skinIdM);
                insertSkin(po);
            } else {
                // Check Point 10
                // 있을경우 에러처리로 바꿔야 함
                log.debug("스킨아이디 존재 [{}, {}]", po.getSiteNo(), po.getSkinId());
                throw new Exception("스킨아이디가 존재");
            }

        } else if (pcGbCd.equals("C") || pcGbCd.equals("M")) {

            int resultCount = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSkinCountBySkinId", po);

            // 스킨 정보가 있는지 확인
            if (resultCount == 0) {
                insertSkin(po);
            } else {
                // Check Point 10
                // 있을경우 에러처리로 바꿔야 함
                log.debug("스킨아이디 존재 [{}, {}]", po.getSiteNo(), po.getSkinId());
                throw new Exception("스킨아이디가 존재");
            }

        } else {
            // Check Point 4
            // 없을경우 에러처리로 바꿔야 함
            log.debug("피시 구분코드가 존재하지 않음 [{}, {}]", po.getSiteNo(), po.getSkinId());
            throw new Exception("피시 구분코드가 존재하지 않음");

        }
    }

    public void insertSkin(SkinPO po) throws Exception {

        // siteId 가져오기
        String siteId = po.getSiteId();

        // 복사할 기준 스킨아이디 정보 가져오기
        String orgSkinId = po.getSkinId();
        // 기본 스킨 아이디가 존재하는 지 확인
        if (orgSkinId == null || orgSkinId.equals("")) {
            orgSkinId = defaultSkinId;
            po.setSkinId(orgSkinId);
        }

        // 스킨번호 스킨 아이디 만들기
        Long skinNo = bizService.getSequence("SKIN", po.getSiteNo());

        String skinNm = orgSkinId;
        if (po.getSkinNm() != null && !po.getSkinNm().equals("")) {
            skinNm = po.getSkinNm();
        }

        String skinId = orgSkinId;
        po.setSkinNo(skinNo);
        po.setSkinId(skinId);

        // 스킨 관련 폴더 복사 기능으로 처리
        // 1.1 저장될 경로 사용 스킨정보
        String sourcePath = bellBaseSkinPath;
        // 1.2 저장될 경로 원본 스킨정보
        String saveOrgPath = orgSkinPath + FileUtil.getCombinedPath(siteId, skinId);
        // 1.3 저장될 경로 사용 스킨정보
        String savePath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");
        // 2. 저장된 원본 파일을 사용 폴더로 복사
        File dir = new File(sourcePath + FileUtil.getCombinedPath(orgSkinId)); // 복사
                                                                               // 원본
                                                                               // 폴더
        File toDir = new File(savePath + FileUtil.getCombinedPath(skinId)); // 복사
                                                                            // 대상
                                                                            // 폴더
        File toDir2 = new File(saveOrgPath); // 복사 대상 폴더

        // 2.1 작업폴더 스킨 복사 기능
        log.debug("작업스킨 복사 {} -> {}", dir, toDir);
        FileZipUtil.copyDir(dir, toDir);
        // 2.2 원본폴더 스킨 복사 기능
        log.debug("원본스킨 복사 {} -> {}", dir, toDir2);
        FileZipUtil.copyDir(dir, toDir2);

        // 5. 데이터 등록
        po.setSkinNm(skinNm);
        po.setImgNm("skin_info.jpg");
        // po.setImgPath("/skins/" + skinId);
        po.setImgPath(FileUtil.getCombinedPath("skins", skinId));
        // po.setFolderPath("/" + siteId + "/skins/" + skinId);
        po.setFolderPath(FileUtil.getCombinedPath(siteId, "skins", skinId));
        // po.setOrgFolderPath("/" + siteId + "/skins/" + skinId);
        po.setOrgFolderPath(FileUtil.getCombinedPath(siteId, skinId));
        po.setDefaultSkinYn("B");
        po.setApplySkinYn("N");
        po.setWorkSkinYn("N");

        if (po.getSkinBasicYn().equals("Y")) {
            po.setApplySkinYn("Y");
            po.setWorkSkinYn("Y");

            // 실제 적용스킨 정보를 진행스킨에 등록처리
            String realPath = SiteUtil.getSiteRootPath(siteId);
            if (po.getPcGbCd().equals("M")) {
                realPath += FileUtil.getCombinedPath("__MSKIN");
            } else {
                realPath += FileUtil.getCombinedPath("__SKIN");
            }
            File realToDir = new File(realPath); // 복사 대상 폴더

            FileZipUtil.copyDir(dir, realToDir);
        }

        try {
            proxyDao.insert(MapperConstants.DESIGN_SKIN + "insertSkin", po);
        } catch (DuplicateKeyException e) {
            throw new Exception("기본스킨 정보 등록 에러", e);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(po.getSiteId());*/
        }
    }

    public Integer getSkinNoBySkinId(SkinVO vo) {
        return proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSkinNoBySkinId", vo);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<SplashVO> selectSplashManagePaging(SplashSO so) {
        // 기본 조회시 정렬값 기본 셋팅
        if (so.getSidx().length() == 0 && so.getSord().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        // 스킨리스트 조회
        return proxyDao.selectListPage(MapperConstants.DESIGN_SKIN + "selectSplashManagePaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<SplashVO> selectSplashManage(SplashSO so) throws Exception {
        // 스플래시 상세 조회
        SplashVO vo = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSplashManage", so);

        log.info("vo = "+vo);
        ResultModel<SplashVO> result = new ResultModel<SplashVO>(vo);

        return result;
    }

    @Override
    public ResultModel<SplashPO> insertSplashManage(SplashPO po) throws Exception {
        // splash 등록
        ResultModel<SplashPO> result = new ResultModel<>();

        try {

            // splash번호 시퀀시 조회
            Long splashNo = bizService.getSequence("TD_SPLASH", po.getSiteNo());

            po.setSplashNo(splashNo);

            // splash 등록 데이터 처리
            proxyDao.insert(MapperConstants.DESIGN_SKIN + "insertSplashManage", po);
            // 정상처리 메세지
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스플래시관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<SplashPO> updateSplashManage(SplashPO po) throws Exception {
        ResultModel<SplashPO> result = new ResultModel<>();
        // splash 수정
        try {
            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            SplashVO voVal = new SplashVO();
            if (StringUtils.isNotEmpty(po.getFileNm())) {
                // 데이터 조회
                voVal = proxyDao.selectOne(MapperConstants.DESIGN_SKIN + "selectSplashManage", po);
            }

            // splash 수정 데이터 처리
            proxyDao.update(MapperConstants.DESIGN_SKIN + "updateSplashManage", po);

            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            if (!po.getFileNm().equals(voVal.getFileNm())) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getFilePath())) && !"".equals(StringUtil.nvl(voVal.getFileNm()))) {
                    // 이미지 삭제
                    String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_SPLASH);
                    File file = new File(deletePath + voVal.getFilePath() + File.separator + voVal.getFileNm());
                    if (file.exists()) { // 존재한다면 삭제
                        FileUtil.delete(file);
                    }
                }
            }

            // 정상처리 메세지 호출
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스플래시관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<SplashPO> deleteSplashManage(SplashPOListWrapper wrapper) throws Exception {
        ResultModel<SplashPO> result = new ResultModel<>();
        // 팝업 삭제
        try {
            String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_SPLASH);
            for (SplashPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                // 이미지 삭제
                File file = new File(deletePath + po.getFilePath() + File.separator + po.getFileNm());
                if (file.exists()) { // 존재한다면 삭제
                    FileUtil.delete(file);
                }

                // 팝업 삭제
                proxyDao.delete(MapperConstants.DESIGN_SKIN + "deleteSplashManage", po);
            }

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스플래시관리" }, e);
        }
        return result;
    }
}
