package net.danvi.dmall.biz.app.board.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 게시판 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BbsCmntManageVO extends BaseModel<BbsCmntManageVO> {
    private String cmntSeq; // 댓글 번호
    private String lettNo; // 글 번호
    private String content; // 내용
    private String cmntSectYn; // 댓글 비밀 여부
    private String memberNn; // 등록자 닉네임
    private String bbsId; // 게시판 아이디
    private String memberGradeNm; // 회원 등급 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId; // 로그인 아이디

    private String num;
    private String rowNum;
}
