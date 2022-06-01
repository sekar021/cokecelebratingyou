/*
 * (c) 2005 BI, Inc.  All rights reserved.
 * $Source: /usr/local/ndscvsroot/products/beacon/src/javaui/com/biperf/core/ui/system/SystemVariableListController.java,v $
 */

package com.biperf.core.ui.system;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.tiles.ComponentContext;

import com.biperf.core.service.system.SystemVariableService;
import com.biperf.core.ui.BaseController;
import com.biperf.core.ui.utils.PresentationUtils;

/**
 * Implements the controller for the SystemVariableList page.
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
 * <td>sedey</td>
 * <td>Apr 14, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class SystemVariableListController extends BaseController
{
  /**
   * Tiles controller for the SystemVariableList page
   * 
   * @see org.apache.struts.tiles.Controller#execute(org.apache.struts.tiles.ComponentContext,
   *      javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
   *      javax.servlet.ServletContext) Overridden from
   * @see com.biperf.core.ui.BaseController#onExecute(org.apache.struts.tiles.ComponentContext,
   *      javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
   *      javax.servlet.ServletContext)
   * @param context
   * @param request
   * @param response
   * @param servletContext
   * @throws Exception
   */
  public void onExecute( ComponentContext context, HttpServletRequest request, HttpServletResponse response, ServletContext servletContext ) throws Exception
  {
    List systemVariableList = getSystemVariableService().getAllProperties();

    request.setAttribute( "systemVariableList", systemVariableList );
    request.setAttribute( "pageSize", new Integer( PresentationUtils.getDisplayTablePageSize( systemVariableList.size() ) ) );
  }

  /**
   * Get the SystemVariableService from the beanLocator.
   * 
   * @return SystemVariableService
   * @throws Exception
   */
  private SystemVariableService getSystemVariableService() throws Exception
  {
    return (SystemVariableService)getService( SystemVariableService.BEAN_NAME );
  }
}