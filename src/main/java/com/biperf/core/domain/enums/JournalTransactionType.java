/*
 * (c) 2005 BI, Inc.  All rights reserved.
 * $Source$
 */

package com.biperf.core.domain.enums;

import java.util.List;

/**
 * The JournalTransactionType is a concrete instance of a PickListItem which wrappes a type save
 * enum object of a PickList from content manager.
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
 * <td>wadzinsk</td>
 * <td>July 21, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class JournalTransactionType extends PickListItem
{

  public static final String DEPOSIT = "deposit";
  public static final String REVERSE = "reverse";
  public static final String PAYOUT = "payout";
  /**
   * Asset name used in Content Manager
   */
  private static final String PICKLIST_ASSET = "picklist.journaltransactiontype";

  /**
   * This constructor is protected - only the PickListFactory class creates these instances.
   */
  protected JournalTransactionType()
  {
    super();
  }

  /**
   * Get the pick list from content manager.
   * 
   * @return List
   */
  public static List getList()
  {
    return getPickListFactory().getPickList( JournalTransactionType.class );
  }

  /**
   * Returns null if the code is null or invalid for this list.
   * 
   * @param code
   * @return PickListItem
   */
  public static JournalTransactionType lookup( String code )
  {
    return (JournalTransactionType)getPickListFactory().getPickListItem( JournalTransactionType.class, code );
  }

  /**
   * Returns null if the defaultItem is not defined - or invalid
   * 
   * @return default PickListItem
   */
  // public static JournalTransactionType getDefaultItem()
  // {
  // return (JournalTransactionType)getPickListFactory().getDefaultPickListItem(
  // JournalTransactionType.class );
  // }
  /**
   * Overridden from
   * 
   * @see com.biperf.core.domain.enums.PickListItem#getPickListAssetCode()
   * @return PICKLIST_ASSET
   */
  public String getPickListAssetCode()
  {
    return PICKLIST_ASSET;
  }

  /**
   * @return True when this transaction type is {@link JournalTransactionType#REVERSE}
   */
  public boolean isReverse()
  {
    return REVERSE.equals( this.getCode() );
  }
}
