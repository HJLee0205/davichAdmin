<%@ page  contentType="text/html; charset=euc-kr" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.Calendar" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.sql.SQLException" %>


<%



/*******************************************************************************
' FILE NAME : mx_rnoti.jsp
' FILE DESCRIPTION :
' 이니시스 smart phone 결제 결과 수신 페이지 샘플
' 기술문의 : ts@inicis.com
' HISTORY 
' 2010. 02. 25 최초작성 
' 2010  06. 23 WEB 방식의 가상계좌 사용시 가상계좌 채번 결과 무시 처리 추가(APP 방식은 해당 없음!!)
' 2017. 09. 18 가산 IP 추가
' WEB 방식일 경우 이미 P_NEXT_URL 에서 채번 결과를 전달 하였으므로, 
' 이니시스에서 전달하는 가상계좌 채번 결과 내용을 무시 하시기 바랍니다.

'*******************************************************************************/


// 이니시스 NOTI 서버에서 받은 Value
//  P_TID	거래번호
//  P_MID	상점아이디
//  P_AUTH_DT	승인일자
//  P_STATUS	거래상태 (00:성공, 01:실패)
//  P_TYPE	지불수단
//  P_OID	상점주문번호
//  P_FN_CD1	금융사코드1
//  P_FN_CD2	금융사코드2
//  P_FN_NM	금융사명 (은행명, 카드사명, 이통사명)
//  P_AMT	거래금액
//  P_UNAME	결제고객성명
//  P_RMESG1	결과코드
//  P_RMESG2	결과메시지
//  P_NOTI	노티메시지(상점에서 올린 메시지)
//  P_AUTH_NO	승인번호

