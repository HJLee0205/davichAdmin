package net.danvi.dmall.biz.app.design.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.*;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.File;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2023. 01. 17.
 * 작성자     : slims
 * 설명       : 아이콘관리 service
 * </pre>
 */
@Slf4j
@Service("iconManageService")
@Transactional(rollbackFor = Exception.class)
public class IconManageServiceImpl extends BaseService implements IconManageService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<IconVO> selectSkinList(IconSO so) {

        // 스킨리스트 조회 - 셀렉트 박스에서 조회할 스킨 정보조회
        List<SkinVO> temp = proxyDao.selectList(MapperConstants.DESIGN_ICON + "selectIconSkin", so);

        ResultListModel<IconVO> resultListModel = new ResultListModel<IconVO>();
        resultListModel.put("skinList", temp);

        return resultListModel;
    }

    @Override
    @Transactional(readOnly = true)
    public List<IconVO> selectIconList(IconSO so) {
        // icon 리스트 조회
        return proxyDao.selectList(MapperConstants.DESIGN_ICON + "selectIconList", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<IconVO> selectIconListPaging(IconSO so) {
        // icon 기본 조회시 정렬값 기본 셋팅
        if (so.getSidx().length() == 0 && so.getSord().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        //PC & MOBILE의 Full width main icon일 경우 icon 갯수 제한 없음
        /*if("MB1".equals(so.getIconAreaCd()) || "MMV".equals(so.getIconAreaCd())) {
        	so.setRows(100);
        }*/
        // icon 리스트 페이징 처리
        ResultListModel<IconVO> resultListModel = proxyDao.selectListPage(MapperConstants.DESIGN_ICON + "selectIconPaging", so);
        if(resultListModel.getResultList() != null && resultListModel.getResultList().size() > 0) {
            for (Object iconVO : resultListModel.getResultList()) {
                if(StringUtil.isNotEmpty(((IconVO) iconVO).getGoodsTypeCd())) {
                    ((IconVO) iconVO).setGoodsTypeCdArr(((IconVO) iconVO).getGoodsTypeCd().split(","));
                }
            }
        }
        return resultListModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<IconVO> viewIconDtl(IconSO so) {
        // icon 상세
        // 상세에 보여줄 스킨리스트 조회
        //List<SkinVO> temp = proxyDao.selectList(MapperConstants.DESIGN_ICON + "selectIconSkin", so);
        // IconVO vo = new IconVO();
        // icon 상세 정보 조회
        IconVO vo = proxyDao.selectOne(MapperConstants.DESIGN_ICON + "selectIcon", so);
        //vo.setSkinList(temp);
        log.info("vo = " + vo);

        ResultModel<IconVO> result = new ResultModel<IconVO>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<IconVO> viewIconDtlNew(IconSO so) {

        // icon 등록
        // icon 등록에 보여줄 스킨리스트 조회
        List<SkinVO> temp = proxyDao.selectList(MapperConstants.DESIGN_ICON + "selectIconSkin", so);
        IconVO vo = new IconVO();
        // IconVO vo = proxyDao.selectOne(MapperConstants.DESIGN_ICON +
        // "selectIcon", so);
        //vo.setSkinList(temp);

        ResultModel<IconVO> result = new ResultModel<IconVO>(vo);

        return result;
    }

    @Override
    public ResultModel<IconPO> insertIcon(IconPO po) throws Exception {
        ResultModel<IconPO> result = new ResultModel<>();

        try {

            // icon 시퀀스 정보 가져오기
            Long iconNo = bizService.getSequence("ICON_NO");

            po.setIconNo(iconNo);

            // icon 등록
            proxyDao.insert(MapperConstants.DESIGN_ICON + "insertIcon", po);

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "Icon관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<IconPO> updateIcon(IconPO po) throws Exception {
        ResultModel<IconPO> result = new ResultModel<>();

        try {

            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            IconVO voVal = new IconVO();
            if (po.getImgSize() != null && po.getImgSize() > 0) {
                // 데이터 조회
                voVal = proxyDao.selectOne(MapperConstants.DESIGN_ICON + "selectIcon", po);
            }

            // icon 수정
            proxyDao.update(MapperConstants.DESIGN_ICON + "updateIcon", po);

            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            if (po.getImgSize() != null && po.getImgSize() > 0) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getImgPath())) && !"".equals(StringUtil.nvl(voVal.getImgNm()))) {
                    // 이미지 삭제
                    String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_ICON);
                    File file = new File(deletePath + voVal.getImgPath() + File.separator + voVal.getImgNm());
                    if (file.exists()) { // 존재한다면 삭제
                        FileUtil.delete(file);
                    }
                }
            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    public ResultModel<IconPO> updateIconView(IconPOListWrapper wrapper) throws Exception {
        ResultModel<IconPO> result = new ResultModel<>();

        try {
            // icon 전시 미전시 리스트에서 선택된 정보만 처리하도록 loop 처리
            for (IconPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                // 전시 미전시 데이터 업데이트
                proxyDao.update(MapperConstants.DESIGN_ICON + "updateIconView", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    public ResultModel<IconPO> updateIconSort(IconPOListWrapper wrapper) throws Exception {
        ResultModel<IconPO> result = new ResultModel<>();

        try {
            // icon 순서저장 리스트에서 선택된 정보만 처리하도록 loop 처리
            for (IconPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                // icon 순서정보 데이터 업데이트
                proxyDao.update(MapperConstants.DESIGN_ICON + "updateIconSort", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    public ResultModel<IconPO> deleteIcon(IconPOListWrapper wrapper) throws Exception {
        ResultModel<IconPO> result = new ResultModel<>();

        try {
            // icon 삭제
            // icon 이미지 삭제 경로
            String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_ICON);
            for (IconPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                // 이미지 삭제
                File file = new File(deletePath + po.getImgPath() + File.separator + po.getImgNm());
                if (file.exists()) { // 존재한다면 삭제
                    FileUtil.delete(file);
                }

                // icon 데이터 삭제
                proxyDao.delete(MapperConstants.DESIGN_ICON + "deleteIcon", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<GoodsVO> selectIconGoodsList(IconSO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        log.info("selectIconGoodsList so = "+so);

        ResultListModel<GoodsVO> result = proxyDao.selectListPage(MapperConstants.DESIGN_ICON + "selectIconGoodsList", so);

        return result;
    }
}
