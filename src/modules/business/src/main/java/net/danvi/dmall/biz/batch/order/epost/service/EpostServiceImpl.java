package net.danvi.dmall.biz.batch.order.epost.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.order.epost.EpostConstant;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryPO;
import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.order.epost.model.EpostVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;

@Service("epostService")
@Slf4j
public class EpostServiceImpl extends BaseService implements EpostService {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "deliveryService")
    private DeliveryService deliveryService;

    // 1.우체국 택배 수신
    @Override
    public void epostReceive(ProcRunnerVO vo, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        // 파일 읽기
        // this.epostReadFolder();
        this.epostReadFile();
        log.debug("수신 파일 조회 완료");

        // 주문 배송완료 업데이트
        log.debug("주문 배송완료 업데이트 완료");

    }

    // 2.우체국 택배 송신
    @Override
    public void epostSend(ProcRunnerVO vo, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        // 주문데이터 읽기
        // String sendText = "01|6003380728|eleven2_740156|6073997820395|차두리|0103213221|0103213221|323-805|충청남도 부여군 부여읍
        // 구아리 789번지10층||차두리|||-||||||(271790)04_미뉴엣-C0503아이보리(IVORY_)240
        // (271790)04_C0503-C0503아이보리(IVORY_)240||||||||||60|1|N||N|N|N|";
        String sendText = "";
        List<EpostVO> epostList = deliveryService.selectDeliveryEpostList();

        if (epostList.size() > 0) {
            for (int i = 0; i < epostList.size(); i++) {

                sendText += epostList.get(i).getSendReqDivCd() + "|";
                sendText += epostList.get(i).getSiteNo() + "|";
                sendText += epostList.get(i).getOrdNo() + "_" + epostList.get(i).getOrdDtlSeq() + "|";
                sendText += epostList.get(i).getAdrsNm() + "|";
                sendText += epostList.get(i).getAdrsMobile() + "|";
                sendText += epostList.get(i).getAdrsTel() + "|";
                sendText += epostList.get(i).getPostNo() + "|";
                sendText += epostList.get(i).getNumAddr() + "|";
                sendText += epostList.get(i).getDtlAddr() + "|";
                sendText += epostList.get(i).getOrdrNm() + "|";
                sendText += epostList.get(i).getOrdrMobile() + "|";
                sendText += epostList.get(i).getOrdrTel() + "|";
                sendText += "|"; // 주문자 우편번호
                sendText += "|"; // 주문자 주소
                sendText += "|"; // 주문자 상세주소
                sendText += "|";
                sendText += epostList.get(i).getDlvrMsg() + "|";
                sendText += epostList.get(i).getGoodsNo() + "|";
                sendText += epostList.get(i).getGoodsNm() + "|";
                sendText += "||||||||"; // goodsNo, goodsNm 2~5
                sendText += "Y|"; // MAILWGHT
                sendText += "Y|"; //
                sendText += "|";
                sendText += "N|";
                sendText += epostList.get(i).getRealDlvrAmt() + "|";
                sendText += "||";
                if (i < epostList.size() - 1) {
                    sendText += "\n";
                }

                DeliveryPO po = new DeliveryPO();
                po.setOrdNo(epostList.get(i).getOrdNo());
                po.setOrdDtlSeq(epostList.get(i).getOrdDtlSeq());
                po.setDlvrApi("S"); // 보냄
                po.setRegrNo(CommonConstants.MEMBER_BATCH_ORDER);
                proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateOrdDtlDeliveryEpost", po);
            }
        }

        log.debug("주문 데이터 조회 완료" + sendText);

        // 파일 생성
        this.epostWriteFile(sendText);
        log.debug("파일 생성 완료");
    }

    // txt 파일 생성
    public void epostWriteFile(String sendText) {
        String filePath = EpostConstant.EPOST_WRITE_FILE_PATH;
        java.text.SimpleDateFormat dateformat = new java.text.SimpleDateFormat("yyyyMMdd HH:mm:ss");
        String nowTotDate = dateformat.format(new java.util.Date());
        Integer nowdate = Integer.parseInt(nowTotDate.substring(0, 8));
        String fileName = "send_" + nowdate + ".txt"; // 생성할 파일명
        String sendPath = filePath + File.separator + fileName;
        File folder = new File(filePath); // 저장폴더
        File f = new File(sendPath); // 파일을 생성할 전체경로

        try {
            if (folder.exists() == false) {
                folder.mkdirs();
            }
            if (f.exists() == false) {
                f.createNewFile(); // 파일생성
            }
            // 파일쓰기
            FileWriter fw = null;

            try {
                fw = new FileWriter(sendPath, true); // 파일쓰기객체생성
                fw.write(sendText + "\n"); // 파일에다 작성

            } catch (IOException e) {
                throw e;
            } finally {
                try {
                    if (fw != null) fw.close();
                } catch (Exception e) {
                    log.debug("{}", e.getMessage());
                }
            }
        } catch (IOException e) {
            log.debug("{}", e.getMessage());
        }
    }

    // txt 파일 읽기
    public void epostReadFile() {
        String filePath = EpostConstant.EPOST_READ_FILE_PATH;
        String outfilePath = EpostConstant.EPOST_READ_FILE_MOVE_PATH;
        BufferedReader in = null;
        try {
            File dirFile = new File(filePath);
            File[] fileList = dirFile.listFiles();

            for (File tempFile : fileList) {
                if (tempFile.isFile()) {
                    String textFileName = tempFile.getName();
                    log.debug("파일명 :::" + textFileName);

                    in = new BufferedReader(
                            new InputStreamReader(new FileInputStream(filePath + "/" + textFileName), "euc-kr"));

                    String s;
                    boolean dlvrCompleted = true;
                    while ((s = in.readLine()) != null) {
                        log.debug("출력 : " + s);
                        String[] strArr = s.split("\\|");
                        log.debug("주문번호 + SEQ : " + strArr[1]);
                        log.debug("송장번호 : " + strArr[2]);
                        log.debug("배송상태코드 : " + strArr[8]);
                        log.debug("배송상태 : " + strArr[9]);

                        // 배달완료일때 상태 변경
                        if (strArr[8].equals("071")) {
                            OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                            // 배송완료 업데이트
                            String[] ordArr = strArr[1].split("_");
                            orderGoodsVO.setSiteNo(Long.parseLong(strArr[4]));
                            orderGoodsVO.setOrdNo(ordArr[0]);
                            orderGoodsVO.setOrdDtlSeq(ordArr[1]);
                            orderGoodsVO.setRegrNo(CommonConstants.MEMBER_BATCH_ORDER);
                            orderGoodsVO.setOrdStatusCd("50"); // 배송완료
                            orderGoodsVO.setOrdDtlStatusCd("50");
                            String curOrdStatusCd = "40"; // 배송중(현재)

                            try {
                                DeliveryPO po = new DeliveryPO();
                                po.setOrdNo(ordArr[0]);
                                po.setOrdDtlSeq(ordArr[1]);
                                po.setDlvrApi("R"); // 받음
                                // 우체국 받음 상태 변경
                                proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateOrdDtlDeliveryEpost", po);
                                // 배송완료 변경
                                orderService.updateOrdStatus(orderGoodsVO, curOrdStatusCd);
                            } catch (Exception e) {
                                log.debug("{}", e.getMessage());
                            }
                        } else {
                            dlvrCompleted = false;
                        }

                    }
                    // 배송완료 상태가 완료이면
                    if (dlvrCompleted) {
                        // 파일 이동 후 원본 파일 삭제
                        fileMove(filePath + "/" + textFileName, outfilePath + "/" + textFileName);
                        // 파일 삭제
                        fileDelete(filePath + "/" + textFileName);
                    }
                }
            }

        } catch (IOException e) {
            log.debug("{}", e.getMessage());
        } finally {
            try {
                if (in != null) in.close();
            } catch (Exception e) {
                log.debug("{}", e.getMessage());
            }
        }
    }

    // 폴더에 파일명 읽기
    public void epostReadFolder() {
        String filePath = EpostConstant.EPOST_READ_FILE_PATH;
        File dirFile = new File(filePath);
        File[] fileList = dirFile.listFiles();

        for (File tempFile : fileList) {
            if (tempFile.isFile()) {
                String tempPath = tempFile.getParent();
                String tempFileName = tempFile.getName();
                log.debug("파일명 :::" + tempFileName);
            }
        }
    }

    // 파일 복사
    public void fileMove(String inFileName, String outFileName) {
        FileInputStream fis = null;
        FileOutputStream fos = null;
        try {
            fis = new FileInputStream(inFileName);
            fos = new FileOutputStream(outFileName);
            int data = 0;
            while ((data = fis.read()) != 1) {
                fos.write(data);
            }
            // 원본파일 삭제함
            fileDelete(inFileName);

        } catch (IOException e) {
            log.debug("{}", e.getMessage());
        } finally {
            try {
                if (fis != null) fos.close();
                if (fos != null) fos.close();
            } catch (Exception e) {
                log.debug("{}", e.getMessage());
            }
        }
    }

    // 파일 삭제
    public void fileDelete(String fileName) {
        File i = new File(fileName);
        i.delete();
    }

}
