package net.danvi.dmall.admin.batch.sabangnet;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model.SabangnetTargetCompanyVO;
import net.danvi.dmall.biz.batch.link.sabangnet.service.SabangnetService;
import org.springframework.batch.core.*;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobExecutionAlreadyRunningException;
import org.springframework.batch.core.repository.JobInstanceAlreadyCompleteException;
import org.springframework.batch.core.repository.JobRestartException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 13.
 * 작성자     : 
 * 설명       : 사방넷을 통한 오픈마켓 연계
 * </pre>
 */
@Component("sabangnetExcute")
@Slf4j
public class SabangnetExcute {

    @Resource(name = "sabangnetService")
    private SabangnetService sabangnetService;

    @Autowired
    private JobLauncher jobLauncher;

    @Resource(name = "goodsRegiJob") // 1.상품등록&수정 Job
    private Job goodsRegiJob;

    @Resource(name = "goodsSmrUpdJob") // 2.상품요약수정 Job
    private Job goodsSmrUpdJob;

    @Resource(name = "orderRequestJob") // 3.주문수집 Job
    private Job orderRequestJob;

    @Resource(name = "invoiceRegiJob") // 4.송장등록 Job
    private Job invoiceRegiJob;

    @Resource(name = "claimRequestJob") // 5.클레임수집 Job
    private Job claimRequestJob;

    @Resource(name = "inquiryRequestJob") // 6.문의사항수집 Job
    private Job inquiryRequestJob;

    @Resource(name = "inquiryReplyRegiJob") // 7.문의답변등록 Job
    private Job inquiryReplyRegiJob;

