/*
 * (c) 2005 BI, Inc.  All rights reserved.
 * $Source: /usr/local/ndscvsroot/products/beacon/src/javatest/com/biperf/core/service/awardbanq/AwardBanqServiceSuite.java,v $
 */

package com.biperf.core.service.awardbanq;

import com.biperf.core.service.awardbanq.impl.MockAwardBanQServiceImplTest;

import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * AwardsBanqService test suite for running all awards banq service tests out of container.
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
 * <td>Sathish</td>
 * <td>May 27, 2005</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 *
 */
public class AwardBanqServiceSuite extends TestSuite
{

  /**
   * Service Test Suite
   * 
   * @return Test
   */
  public static Test suite()
  {
    TestSuite suite = new TestSuite( "com.biperf.core.service.awardbanq.AwardBanqServiceSuite" );

    suite.addTestSuite( MockAwardBanQServiceImplTest.class );

    return suite;
  }

}
