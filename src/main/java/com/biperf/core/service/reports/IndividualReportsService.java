
package com.biperf.core.service.reports;

import java.util.Map;

import com.biperf.core.service.SAO;

public interface IndividualReportsService extends SAO
{
  public static String BEAN_NAME = "individualReportsService";

  // =============================
  // INDIVIDUAL ACTIVITY REPORT
  // =============================

  public Map<String, Object> getIndividualActivityTabularResults( Map<String, Object> reportParameters );

  public Map<String, Object> getIndividualActivityPointsReceivedChart( Map<String, Object> reportParameters );

  public Map<String, Object> getIndividualActivityPointsGivenReceivedChart( Map<String, Object> reportParameters );

  public Map<String, Object> getIndividualActivityTotalActivityChart( Map<String, Object> reportParameters );

  public Map<String, Object> getIndividualActivityMetricsChart( Map<String, Object> reportParameters );

  // ===================================================
  // INDIVIDUAL ACTIVITY REPORT - AWARDS RECEIVED
  // ===================================================
  public Map<String, Object> getIndividualActivityAwardsReceivedTabularResults( Map<String, Object> reportParameters );

  // ===================================================
  // INDIVIDUAL ACTIVITY REPORT - NOMINATIONS RECEIVED
  // ==================================================

  public Map<String, Object> getIndividualActivityNominationsReceivedTabularResults( Map<String, Object> reportParameters );

  // ===================================================
  // INDIVIDUAL ACTIVITY REPORT - NOMINATIONS GIVEN
  // ===================================================

  public Map<String, Object> getIndividualActivityNominationsGivenTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - PRODUCT CLAIM
  // ==================================================

  public Map<String, Object> getIndividualActivityProductClaimTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - RECOGNITIONS GIVEN
  // ==================================================

  public Map<String, Object> getIndividualActivityRecognitionsGivenTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - RECOGNITIONS RECEIVED
  // ==================================================

  public Map<String, Object> getIndividualActivityRecognitionsReceivedTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - QUIZ
  // ==================================================

  public Map<String, Object> getIndividualActivityQuizTabularResults( Map<String, Object> reportParameters );

  public Map<String, Object> getIndividualActivityQuizDetailResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - THROWDOWN
  // ==================================================

  public Map<String, Object> getIndividualActivityThrowdownTabularResults( Map<String, Object> reportParameters );

  public Map<String, Object> getIndividualActivityThrowdownDetailResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - GOALQUEST
  // ==================================================

  public Map<String, Object> getIndividualActivityGoalQuestTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - CHALLENGEPOINT
  // ==================================================

  public Map<String, Object> getIndividualActivityChallengePointTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - ONTHESPOT
  // ==================================================

  public Map<String, Object> getIndividualActivityOnTheSpotTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - BADGE
  // ==================================================

  public Map<String, Object> getIndividualActivityBadgeTabularResults( Map<String, Object> reportParameters );

  // ==================================================
  // INDIVIDUAL ACTIVITY REPORT - EXTRACTS
  // ==================================================

  public Map getIndividualActivityReportExtract( Map<String, Object> reportParameters );

  // ==================================================
  // END INDIVIDUAL ACTIVITY REPORT - EXTRACTS
  // ==================================================

  public Map<String, Object> getIndividualActivitySSIContestTabularResults( Map<String, Object> reportParameters );

}
