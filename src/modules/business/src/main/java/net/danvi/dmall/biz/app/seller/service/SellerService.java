package net.danvi.dmall.biz.app.seller.service;

import java.util.List;

import net.danvi.dmall.biz.app.goods.model.GoodsSO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.model.SellerVOListWrapper;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.setup.delivery.model.*;

import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2017. 11. 20.
 * 작성자     : 김현열
 * 설명       :
 * </pre>
 */

public interface SellerService {

    public ResultListModel<SellerVO> selectSellerList(SellerSO sellerSO);
    public int checkDuplicationId(SellerSO sellerSO);
    public ResultModel<SellerVO> saveSeller(SellerPO sellerPO);
    public ResultModel<SellerVO> selectSellerInfo(SellerSO sellerSO);
    public List<SellerVO> selectSellerListExcel(SellerSO sellerSO);
    public List<SellerVO> getSellerList(SellerSO sellerSO);
    public ResultModel<AtchFilePO> deleteAtchFile(SellerVO vo)  throws Exception; 
    public FileVO selectAtchFileDtl(SellerVO so) throws Exception;
    public ResultModel<SellerVO> updateSellerSt(SellerVOListWrapper wrapper) throws Exception;
    public ResultModel<SellerVO> deleteSellerSt(SellerVOListWrapper wrapper) throws Exception;
    public ResultModel<SellerVO> viewMemInfoDtl(MemberManageSO memberManageSO);

    public ResultModel<DeliveryConfigVO> selectDeliveryConfig(SellerPO po);
    public ResultModel<DeliveryConfigPO> updateDeliveryConfig(DeliveryConfigPO po) throws Exception;
    public ResultListModel<DeliveryAreaVO> selectDeliveryListPaging(DeliveryAreaSO so);
    public ResultModel<DeliveryAreaPO> insertDeliveryArea(DeliveryAreaPO po) throws Exception;
    public ResultModel<DeliveryAreaPO> updateDeliveryArea(DeliveryAreaPO po) throws Exception;
    public ResultModel<DeliveryAreaPO> updateApplyDefaultDeliveryArea(DeliveryAreaPO po) throws Exception;
    public ResultModel<DeliveryAreaPO> deleteDeliveryArea(DeliveryAreaPOListWrapper wrapper);
    public ResultModel<DeliveryAreaPO> deleteAllDeliveryArea(DeliveryAreaPO po);
    public ResultListModel<HscdVO> selectHscdListPaging(HscdSO so);
    public ResultModel<HscdPO> updateHscd(HscdPO po) throws Exception;
    public ResultModel<HscdPO> deleteHscd(HscdPO po) throws Exception;
    public ResultModel<SellerPO> insertSellerReply(SellerPO po, HttpServletRequest request) throws Exception;
}