    /*@Resource(name = "goodsRequestJob") // 8.상품수집 Job
    private Job goodsRequestJob;*/

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : 
     * 설명   : 상품등록&수정
     *          매일 매시 정각 실행
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13.  - 최초생성
     * </pre>
     *
     */
    // 1.사방넷 상품등록&수정
    // @Scheduled(cron = "0 0/60 * * * *")
    public void registGoods() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("1-0.사방넷 상품등록&수정 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("1");
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("1-0.상품등록&수정 : 실행 -> {} ", vo);

            // 배치 실행 파라미터 세팅
            param = new JobParametersBuilder().addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.LANG, "EUC-KR") // 인코딩타입
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain()).addDate("d", new Date()) // 테스트
                    // 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
                    .toJobParameters();

            // 배치 실행
            runJob(goodsRegiJob, param);
        }

        log.debug("1-end.사방넷 상품등록 SabangnetExcute 종료");
    }

    // 2.사방넷 상품요약수정
    // @Scheduled(cron = "0 0/30 * * * *")
    public void smrUpdGoods() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("2-0.사방넷 상품요약수정 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("2");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("2-0.상품요약수정 : 실행 -> {} ", vo);

            // 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.LANG, "EUC-KR") // 인코딩타입
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain());

            jobParametersBuilder.addDate("d", new Date()); // 테스트
            // 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
            param = jobParametersBuilder.toJobParameters();

            // 배치 실행
            runJob(goodsSmrUpdJob, param);
        }

        log.debug("2-end.사방넷 상품요약수정 SabangnetExcute 종료");
    }

    // 3.사방넷 주문수집
    // @Scheduled(cron = "0 0/30 * * * *")
    public void readOrderInfo() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("3-0.사방넷 주문 수집 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("3");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("3-0.주문수집 : 실행 -> {} ", vo);

            // 주문수집 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain())

                    .addString(SabangnetConstant.ST_DATE, vo.getStDate()) // 주문<-검색시작일자
                    .addString(SabangnetConstant.ED_DATE, vo.getEdDate()) // 주문<-검색종료일자
                    .addString(SabangnetConstant.JUNG_CHK_YN2, "") // 매출정산확인여부
                    .addString(SabangnetConstant.ORDER_ID, "") // 주문번호
                    .addString(SabangnetConstant.MALL_ID, "") // 쇼핑몰ID
                    .addString(SabangnetConstant.ORDER_STATUS, "") // 주문상태
                    .addString(SabangnetConstant.LANG, "EUC-KR"); // 인코딩타입

            jobParametersBuilder.addDate("d", new Date()); // 테스트 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
            param = jobParametersBuilder.toJobParameters();

            // 배치 실행
            runJob(orderRequestJob, param);

        }

        log.debug("3-end.사방넷 주문 수집 SabangnetExcute 종료");
    }

    // 4.사방넷 송장등록
    // @Scheduled(cron = "0 0/30 * * * *")
    public void registInvoice() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("4-0.사방넷 송장등록 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("4");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("4-0.송장등록 : 실행 -> {} ", vo);

            // 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.LANG, "EUC-KR") // 인코딩타입
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain());

            jobParametersBuilder.addDate("d", new Date()); // 테스트
            // 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
            param = jobParametersBuilder.toJobParameters();

            // 배치 실행
            runJob(invoiceRegiJob, param);
        }

        log.debug("4-end.사방넷 송장등록 SabangnetExcute 종료");
    }

    // 5.사방넷 클레임수집
    // @Scheduled(cron = "0 0/60 * * * *")
    public void readClaimInfo() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("5-0.사방넷 클레임 수집 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("5");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("5-0.클레임수집 : 실행 -> {} ", vo);

            // 클레임수집 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain())

                    .addString(SabangnetConstant.ST_DATE, vo.getStDate()) // 클레임<-검색시작일자
                    .addString(SabangnetConstant.ED_DATE, vo.getEdDate()) // 클레임<-검색종료일자
                    .addString(SabangnetConstant.LANG, "EUC-KR"); // 인코딩타입

            jobParametersBuilder.addDate("d", new Date()); // 테스트
            // 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
            param = jobParametersBuilder.toJobParameters();

            // 배치 실행
            runJob(claimRequestJob, param);

        }

        log.debug("5-end.사방넷 클레임 수집 SabangnetExcute 종료");
    }

    // 6.사방넷 문의사항수집
    // @Scheduled(cron = "0 0/60 * * * *")
    public void readInquiryInfo() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("6-0.사방넷 문의사항 수집 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("6");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("6-0.문의사항수집 : 실행 -> {} ", vo);

            // 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain())

                    .addString(SabangnetConstant.ST_DATE, vo.getStDate()) // 문의사항<-검색시작일자
                    .addString(SabangnetConstant.ED_DATE, vo.getEdDate()) // 문의사항<-검색종료일자
                    .addString(SabangnetConstant.LANG, "EUC-KR"); // 인코딩타입

            jobParametersBuilder.addDate("d", new Date()); // 테스트
            // 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터

            param = jobParametersBuilder.toJobParameters();
            runJob(inquiryRequestJob, param);

        }

        log.debug("6-end.사방넷 문의사항 수집 SabangnetExcute 종료");
    }

    // 7.사방넷 문의답변등록
    // @Scheduled(cron = "0 0/30 * * * *")
    public void registInquiryReply() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("7-0.사방넷 문의답변등록 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("7");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("7-0.문의답변등록 : 실행 -> {} ", vo);

            // 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.LANG, "EUC-KR") // 인코딩타입
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain());

            jobParametersBuilder.addDate("d", new Date()); // 테스트
            // 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
            param = jobParametersBuilder.toJobParameters();

            // 배치 실행
            runJob(inquiryReplyRegiJob, param);
        }

        log.debug("7-end.사방넷 문의답변등록 SabangnetExcute 종료");
    }

    // 8.사방넷 상품수집
    // @Scheduled(cron = "0 0/30 * * * *")
   /* public void readGoodsInfo() throws JobParametersInvalidException, JobExecutionAlreadyRunningException,
            JobRestartException, JobInstanceAlreadyCompleteException {
        log.debug("8-0.사방넷 상품 수집 SabangnetExcute 시작");

        List<SabangnetTargetCompanyVO> companyList = sabangnetService.selectTargetCompany("8");
        JobParametersBuilder jobParametersBuilder;
        JobParameters param;

        // 업체별 루프
        for (SabangnetTargetCompanyVO vo : companyList) {
            log.debug("8-0.상품수집 : 실행 -> {} ", vo);

            // 주문수집 배치 실행 파라미터 세팅
            jobParametersBuilder = new JobParametersBuilder()
                    .addString(SabangnetConstant.SEND_COMPAYNY_ID, vo.getSendCompaynyId())
                    .addString(SabangnetConstant.SEND_AUTH_KEY, vo.getSendAuthKey())
                    .addString(SabangnetConstant.SEND_DATE, vo.getSendDate())
                    .addLong(SabangnetConstant.SITE_NO, vo.getSiteNo()) // 사이트번호
                    .addString(SabangnetConstant.SITE_ID, vo.getSiteId()) // 사이트ID
                    .addString(SabangnetConstant.SITE_NM, vo.getSiteNm()) // 사이트명
                    .addString(SabangnetConstant.DOMAIN, vo.getDlgtDomain())

                    .addString(SabangnetConstant.ST_DATE, vo.getStDate()) // 주문<-검색시작일자
                    .addString(SabangnetConstant.ED_DATE, vo.getEdDate()) // 주문<-검색종료일자
                    .addString(SabangnetConstant.LANG, "EUC-KR"); // 인코딩타입

            jobParametersBuilder.addDate("d", new Date()); // 테스트 후 삭제, 파라미터 중복으로 테스트 안되서 넣은 테스트용 파라미터
            param = jobParametersBuilder.toJobParameters();

            // 배치 실행
            runJob(goodsRequestJob, param);

        }

        log.debug("8-end.사방넷 상품 수집 SabangnetExcute 종료");
    }*/

    private void runJob(Job job, JobParameters param) throws JobParametersInvalidException,
            JobExecutionAlreadyRunningException, JobRestartException, JobInstanceAlreadyCompleteException {
        JobExecution execution;// 배치 실행
        execution = jobLauncher.run(job, param);
        log.debug("Exit Status : {}", execution.getStatus());
        log.debug("Exit Status : {}", execution.getFailureExceptions());
        log.debug("Exit Status : {}", execution.getAllFailureExceptions());
    }
}
