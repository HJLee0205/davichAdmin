package net.danvi.dmall.biz.app.operation.model;

import java.util.List;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PushSendVO extends BaseModel<PushSendVO> {
	private Integer rowNum;
	private Integer pagingNum;
	private String pushNo;
	private String sendType;
	private String alarmGb;
	private String alarmGbNm;
	private String senderNo;
	@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
	private String senderNm;
	private String sendMsg;
	private String link;
	private String sendCnt;
	private String recvCndtGb;
	private String pushStatus;
	private String pushStatusNm;
	private String sendDttm;
	private String cancelerNo;
	private String cancelDttm;
	private String dateSetup;
	private String timeSetup;
	
	private String receiverNo;
	private String receiverId;
	private String receiverNm;
	private String appToken;
	private String srchCndt;
	
	private String sendDate;
	private String sendTime;
	
	private String regDate;
	private String updDate;
	
	private List<PushSendVO> list;
	
	private String confCnt;
	private String confRate;
	
	private String filePath;
	private String fileNm;
	private String orgFileNm;
	private String imgUrl;
	private String osType;
	
	private Integer ordCnt;
	private Integer visitCnt;
			 
}
