package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.imageio.ImageIO;
import java.awt.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.channels.GatheringByteChannel;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })
public class FileSizeTest extends BaseService {

@Test
public void main() {
    /*BufferedWriter bufWriter = new BufferedWriter(new OutputStreamWriter(System.out));;*/
    BufferedWriter bufWriter = null;
    HttpURLConnection conn = null;
    BufferedInputStream inputStream = null;
    FileOutputStream fileOS = null;
    try {
        String epTxtFilename = "fileSIze.txt";
        String epfilePath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file") + File.separator + epTxtFilename;


        File orgFile = new File(epfilePath);
        if (!orgFile.getParentFile().exists()) {
            orgFile.getParentFile().mkdirs();
        }

        File targetFile = new File(SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file")
                + File.separator + FileUtil.getNowdatePath() + File.separator + epTxtFilename);
        if (orgFile != null && orgFile.exists()) {
            FileUtil.copy(orgFile, targetFile);
        } else {
            orgFile.createNewFile();
        }

        bufWriter = Files.newBufferedWriter(Paths.get(epfilePath), Charset.forName("euc-kr"));

        String filePath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file") + File.separator + "fileSIze.jpg";

        //전시용 이미지
        List<Map<String, Object>> dispImgList = proxyDao.selectList("batch.goods." + "selectDispImgList");
        for (Map<String, Object> newLine : dispImgList) {
            Iterator<String> keys = newLine.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = newLine.get(key);

                if (key.equals("URL_A") || key.equals("URL_B") || key.equals("URL_C") || key.equals("URL_D")
                        || key.equals("URL_E") || key.equals("URL_F") || key.equals("URL_G") || key.equals("URL_S") || key.equals("URL_M")) {

                    URL url = new URL((String) value);
                    Image image = ImageIO.read(url);
                    int width = 0;
                    int height = 0;
                    if (image != null) {
                        width = image.getWidth(null);
                        height = image.getHeight(null);
                    }

                    try (BufferedInputStream in = new BufferedInputStream(url.openStream());
                         FileOutputStream fileOutputStream = new FileOutputStream(filePath)) {
                        byte dataBuffer[] = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
                            fileOutputStream.write(dataBuffer, 0, bytesRead);
                        }
                        File file = new File(filePath);
                        bufWriter.write(String.valueOf(value == null ? "" : value));
                        bufWriter.write("\t");
                        value = file.length();

                    } catch (IOException e) {
                        // handle exception
                    }
                }
                bufWriter.write(String.valueOf(value == null ? "" : value));
                bufWriter.write("\t");


            }
            bufWriter.newLine();
            bufWriter.flush();

        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (bufWriter != null) {
                bufWriter.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

@Test
public void test2() {
    /*BufferedWriter bufWriter = new BufferedWriter(new OutputStreamWriter(System.out));;*/
    BufferedWriter bufWriter = null;
    HttpURLConnection conn = null;
    BufferedInputStream inputStream = null;
    FileOutputStream fileOS = null;

    try {
        String epTxtFilename = "fileImgSIze.txt";
        String epfilePath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file") + File.separator + epTxtFilename;


        File orgFile = new File(epfilePath);
        if (!orgFile.getParentFile().exists()) {
            orgFile.getParentFile().mkdirs();
        }

        File targetFile = new File(SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file")
                + File.separator + FileUtil.getNowdatePath() + File.separator + epTxtFilename);
        if (orgFile != null && orgFile.exists()) {
            FileUtil.copy(orgFile, targetFile);
        } else {
            orgFile.createNewFile();
        }

        bufWriter = Files.newBufferedWriter(Paths.get(epfilePath), Charset.forName("euc-kr"));


        String filePath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file") + File.separator + "fileImgSIze.jpg";

        //전시용 이미지
        List<Map<String, Object>> dispImgList = proxyDao.selectList("batch.goods." + "selectImgList");
        for (Map<String, Object> newLine : dispImgList) {
            Iterator<String> keys = newLine.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = newLine.get(key);

                if (key.equals("URL")) {

                    URL url = new URL((String) value);
                    Image image = ImageIO.read(url);
                    int width = 0;
                    int height = 0;
                    if (image != null) {
                        width = image.getWidth(null);
                        height = image.getHeight(null);
                    }
                        bufWriter.write(String.valueOf(width));
                        bufWriter.write("\t");
                        bufWriter.write(String.valueOf(height));
                        bufWriter.write("\t");

                    try (BufferedInputStream in = new BufferedInputStream(url.openStream());
                         FileOutputStream fileOutputStream = new FileOutputStream(filePath)) {
                        byte dataBuffer[] = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
                            fileOutputStream.write(dataBuffer, 0, bytesRead);
                        }
                        File file = new File(filePath);
                        bufWriter.write(String.valueOf(value == null ? "" : value));
                        bufWriter.write("\t");
                        value = file.length();

                    } catch (IOException e) {
                        // handle exception
                    }
                }
                bufWriter.write(String.valueOf(value == null ? "" : value));
                bufWriter.write("\t");


            }
            bufWriter.newLine();

        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (bufWriter != null) {
                bufWriter.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

    @Test
    public void NIOtest() throws Exception {
    String epTxtFilename = "fileImg2SIze.txt";
        String epfilePath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file") + File.separator + epTxtFilename;
         File orgFile = new File(epfilePath);
        if (!orgFile.getParentFile().exists()) {
            orgFile.getParentFile().mkdirs();
        }

        File targetFile = new File(SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file")
                + File.separator + FileUtil.getNowdatePath() + File.separator + epTxtFilename);
        if (orgFile != null && orgFile.exists()) {
            FileUtil.copy(orgFile, targetFile);
        } else {
            orgFile.createNewFile();
        }

        String filePath = SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "file") + File.separator + "fileImg2SIze.jpg";

            FileOutputStream fo = new FileOutputStream(epfilePath);

			GatheringByteChannel gchannel = fo.getChannel();
			ByteBuffer wheader = ByteBuffer.allocate(30);
			ByteBuffer wbody = ByteBuffer.allocate(800 * 1024 * 1024);

			ByteBuffer[] wbuffers = { wbody };

            //전시용 이미지
        List<Map<String, Object>> dispImgList = proxyDao.selectList("batch.goods." + "selectImgList");
        for (Map<String, Object> newLine : dispImgList) {
            Iterator<String> keys = newLine.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = newLine.get(key);
                wbody = ByteBuffer.allocate(String.valueOf(value).length());
                if (key.equals("URL")) {
                    URL url = new URL((String) value);
                    Image image = ImageIO.read(url);
                    int width = 0;
                    int height = 0;
                    if (image != null) {
                        width = image.getWidth(null);
                        height = image.getHeight(null);
                    }
                        wbody.put(String.valueOf(width).getBytes());
                        wbody.flip();
                        wbody.put("\t".getBytes());
                        wbody.flip();
                        wbody.put(String.valueOf(height).getBytes());
                        wbody.flip();
                        wbody.put("\t".getBytes());
                        wbody.flip();

                    try (BufferedInputStream in = new BufferedInputStream(url.openStream());
                         FileOutputStream fileOutputStream = new FileOutputStream(filePath)) {
                        byte dataBuffer[] = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
                            fileOutputStream.write(dataBuffer, 0, bytesRead);
                        }
                        File file = new File(filePath);
                        wbody.put(String.valueOf(value == null ? "" : value).getBytes());
                        wbody.flip();
                        wbody.put("\t".getBytes());
                        wbody.flip();
                        value = file.length();

                    } catch (IOException e) {
                        // handle exception
                    }
                   //wheader.put("header is hello world".getBytes());
                   //wbody.put("body is welcome to channel".getBytes());

                   //wheader.flip();
                   //wbody.flip();
                }
                wbody.put(String.valueOf(value == null ? "" : value).getBytes());
                wbody.flip();
                wbody.put("\t".getBytes());
                wbody.flip();
            }
        }

			gchannel.write(wbuffers);
			gchannel.close();


    }
}