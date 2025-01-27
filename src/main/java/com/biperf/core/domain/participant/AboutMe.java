/*
 * (c) 2005 BI, Inc.  All rights reserved.
 * $Source: /usr/local/ndscvsroot/products/penta-g/src/java/com/biperf/core/domain/user/User.java,v $
 */

package com.biperf.core.domain.participant;

import com.biperf.core.domain.BaseDomain;
import com.biperf.core.domain.enums.AboutMeQuestionType;
import com.biperf.core.domain.user.User;

/**
 * AboutMe domain object which represents ALL users within the Beacon application.
 * <p>
 * <b>Change History:</b><br>
 * <table border="1">
 * <tr>
 * <th>Author</th>
 * <th>Date</th>
 * <th>Version</th>
 * <th>Comments</th>
 * </tr>
 * <tr>
 * <td>crosenquest</td>
 * <td>Apr 4, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class AboutMe extends BaseDomain
{
  private AboutMeQuestionType aboutMeQuestionType;
  private String answer;
  private User user;

  public AboutMeQuestionType getAboutMeQuestionType()
  {
    return aboutMeQuestionType;
  }

  public void setAboutMeQuestionType( AboutMeQuestionType aboutMeQuestionType )
  {
    this.aboutMeQuestionType = aboutMeQuestionType;
  }

  public String getAnswer()
  {
    return answer;
  }

  public void setAnswer( String answer )
  {
    this.answer = answer;
  }

  public User getUser()
  {
    return user;
  }

  public void setUser( User user )
  {
    this.user = user;
  }

  @Override
  public boolean equals( Object obj )
  {
    if ( this == obj )
    {
      return true;
    }
    if ( obj == null )
    {
      return false;
    }
    if ( getClass() != obj.getClass() )
    {
      return false;
    }
    AboutMe other = (AboutMe)obj;
    if ( aboutMeQuestionType == null )
    {
      if ( other.aboutMeQuestionType != null )
      {
        return false;
      }
    }
    else if ( !aboutMeQuestionType.equals( other.aboutMeQuestionType ) )
    {
      return false;
    }
    if ( answer == null )
    {
      if ( other.answer != null )
      {
        return false;
      }
    }
    else if ( !answer.equals( other.answer ) )
    {
      return false;
    }
    if ( user == null )
    {
      if ( other.user != null )
      {
        return false;
      }
    }
    else if ( !user.equals( other.user ) )
    {
      return false;
    }
    return true;
  }

  @Override
  public int hashCode()
  {
    final int prime = 31;
    int result = 1;
    result = prime * result + ( aboutMeQuestionType == null ? 0 : aboutMeQuestionType.hashCode() );
    result = prime * result + ( answer == null ? 0 : answer.hashCode() );
    result = prime * result + ( user == null ? 0 : user.hashCode() );
    return result;
  }

}
