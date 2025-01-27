<%@ include file="/include/taglib.jspf"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
    <head>
        <title>Launch As</title>

        <script type="text/javascript">
            function bindEvents() {
                window.assetLocatorSite.onmouseup = function(event) {
                    // we don't want to do anything with text input or textarea fields
                    if( event.target.tagName.toUpperCase() == 'INPUT' || event.target.tagName.toUpperCase() == 'TEXTAREA' ) {
                        return false;
                    }
                    setTimeout(function() {
                        var text = getSelectedText();
                        // only do something if there is text selected
                        if(text.length) {
                            window.textSelection = text;
                            doSomethingWithText();
                        }
                    }, 1);
                };
            }

            function getSelectedText() {
                if (window.assetLocatorSite.getSelection) {
                    return window.assetLocatorSite.getSelection().toString();
                } else if (window.assetLocatorSite.document.selection) {
                    return window.assetLocatorSite.document.selection.createRange().text;
                }
                return '';
            }

            function doSomethingWithText() {
                window.assetLocatorDebug.cmsDbg.Filter(window.textSelection);
            }
        </script>
    </head>

    <frameset cols="*,310,0">
        <frame frameborder="0" marginheight="0" marginwidth="0" name="assetLocatorSite" src="${pageContext.request.contextPath}/homePage.do" onload="bindEvents()">
        <frame frameborder="0" marginheight="0" marginwidth="0" name="assetLocatorDebug" src="${pageContext.request.contextPath}/cmsDebug.do">
        <%-- ok, SSO into the CMS application under the covers here --%>
        <frame src="${pageContext.request.contextPath}/admin/cmSso.do?method=sso" name="cm-sso">
    </frameset>
</html>
