
package com.biperf.core.service.awardbanq;

public class ProcedureResponseVO
{
  private int errCode;
  private String errDescription;

  public ProcedureResponseVO()
  {

  }

  public int getErrCode()
  {
    return errCode;
  }

  public void setErrCode( int errCode )
  {
    this.errCode = errCode;
  }

  public String getErrDescription()
  {
    return errDescription;
  }

  public void setErrDescription( String errDescription )
  {
    this.errDescription = errDescription;
  }
}
