package net.danvi.dmall.admin.web.common.util;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;

public class GoodsImageResizer {

    /** 원본 이미지 객체 */
    private final BufferedImage originalImage;
    /** 원본 이미지 path */
    private final String orgImgPath;
    /** image type enum */
    private final GoodsImageType imageType;
    /** 생성파일 List */
    private final List<File> destFileList;

    private final int goodsDetailWidth;

    private final int goodsDetailHeight;

    private final int goodsListWidth;

    private final int goodsListHeight;

    private final int dispWidthTypeA;

    private final int dispHeightTypeA;

    private final int dispWidthTypeB;

    private final int dispHeightTypeB;

    private final int dispWidthTypeC;

    private final int dispHeightTypeC;

    private final int dispWidthTypeD;

    private final int dispHeightTypeD;

    private final int dispWidthTypeE;

    private final int dispHeightTypeE;

    private final int dispWidthTypeF;

    private final int dispHeightTypeF;

    private final int dispWidthTypeG;

    private final int dispHeightTypeG;

    private final int dispWidthTypeS;

    private final int dispHeightTypeS;

    private final int dispWidthTypeM;

    private final int dispHeightTypeM;
    
    private final int dispWidthTypeO;

    private final int dispHeightTypeO;
    
    private final int dispWidthTypeP;

    private final int dispHeightTypeP;

    private final int goodsWearWidthL;

    private final int goodsWearHeightL;

    private final int goodsWearWidthR;

    private final int goodsWearHeightR;

    private final int  goodsLensWidthL;
    private final int  goodsLensHeightL;
    private final int  goodsLensWidthR;
    private final int  goodsLensHeightR;

    /**
     * constructor
     *
     * @throws IOException
     */
    public GoodsImageResizer(GoodsImageInfoData data) throws IOException {
        orgImgPath = data.getOrgImgPath();
        imageType = data.getGoodsImageType();

        goodsDetailWidth = data.getWidthForGoodsDetail();
        goodsDetailHeight = data.getHeightForGoodsDetail();
        goodsListWidth = data.getWidthForGoodsThumbnail();
        goodsListHeight = data.getHeightForGoodsThumbnail();

        dispWidthTypeA = data.getWidthForDispTypeA();
        dispHeightTypeA = data.getHeightForDispTypeA();
        dispWidthTypeB = data.getWidthForDispTypeB();
        dispHeightTypeB = data.getHeightForDispTypeB();
        dispWidthTypeC = data.getWidthForDispTypeC();
        dispHeightTypeC = data.getHeightForDispTypeC();
        dispWidthTypeD = data.getWidthForDispTypeD();
        dispHeightTypeD = data.getHeightForDispTypeD();
        dispWidthTypeE = data.getWidthForDispTypeE();
        dispHeightTypeE = data.getHeightForDispTypeE();

        dispWidthTypeF = data.getWidthForDispTypeF();
        dispHeightTypeF = data.getHeightForDispTypeF();
        dispWidthTypeG = data.getWidthForDispTypeG();
        dispHeightTypeG = data.getHeightForDispTypeG();
        dispWidthTypeS = data.getWidthForDispTypeS();
        dispHeightTypeS = data.getHeightForDispTypeS();

        dispWidthTypeM = data.getWidthForDispTypeM();
        dispHeightTypeM = data.getHeightForDispTypeM();
        
        dispWidthTypeO = data.getWidthForDispTypeO();
        dispHeightTypeO = data.getHeightForDispTypeO();

        dispWidthTypeP = data.getWidthForDispTypeP();
        dispHeightTypeP = data.getHeightForDispTypeP();

        goodsWearWidthL = data.getWidthForWearL();
        goodsWearHeightL = data.getHeightForWearL();

        goodsWearWidthR = data.getWidthForWearR();
        goodsWearHeightR = data.getHeightForWearR();

        goodsLensWidthL = data.getWidthForLensL();
        goodsLensHeightL = data.getHeightForLensL();

        goodsLensWidthR = data.getWidthForLensR();
        goodsLensHeightR = data.getHeightForLensR();

        originalImage = ImageIO.read(new File(orgImgPath));
        destFileList = new ArrayList<File>();
        data.setDestFileList(destFileList);
    }

