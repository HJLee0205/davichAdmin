package net.danvi.dmall.biz.batch.sttcs.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class ProcRunnerVO implements Serializable {

    private static final long serialVersionUID = -3878977625541451017L;

    private String btId; // 배치ID
    private String btPgmId; // 배치프로그램ID
    private String btPgmNm; // 배치프로그램명

    private String startIfSno; // 시작배치일련번호
    private String endIfSno; // 종료배치일련번호
    private String resultContent; // 결과내용
}
