package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;

import net.danvi.dmall.biz.system.validation.InsertGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       : 재입고 알립 정보 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class RestockNotifyPO extends BaseModel<RestockNotifyPO> {

    // 재입고 알림 번호
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long reinwareAlarmNo;
    // 상품 번호
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String goodsNo;
    // 회원 번호
    @NotNull(groups = { InsertGroup.class, UpdateGroup.class })
    private Long memberNo;
    // 재입고 알림 수신 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    // 재입고 알림 상태 코드
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String alarmStatusCd;
    // 재입고 알림 일시
    private String alarmDttm;
    // 재등록 여부
    private String reInsertYn;

    // 상품명
    private String goodsNm;
    // SMS 수신자 전화번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String recvTelNo;
    // SMS 회원
    private String receiverNo;
    // SMS 수신자명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverNm;
    // SMS 송신문구
    private String sendWords;
    // 관리자메모
    private String managerMemo;

    private int sendCnt;
}
