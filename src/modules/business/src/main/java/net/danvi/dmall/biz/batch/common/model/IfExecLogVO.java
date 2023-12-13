package net.danvi.dmall.biz.batch.common.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class IfExecLogVO implements Serializable {
    private static final long serialVersionUID = -5868615968347416367L;

    private String ifSno;
    private String ifNo;
    private String ifPgmNm;
    private Long siteNo;
    private String sucsYn;
    private String errCd;
    private String resultContent;
    private String execKey;
    private String execConts;
    private String logFilePath;
    private String logFileNm;
    private Long regrNo;
    private Long updrNo;

    private String srchKey;
}
