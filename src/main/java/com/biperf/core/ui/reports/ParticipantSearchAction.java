
package com.biperf.core.ui.reports;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import com.biperf.core.ui.participant.ParticipantSearchAjaxAction;

/**
 * ParticipantSearchAction.
 * 
 *
 */
public class ParticipantSearchAction extends ParticipantSearchAjaxAction
{
  // override
  protected Long getMainUserNode( HttpServletRequest request )
  {
    Long mainUserNode = null;

    String mainUserNodePar = request.getParameter( "mainUserNode" );
    if ( StringUtils.isNotBlank( mainUserNodePar ) )
    {
      try
      {
        mainUserNode = new Long( mainUserNodePar );
      }
      catch( NumberFormatException nfe )
      {
        // ignore
      }
    }

    return mainUserNode;
  }
}