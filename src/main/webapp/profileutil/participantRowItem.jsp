<%@ include file="/include/taglib.jspf" %>
<%@ page import="com.biperf.core.ui.utils.RequestUtils"%>
{{#if invalid}}
    <!-- nothing -->
{{else}}
<tr class="participant-item"
        data-participant-cid="{{cid}}"
        data-participant-id="{{id}}">

    <td class="participant">
        <input type="hidden" name="pax[{{autoIndex}}].userId" value="{{id}}" />
        <input type="hidden" name="pax[{{autoIndex}}].firstName" value="{{firstName}}" />
        <input type="hidden" name="pax[{{autoIndex}}].lastName" value="{{lastName}}" />

        <a class="participant-popover" href="#" data-participant-ids="[{{id}}]">
            <span class="avatarwrap">
                {{#if avatarUrl}}
                    <img alt="{{firstName}} {{lastName}}" class="participant-list-avatar avatar" src="{{#timeStamp avatarUrl}}{{/timeStamp}}"/>
                {{else}}
                    <div class="avatar-initials">{{trimString firstName 0 1}}{{trimString lastName 0 1}}</div>
                {{/if}}
            </span>
            {{firstName}}
            {{lastName}}
        </a>
        {{#if countryCode}}<img src="<%=RequestUtils.getBaseURI(request)%>/assets/img/flags/{{countryCode}}.png" alt="{{countryCode}}" class="countryFlag"  title="{{countryName}}" />{{/if}}
        <span class="org">{{orgName}} {{#if departmentName}}{{#if orgName}}&bull;{{/if}} {{departmentName}}{{/if}} {{#if jobName}}{{#if departmentName}}&bull;{{else}}{{#if orgName}}&bull;{{/if}}{{/if}} {{jobName}}{{/if}}</span>
    </td>

    <td class="remove">
        <a class="remParticipantControl" title="<cms:contentText key="REMOVE_PAX" code="participant.search" />"><i class="icon-trash"></i></a>
    </td>

</tr><!-- /.participant-item participantRowItem-->{{/if}}