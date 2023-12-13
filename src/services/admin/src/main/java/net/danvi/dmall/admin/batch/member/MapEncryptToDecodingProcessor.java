package net.danvi.dmall.admin.batch.member;

import java.util.Map;

import org.springframework.batch.item.ItemProcessor;

import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 22.
 * 작성자     : kjw
 * 설명       : Map의 암호화된 생년월일을 복호화하여 성인여부 판단
 * </pre>
 */
public class MapEncryptToDecodingProcessor implements ItemProcessor<Map, MemberManageVO> {

    @Override
    public MemberManageVO process(Map m) throws Exception {
        MemberManageVO memberManageVO = new MemberManageVO();
        Number memNo = (Number) m.get("MEMBER_NO");
        memberManageVO.setBirth(CryptoUtil.decryptAES((String) m.get("BIRTH")));
        memberManageVO.setMemberNo(memNo.longValue());

        String adultYn = DateUtil.getAdultYn(memberManageVO.getBirth());

        memberManageVO.setAdultCertifyYn(adultYn);
        // String birth = memberManageVO.getBirth();
        //
        // String today = ""; // 오늘 날짜
        // int manAge = 0; // 만 나이
        //
        // SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        //
        // today = formatter.format(new Date()); // 시스템 날짜를 가져와서 yyyyMMdd 형태로 변환
        //
        // // today yyyyMMdd
        // int todayYear = Integer.parseInt(today.substring(0, 4));
        // int todayMonth = Integer.parseInt(today.substring(4, 6));
        // int todayDay = Integer.parseInt(today.substring(6, 8));
        //
        // int ssnYear = Integer.parseInt(birth.substring(0, 4));
        // int ssnMonth = Integer.parseInt(birth.substring(4, 6));
        // int ssnDay = Integer.parseInt(birth.substring(6, 8));
        //
        // manAge = todayYear - ssnYear;
        //
        // if (todayMonth < ssnMonth) { // 생년월일 "월"이 지났는지 체크
        // manAge--;
        // } else if (todayMonth == ssnMonth) { // 생년월일 "일"이 지났는지 체크
        // if (todayDay < ssnDay) {
        // manAge--; // 생일 안지났으면 (만나이 - 1)
        // }
        // }
        //
        // if (manAge < 19) {
        // memberManageVO.setAdultCertifyYn("N");
        // } else {
        // memberManageVO.setAdultCertifyYn("Y");
        // }

        return memberManageVO;
    }
}