    /**
     * <pre>
     * process
     * 이미지 resize process
     *
     * <pre>
     *
     * @throws IOException
     */
    public void process() throws Exception {
        int type = getImgType();
        String imgFormat = imageType.imgFormat();
        List<String> imgSizeList = imageType.imageSizeList();
        if (imageType == GoodsImageType.GOODS_IMAGE_TYPE_A) {
            imgSizeList.add(this.goodsDetailWidth + "x" + this.goodsDetailHeight + "x02");
        } else if (imageType == GoodsImageType.GOODS_IMAGE_TYPE_B) {
            imgSizeList.add(this.goodsListWidth + "x" + this.goodsListHeight + "x03");
            // 사은품에서 사용 이미지 사이즈 확인 필요 (고정일 경우 고정 값, 가변일 경우 설정 값 롹인)
        } else if (imageType == GoodsImageType.GOODS_IMAGE) {
            imgSizeList.add(this.goodsDetailWidth + "x" + this.goodsDetailHeight + "x02");
            imgSizeList.add(this.goodsListWidth + "x" + this.goodsListHeight + "x03");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_A) {
            imgSizeList.add(this.dispWidthTypeA + "x" + this.dispHeightTypeA + "xA");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_B) {
            imgSizeList.add(this.dispWidthTypeB + "x" + this.dispHeightTypeB + "xB");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_C) {
            imgSizeList.add(this.dispWidthTypeC + "x" + this.dispHeightTypeC + "xC");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_D) {
            imgSizeList.add(this.dispWidthTypeD + "x" + this.dispHeightTypeD + "xD");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_E) {
            imgSizeList.add(this.dispWidthTypeE + "x" + this.dispHeightTypeE + "xE");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_F) {
            imgSizeList.add(this.dispWidthTypeF + "x" + this.dispHeightTypeF + "xF");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_G) {
            imgSizeList.add(this.dispWidthTypeG + "x" + this.dispHeightTypeG + "xG");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_S) {
            imgSizeList.add(this.dispWidthTypeS + "x" + this.dispHeightTypeS + "xS");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_M) {
            imgSizeList.add(this.dispWidthTypeM + "x" + this.dispHeightTypeM + "xM");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_O) {
            imgSizeList.add(this.dispWidthTypeO + "x" + this.dispHeightTypeO + "xO");
        } else if (imageType == GoodsImageType.DISP_IMAGE_TYPE_P) {
            imgSizeList.add(this.dispWidthTypeP + "x" + this.dispHeightTypeP + "xP");
        }else if (imageType == GoodsImageType.DISP_IMAGE) {
            imgSizeList.add(this.dispWidthTypeA + "x" + this.dispHeightTypeA + "xA");
            imgSizeList.add(this.dispWidthTypeB + "x" + this.dispHeightTypeB + "xB");
            imgSizeList.add(this.dispWidthTypeC + "x" + this.dispHeightTypeC + "xC");
            imgSizeList.add(this.dispWidthTypeD + "x" + this.dispHeightTypeD + "xD");
            imgSizeList.add(this.dispWidthTypeE + "x" + this.dispHeightTypeE + "xE");
            imgSizeList.add(this.dispWidthTypeF + "x" + this.dispHeightTypeF + "xF");
            imgSizeList.add(this.dispWidthTypeG + "x" + this.dispHeightTypeG + "xG");
            imgSizeList.add(this.dispWidthTypeS + "x" + this.dispHeightTypeS + "xS");
            imgSizeList.add(this.dispWidthTypeM + "x" + "0xM");
            imgSizeList.add(this.dispWidthTypeO + "x" + this.dispHeightTypeO + "xO");
            imgSizeList.add(this.dispWidthTypeP + "x" + this.dispHeightTypeP + "xP");
        } else if (imageType == GoodsImageType.FREEBIE_IMAGE_TYPE_B) {
            imgSizeList.add(this.goodsDetailWidth + "x" + this.goodsDetailHeight + "x03");
            imgSizeList.add("110x110x01");
        } else if (imageType == GoodsImageType.FREEBIE_IMAGE_TYPE_D) {
            imgSizeList.add(this.goodsListWidth + "x" + this.goodsListHeight + "x05");
            imgSizeList.add("110x110x01");
        } else if (imageType == GoodsImageType.FREEBIE_IMAGE) {
            imgSizeList.add("110x110x01");
            imgSizeList.add("500x500x02");
            imgSizeList.add(this.goodsDetailWidth + "x" + this.goodsDetailHeight + "x03");
            imgSizeList.add("130x130x04");
            imgSizeList.add(this.goodsListWidth + "x" + this.goodsListHeight + "x05");
            imgSizeList.add("50x50x06");
        } else if (imageType == GoodsImageType.LEFT_WEAR_IMAGE) {
            imgSizeList.add(this.goodsWearWidthL + "x" + this.goodsWearHeightL + "x02");
        } else if (imageType == GoodsImageType.RIGHT_WEAR_IMAGE) {
            imgSizeList.add(this.goodsWearWidthR + "x" + this.goodsWearHeightR + "x03");
        } else if (imageType == GoodsImageType.LEFT_LENS_IMAGE) {
            imgSizeList.add(this.goodsLensWidthL + "x" + this.goodsLensHeightL + "x04");
        } else if (imageType == GoodsImageType.RIGHT_LENS_IMAGE) {
            imgSizeList.add(this.goodsLensWidthR + "x" + this.goodsLensHeightR + "x05");
        }

        imgSizeList.add("110x110x01");

        for (String size : imgSizeList) {
            // 가로, 세로 사이즈 추출
            Map<String, String> sizeMap = getSize(size);

            int width = Integer.parseInt(sizeMap.get("width"));
            int height = Integer.parseInt(sizeMap.get("height"));
            String typeStr = sizeMap.get("type");

            // 이미지 리사이즈
            BufferedImage resizeImage = resizeImageHighQuality(typeStr, width, height);

            // 이미지 파일 생성
            String destResizeImgFilePath = makeDestEditorImgFilePath(size);
            // destResizeImgFilePath);

            File destFile = new File(destResizeImgFilePath);
            ImageIO.write(resizeImage, imgFormat, destFile);
            destFileList.add(destFile);
        }
    }

