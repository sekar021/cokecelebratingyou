
package com.biperf.core.exception;

public class BadRequestException extends RuntimeException
{

  private static final long serialVersionUID = 1L;

  public BadRequestException( String msg )
  {
    super( msg );
  }

  public BadRequestException( String msg, Throwable t )
  {
    super( msg, t );
  }

}
