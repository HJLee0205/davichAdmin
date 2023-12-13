package net.danvi.dmall.smsemail.model.email;

import net.danvi.dmall.smsemail.model.request.EmailReceiverPO;

import java.util.Date;

/**
 * Created by dong on 2016-08-31.
 */
public class CustomerDataPO {
    /** 아이디 */
    private Long id;
    /** 이메일 */
    private String email;
    /** 고객명 */
    private String first;
    /** 고객번호 */
    private String second;
    /** 수신동의일 */
    private String third;
    /** 우수고객등급 */
    private String fourth;
    /** 우수고객포인트 */
    private String fifth;
    /** 기타1 */
    private String sixth;
    /** 기타2 */
    private String seventh;
    /** 기타3 */
    private String eighth;
    /** 기타4 */
    private String ninth;
    /** 기타5 */
    private String tenth;
    /** 기타6 */
    private String eleventh;
    /** 기타7 */
    private String twelfth;
    /** 기타8 */
    private String thirteenth;
    /** 기타9 */
    private String fourteenth;
    /** 기타10 */
    private String fifteenth;
    /** 휴대폰 */
    private String sixteenth;
    /** 텍스트1 */
    private String seventeenth;
    /** 텍스트2 */
    private String eighteenth;
    /** 텍스트3 */
    private String nineteenth;
    /** 입력시간 */
    private Date registDate;

    public CustomerDataPO() {}

    public CustomerDataPO(EmailReceiverPO po) {
        this.email = po.getReceiverEmail();
        this.first = po.getReceiverNm();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirst() {
        return first;
    }

    public void setFirst(String first) {
        this.first = first;
    }

    public String getSecond() {
        return second;
    }

    public void setSecond(String second) {
        this.second = second;
    }

    public String getThird() {
        return third;
    }

    public void setThird(String third) {
        this.third = third;
    }

    public String getFourth() {
        return fourth;
    }

    public void setFourth(String fourth) {
        this.fourth = fourth;
    }

    public String getFifth() {
        return fifth;
    }

    public void setFifth(String fifth) {
        this.fifth = fifth;
    }

    public String getSixth() {
        return sixth;
    }

    public void setSixth(String sixth) {
        this.sixth = sixth;
    }

    public String getSeventh() {
        return seventh;
    }

    public void setSeventh(String seventh) {
        this.seventh = seventh;
    }

    public String getEighth() {
        return eighth;
    }

    public void setEighth(String eighth) {
        this.eighth = eighth;
    }

    public String getNinth() {
        return ninth;
    }

    public void setNinth(String ninth) {
        this.ninth = ninth;
    }

    public String getTenth() {
        return tenth;
    }

    public void setTenth(String tenth) {
        this.tenth = tenth;
    }

    public String getEleventh() {
        return eleventh;
    }

    public void setEleventh(String eleventh) {
        this.eleventh = eleventh;
    }

    public String getTwelfth() {
        return twelfth;
    }

    public void setTwelfth(String twelfth) {
        this.twelfth = twelfth;
    }

    public String getThirteenth() {
        return thirteenth;
    }

    public void setThirteenth(String thirteenth) {
        this.thirteenth = thirteenth;
    }

    public String getFourteenth() {
        return fourteenth;
    }

    public void setFourteenth(String fourteenth) {
        this.fourteenth = fourteenth;
    }

    public String getFifteenth() {
        return fifteenth;
    }

    public void setFifteenth(String fifteenth) {
        this.fifteenth = fifteenth;
    }

    public String getSixteenth() {
        return sixteenth;
    }

    public void setSixteenth(String sixteenth) {
        this.sixteenth = sixteenth;
    }

    public String getSeventeenth() {
        return seventeenth;
    }

    public void setSeventeenth(String seventeenth) {
        this.seventeenth = seventeenth;
    }

    public String getEighteenth() {
        return eighteenth;
    }

    public void setEighteenth(String eighteenth) {
        this.eighteenth = eighteenth;
    }

    public String getNineteenth() {
        return nineteenth;
    }

    public void setNineteenth(String nineteenth) {
        this.nineteenth = nineteenth;
    }

    public Date getRegistDate() {
        return registDate;
    }

    public void setRegistDate(Date registDate) {
        this.registDate = registDate;
    }
}
