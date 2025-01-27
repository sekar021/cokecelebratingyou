/*
 * $Source: /usr/local/ndscvsroot/products/penta-g/src/java/com/biperf/core/service/budget/BudgetToNodeOwnersAddressAssociationRequest.java,v $
 * (c) 2005 BI, Inc.  All rights reserved.
 */

package com.biperf.core.service.budget;

import com.biperf.core.domain.budget.Budget;
import com.biperf.core.service.BaseAssociationRequest;

/**
 * BudgetToNodeCharacteristicsAssociationRequest.
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
 * <td>meadows</td>
 * <td>Aug 22, 2006</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class BudgetToNodeOwnersAddressAssociationRequest extends BaseAssociationRequest
{

  /**
   * Overridden from
   * 
   * @see com.biperf.core.service.AssociationRequest#execute(Object)
   * @param domainObject
   */
  public void execute( Object domainObject )
  {
    Budget budget;
    if ( domainObject != null )
    {
      budget = (Budget)domainObject;
      initialize( budget.getNode() );
      if ( budget.getNode() != null )
      {
        initialize( budget.getNode().getUserNodes() );
        if ( budget.getNode().getNodeOwner() != null )
        {
          initialize( budget.getNode().getNodeOwner().getUserAddresses() );
        }
      }
    }
  }
}
