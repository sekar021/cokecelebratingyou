/*
 * (c) 2005 BI, Inc.  All rights reserved.
 * $Source: /usr/local/ndscvsroot/products/penta-g/src/java/com/biperf/core/domain/enums/PickListItemSortOrderComparator.java,v $
 *
 */

package com.biperf.core.domain.enums;

import java.io.Serializable;
import java.util.Comparator;

/**
 * PickListItemNameComparator <p/> <b>Change History:</b><br>
 * <table border="1">
 * <tr>
 * <th>Author</th>
 * <th>Date</th>
 * <th>Version</th>
 * <th>Comments</th>
 * </tr>
 * <tr>
 * <td>dunne</td>
 * <td>Oct 7, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 * @author dunne
 *
 */
public class PickListItemSortOrderComparator implements Comparator, Serializable
{
  /**
   * Compares its two arguments for order. Returns a negative integer, zero, or a positive integer
   * as the first argument is less than, equal to, or greater than the second.
   * <p>
   * <p/> The implementor must ensure that <tt>sgn(compare(x, y)) == -sgn(compare(y, x))</tt> for
   * all <tt>x</tt> and <tt>y</tt>. (This implies that <tt>compare(x, y)</tt> must throw an
   * exception if and only if <tt>compare(y, x)</tt> throws an exception.)
   * <p>
   * <p/> The implementor must also ensure that the relation is transitive:
   * <tt>((compare(x, y)&gt;0)
   * &amp;&amp; (compare(y, z)&gt;0))</tt> implies
   * <tt>compare(x, z)&gt;0</tt>.
   * <p>
   * <p/> Finally, the implementer must ensure that <tt>compare(x, y)==0</tt> implies that
   * <tt>sgn(compare(x, z))==sgn(compare(y, z))</tt> for all <tt>z</tt>.
   * <p>
   * <p/> It is generally the case, but <i>not</i> strictly required that <tt>(compare(x, y)==0) ==
   * (x.equals(y))</tt>.
   * Generally speaking, any comparator that violates this condition should clearly indicate this
   * fact. The recommended language is "Note: this comparator imposes orderings that are
   * inconsistent with equals."
   * 
   * @param o1 the first object to be compared.
   * @param o2 the second object to be compared.
   * @return a negative integer, zero, or a positive integer as the first argument is less than,
   *         equal to, or greater than the second.
   * @throws ClassCastException if the arguments' types prevent them from being compared by this
   *           Comparator.
   */
  public int compare( Object o1, Object o2 )
  {
    if ( ! ( o1 instanceof PickListItem ) || ! ( o2 instanceof PickListItem ) )
    {
      throw new ClassCastException( "Object is not a PickListItem domain object!" );
    }
    PickListItem item1 = (PickListItem)o1;
    PickListItem item2 = (PickListItem)o2;

    return item1.getSortOrder() < item2.getSortOrder() ? -1 : item1.getSortOrder() == item2.getSortOrder() ? 0 : 1;
  }
}
