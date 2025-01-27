/*
 * $Source: /usr/local/ndscvsroot/products/beacon/src/java/com/biperf/core/service/hierarchy/NodeToNodeTypeAssociationRequest.java,v $
 * (c) 2005 BI, Inc.  All rights reserved.
 */

package com.biperf.core.service.hierarchy;

import com.biperf.core.domain.hierarchy.Node;
import com.biperf.core.service.BaseAssociationRequest;

/**
 * NodeToNodeTypeAssociationRequest is a concrete implementation of AssociationRequest and hydrates
 * the Node to NodeType association.
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
 * <td>sharma</td>
 * <td>May 13, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class NodeToNodeTypeAssociationRequest extends BaseAssociationRequest
{
  /**
   * Overridden from
   * 
   * @see com.biperf.core.service.AssociationRequest#execute(Object)
   * @param domainObject
   */
  public void execute( Object domainObject )
  {
    Node node = (Node)domainObject;
    initialize( node.getNodeType() ); // hydrate the association
  }

}
