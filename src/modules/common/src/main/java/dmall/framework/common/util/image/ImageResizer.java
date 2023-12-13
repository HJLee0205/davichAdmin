package dmall.framework.common.util.image;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.image.Raster;
import java.io.File;
import java.io.IOException;
import java.util.*;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

import org.apache.sanselan.ImageReadException;
import org.imgscalr.Scalr;

public class ImageResizer {

    /** 원본 이미지 객체 */
    private final BufferedImage originalImage;
    /** 원본 이미지 path */
    private final String orgImgPath;
    /** image type enum */
    private final ImageType imageType;
    /** 생성파일 List */
    private final List<File> destFileList;

    /**
     * constructor
     *
     * @throws IOException
     */
    public ImageResizer(ImageInfoData data) throws IOException ,ImageReadException{
        orgImgPath = data.getOrgImgPath();
        imageType = data.getImageType();
        JpegReader jpegReader = new JpegReader();
        originalImage = jpegReader.readImage(new File(orgImgPath));
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

        for (String size : imgSizeList) {
            // 가로, 세로 사이즈 추출
            Map<String, Integer> sizeMap = getSize(size);
            int width = sizeMap.get("width");
            int height = sizeMap.get("height");

            // 이미지 리사이즈
            BufferedImage resizeImage = resizeImageHighQuality(type, width, height);

            // 이미지 파일 생성
            String destResizeImgFilePath;
            if (imageType == ImageType.EDITOR_IMAGE || imageType == ImageType.GOODS_IMAGE
                    || imageType == ImageType.GOODS_IMAGE_TYPE_A || imageType == ImageType.GOODS_IMAGE_TYPE_B
                    || imageType == ImageType.GOODS_IMAGE_TYPE_C || imageType == ImageType.GOODS_IMAGE_TYPE_D
                    || imageType == ImageType.GOODS_IMAGE_TYPE_E) {
                destResizeImgFilePath = makeDestEditorImgFilePath(size);
            } else {
                destResizeImgFilePath = makeDestImgFilePath(size);
            }

            File destFile = new File(destResizeImgFilePath);
            ImageIO.write(resizeImage, imgFormat, destFile);
            destFileList.add(destFile);
        }
    }

    // public void ftpProcess() throws Exception {
    // int type = getImgType();
    // String imgFormat = imageType.imgFormat();
    // List<String> imgSizeList = imageType.imageSizeList();
    //
    // FtpImgUtil ftpImgUtil = new FtpImgUtil();
    // for (String size : imgSizeList) {
    // // 가로, 세로 사이즈 추출
    // Map<String, Integer> sizeMap = getSize(size);
    // int width = sizeMap.get("width");
    // int height = sizeMap.get("height");
    //
    // // 이미지 리사이즈
    // BufferedImage resizeImage = resizeImageHighQuality (type, width, height);
    // // 이미지 파일 생성
    // String destResizeImgFilePath = makeDestImgFilePath (size);
    // File destFile = new File(destResizeImgFilePath);
    // ImageIO.write(resizeImage, imgFormat, destFile);
    //
    // // FTP 전송
    // ftpImgUtil.goodsImgUpload(destResizeImgFilePath );
    // destFile.delete();
    // }
    // }

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
     * @param type
     * @param width
     * @param height
     * @return
     * @throws Exception
     */
    private BufferedImage resizeImageHighQuality(int type, int width, int height) throws Exception {

        int imgwidth = Math.min(originalImage.getHeight(), originalImage.getWidth());
        int imgheight = imgwidth;

        BufferedImage scaledImage = null;
        scaledImage = originalImage;
        //scaledImage = Scalr.crop(originalImage, (originalImage.getWidth() - imgwidth) / 2, (originalImage.getHeight() - imgheight) / 2, imgwidth, imgheight, null);
        BufferedImage resizedImage = Scalr.resize(scaledImage, Scalr.Mode.FIT_EXACT, width, height, null);
        //BufferedImage resizedImage = Scalr.resize(scaledImage, width, height, null);
        // ImageIO.write(resizedImage, imageType, new File(targetFilePath));
        /*
         * Image image = originalImage.getScaledInstance(width, height,
         * Image.SCALE_SMOOTH);
         * int pixels[] = new int[width * height];
         * PixelGrabber pixelGrabber = new PixelGrabber(image, 0, 0, width,
         * height, pixels, 0, width);
         * pixelGrabber.grabPixels();
         * // image 객체로부터 픽셀 정보를 읽어온 후, BufferedImage에 채워 넣어주면 이미지 크기 변환이 된다.
         * BufferedImage destImg = new BufferedImage(width, height, type);
         * destImg.setRGB(0, 0, width, height, pixels, 0, width);
         */
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
    private Map<String, Integer> getSize(String size) {
        Map<String, Integer> sizeMap = new HashMap<String, Integer>();
        String[] sizeArr = size.split("x");

        String widthStr = sizeArr[0];
        String heightStr = sizeArr[1];
        int width = Integer.parseInt(widthStr);
        int height = Integer.parseInt(heightStr);

        sizeMap.put("width", width);
        sizeMap.put("height", height);

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
        destFilePathBuf.append(".");
        destFilePathBuf.append(imgFormat);

        return destFilePathBuf.toString();
    }

    private String makeDestEditorImgFilePath(String size) {
        StringBuilder destFilePathBuf = new StringBuilder();
        destFilePathBuf.append(orgImgPath);
        destFilePathBuf.append("_");
        destFilePathBuf.append(size);

        return destFilePathBuf.toString();
    }

}
