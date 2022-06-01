
package com.biperf.core.value.ssi;

/**
 * 
 * SSIContestMessageView.
 * 
 * @author kandhi
 * @since Nov 10, 2014
 * @version 1.0
 */
public class SSIContestMessageValueBean
{
  private String language;
  private String text;

  public SSIContestMessageValueBean()
  {
    super();
  }

  public SSIContestMessageValueBean( String language, String text )
  {
    super();
    this.language = language;
    this.text = text;
  }

  public String getLanguage()
  {
    return language;
  }

  public void setLanguage( String language )
  {
    this.language = language;
  }

  public String getText()
  {
    return text;
  }

  public void setText( String text )
  {
    this.text = text;
  }

}