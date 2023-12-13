package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
public class MemberDPointErpDTO {
    private String DATES;
    private String STRCODE;
    private String POSNO;
    private String TRXNNO;
    private String CANCTYPE;
    private String INFLAG;
    private String SALAMT; /*구매금액*/
    private String CASHPAY; /*현금지불*/
    private String CASHPOINT;
    private String CARDPAY; /*카드지불*/
    private String CARDPOINT;
    private String SALPOINT; /*적립포인트*/
    private String NMCUST;
    private String USEPOINT; /*사용포인트*/
    private String USECDCUST;
    private String USENMCUST;
    private String POINTTOTAL;//단계별로 쌓이는 과정을 보여줌
    private String POINTTOTAL2;//최종포인트2 아직 2,3 번은 값이 같음 사용을 하던 적립을 하던
    private String POINTTOTAL3;//최종포인트3 그래서 총보유포인트를 이걸로 사용중 나중에 바꾸면됨
}
