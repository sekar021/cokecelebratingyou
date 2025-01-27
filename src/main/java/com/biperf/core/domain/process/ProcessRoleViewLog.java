/*
 * (c) 2005 BI, Inc.  All rights reserved.
 * $Source: /usr/local/ndscvsroot/products/beacon/src/java/com/biperf/core/domain/process/ProcessRoleViewLog.java,v $
 */

package com.biperf.core.domain.process;

import com.biperf.core.domain.user.Role;

/**
 * PromotionWebRulesAudience.
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
 * <td>Aug 29, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class ProcessRoleViewLog extends ProcessRole
{

  public static final String PROCESS_ROLE_TYPE = "VIEW_LOG";

  public ProcessRoleViewLog()
  {
    super();
  }

  public ProcessRoleViewLog( Role role, Process process )
  {
    super();
    setRole( role );
    setProcess( process );
  }

  /**
   * Builds a String representations of this. Overridden from
   * 
   * @see java.lang.Object#toString()
   * @return String
   */
  public String toString()
  {

    StringBuffer sb = new StringBuffer();
    sb.append( super.toString() );
    sb.append( "processRoleType = " + ProcessRoleViewLog.PROCESS_ROLE_TYPE );

    return sb.toString();

  }

  public boolean equals( Object object )
  {
    if ( this == object )
    {
      return true;
    }

    if ( object instanceof ProcessRoleViewLog )
    {
      return super.equals( object );
    }

    return false;
  }

  public int hashCode()
  {
    return super.hashCode();
  }

}
