<!------------------------------------------------------------------------------
FILE NAME : INIcancel_sid.html
AUTHOR : mi@inicis.com
DATE : 2017/01
USE WITH : INIcancel_sid.jsp, config.jsp, INIpayJAVA.jar

SID로 지불 취소를 요청한다.

Copyright 2007 Inicis, Co. All rights reserved.
------------------------------------------------------------------------------->


<html>
    <head>
        <title>INIpay</title>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
        <style type="text/css">
            BODY{font-size:9pt; line-height:160%}
            TD{font-size:9pt; line-height:160%}
            A {color:blue;line-height:160%; background-color:#E0EFFE}
            INPUT{font-size:9pt;}
            SELECT{font-size:9pt;}
            .emp{background-color:#FDEAFE;}
        </style>
    </head>

    <body>
        <form name=ini method=post action=INIcancel_sid.jsp>

            <table border=0 width=500>
                <tr>
                    <td>
                        <hr noshade size=1>
                        <b>SID 지불 취소 샘플</b>
                        <hr noshade size=1>
                    </td>
                </tr>

                <tr>
                    <td>
                        <font color=gray>
                        이 페이지는 지불을 취소하는 JSP, HTML등을 구성하기 위한 예시입니다.
                        귀사의 요구에 맞게 적절히 수정하여 사용하십시오.
                        </font>
                    </td>
                </tr>

                <tr>
                    <td>
                        <br>지불시에 얻게 되는 거래번호(SID)를 입력하여 지불을 취소합니다.
                    </td>
                </tr>
            </table>
            <br>

            <table border=0 width=500>
                <tr>
                    <td align=center>
                        <table width=450 cellspacing=0 cellpadding=0 border=0 bgcolor=#6699CC>
                            <tr>
                                <td>
                                    <table width=100% cellspacing=1 cellpadding=2 border=0>
                                        <tr bgcolor=#BBCCDD height=25>
                                            <td align=center>
                                                정보를 기입하신 후 확인버튼을 눌러주십시오
                                            </td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td valign=top>
                                                <table width=100% cellspacing=0 cellpadding=2 border=0>
                                                    <tr>
                                                        <td align=center>
                                                            <br>
                                                            <table>
                                                                <tr>
                                                                    <td>상점아이디 : </td>
                                                                    <td><input type=text name=mid size=10 value="INIpayTes2"></td>
                                                                </tr>

                                                                <tr>
                                                                    <td>거래번호(SID) : </td>
                                                                    <td><input type=text name=sid size=40 value=""></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>지불수단 : </td>
                                                                    <td><input type=text name=paymethod size=10 value="TPAY"> (위챗페이 : TPAY)</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>서비스코드  </td>
                                                                    <td><input type=text name=svccode size=10 value="W"> (위챗페이 : W)</td>
                                                                </tr>                                                                
                                                                <tr>
                                                                    <td>취소사유 : </td>
                                                                    <td><input type=text name=cancelMsg size=40 value=""></td>
                                                                </tr>

                                                                <tr>
                                                                    <td colspan=2 align=center>
                                                                        <br>
                                                                        <input type="submit" value=" 확 인 ">
                                                                        <br><br>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br>

            <table border=0 width=500>
                <tr>
                    <td><hr noshade size=1></td>
                </tr>

                <tr>
                    <td align=right>Copyright Inicis, Co.<br>www.inicis.com</td>
                </tr>
            </table>

        </form>
    </body>
</html>