String addr = request.getRemoteAddr().toString();
if("118.129.210.25".equals(addr) || "211.219.96.165".equals(addr) || "118.129.210.24".equals(addr) || "192.168.187.140".equals(addr) || "172.20.22.40".equals(addr) || "127.0.0.1".equals(addr) || "183.109.71.153".equals(addr) || "39.115.212.9".equals(addr) ) //PG에서 보냈는지 IP로 체크  118.129.210.24, 192.168.187.140, 172.20.22.40, 127.0.0.1은 사내 네트웍에서 테스트하기 위한 용도임
{
//**********************************************************************************
//이부분에 로그파일 경로를 수정해주세요.	
String file_path = "C:\\Program Files\\Apache Software Foundation\\Tomcat 7.0\\webapps\\ROOT\\company\\inicis\\test_logic\\mx\\jsp\\euckr\\log";  //로그를 기록할 디렉터리
//**********************************************************************************


	P_TID			= request.getParameter("P_TID") + "";   
	P_MID	    	= request.getParameter("P_MID") + "";   
	P_AUTH_DT   	= request.getParameter("P_AUTH_DT") + ""; 
	P_STATUS      	= request.getParameter("P_STATUS") + "";  
	P_TYPE       	= request.getParameter("P_TYPE") + "";    
	P_OID		 	= request.getParameter("P_OID") + "";     
	P_FN_CD1    	= request.getParameter("P_FN_CD1") + "";  
	P_FN_CD2    	= request.getParameter("P_FN_CD2") + "";  
	P_FN_NM     	= request.getParameter("P_FN_NM") + "";   
	P_UNAME     	= request.getParameter("P_UNAME") + "";   
	P_AMT       	= request.getParameter("P_AMT") + "";     
	P_RMESG1      	= request.getParameter("P_RMESG1") + "";  
	P_RMESG2    	= request.getParameter("P_RMESG2") + "";  
	P_NOTI			= request.getParameter("P_NOTI") + "";    
	P_AUTH_NO      	= request.getParameter("P_AUTH_NO") + ""; 

	P_CARD_ISSUER_CODE		= request.getParameter("P_CARD_ISSUER_CODE") + ""; 
	P_CARD_NUM				= request.getParameter("P_CARD_NUM") + ""; 

	/***********************************************************************************
	 결제처리에 관한 로그 기록
	 위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "OK"를 이니시스로 실패시는 "FAIL" 을
	 리턴하셔야합니다. 아래 조건에 데이터베이스 성공시 받는 FLAG 변수를 넣으세요
	 (주의) OK를 리턴하지 않으시면 이니시스 지불 서버는 "OK"를 수신할때까지 계속 재전송을 시도합니다
	 기타 다른 형태의 out.println(response.write)는 하지 않으시기 바랍니다
	***********************************************************************************/
	writeLog(file_path);
	//원래 소스는 91라인 바로 위에 넣어주는 것이다. 이쪽으로 위치시킨 것은 가상계좌 채번을 통해 
	//노티 페이지가 정상적으로 동작하는지 테스트하기 위함이다.
	




	try
	{	
		//WEB 방식의 경우 가상계좌 채번 결과 무시 처리
		//(APP 방식의 경우 해당 내용을 삭제 또는 주석 처리 하시기 바랍니다.)		
		/*
		if(P_TYPE.equals("VBANK"))	//결제수단이 가상계좌이며
		{
		  if(!P_STATUS.equals("02"))	//입금통보 "02" 가 아니면(가상계좌 채번 : 00 또는 01 경우)
		  {
		     out.print("OK");
		     return;		  	 
		  }
		
		}	
		*/
/* 생성한 DB 테이블
create database mobile;
use mobile;
create table mx(
	NO_ID INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	DT_INPUT DATE,
	TM_INPUT TIME,
	P_TID CHAR(40) ,
	P_MID CHAR(10) ,
	P_AUTH_DT CHAR(14),
	P_STATUS CHAR(4),
	P_TYPE VARCHAR(10),
	P_OID VARCHAR(100),
	P_FN_CD1 VARCHAR(4),
	P_FN_CD2 VARCHAR(10),
	P_FN_NM VARCHAR(50),
	P_UNAME VARCHAR(30),
	P_AMT VARCHAR(8),
	P_RMESG1 VARCHAR(500),
	P_RMESG2 VARCHAR(500),
	P_NOTI VARCHAR(1024),
	P_AUTH_NO VARCHAR(30),
	P_CARD_ISSUER_CODE VARCHAR(4),
	P_CARD_NUM VARCHAR(16)
);
*/
		System.out.println("Inserting values in Mysql database table!");
		Connection con = null;
		String url = "jdbc:mysql://localhost:3306/";
		String db = "mobile";
		String driver = "com.mysql.jdbc.Driver";
		try{
		  Class.forName(driver);
		  con = DriverManager.getConnection(url+db,"test","0000");
		  try{
			Statement st = con.createStatement();

			String sql = "INSERT INTO mx ";
			sql += "(P_TID,P_MID,P_AUTH_DT,P_STATUS,P_TYPE,P_OID,P_FN_CD1,P_FN_CD2,P_FN_NM,P_UNAME,P_AMT,P_RMESG1,P_RMESG2,P_NOTI,P_AUTH_NO,P_CARD_ISSUER_CODE,P_CARD_NUM) " ;
			sql += "VALUES ";
			sql += "(";
			sql += "'" + P_TID + "'" + ",";
			sql += "'" + P_MID + "'" + ",";
			sql += "'" + P_AUTH_DT + "'" + ",";
			sql += "'" + P_STATUS + "'" + ",";
			sql += "'" + P_TYPE + "'" + ",";
			sql += "'" + P_OID + "'" + ",";
			sql += "'" + P_FN_CD1 + "'" + ",";
			sql += "'" + P_FN_CD2 + "'" + ",";
			sql += "'" + P_FN_NM + "'" + ",";
			sql += "'" + P_UNAME + "'" + ",";
			sql += "'" + P_AMT + "'" + ",";
			sql += "'" + P_RMESG1 + "'" + ",";
			sql += "'" + P_RMESG2 + "'" + ",";
			sql += "'" + P_NOTI + "'" + ",";
			sql += "'" + P_AUTH_NO + "'" + ",";
			sql += "'" + P_CARD_ISSUER_CODE + "'" + ",";
			sql += "'" + P_CARD_NUM + "'";
			sql += ")";

			int val = st.executeUpdate(sql);
		   // System.out.println("1 row affected");
			// out.print("1 row affected");
			out.print("OK"); // 절대로 지우지 마세요 - 이 메시지가 입금통보 OK메시지
		  }
		  catch (SQLException s){
			//System.out.println("SQL statement is not executed!");
			// SQL 입력시 에러가 발생하면...
			out.print(""+s.toString());
			//out.print("SQL statement is not executed!");
		  }
		}
		catch (Exception e){
		  e.printStackTrace();
		}
  	  

	    
	}
	catch(Exception e)
	{
		out.print(e.getMessage());
	}


}	
%>



