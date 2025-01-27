<%@ page import="com.biperf.core.ui.utils.RequestUtils"%>
{{#if invalid}}
    <!-- nothing -->
{{else}}
<tr class="participantSearchResultRow{{#if isSelected}} selected{{/if}}{{#if isLocked}} locked{{/if}}">
     <td class="selectCell{{#if isSelected}} selected{{/if}}" data-participant-url="{{participantUrl}}"  data-participant-id="{{id}}">

        {{#if isLocked}}
            <i class='icon-lock'></i>
        {{else}}

            {{#if _singleSelectMode}}

                {{#if _selectTxt}}
                    <a href="#"
                        data-participant-id="{{id}}"
                        class="participantSelectControl select-txt"
                    >{{{_selectTxt}}}</a>
                    <span class="deselTxt selected-txt">{{{_selectedTxt}}}</span>
                {{else}}
                    <input name="partSelRadioGroup"
                        type="radio"
                        data-participant-id="{{id}}"
                        class="participantSelectControl"
                        {{#if isSelected}} checked="checked"{{/if}} />
                {{/if}}

            {{else}}

                {{#if _selectTxt}}
                    <a href="#"
                        data-participant-id="{{id}}"
                        class="participantSelectControl select-txt"
                    >{{{_selectTxt}}}</a>
                    <span class="deselTxt selected-txt">{{{_selectedTxt}}}</span>
                {{else}}
                    <input name="partSelCheck{{id}}"
                        type="checkbox"
                        data-participant-id="{{id}}"
                        class="participantSelectControl"
                        {{#if isSelected}} checked="checked"{{/if}} />
                {{/if}}

            {{/if}}

        {{/if}}
    </td>
    <td class="participantSearchNameCol">
        <a class="participant-popover" href="#" data-participant-ids="[{{id}}]">
            {{lastName}}, {{firstName}}
        </a>
    </td>
    <td class="participantSearchOrgCol">
        {{! this is just the first node in the node array }}
        {{nodes.0.name}}
    </td>
    <td class="participantSearchCountryCol">
        {{#if countryCode}}<img class="countryFlag" src="<%=RequestUtils.getBaseURI(request)%>/assets/img/flags/{{countryCode}}.png" alt="{{countryCode}}" title="{{countryName}}" />{{/if}}
    </td>
    <td class="participantSearchDepartmentCol">{{departmentName}}</td>
    <td class="participantSearchJobCol">{{jobName}}</td>
</tr><!-- /.participantSearchTableRow -->
{{/if}}
