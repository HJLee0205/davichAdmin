<%@page import="sun.misc.BASE64Decoder"%>
<%@page import="sun.misc.BASE64Encoder"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.Calendar" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%
/*******************************************************************************
 * FILE NAME : tenpay_noti_recv.jsp
 * DATE : 2015.08
 * 이니시스 텐페이 결제 결과 통보를 받는 샘플 페이지입니다.
 * [수신정보] 자세한 내용은 메뉴얼 참조
 * 변수명           한글명                           
 * P_TID        TID
 * P_MID        상점아이디
 * P_AUTH_DT    승인일자
 * P_STATUS     거래상태
 * P_TYPE       지불수단
 * P_OID        주문번호
 * P_AUTH_NO    승인 번호
 * P_AMT        승인 금액
 * P_RESULTCD   결과코드
 * P_RESULTMSG  결과메시지
 * P_EXRATE     환율
 * P_HASH       해쉬검증
 * P_RMESG1     임시필드 1
 *******************************************************************************/

/***********************************************************************************
 * 이니시스가 전달하는 알리페이 결제 결과를 수신하여 DB 처리 하는 부분 입니다.	
 * 필요한 파라메터에 대한 DB 작업을 수행하십시오.
 ***********************************************************************************/	

	String file_path = "/usr/local/resin/webapps/INIpay";

	P_TID = request.getParameter("P_TID");
    P_MID = request.getParameter("P_MID");
	P_AUTH_DT = request.getParameter("P_AUTH_DT");
	P_STATUS = request.getParameter("P_STATUS");
	P_TYPE = request.getParameter("P_TYPE");
	P_OID = request.getParameter("P_OID");
	P_AUTH_NO = request.getParameter("P_AUTH_NO");
	P_AMT = request.getParameter("P_AMT");
	P_RESULTCD = request.getParameter("P_RESULTCD");
	P_RESULTMSG = request.getParameter("P_RESULTMSG");
	P_EXRATE = request.getParameter("P_EXRATE");
	P_HASH = request.getParameter("P_HASH");
	P_RMESG1 = request.getParameter("P_RMESG1");


    //hash 검증용 parameter
    signature = P_HASH;//검증 해시값
    hash_key = "SU5JTElURV9UUklQTEVERVNfS0VZU1RS";//가맹점 관리자사이트내에서 확인 바랍니다.
    hash_chk = "";//해쉬 검증 결과값
    
    // 매뉴얼을 보시고 추가하실 파라메터가 있으시면 아래와 같은 방법으로 추가하여 사용하시기 바랍니다.
    // String value = reqeust.getParameter("전문의 필드명");

	try
	{
		// ================================================================================================
	    // 해쉬값 검증을 하는 로직입니다.
	    // sha512 함수는 hex 처리를 하지 않는 샘플 함수로 가맹점에 환경에 맞게 구현하실 수 있습니다.
	    // base64 인코딩 및 디코딩은 sun.misc.* 패키지를 이용하여 처리 합니다. 가맹점에 환경에 맞게 구현하실 수 있습니다.

	    String plainText = P_OID + P_AMT + P_AUTH_NO + hash_key;//해쉬 검증 평문값 
	    byte sha512[] = sha512NotHex(plainText);      
	    
	    String tempSignature = new BASE64Encoder().encode(sha512);//생성된 hash값 base64 인코딩 처리 
	    System.out.println("signature : " + signature);    
        System.out.println("tempSignature : " + tempSignature);    
	    
	    //가맹점에서 생성한 sha512 hash 값과 받은 signature값의 base64 디코딩한 hash 값을 검증합니다.
		boolean verifyHash  = java.util.Arrays.equals(sha512, new BASE64Decoder().decodeBuffer(signature) );//byte 비교 함수를 통해 검증       

	    if(verifyHash){
			hash_chk = "HASH CHECK SUCCESS";
			writeLog(file_path);
		}else{
			hash_chk = "HASH CHECK FAIL";
			writeLog(file_path);
			return;
		}  
		
		//***********************************************************************************
		//	위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "OK"를, 실패시에는 "CANCEL"을 이니시스로
		//	리턴하셔야합니다. 아래 조건에 데이터베이스 성공시 받는 FLAG 변수를 넣으세요
		//	(주의) 이니시스 지불 서버는 "OK" 또는 "CANCEL"을 수신할때까지 계속 재전송을 시도합니다
		//	기타 다른 형태의 out.println(response.write)는 하지 않으시기 바랍니다
		
		boolean chkDB = true;
		if (chkDB) 
		{
        	out.print("OK"); // 절대로 지우지 마세요
		} else {
            out.print("CANCEL"); // 절대로 지우지 마세요
		}
	
	} catch(Exception e) {
		out.print(e.getMessage());
	}

%>
<%!

    private String P_TID;
    private String P_MID;
    private String P_AUTH_DT;
    private String P_STATUS;
    private String P_TYPE;
    private String P_OID;
    private String P_AUTH_NO;
    private String P_AMT;
    private String P_RESULTCD;
    private String P_RESULTMSG;
    private String P_EXRATE;
    private String P_HASH;
    private String P_RMESG1;
    
    private StringBuffer times;
    private String signature;
    private String hash_key;    
    private String hash_chk;    
    
    private String getDate()
    {
    	Calendar calendar = Calendar.getInstance();
    	
    	times = new StringBuffer();
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
    	
    	times = new StringBuffer();

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

		System.out.println(file_path);
        File file = new File(file_path);
        file.createNewFile();
        FileWriter file2 = new FileWriter(file_path+"/tenpay_noti_"+getDate()+".log", true);


        file2.write("\n************************************************\n");
        file2.write("PageCall time : " + getTime());
        file2.write("\nP_TID : " + P_TID);
        file2.write("\nP_MID : " + P_MID);
        file2.write("\nP_AUTH_DT : " + P_AUTH_DT);
        file2.write("\nP_STATUS : " + P_STATUS);
        file2.write("\nP_TYPE : " + P_TYPE);
        file2.write("\nP_OID : " + P_AUTH_NO);
        file2.write("\nP_AMT : " + P_AMT);        
        file2.write("\nP_RESULTCD : " + P_RESULTCD);        
        file2.write("\nP_RESULTMSG : " + P_RESULTMSG);        
        file2.write("\nP_EXRATE : " + P_EXRATE);        
        file2.write("\nP_RMESG1 : " + P_RMESG1);        
        file2.write("\nP_HASH : " + P_HASH);
        file2.write("\nHASH_CHK : " + hash_chk);              
        file2.write("\n************************************************\n");

        file2.close();

    }
    
    public byte[] sha512NotHex(String str){

        byte byteData[] = null;

         try{

             MessageDigest sh = MessageDigest.getInstance("SHA-512"); 
             sh.update(str.getBytes()); 
             byteData = sh.digest();
             
         }catch(NoSuchAlgorithmException e){
             e.printStackTrace();
         }
         
         return byteData;
    }
    
%>
