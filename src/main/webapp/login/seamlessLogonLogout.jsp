<%@ include file="/include/taglib.jspf"%>
<%@ page import="com.biperf.core.ui.utils.RequestUtils"%>


<div class="page-content" id="seamlessLogonPage">
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
		  <cms:contentText code="login.seamlesslogon" key="LOGGED_OUT" />
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
</div><!-- /#seamlessLogonPage.page-content -->

<script>
    $(document).ready(function() {
       slp = new PageView({
            el : $('#seamlessLogonPage'),
            mode : 'help',
            pageNav : {
                back : {}
            },
            pageTitle : '',
            loggedIn : false
        });
    });
</script>
