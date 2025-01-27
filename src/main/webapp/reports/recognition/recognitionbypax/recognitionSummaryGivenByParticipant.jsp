<%@ include file="/include/taglib.jspf" %>
<%@page import="com.biperf.core.utils.ClientStateUtils"%>
<%@page import="com.biperf.core.ui.utils.RequestUtils"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.biperf.core.domain.report.Report"%>
<%@page import="com.biperf.core.value.recognitionbypax.RecognitionSummaryGivenByParticipantValue"%>
<%@page import="com.biperf.core.ui.reports.ReportParametersForm"%>

<%
Map<String, Object> sortMap = new HashMap<String, Object>();
ReportParametersForm reportParametersForm = (ReportParametersForm) request.getSession(  ).getAttribute( ReportParametersForm.FORM_NAME );
sortMap.put( "parentNodeId", reportParametersForm.getParentNodeId(  ) );
Report report = (Report)request.getAttribute( "report" );
String reportUrl = report.getUrl(  );
String sortUrl = ClientStateUtils.generateEncodedLink( "", reportUrl, sortMap );
pageContext.setAttribute("sortUrl", sortUrl);
%>

"tabularData": [
      {
        "meta": {
          "columns": [
          <c:choose>
			<c:when test="${displayHaveNotFilterExportMessage}">
				{
	              "id": "1",
	              "name": "Data not available for display",
	              "description": "This tabular data is only available for export",
	              "type": "string",
	              "alignment": "",
	              "nameId": "",
	              "sortable": false,
	              "sortUrl": "",
	              "summary": ""
	            }
			</c:when>
			<c:otherwise>
            {
              "id": "1",
              "name": "<cms:contentText key="GIVER" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="GIVER_DESC" code="${report.cmAssetCode}"/>",
              "type": "string",
              "alignment": "",
              "nameId": "",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=3&sortedBy=",
              "summary": "<c:if test="${totalsRowData!=null}"><cms:contentText key="TOTALS" code="${report.cmAssetCode}"/></c:if>"
            },
            {
              "id": "2",
              "name": "Organization drill-down URL",
              "description": "",
              "type": "URL",
              "alignment": "",
              "nameId": "",
              "sortable": false,
              "sortUrl": "",
              "summary": ""
            },
            {
              "id": "4",
              "name": "<cms:contentText key="COUNTRY" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="COUNTRY_DESC" code="${report.cmAssetCode}"/>",
              "type": "string",
              "alignment": "",
              "nameId": "",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=4&sortedBy=",
              "summary": ""
            },
            {
              "id": "5",
              "name": "<cms:contentText key="ORG_NAME" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="ORG_NAME_DESC" code="${report.cmAssetCode}"/>",
              "type": "string",
              "alignment": "",
              "nameId": "",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=5&sortedBy=",
              "summary": ""
            },
            {
              "id": "6",
              "name": "<cms:contentText key="DEPARTMENT" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="DEPARTMENT_DESC" code="${report.cmAssetCode}"/>",
              "type": "string",
              "alignment": "",
              "nameId": "",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=6&sortedBy=",
              "summary": ""
            },
            {
              "id": "7",
              "name": "<cms:contentText key="JOB_POSITION" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="JOB_POSITION_DESC" code="${report.cmAssetCode}"/>",
              "type": "string",
              "alignment": "",
              "nameId": "",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=7&sortedBy=",
              "summary": ""
            },
            {
              "id": "8",
              "name": "<cms:contentText key="NUMBER_OF_RECOGNITIONS" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="NUMBER_OF_RECOGNITIONS_DESC" code="${report.cmAssetCode}"/>",
              "type": "number",
              "alignment": "",
              "nameId": "total",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=8&sortedBy=",
              "summary": "<fmt:formatNumber value="${totalsRowData.recognitionsCnt}"/>"
            },
            {
              "id": "9",
              "name": "<cms:contentText key="POINTS_ISSUED" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="POINTS_ISSUED_DESC" code="${report.cmAssetCode}"/>",
              "type": "number",
              "alignment": "",
              "nameId": "total",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=9&sortedBy=",
              "summary": "<fmt:formatNumber value="${totalsRowData.pointsIssued}"/>"
            },
            {
              "id": "10",
              "name": "<cms:contentText key="PLATEAU_EARNED" code="${report.cmAssetCode}"/>",
              "description": "<cms:contentText key="PLATEAU_EARNED_DESC" code="${report.cmAssetCode}"/>",
              "type": "number",
              "alignment": "",
              "nameId": "",
              "sortable": true,
              "sortUrl": "<c:out value="${sortUrl}"/>&sortedOn=10&sortedBy=",
              "summary": "<fmt:formatNumber value="${totalsRowData.plateauEarnedCnt}"/>"
            }
            </c:otherwise>
         </c:choose>  
          ],
          <c:choose>
	          <c:when test="${reportParametersForm.sortedOn > 0}">
		          "sortedOn": "${reportParametersForm.sortedOn}",
		          "sortedBy": "${reportParametersForm.sortedBy}",
	          </c:when>
	          <c:otherwise>
		          "sortedOn": "1",
		          "sortedBy": "asc",
	          </c:otherwise>
          </c:choose>
          "maxRows": "${maxRows}",
          "exportFullReportUrl": [
            {
              "label": "<cms:contentText key="EXTRACT_FULL" code="report.display.page"/>",
              "url":  "${systemUrl}/reports/displayRecognitionGivenByPaxReport.do?method=extractReport&exportViewType=fullView"
            }
          ],
          "exportCurrentView": {
            "label": "<cms:contentText key="EXTRACT_CURRENT" code="report.display.page"/>",
            "url": "${systemUrl}/reports/displayRecognitionGivenByPaxReport.do?method=extractReport&exportViewType=currentView"
          },
      	  "inlineTextDescription": ""
        },
        "results": [
        <c:choose>
			<c:when test="${displayHaveNotFilterExportMessage}">
				[
					"<cms:contentText key="HAVE_NOT_FILTER_MSG" code="report.display.page"/>"
				]
			</c:when>
			<c:otherwise>
	        	<c:forEach var="reportItem" items="${reportData}" varStatus="reportDataStatus">
	          		<c:if test="${reportDataStatus.index != 0}">,</c:if>
	          		[
			            "${reportItem.giver}",
			            <%
			            RecognitionSummaryGivenByParticipantValue reportValue = (RecognitionSummaryGivenByParticipantValue)pageContext.getAttribute( "reportItem" );
            	        Map<String, Object> urlMap = new HashMap<String, Object>();
            		    Map<String, Object> paramMap = new HashMap<String, Object>();
            		    paramMap.put("userId", reportValue.getGiverUserId() );
            		    paramMap.put("giverNodeId", reportValue.getGiverNodeId() );
			    	    String urlToUse = "/reports/displayRecognitionGivenByPaxReport.do?method=displayActivityDetailReport";
			    	    String drilldownUrl = ClientStateUtils.generateEncodedLink( RequestUtils.getBaseURI(request), urlToUse, paramMap );
					%>
					"<%=drilldownUrl %>",
			            "${reportItem.country}",
			            "${reportItem.orgName}",
			            "${reportItem.department}",
			            "${reportItem.title}",
			            "<fmt:formatNumber value="${reportItem.recognitionsCnt}" />",
			            "<fmt:formatNumber value="${reportItem.pointsIssued}" />",
			            "<fmt:formatNumber value="${reportItem.plateauEarnedCnt}" />"
			  		]
	          	</c:forEach>
	        </c:otherwise>
		</c:choose>  	
        ]
      }
    ],
