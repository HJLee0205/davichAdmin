package net.danvi.dmall.biz.system.util;
/**
 * oracle clob 처리 handler
 * ex) query
 * #{content} --> #{content,jdbcType=CLOB}
 */

import java.io.StringReader;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;

import oracle.jdbc.OracleConnection;
import oracle.sql.CLOB;

@MappedJdbcTypes(JdbcType.CLOB)
public class ClobTypeHandler extends BaseTypeHandler<String> {

	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, String parameter, JdbcType jdbcType)
			throws SQLException {
		String value = (String) parameter;
		OracleConnection oracleConnection = null;

		try{
			// isWrapperFor 오류로 connection null 만 체크
			if(ps.getConnection() != null){
				oracleConnection = (OracleConnection) ps.getConnection();
			}
//			if (ps.getConnection().isWrapperFor(OracleConnection.class)) {
//				oracleConnection = ps.getConnection().unwrap(OracleConnection.class);
//			}
		}catch(Exception e){
			e.printStackTrace();
		}

		if (value != null) {
			CLOB clob = CLOB.createTemporary(oracleConnection, true, CLOB.DURATION_SESSION);
			clob.putChars(1, value.toCharArray());
			ps.setClob(i, clob);
		} else {
			ps.setString(i, null);
		}

//		StringReader reader = new StringReader(parameter);
//		ps.setCharacterStream(i, reader, parameter.length());
	}

	@Override
	public String getNullableResult(ResultSet rs, String columnName) throws SQLException {
		String value = "";
		Clob clob = rs.getClob(columnName);
		if (clob != null) {
			int size = (int) clob.length();
			value = clob.getSubString(1, size);
		}
		return value;
	}

	@Override
	public String getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		String value = "";
		Clob clob = rs.getClob(columnIndex);
		if (clob != null) {
			int size = (int) clob.length();
			value = clob.getSubString(1, size);
		}
		return value;
	}

	@Override
	public String getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		String value = "";
		Clob clob = cs.getClob(columnIndex);
		if (clob != null) {
			int size = (int) clob.length();
			value = clob.getSubString(1, size);
		}
		return value;
	}
}
