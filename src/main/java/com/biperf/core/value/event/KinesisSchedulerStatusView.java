package com.biperf.core.value.event;

public class KinesisSchedulerStatusView
{
  private String status = null;
  private String message = null;

  public String getStatus()
  {
    return status;
  }

  public void setStatus( String status )
  {
    this.status = status;
  }

  public String getMessage()
  {
    return message;
  }

  public void setMessage( String message )
  {
    this.message = message;
  }

}