    /**
     * <pre>
     * resizeImage
     * 이미지 리사이즈
     * 빠른 속도로 이미지 크기 변환을 처리하지만 새롭게 생성된 이미지의 품질이 떨어진다.
     *
     * <pre>
     *
     * @param type
     * @param width
     * @param height
     * @return
     * @throws InterruptedException
     */
    @Deprecated
    @SuppressWarnings("unused")
    private BufferedImage resizeImage(int type, int width, int height) throws Exception {
        BufferedImage destImg = new BufferedImage(width, height, type);
        Graphics2D graphics2d = destImg.createGraphics();
        graphics2d.drawImage(originalImage, 0, 0, width, height, null);
        graphics2d.dispose();

        return destImg;
    }

    /**
     * <pre>
     * resizeImageHighQuality
     * 이미지 리사이즈 (원본 품질 유지)
     * getScaledInstance 함수를 통해 이미지 크기 변환을 하면 변환된 이미지의 품질이 떨어지지 않는다.
     * Image.SCALE_SMOOTH를 이용하면 새롭게 생성된 이미지의 품질이 떨어지지 않게 된다.
     *
     * <pre>
     *
     * @param typeStr
     * @param width
     * @param height
     * @return
     * @throws Exception
     */
    private BufferedImage resizeImageHighQuality(String typeStr, int width, int height) throws Exception {

        int imgwidth = Math.min(originalImage.getHeight(), originalImage.getWidth());
        int imgheight = imgwidth;

        // 메인 전시용 상품이미지 원본사이즈 유지
        if(("A,B,C,D,E,F,G,S,M").indexOf(typeStr)>-1){
            imgwidth = width;
            imgheight = height;
        }

        BufferedImage scaledImage = null;
        if(originalImage.getWidth() > imgwidth && originalImage.getHeight() > imgheight){
            scaledImage = originalImage;
        	//scaledImage = Scalr.crop(originalImage, (originalImage.getWidth() - imgwidth) / 2,(originalImage.getHeight() - imgheight) / 2, imgwidth, imgheight, null);
        }else{
        	scaledImage = originalImage;
        }

        if(height <1){
            height = originalImage.getHeight();
        }
        // 파라메터로 넘겨준 가로, 세로 길이를 적용하기 위해서 Mode.FIT_EXACT 을 적용
        BufferedImage resizedImage = Scalr.resize(scaledImage, Scalr.Mode.FIT_EXACT, width, height, null);
        return resizedImage;
    }

    /**
     * <pre>
     * getSize
     * 가로, 세로 데이터 추출
     *
     * <pre>
     *
     * @param size
     * @return
     */
    private Map<String, String> getSize(String size) {
        Map<String, String> sizeMap = new HashMap<String, String>();
        String[] sizeArr = size.split("x");

        sizeMap.put("width", sizeArr[0]);
        sizeMap.put("height", sizeArr[1]);
        sizeMap.put("type", sizeArr[2]);

        return sizeMap;
    }

    /**
     * <pre>
     * getImgType
     * BufferedImage.TYPE_INT_RGB 이면, 배경색이 검정
     * BufferedImage.TYPE_INT_ARGB 이면, 배경색이 투명
     *
     * <pre>
     *
     * @return
     */
    private int getImgType() {
        int imtType = 0;
        int originalImgType = originalImage.getType(); // 원본 이미지 type
        if (originalImgType == 0) {
            imtType = BufferedImage.TYPE_INT_ARGB;
        } else {
            imtType = originalImgType;
        }
        return imtType;
    }

    /**
     * <pre>
     * getDestImgFilePath
     * resize 이미지 path 생성
     *
     * <pre>
     *
     * @param size
     */
    private String makeDestImgFilePath(String size) {
        String imgFormat = imageType.imgFormat();

        int idx = orgImgPath.lastIndexOf(".");
        String destFilePrefix = (idx > 0) ? orgImgPath.substring(0, idx) : orgImgPath;

        StringBuilder destFilePathBuf = new StringBuilder();
        destFilePathBuf.append(destFilePrefix);
        destFilePathBuf.append("_");
        destFilePathBuf.append(size);
        // destFilePathBuf.append(type);
        destFilePathBuf.append(".");
        destFilePathBuf.append(imgFormat);

        return destFilePathBuf.toString();
    }

    private String makeDestEditorImgFilePath(String size) {
        StringBuilder destFilePathBuf = new StringBuilder();
        destFilePathBuf.append(orgImgPath);
        destFilePathBuf.append("_");
        destFilePathBuf.append(size);
        // destFilePathBuf.append("_").append(type);

        return destFilePathBuf.toString();
    }

}