<%!

   	//이니시스 NOTI 서버에서 받은 Value
	String  P_TID;			// 거래번호
	String  P_MID;			// 상점아이디
	String  P_AUTH_DT;		// 승인일자
	String  P_STATUS;		// 거래상태 (00:성공, 01:실패)
	String  P_TYPE;			// 지불수단
	String  P_OID;			// 상점주문번호
	String  P_FN_CD1;		// 금융사코드1
	String  P_FN_CD2;		// 금융사코드2
	String  P_FN_NM;		// 금융사명 (은행명, 카드사명, 이통사명)
	String  P_AMT;			// 거래금액
	String  P_UNAME;		// 결제고객성명
	String  P_RMESG1;		// 결과코드
	String  P_RMESG2;		// 결과메시지
	String  P_NOTI;			// 노티메시지(상점에서 올린 메시지)
	String  P_AUTH_NO;		// 승인번호

	String  P_CARD_ISSUER_CODE;	// 발급사코드
	String  P_CARD_NUM;			// 카드번호


    private String getDate()
    {
    	Calendar calendar = Calendar.getInstance();
    	
    	StringBuffer times = new StringBuffer();
        times.append(Integer.toString(calendar.get(Calendar.YEAR)));
		if((calendar.get(Calendar.MONTH)+1)<10)
        { 
            times.append("0"); 
        }
		times.append(Integer.toString(calendar.get(Calendar.MONTH)+1));
		if((calendar.get(Calendar.DATE))<10) 
        {
            times.append("0");	
        } 
		times.append(Integer.toString(calendar.get(Calendar.DATE)));
    	
    	return times.toString();
    }
    
    private String getTime()
    {
    	Calendar calendar = Calendar.getInstance();
    	
    	StringBuffer times = new StringBuffer();

    	times.append("[");
    	if((calendar.get(Calendar.HOUR_OF_DAY))<10) 
        { 
            times.append("0"); 
        } 
 		times.append(Integer.toString(calendar.get(Calendar.HOUR_OF_DAY)));
 		times.append(":");
 		if((calendar.get(Calendar.MINUTE))<10) 
        { 
            times.append("0"); 
        }
 		times.append(Integer.toString(calendar.get(Calendar.MINUTE)));
 		times.append(":");
 		if((calendar.get(Calendar.SECOND))<10) 
        { 
            times.append("0"); 
        }
 		times.append(Integer.toString(calendar.get(Calendar.SECOND)));
 		times.append("]");
 		
 		return times.toString();
    }

    private void writeLog(String file_path) throws Exception
    {

        File file = new File(file_path);
        file.createNewFile();

        FileWriter file2 = new FileWriter(file_path+"/noti_input_"+getDate()+".log", true);


        file2.write("\n************************************************\n");
        file2.write("PageCall time : " 	+ getTime());
        file2.write("\n P_TID : " 	+ P_TID);
		file2.write("\n P_MID : " 	+ P_MID);
		file2.write("\n P_AUTH_DT : " 	+ P_AUTH_DT);
		file2.write("\n P_STATUS : " 	+ P_STATUS);
		file2.write("\n P_TYPE : " 	+ P_TYPE);
		file2.write("\n P_OID : " 	+ P_OID);
		file2.write("\n P_FN_CD1 : " 	+ P_FN_CD1);
		file2.write("\n P_FN_CD2 : " 	+ P_FN_CD2);
		file2.write("\n P_FN_NM : " 	+ P_FN_NM);
		file2.write("\n P_AMT : " 	+ P_AMT);
		file2.write("\n P_UNAME : " 	+ P_UNAME);
		file2.write("\n P_RMESG1 : " 	+ P_RMESG1);
		file2.write("\n P_RMESG2 : " 	+ P_RMESG2);
		file2.write("\n P_NOTI : " 	+ P_NOTI);	
		file2.write("\n P_AUTH_NO : " +	 P_AUTH_NO);	
		file2.write("\n P_CARD_ISSUER_CODE : " +	 P_CARD_ISSUER_CODE);	
		file2.write("\n P_CARD_NUM : " +	 P_CARD_NUM);	
        file2.write("\n************************************************");
		file2.write("\r\n\r\n");
        file2.close();

    }
%>

