<%@ include file="/include/taglib.jspf"%>
<%@ page import="com.biperf.core.ui.utils.RequestUtils"%>

<div class="page-content" id="notAuthenticatedTimeout">
    <div class="row">
        <div class="span12">
        
<table border="0" cellpadding="10" cellspacing="0" width="100%">	

    <tr align="left">
	  	<td align="left">
	  		<img src="<%=RequestUtils.getBaseURI(request)%>/assets/g4skin/images/spacer.gif" width="10" height="2" border="0">
		</td>
  	</tr>
	<tr> 
		<td class="content-field" colspan="2" align="center">	 
		  <cms:contentText code="login.timeout" key="NOT_AUTHENTICATED_TIMEOUT" /><br/><br/><br/>
		</td>
	</tr>
    <tr align="left">
  		<td align="left">
  			<img src="<%=RequestUtils.getBaseURI(request)%>/assets/g4skin/images/spacer.gif" width="10" height="2" border="0">
		</td>
 	</tr>
    <tr align="left">
  		<td align="left">
  			<img src="<%=RequestUtils.getBaseURI(request)%>/assets/g4skin/images/spacer.gif" width="10" height="2" border="0">
		</td>
 	</tr>
    <tr align="left">
  		<td align="left">
  			<img src="<%=RequestUtils.getBaseURI(request)%>/assets/g4skin/images/spacer.gif" width="10" height="2" border="0">
		</td>
 	</tr>
</table>

        </div><!-- /.span12 -->
    </div><!-- /.row -->
</div><!-- /#notAuthenticatedTimeout.page-content -->

<script>
    $(document).ready(function() {
       slp = new PageView({
            el : $('#notAuthenticatedTimeout'),           
            pageNav : {
                back : {}
            },
            pageTitle : '',
            loggedIn : false
        });
    });
</script>