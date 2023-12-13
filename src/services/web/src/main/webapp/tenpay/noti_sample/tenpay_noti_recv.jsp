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
 * �̴Ͻý� ������ ���� ��� �뺸�� �޴� ���� �������Դϴ�.
 * [��������] �ڼ��� ������ �޴��� ����
 * ������           �ѱ۸�                           
 * P_TID        TID
 * P_MID        �������̵�
 * P_AUTH_DT    ��������
 * P_STATUS     �ŷ�����
 * P_TYPE       ���Ҽ���
 * P_OID        �ֹ���ȣ
 * P_AUTH_NO    ���� ��ȣ
 * P_AMT        ���� �ݾ�
 * P_RESULTCD   ����ڵ�
 * P_RESULTMSG  ����޽���
 * P_EXRATE     ȯ��
 * P_HASH       �ؽ�����
 * P_RMESG1     �ӽ��ʵ� 1
 *******************************************************************************/

/***********************************************************************************
 * �̴Ͻý��� �����ϴ� �˸����� ���� ����� �����Ͽ� DB ó�� �ϴ� �κ� �Դϴ�.	
 * �ʿ��� �Ķ���Ϳ� ���� DB �۾��� �����Ͻʽÿ�.
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


    //hash ������ parameter
    signature = P_HASH;//���� �ؽð�
    hash_key = "SU5JTElURV9UUklQTEVERVNfS0VZU1RS";//������ �����ڻ���Ʈ������ Ȯ�� �ٶ��ϴ�.
    hash_chk = "";//�ؽ� ���� �����
    
    // �Ŵ����� ���ð� �߰��Ͻ� �Ķ���Ͱ� �����ø� �Ʒ��� ���� ������� �߰��Ͽ� ����Ͻñ� �ٶ��ϴ�.
    // String value = reqeust.getParameter("������ �ʵ��");

	try
	{
		// ================================================================================================
	    // �ؽ��� ������ �ϴ� �����Դϴ�.
	    // sha512 �Լ��� hex ó���� ���� �ʴ� ���� �Լ��� �������� ȯ�濡 �°� �����Ͻ� �� �ֽ��ϴ�.
	    // base64 ���ڵ� �� ���ڵ��� sun.misc.* ��Ű���� �̿��Ͽ� ó�� �մϴ�. �������� ȯ�濡 �°� �����Ͻ� �� �ֽ��ϴ�.

	    String plainText = P_OID + P_AMT + P_AUTH_NO + hash_key;//�ؽ� ���� �򹮰� 
	    byte sha512[] = sha512NotHex(plainText);      
	    
	    String tempSignature = new BASE64Encoder().encode(sha512);//������ hash�� base64 ���ڵ� ó�� 
	    System.out.println("signature : " + signature);    
        System.out.println("tempSignature : " + tempSignature);    
	    
	    //���������� ������ sha512 hash ���� ���� signature���� base64 ���ڵ��� hash ���� �����մϴ�.
		boolean verifyHash  = java.util.Arrays.equals(sha512, new BASE64Decoder().decodeBuffer(signature) );//byte �� �Լ��� ���� ����       

	    if(verifyHash){
			hash_chk = "HASH CHECK SUCCESS";
			writeLog(file_path);
		}else{
			hash_chk = "HASH CHECK FAIL";
			writeLog(file_path);
			return;
		}  
		
		//***********************************************************************************
		//	������ ���� �����ͺ��̽��� ��� ���������� ���� �����ÿ��� "OK"��, ���нÿ��� "CANCEL"�� �̴Ͻý���
		//	�����ϼž��մϴ�. �Ʒ� ���ǿ� �����ͺ��̽� ������ �޴� FLAG ������ ��������
		//	(����) �̴Ͻý� ���� ������ "OK" �Ǵ� "CANCEL"�� �����Ҷ����� ��� �������� �õ��մϴ�
		//	��Ÿ �ٸ� ������ out.println(response.write)�� ���� �����ñ� �ٶ��ϴ�
		
		boolean chkDB = true;
		if (chkDB) 
		{
        	out.print("OK"); // ����� ������ ������
		} else {
            out.print("CANCEL"); // ����� ������ ������
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
