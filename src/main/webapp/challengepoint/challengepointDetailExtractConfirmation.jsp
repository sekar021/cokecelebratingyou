<%--UI REFACTORED--%>
<%@ include file="/include/taglib.jspf"%>
<%@ page import="com.biperf.core.ui.utils.RequestUtils"%>
<%@ page import="java.util.*" %>
<%@ page import="com.biperf.core.domain.promotion.ChallengePointPromotion" %>
<%@ page import="com.biperf.core.utils.ClientStateUtils" %>

	<table border="0" cellpadding="10" cellspacing="0" width="100%">
		<tr>
		  <td>
			<span class="headline"><cms:contentText key="TITLE" code="promotion.challengepoint.detail.extract"/></span>
			<br/>
    	 	<span class="content-instruction">
				<b><c:out value="${promotionName}"/></b>
	     	</span>		
			<%--INSTRUCTIONS--%>
			<br/><br/>
    	 	<span class="content-instruction">
				<cms:contentText key="CONFIRMATION_MESSAGE" code="promotion.challengepoint.detail.extract"/>
     		</span>
	     	<br/><br/>
    	 	<%--END INSTRUCTIONS--%>
     		<cms:errors/>
		</td>
		</tr>    
					<%  Map parameterMap = new HashMap();
						ChallengePointPromotion temp = (ChallengePointPromotion)request.getAttribute("promotion");
						parameterMap.put( "id", temp.getId() );
						pageContext.setAttribute("viewUrl", ClientStateUtils.generateEncodedLink( "", "pendingCPAwardSummary.do", parameterMap ) );
					%>

		<tr align="center">
			<td>
      			<html:submit styleClass="content-buttonstyle" onclick="callUrl('${viewUrl}')" >
					<cms:contentText key="BACK_TO_SUMMARY" code="promotion.challengepoint.detail.extract"/>
				</html:submit>	
       	  	</td>
   		</tr>
	</table>    		


