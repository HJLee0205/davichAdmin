package net.danvi.dmall.biz.batch.link.sabangnet.model.request;

import lombok.Data;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;
import dmall.framework.common.annotation.CDATA;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 상품등록 DATA 클래스
 * </pre>
 */
@Data
public class Goods extends SabangnetData {
    private static final long serialVersionUID = -4047625213155635805L;

    @CDATA
    String goodsNm;
    @CDATA
    String modelNm;
    @CDATA
    String brandNm;
    @CDATA
    String compaynyGoodsCd;
    @CDATA
    String goodsSearch;
    String goodsGubun;
    @CDATA
    String classCd1;
    @CDATA
    String classCd2;
    @CDATA
    String classCd3;
    @CDATA
    String classCd4;
    @CDATA
    String maker;
    @CDATA
    String origin;
    @CDATA
    String makeYear;
    @CDATA
    String makeDm;
    String goodsSeason;
    String sex;
    String status;
    String taxYn;
    String delvType;
    String delvCost;
    String goodsCost;
    String goodsPrice;
    String goodsConsumerPrice;
    @CDATA
    String char1Nm;
    @CDATA
    String char1Val;
    @CDATA
    String char2Nm;
    @CDATA
    String char2Val;
    @CDATA
    String imgPath;
    @CDATA
    String imgPath1;
    @CDATA
    String imgPath2;
    @CDATA
    String imgPath3;
    @CDATA
    String imgPath4;
    @CDATA
    String imgPath5;
    @CDATA
    String goodsRemarks;
    String material;
    @CDATA
    String stockUseYn;
    @CDATA
    String optType;
    String propEditYn;
    String prop1Cd;
    @CDATA
    String propVal1;
    @CDATA
    String propVal2;
    @CDATA
    String propVal3;
    @CDATA
    String propVal4;
    @CDATA
    String propVal5;
    @CDATA
    String propVal6;
    @CDATA
    String propVal7;
    @CDATA
    String propVal8;
    @CDATA
    String propVal9;
    @CDATA
    String propVal10;
    @CDATA
    String propVal11;
    @CDATA
    String propVal12;
    @CDATA
    String propVal13;
    @CDATA
    String propVal14;
    @CDATA
    String propVal15;
    @CDATA
    String propVal16;
    @CDATA
    String propVal17;
    @CDATA
    String propVal18;
    @CDATA
    String propVal19;
    @CDATA
    String propVal20;
    @CDATA
    String propVal21;
    @CDATA
    String propVal22;
    @CDATA
    String propVal23;
    @CDATA
    String propVal24;
    @CDATA
    String importno;
    @CDATA
    String regStDate;
    @CDATA
    String regEdDate;
    @CDATA
    String lang;
    @CDATA
    String goodsField;
}
