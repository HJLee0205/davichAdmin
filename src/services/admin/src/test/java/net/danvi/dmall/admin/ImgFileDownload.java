package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.GoodsImageHandler;
import net.danvi.dmall.admin.web.common.util.GoodsImageInfoData;
import net.danvi.dmall.admin.web.common.util.GoodsImageType;
import net.danvi.dmall.biz.app.goods.model.GoodsImageDtlPO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSetPO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSizeVO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageUploadVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.common.service.BizService;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import java.awt.*;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Package Name   : net.danvi.dmall.admin
 * @FileName  : ${FILE_NAME}
 * @작성일       : 2019. 05. 27. 
 * @작성자       : 김동엽
 * @프로그램 설명 : 

 */
@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })
public class ImgFileDownload  extends BaseService {

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "goodsImageHandler")
    private GoodsImageHandler imageHandler;

        /** 상품 이미지 임시 업로드 경로 */
    @Value("#{system['system.upload.goods.temp.image.path']}")
    private String goodsTempImageFilePath;

    @Resource(name = "bizService")
    private BizService bizService;




    @Test
public void main() throws Exception{

            SiteSO so = new SiteSO();
            so.setSiteNo(1L);
            ResultModel<GoodsImageSizeVO> goodsImageSizeVO = siteInfoService.selectGoodsImageInfo(so);

            Map mapA  = new HashMap();
            Map mapB  = new HashMap();
            Map mapC  = new HashMap();
            Map mapD  = new HashMap();
            Map mapE  = new HashMap();
            Map mapF  = new HashMap();
            Map mapG  = new HashMap();
            Map mapS  = new HashMap();
            Map mapM  = new HashMap();
            String dlgtImgPath  ="http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";

            mapA = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_A.jpg","DISP","A");
            mapB = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_B.jpg","DISP","B");
            mapC = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_C.jpg","DISP","C");
            mapD = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_D.jpg","DISP","D");
            mapE = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_E.jpg","DISP","E");
            mapF = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_F.jpg","DISP","F");
            mapG = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_G.jpg","DISP","G");
            mapS = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_S.jpg","DISP","S");
            mapM = this.goodsImageUploadResult(goodsImageSizeVO,dlgtImgPath,"G1905271049_5071"+"_M.jpg","DISP","M");


            System.out.println("mapA "+ mapA.get("files"));

            List<GoodsImageUploadVO> resultListA = (List<GoodsImageUploadVO>) mapA.get("files");

            for (GoodsImageUploadVO vo : resultListA){
                if(vo.getImgType().equals("A")) {
                    System.out.println("tempFileNmA " + vo.getTempFileName());
                }
            }

            List<GoodsImageUploadVO> resultListB = (List<GoodsImageUploadVO>) mapB.get("files");

            for (GoodsImageUploadVO vo : resultListB){
                if(vo.getImgType().equals("B")) {
                    System.out.println("tempFileNmB " + vo.getTempFileName());
                }
            }


                    // 이미지 정보 등록
                    GoodsImageSetPO goodsImageSetPo = new GoodsImageSetPO();

                    List<GoodsImageSetPO> goodsImageSetList = new ArrayList<>();
                    List<GoodsImageDtlPO> goodsImageDtlList = new ArrayList<>();

                    String imgPath1  = "http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";
                    String imgPath2  = "http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";
                    String imgPath3  = "http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";
                    String imgPath4  = "http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";
                    String imgPath5  = "http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=20190228_41ede065ea9c05b978db6f09016e76057718e22a46547765ab79560de5eea81a_735x645x02";

                    goodsImageSetPo.setGoodsNo("G1905271049_5071");
                    goodsImageSetPo.setDlgtImgYn("Y");

                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",dlgtImgPath,"G1905271049_5071"+"_1.jpg","GOODS","01"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",dlgtImgPath,"G1905271049_5071"+"_A.jpg","GOODS","02"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",dlgtImgPath,"G1905271049_5071"+"_B.jpg","GOODS","03"));
                    goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);
                    goodsImageSetList.add(goodsImageSetPo);

                    goodsImageSetPo.setDlgtImgYn("N");
                    goodsImageDtlList = new ArrayList<>();
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath1,"G1905271049_5071"+"_1.jpg","GOODS","01"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath1,"G1905271049_5071"+"_1.jpg","GOODS","02"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath1,"G1905271049_5071"+"_1.jpg","GOODS","03"));
                    goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);
                    goodsImageSetList.add(goodsImageSetPo);

                    goodsImageDtlList = new ArrayList<>();
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath2,"G1905271049_5071"+"_2.jpg","GOODS","01"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath2,"G1905271049_5071"+"_2.jpg","GOODS","02"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath2,"G1905271049_5071"+"_2.jpg","GOODS","03"));
                    goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);
                    goodsImageSetList.add(goodsImageSetPo);

                    goodsImageDtlList = new ArrayList<>();
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath3,"G1905271049_5071"+"_3.jpg","GOODS","01"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath3,"G1905271049_5071"+"_3.jpg","GOODS","02"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath3,"G1905271049_5071"+"_3.jpg","GOODS","03"));
                    goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);
                    goodsImageSetList.add(goodsImageSetPo);

                    goodsImageDtlList = new ArrayList<>();
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath4,"G1905271049_5071"+"_4.jpg","GOODS","01"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath4,"G1905271049_5071"+"_4.jpg","GOODS","02"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath4,"G1905271049_5071"+"_4.jpg","GOODS","03"));
                    goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);
                    goodsImageSetList.add(goodsImageSetPo);

                    goodsImageDtlList = new ArrayList<>();
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath5,"G1905271049_5071"+"_5.jpg","GOODS","01"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath5,"G1905271049_5071"+"_5.jpg","GOODS","02"));
                    goodsImageDtlList.addAll(goodsImageDtlInfoList(goodsImageSizeVO,"G1905271049_5071",imgPath5,"G1905271049_5071"+"_5.jpg","GOODS","03"));
                    goodsImageSetPo.setGoodsImageDtlList(goodsImageDtlList);
                    goodsImageSetList.add(goodsImageSetPo);


                    if (goodsImageSetList != null && goodsImageSetList.size() > 0) {
                        for (GoodsImageSetPO goodsImageSet : goodsImageSetList) {
                            long imgSetNo = goodsImageSet.getGoodsImgsetNo();
                            boolean isImageInfo = false;
                            goodsImageDtlList = goodsImageSet.getGoodsImageDtlList();

                            if (goodsImageDtlList != null && goodsImageDtlList.size() > 0) {
                                isImageInfo = true;
                            }

                            if (isImageInfo) {
                                goodsImageSet.setGoodsImgsetNo((long) bizService.getSequence("GOODS_IMGSET_NO"));
                                /*proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageSet", goodsImageSet);*/
                                imgSetNo = goodsImageSet.getGoodsImgsetNo();

                                for (GoodsImageDtlPO goodsImageDtl : goodsImageDtlList) {
                                    String tempFileNm = goodsImageDtl.getTempFileNm();
                                    if (!StringUtils.isEmpty(tempFileNm)) {
                                        String tempThumFileNm = tempFileNm.substring(0, tempFileNm.lastIndexOf("_")) + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

                                        goodsImageDtl.setGoodsImgsetNo(imgSetNo);
                                        /*proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageDtl", goodsImageDtl);*/

                                        // 임시 경로의 이미지를 실제 서비스 경로로 복사
                                        /*FileUtil.copyGoodsImage(tempFileNm);
                                        FileUtil.copyGoodsImage(tempThumFileNm);

                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempThumFileNm);*/

                                    }
                                }
                            }
                        }
                    }





    }

    private String getTempRootPath() {
        return "/home/bitlabs/service/davich-mall/upload" + File.separator + "id1" + File.separator + UploadConstants.PATH_TEMP;
    }

    public Map goodsImageUploadResult(ResultModel<GoodsImageSizeVO> goodsImageSizeVO,String imgUrl, String fileOrgName,String imageKind,String imageType) throws Exception {
            GoodsImageUploadVO result;
            List<GoodsImageUploadVO> resultList = new ArrayList<>();
            Map map = new HashMap();

            /*SiteSO so = new SiteSO();
            so.setSiteNo(1L);
            ResultModel<GoodsImageSizeVO> goodsImageSizeVO = siteInfoService.selectGoodsImageInfo(so);*/

            String extension;
            String fileName;
            File file;
            String filePath;
            String path;
            // 상품 이미지는 이하 5가지 확장자만 가능
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            Boolean checkExe;
            GoodsImageInfoData imageInfoData;
            // 업로드된 이미지 종류(GOODS : 상품 이미지, DISP : 전시 이미지)
            //String imageKind = "DISP";
            // 이미지 유형
            // (상품이미지 - A Type, B Type, 전시이미지 - A Type, B Type, C Type, D Type, E Type, F Type, G Type, S Type, M Type)
            //String imageType = "";

            URL url = new URL((String) imgUrl);
            Image image = ImageIO.read(url);
            try  {
            BufferedInputStream in = new BufferedInputStream(url.openStream());

            extension = FilenameUtils.getExtension(fileOrgName);
            checkExe = true;
            for (String ex : fileFilter) {
                if (ex.equalsIgnoreCase(extension)) {
                    checkExe = false;
                }
            }
            //
            if (checkExe) {
                throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
            }


            // 업로드 등록할 이미지 파일명
            fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
            // 파일 경로
            path = FileUtil.getNowdatePath();
            filePath = getTempRootPath() + File.separator + path + File.separator + fileName;

            file = new File(filePath);

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

               MultipartFile mFile = new MockMultipartFile("file",file.getName(), "text/plain", IOUtils.toByteArray(in));

               /*FileOutputStream fileOutputStream = new FileOutputStream(filePath);

                byte dataBuffer[] = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
                    fileOutputStream.write(dataBuffer, 0, bytesRead);
                }*/
                mFile.transferTo(file);



            // 리사이징 정보등을 담은 이미지 객체 생성
            imageInfoData = new GoodsImageInfoData();

            // 업로드 이미지 정보에 따라 이미지 객체에 이미지 유형 설정
            if ("GOODS".equals(imageKind)) {
                switch (imageType) {
                case "02":
                    imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE_TYPE_A);
                    break;
                case "03":
                    imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE_TYPE_B);
                    break;
                default:
                    imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE);
                    break;
                }
            } else {
                switch (imageType) {
                case "A":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_A);
                    break;
                case "B":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_B);
                    break;
                case "C":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_C);
                    break;
                case "D":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_D);
                    break;
                case "E":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_E);
                    break;
                case "F":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_F);
                    break;
                case "G":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_G);
                    break;
                case "S":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_S);
                    break;
                case "M":
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_M);
                    break;
                default:
                    imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE);
                    break;
                }
            }

            // 사이트 설정에서 취득한 상품 이미지 설정 정보를 세팅
            imageInfoData.setWidthForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgWidth()));
            imageInfoData.setHeightForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgHeight()));

            imageInfoData.setWidthForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgWidth()));
            imageInfoData.setHeightForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgHeight()));

            imageInfoData.setWidthForDispTypeA(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeAWidth()));
            imageInfoData.setHeightForDispTypeA(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeAHeight()));

            imageInfoData.setWidthForDispTypeB(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeBWidth()));
            imageInfoData.setHeightForDispTypeB(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeBHeight()));

            imageInfoData.setWidthForDispTypeC(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeCWidth()));
            imageInfoData.setHeightForDispTypeC(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeCHeight()));

            imageInfoData.setWidthForDispTypeD(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeDWidth()));
            imageInfoData.setHeightForDispTypeD(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeDHeight()));

            imageInfoData.setWidthForDispTypeE(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeEWidth()));
            imageInfoData.setHeightForDispTypeE(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeEHeight()));

            imageInfoData.setWidthForDispTypeF(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeFWidth()));
            imageInfoData.setHeightForDispTypeF(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeFHeight()));

            imageInfoData.setWidthForDispTypeG(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeGWidth()));
            imageInfoData.setHeightForDispTypeG(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeGHeight()));

            imageInfoData.setWidthForDispTypeS(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeSWidth()));
            imageInfoData.setHeightForDispTypeS(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeSHeight()));

            imageInfoData.setWidthForDispTypeM(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeMWidth()));
            imageInfoData.setHeightForDispTypeM(0);

            imageInfoData.setOrgImgPath(file.getAbsolutePath());
            // 이미지 리사이징 실행
            imageHandler.job(imageInfoData);

            // 이미지 업로드 결과로 반환 할 결과 목록객체 생성
            List<File> destFileList = imageInfoData.getDestFileList();

            for (File destFile : destFileList) {
                // 화면에 반환할 정보 설정
                String targetFileName = destFile.getName();
                String[] fileInfoArr = targetFileName.split("_");
                String[] sizeArr = fileInfoArr[1].split("x");

                result = new GoodsImageUploadVO();
                result.setFileName(fileOrgName);
                result.setImageWidth(sizeArr[0]);
                result.setImageHeight(sizeArr[1]);
                result.setImgType(targetFileName.substring(targetFileName.lastIndexOf("x") + 1,targetFileName.length()));
                result.setTempFileName(DateUtil.getNowDate() + "_" + destFile.getName());
                result.setFileSize(mFile.getSize());
                // 이미지 미리보기 URL
                result.setImageUrl(UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_"+ targetFileName);
                // 이미지 썸네일 URL
                result.setThumbUrl(UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_"+ (targetFileName).substring(0, targetFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
                resultList.add(result);
            }


            } catch (IOException e) {
                // handle exception
            }

             // 반환 정보 설정
                map.put("files", resultList);
                // JSON 형태로 반환
                return map;

    }


    private void copyTempDispImageFile(String tempFileName) throws Exception {
        if (!StringUtils.isEmpty(tempFileName)) {
            String tempThumFileNm = tempFileName.substring(0, tempFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
            // 임시 경로의 이미지를 실제 서비스 경로로 복사
            FileUtil.copyGoodsImage(tempFileName);
            FileUtil.copyGoodsImage(tempThumFileNm);

            FileUtil.deleteTempFile(tempFileName); // 이미지 삭제
            FileUtil.deleteTempFile(tempThumFileNm); // 이미지 삭제
        }
    }

    private static void deleteTempGoodsImageFile(String path, String tempFileNm) throws Exception {
        FileUtil.deleteTempFile(tempFileNm); // 이미지 삭제
    }


    private List<GoodsImageDtlPO> goodsImageDtlInfoList(ResultModel<GoodsImageSizeVO> goodsImageSizeVO,String goodsNo,String imgPath,String fileOrgName,String imageKind , String imageType) throws Exception {
        List<GoodsImageDtlPO> goodsImageDtlList = new ArrayList<>();
        Map ImgPathMap  = new HashMap();

         ImgPathMap = goodsImageUploadResult(goodsImageSizeVO,imgPath,fileOrgName,imageKind,imageType);
         List<GoodsImageUploadVO> list = (List<GoodsImageUploadVO>) ImgPathMap.get("files");

        for(GoodsImageUploadVO vo : list){
            GoodsImageDtlPO goodsImageDtlPO = new GoodsImageDtlPO();

            goodsImageDtlPO.setGoodsNo(goodsNo);
            goodsImageDtlPO.setTempFileNm(vo.getTempFileName());
            goodsImageDtlPO.setImgPath(vo.getTempFileName()!=null?vo.getTempFileName().split("_")[0]:"");
            goodsImageDtlPO.setImgNm(vo.getTempFileName()!=null?vo.getTempFileName().split("_")[1]+"_"+vo.getTempFileName().split("_")[2]:"");
            goodsImageDtlPO.setGoodsImgType(vo.getImgType());
            goodsImageDtlPO.setImgWidth(Integer.parseInt(vo.getImageWidth()));
            goodsImageDtlPO.setImgHeight(Integer.parseInt(vo.getImageHeight()));
            goodsImageDtlPO.setImgSize(Long.valueOf(vo.getFileSize()).intValue());
            goodsImageDtlPO.setImgUrl(vo.getImageUrl());
            goodsImageDtlList.add(goodsImageDtlPO);

        }
        return goodsImageDtlList;
    }
}
