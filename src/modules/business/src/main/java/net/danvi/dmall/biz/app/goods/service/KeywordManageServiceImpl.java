package net.danvi.dmall.biz.app.goods.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : keyword 정보 관리 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("keywordManageService")
@Transactional(rollbackFor = Exception.class)
public class KeywordManageServiceImpl extends BaseService implements KeywordManageService {

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectKeywordList(KeywordSO keywordSO) {

        keywordSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectKeywordList : getSiteNo {}", keywordSO.getSiteNo());
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectKeywordList", keywordSO);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectKeywordList1depth(KeywordSO keywordSO) {

        keywordSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectKeywordList1depth : getSiteNo {}", keywordSO.getSiteNo());
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectKeywordList1depth", keywordSO);
    }

    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectKeywordListDepth(KeywordSO keywordSO) {

        keywordSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectKeywordListDepth : getSiteNo {}", keywordSO.getSiteNo());
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectKeywordListDepth", keywordSO);
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectKeywordGoodsYn(KeywordPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.KEYWORD_MANAGE + "selectKeywordGoodsYn", po);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectCpYn(KeywordPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.KEYWORD_MANAGE + "selectCpYn", po);
        return result;
    }

    @Override
    public ResultModel<KeywordPO> deleteKeyword(KeywordPO po) {
        ResultModel<KeywordPO> result = new ResultModel<>();
        try {
            // 하위 keyword 번호 조회
            List<Integer> ctgNoList = selectChildKeywordNo(po);
            log.info("deleteKeyword : ctgNoList {}", ctgNoList);
            File dFile;

            po.setChildKeywordNoList(ctgNoList);
            log.info("deleteKeyword : param {}", po);
            KeywordSO so = new KeywordSO();
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            so.setKeywordNo(po.getKeywordNo());
            int cnt = proxyDao.selectOne(MapperConstants.KEYWORD_MANAGE + "existsKeywordGoods", so);
            if(cnt > 0) {
                // 상품 keyword 삭제
                proxyDao.delete(MapperConstants.KEYWORD_MANAGE + "deleteKeywordGoods", po);
            }
            // keyword 삭제
            proxyDao.delete(MapperConstants.KEYWORD_MANAGE + "deleteKeyword", po);

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public List<Integer> selectChildKeywordNo(KeywordPO po) {
        List<Integer> ctgNoList = proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectChildKeywordNo", po);
        return ctgNoList;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<KeywordVO> selectKeyword(KeywordSO so) {

        log.info("selectKeyword  :{}", so);
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        KeywordVO vo = proxyDao.selectOne(MapperConstants.KEYWORD_MANAGE + "selectKeyword", so);
        log.info("selectKeyword  vo :{}", vo);
        //vo.setKeywordImgPath(StringUtil.replaceAll(vo.getKeywordImgNm(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        //log.info("selectKeyword  vo 2 :{}", vo);
        /*if (vo.getKeywordImgPath() != null && vo.getKeywordImgPath().length() > 0) {
            // 이미지 파일 가로, 세로 크기
            Image img = new ImageIcon(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator + UploadConstants.PATH_CTG + File.separator
                            + vo.getKeywordImgPath().substring(0, 4) + File.separator + vo.getKeywordImgPath().substring(4, 6)
                            + File.separator + vo.getKeywordImgPath().substring(6) + File.separator + vo.getKeywordImgNm())).getImage();

            vo.setKeywordNmImgWidth(Integer.toString(img.getWidth(null)));
            vo.setKeywordNmImgHeight(Integer.toString(img.getHeight(null)));

        } else {
            vo.setKeywordNmImgWidth("000");
            vo.setKeywordNmImgHeight("000");
        }*/

        /*if (vo.getMouseoverImgPath() != null && vo.getMouseoverImgPath().length() > 0) {
            // 이미지 파일 가로, 세로 크기
            Image img = new ImageIcon(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
                    + UploadConstants.PATH_CTG + File.separator + vo.getMouseoverImgPath().substring(0, 4)
                    + File.separator + vo.getMouseoverImgPath().substring(4, 6) + File.separator
                    + vo.getMouseoverImgPath().substring(6) + File.separator + vo.getMouseoverImgNm())).getImage();
            vo.setMouseoverImgWidth(Integer.toString(img.getWidth(null)));
            vo.setMouseoverImgHeight(Integer.toString(img.getHeight(null)));
        } else {
            vo.setMouseoverImgWidth("000");
            vo.setMouseoverImgHeight("000");
        }*/

        /*// keyword 상품, 판매중인 상품 갯수 조회 resultModel
        ResultModel<KeywordVO> ctgGoodsCnt = new ResultModel<>();
        // keyword 상품, 판매중인 상품 갯수 조회
        ctgGoodsCnt = selectKeywordGoodsCnt(so);

        if (ctgGoodsCnt.getData() != null) {
            // keyword에 등록된 상품 갯수
            if (ctgGoodsCnt.getData().getKeywordGoodsCnt() != null) {
                vo.setKeywordGoodsCnt(ctgGoodsCnt.getData().getKeywordGoodsCnt());
            }
            // keyword에 등록된 판매중인 상품 갯수
            if (ctgGoodsCnt.getData().getKeywordSalesGoodsCnt() != null) {
                vo.setKeywordSalesGoodsCnt(ctgGoodsCnt.getData().getKeywordSalesGoodsCnt());
            }
        }*/

        // 에디터 파일 정보 조회
        // 이미지 디비 정보 조회 조건 세팅
        /*CmnAtchFileSO atchFileso = new CmnAtchFileSO();
        atchFileso.setSiteNo(so.getSiteNo());
        atchFileso.setRefNo(so.getKeywordNo());
        atchFileso.setFileGb("TG_CTG");

        // 공통 첨부 파일 조회하여 VO에 담는다.
        editorService.setCmnAtchFileToEditorVO(atchFileso, vo);*/

        ResultModel<KeywordVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsVO> selectKeywordGoodsList(KeywordSO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectKeywordGoodsList so = "+so);
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectKeywordGoodsList", so);
    }

    @Override
    public ResultModel<KeywordPO> updateKeyword(KeywordPO po) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<KeywordPO> result = new ResultModel<>();

        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();

        KeywordSO so = new KeywordSO();
        so.setSiteNo(siteNo);
        so.setKeywordNo(po.getKeywordNo());
        int cnt = proxyDao.selectOne(MapperConstants.KEYWORD_MANAGE + "existsKeywordGoods", so);

        if(cnt > 0) {
            proxyDao.delete(MapperConstants.KEYWORD_MANAGE + "deleteKeywordGoods", so);
        }

        if(po.getInsKeywordGoodsNoList() != null && po.getInsKeywordGoodsNoList().length > 0) {
            String[] keywordNoArr = po.getInsKeywordGoodsNoList();
            for (int i = 0; i < keywordNoArr.length; i++) {

                KeywordPO keywordPO = new KeywordPO();
                keywordPO.setKeywordNo(po.getKeywordNo());
                keywordPO.setSiteNo(siteNo);
                keywordPO.setGoodsNo(keywordNoArr[i]);
                keywordPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                proxyDao.insert(MapperConstants.KEYWORD_MANAGE + "insertKeywordGoods", keywordPO);
            }
        }

        proxyDao.update(MapperConstants.KEYWORD_MANAGE + "updateKeyword", po);

        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    @Override
    public ResultModel<KeywordPO> insertKeyword(KeywordPO po) {
        ResultModel<KeywordPO> result = new ResultModel<>();
        Long keywordNo = (long) 0;
        try {
            keywordNo = bizService.getSequence("KEYWORD_NO", po.getSiteNo());

            log.info("insertKeyword keywordNo :{}", keywordNo);
            log.info("insertKeyword po :{}", po);

            po.setKeywordNo(String.valueOf(keywordNo));
            proxyDao.insert(MapperConstants.KEYWORD_MANAGE + "insertKeyword", po);

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
        	e.printStackTrace();
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }
        return result;
    }

    // @Override
    // public List<DisplayGoodsVO> selectKeywordGoodsList(KeywordSO so) {
    // return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectKeywordGoodsList", so);
    // }

    // @Override
    // public ResultModel<KeywordPO> updateKeywordGoodsDispYn(KeywordPO po) {
    // ResultModel<KeywordPO> result = new ResultModel<>();
    //
    // proxyDao.update(MapperConstants.KEYWORD_MANAGE + "updateKeywordGoodsDispYn", po);
    //
    // result.setMessage(MessageUtil.getMessage("biz.common.update"));
    // return result;
    // }

    // @Override
    // public ResultModel<KeywordPO> updateKeywordShowGoodsManage(KeywordPO po) {
    // ResultModel<KeywordPO> result = new ResultModel<>();
    //
    // if (po.getDispGoodsExpsYn() == null || po.getDispGoodsExpsYn() == "") {
    // po.setDispGoodsExpsYn("N");
    // }
    //
    // if (po.getNoDispGoodsExpsYn() == null || po.getNoDispGoodsExpsYn() == "") {
    // po.setNoDispGoodsExpsYn("N");
    // }
    //
    // if (po.getSalemediumGoodsExpsYn() == null || po.getSalemediumGoodsExpsYn() == "") {
    // po.setSalemediumGoodsExpsYn("N");
    // }
    //
    // if (po.getSalestnbyGoodsExpsYn() == null || po.getSalestnbyGoodsExpsYn() == "") {
    // po.setSalestnbyGoodsExpsYn("N");
    // }
    //
    // // 사용자 지정 상품 정렬 인 경우
    // if (po.getExpsGoodsSortCd().equals("6")) {
    // // keyword 상품 삭제 후 노출 우선 순위에 따라 Insert
    // proxyDao.delete(MapperConstants.KEYWORD_MANAGE + "deleteShowGoods", po);
    //
    // String[] goodsNoArr = po.getGoodsNoArr();
    // String[] dispYnArr = po.getDispYnArr();
    // String[] dlgtKeywordYnArr = po.getDlgtKeywordYnArr();
    // for (int i = 0; i < goodsNoArr.length; i++) {
    // po.setGoodsNo(goodsNoArr[i]);
    // po.setDispYn(dispYnArr[i]);
    // po.setDlgtKeywordYn(dlgtKeywordYnArr[i]);
    // po.setExpsPriorRank(Integer.toString(i + 1));
    //
    // proxyDao.insert(MapperConstants.KEYWORD_MANAGE + "insertShowGoods", po);
    // }
    // }
    //
    // proxyDao.update(MapperConstants.KEYWORD_MANAGE + "updateKeywordShowGoodsManage", po);
    //
    // result.setMessage(MessageUtil.getMessage("biz.common.update"));
    // return result;
    // }

    /** 전체keyword 목록을 조회 **/
    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectFrontGnbList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectFrontGnbList", siteNo);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectFrontLnbList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectFrontLnbList", siteNo);
    }

    /** 네이게이션 (하위에서 상위조회) **/
    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectUpNavagation(KeywordSO so) {
        KeywordVO cv = new KeywordVO();// keyword 정보 조회(상위keyword 조회시 keyword 레벨필요)
        cv = proxyDao.selectOne(MapperConstants.KEYWORD_MANAGE + "selectNavigationInfo", so);
        so.setKeywordNm(cv.getKeywordNm());
        so.setKeywordLvl(cv.getKeywordLvl());
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectUpNavagation", so);
    }

    /** 동일 상위,레벨 keyword 조회 **/
    @Override
    @Transactional(readOnly = true)
    public List<KeywordVO> selectNavigationList(KeywordSO so) {
        return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectNavigationList", so);
    }
    
    @Override
    public ResultModel<KeywordPO> updateKeywordSort(KeywordPO po) {
        ResultModel<KeywordPO> result = new ResultModel<>();
        try {
	        // 순번 초기화
	        proxyDao.update(MapperConstants.KEYWORD_MANAGE + "keywordSortInit", po);
	        
	        // 선택 keyword 순번 업데이트
	        proxyDao.update(MapperConstants.KEYWORD_MANAGE + "updateKeywordSort", po);
	        
	        // 순번 재정렬
	        proxyDao.update(MapperConstants.KEYWORD_MANAGE + "keywordSortSetting", po);
	        
	        // 하위 keyword LEVEL 재정렬
	        if(!"".equals(po.getDownKeywordNo())) {	// 하위 keyword가 존재할 경우
		        int orgLvl = Integer.parseInt(po.getOrgKeywordLvl()); // 기존 LEVEL
		        int newLvl = Integer.parseInt(po.getKeywordLvl());	  // 변경 LEVEL
		        int calcLvl = newLvl - orgLvl; // 이동한 LEVEL
		        
		        if(calcLvl != 0) {
		        	po.setCalcLvl(calcLvl);
		        	proxyDao.update(MapperConstants.KEYWORD_MANAGE + "keywordLvlSetting", po);
		        }
	        }

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        
        return result;

    }
    
    @Override
    public List<KeywordVO> selectMainDispGoodsList(KeywordPO keywordPO) {
    	return proxyDao.selectList(MapperConstants.KEYWORD_MANAGE + "selectMainDispGoodsList", keywordPO);
    }
    
}
