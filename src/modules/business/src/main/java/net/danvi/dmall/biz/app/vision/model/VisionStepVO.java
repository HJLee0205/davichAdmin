package net.danvi.dmall.biz.app.vision.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 10. 11.
 * 작성자     : yji
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionStepVO {
	private int visionNo;
    private String visionGb;
    private String ageCd;
    private String step1Cd;
    private String step2Cd;
    private String step3Cd;
    private String step4Cd;
    private String step5Cd;
    private String step6Cd;
    private String step7Cd;
    private String step8Cd;
    private String step9Cd;
    private String step10Cd;
    private String stepFullNm;
    private int sortSeq;
    private String useYn;    

    private String ageNm;
    private String step1Nm;
    private String step2Nm;
    private String step3Nm;
    private String step4Nm;
    private String step5Nm;
    private String step6Nm;
    private String step7Nm;
    private String step8Nm;
    private String step9Nm;
    private String step10Nm;
    
    private String checkNos;
    private String relateActivity;
    private String grpCd;
    private String stepCds;
    
    private String cd;
    private String cdNm;
}
