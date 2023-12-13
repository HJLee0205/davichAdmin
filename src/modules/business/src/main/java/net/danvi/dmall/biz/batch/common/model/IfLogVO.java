package net.danvi.dmall.biz.batch.common.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class IfLogVO implements Serializable {
    private static final long serialVersionUID = -5868615968347416367L;

    private String ifNo; // 연계 번호
    private String ifId;
    private Long siteNo;
    private String siteId;
    private String siteNm;
    private String ifPgmId;
    private String ifPgmNm;
    private String ifGbCd;
    private String upIfNo;
    private String startIfSno;
    private String endIfSno;
    private String sucsYn;
    private String errCd;
    private String resultContent;
    private Long dataCnt;
    private Long dataTotCnt;
    private String startKey;
    private String endKey;
    private String sendConts;
    private String recvConts;
    private Long regrNo;
    private Long updrNo;

    private String mediaCd;
}
