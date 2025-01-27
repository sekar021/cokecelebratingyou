<%@ page import="java.util.*" %>
<%@ page import="com.biperf.core.utils.ClientStateUtils" %>
<%@ page import="com.biperf.core.ui.utils.RequestUtils"%>
<%@ page import="com.biperf.core.utils.UserManager"%>
<%@ include file="/include/taglib.jspf" %>

<%--UI REFACTORED--%>

<script type="text/javascript">

<%  
  Map paramMap = new HashMap();
  Long userId = (Long)request.getAttribute("userId");
  Long promotionId = (Long)request.getAttribute("promotionId");
  paramMap.put( "userId", userId );
  paramMap.put( "promotionId", promotionId );
%>

function backToPromotionsDetails()
{
  <% 
	pageContext.setAttribute("promotionURL", ClientStateUtils.generateEncodedLink( RequestUtils.getBaseURI(request), "/participant/paxThrowdownDetailsDisplay.do", paramMap ) );
  %>
  var url = "<c:out value='${promotionURL}'/>";
  url = url.replace(/&amp;/g, "&");
  window.location = url;
}


function getProgress()
{
  setActionDispatchAndSubmit('throwdownProgress.do','getProgress')
}

</script>
<html:form styleId="contentForm" action="saveThrowdownProgress">
  <html:hidden property="method" value="savePaxProgress" />
  <html:hidden property="promotionId" value="${promotionId}" />
  <html:hidden property="userId" value="${userId}"/>
  
<table border="0" cellpadding="10" cellspacing="0" width="100%">
  <tr>
	<td colspan="2">
	  <span class="headline">
	    <cms:contentText key="TITLE" code="participant.throwdown.promo.detail"/>
	  </span>
	  <br/>
	  <beacon:username userId="${userId}"/> 
    </td>
  </tr>  
  <%--INSTRUCTIONS--%>
  <tr>
    <td></td>
    <td class="content-instruction">
        <cms:contentText key="INSTRUCTIONS" code="participant.throwdown.promo.detail"/>
        <br><br>
        <cms:errors/>
    </td>
  </tr>
  <tr>
	<td></td>
	<td> 
      <table>
	    <tr class="form-row-spacer">				  
          <td class="content-field-label">
            <cms:contentText key="PROMO_NAME" code="participant.throwdown.promo.detail"/>
          </td>
          <td colspan="4" class="content-field-review">
            <c:out value="${throwdownPromotion.name}"/>
          </td>
		</tr>
	    <%-- Needed between every regular row --%>
        <tr class="form-blank-row">
          <td colspan="5"></td>
        </tr>
        </table>
        
		<table>
		<%-- Needed between every regular row --%>
        <tr class="form-blank-row">
          <td></td>
        </tr>        
        
      <tr class="form-row-spacer" id="roundNumberRow">				  
		        <beacon:label property="roundNumber" required="true">
		          	<cms:contentText code="participant.throwdown.promo.detail" key="PROMOTION_ROUND_NUMBER" />
		        </beacon:label>	
		        <td class="content-field">
				  <html:select styleId="roundNumber" property="roundNumber" styleClass="content-field" onchange="getProgress()">
			        <html:option value=''><cms:contentText key="CHOOSE_ONE" code="system.general"/></html:option>	
			        <c:forEach items="${roundNumbers}" var="number">
				      <html:option value='${number}'>${number}</html:option>
				    </c:forEach>
				    <%--<html:options collection="roundNumbers" property="roundNumbers" labelProperty="roundNumbers"  /> --%>
				  </html:select>  
		        </td>
		    </tr>         

		<tr>        
        </table>
        
        <table>  
        
			<td align="right"><display:table
				name="cumulativeProgressList" id="reviewProgress">
				<display:setProperty name="basic.msg.empty_list_row">
					       			<tr class="crud-content" align="left"><td colspan="{0}">
                          			<cms:contentText key="NOTHING_FOUND" code="system.errors"/>
                       				 </td></tr>
				</display:setProperty>
				<display:setProperty name="basic.empty.showtable" value="true"></display:setProperty>
				<display:column
					titleKey="participant.throwdown.promo.detail.PROGRESS_DATE"
					headerClass="crud-table-header-row"
					class="crud-content left-align">
					<c:out
						value="${reviewProgress.displaySubmissionDate}" />
				</display:column>
				<display:column
					titleKey="participant.throwdown.promo.detail.QUANTITY"
					headerClass="crud-table-header-row"
					class="crud-content right-align">
					<c:out value="${reviewProgress.progress}" />					
        			</display:column>
				<display:column
					titleKey="participant.throwdown.promo.detail.CUMULATIVE_TOTAL"
					headerClass="crud-table-header-row"
					class="crud-content right-align">
					<c:out value="${reviewProgress.cumulativeTotal}" />
	  			</display:column>
				<display:column
					titleKey="participant.throwdown.promo.detail.LOAD_TYPE"
					headerClass="crud-table-header-row"
					class="crud-content left-align">
					<c:out value="${reviewProgress.progressType}" />
				</display:column>
			</display:table></td>
		</tr>
		</table>
		<table>
		<%-- Needed between every regular row --%>
        <tr class="form-blank-row">
          <td></td>
        </tr>

		<tr class="form-row-spacer">				  
            <beacon:label property="newQuantity" required="true">
              <cms:contentText key="NEW_QUANTITY" code="participant.throwdown.promo.detail"/>
            </beacon:label>	
            <td class="content-field">
              <html:text property="newQuantity" maxlength="18" size="18" styleClass="content-field"/>
            </td>
       </tr>

        <tr class="form-blank-row">
          <td></td>
        </tr>       
		<tr class="form-row-spacer">				  
            <beacon:label property="addReplace" required="true">
              <cms:contentText key="ADD_REPLACE" code="participant.throwdown.promo.detail"/>
            </beacon:label>	
            <td class="content-field">
				  <html:select styleId="addReplaceType" property="addReplaceType" styleClass="content-field">
			        <html:option value=''><cms:contentText key="CHOOSE_ONE" code="system.general"/></html:option>	
				    <html:options collection="addReplaceList" property="code" labelProperty="name"  />
				  </html:select>              
            </td>
       </tr>
       
        <tr class="form-blank-row">
          <td></td>
        </tr>         
		</table>
		<table  border="0" cellpadding="10" cellspacing="0" width="100%">
        <tr class="form-buttonrow center-align">
          <td>
            <html:submit property="saveBtn" styleClass="content-buttonstyle" onclick="setDispatch('savePaxProgress')">
              <cms:contentText code="system.button" key="SAVE"  />
            </html:submit>
            <html:button property="cancelBtn" styleClass="content-buttonstyle" onclick="backToPromotionsDetails()">
              <cms:contentText code="system.button" key="CANCEL" />
            </html:button>
          </td>
        </tr>
      </table>
    </td>
  </tr>        
</table>
</html:form>