
package com.biperf.core.dao.reports.hibernate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.StoredProcedure;

import oracle.jdbc.OracleTypes;

public class CallPrcCashBudgetSecondLevelExtract extends StoredProcedure
{
  private static final String STORED_PROC_NAME = "PKG_EXTRACTS.PRC_CASH_BUDGET_SUMDTL_EXTRACT";

  public CallPrcCashBudgetSecondLevelExtract( DataSource ds )
  {
    super( ds, STORED_PROC_NAME );
    // Note: Calls to declareParameter must be made in the same order as they appear in the
    // database's stored procedure parameter list.
    declareParameter( new SqlParameter( "p_in_parentNodeId", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_in_promotionId", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_in_budgetDistribution", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_in_budgetStatus", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_in_userid", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_in_locale", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_in_file_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_in_header", Types.VARCHAR ) );
    declareParameter( new SqlOutParameter( "p_out_return_code", Types.VARCHAR ) );
    declareParameter( new SqlOutParameter( "p_out_result_set", OracleTypes.CURSOR, new DataMapper() ) );

    compile();
  }

  public Map executeProcedure( Map<String, Object> reportParameters )
  {
    Map<String, Object> inParams = new HashMap<String, Object>();
    inParams.put( "p_in_parentNodeId", reportParameters.get( "parentNodeId" ) );
    if ( reportParameters.get( "extractType" ) != null && reportParameters.get( "extractType" ).equals( "primary" ) )
    {
      inParams.put( "p_in_promotionId", reportParameters.get( "filterPromotionId" ) );
    }
    else
    {
      inParams.put( "p_in_promotionId", reportParameters.get( "drilldownPromoId" ) );
    }
    inParams.put( "p_in_budgetDistribution", reportParameters.get( "budgetDistribution" ) );
    inParams.put( "p_in_budgetStatus", reportParameters.get( "budgetStatus" ) );
    inParams.put( "p_in_userid", reportParameters.get( "userId" ) );
    inParams.put( "p_in_locale", reportParameters.get( "languageCode" ) );
    inParams.put( "p_in_file_name", reportParameters.get( "internalFilename" ) );
    inParams.put( "p_in_header", reportParameters.get( "csHeaders" ) );

    Map outParams = execute( inParams );
    return outParams;
  }

  /**
   * DataMapper is an Inner class which implements the RowMapper.
   */
  private class DataMapper implements RowMapper
  {

    public String mapRow( ResultSet rs, int rowNum ) throws SQLException
    {
      return rs.getString( 1 );
    }
  }
}
