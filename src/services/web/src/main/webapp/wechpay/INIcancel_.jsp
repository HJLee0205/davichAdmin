<!------------------------------------------------------------------------------
FILE NAME : INIcancel.html
AUTHOR : rywkim@inicis.com
DATE : 2007/01
USE WITH : INIcancel.jsp, config.jsp, INIpay41.jar

지불 취소를 요청한다.

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
        <form name=ini method=post action=INIcancel.jsp>

            <table border=0 width=500>
                <tr>
                    <td>
                        <hr noshade size=1>
                        <b>지불 취소 샘플</b>
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
                        <br>지불시에 얻게 되는 거래번호(TID)를 입력하여 지불을 취소합니다.
                        관리자만이 이용할 수 있도록 구성하십시오. 지불 취소 및 각종 조회는
                        <a href=https://iniweb.inicis.com>https://iniweb.inicis.com</a>에서도
                        이용하실 수 있습니다.
                    </td>
                </tr>
            </table>
            <br>

            <table border=0 width=500>
                <tr>
                    <td align=center>
                        <table width=400 cellspacing=0 cellpadding=0 border=0 bgcolor=#6699CC>
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
                                                                    <td>거래번호 : </td>
                                                                    <td><input type=text name=tid size=45 value=""></td>
                                                                </tr>

                                                                <tr>
                                                                    <td>취소사유 : </td>
                                                                    <td><input type=text name=cancelMsg size=45 value=""></td>
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
