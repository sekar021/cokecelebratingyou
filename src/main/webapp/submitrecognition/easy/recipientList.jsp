<ul id="ezRecipListWrapper">
{{#each this}}
    <li class="moduleRecipWrapper" data-tabindex="{{this.index}}" data-recipientId="{{this.id}}" data-recipientNodeId="{{this.nodeId}}">
        <h1>{{this.firstName}} {{this.lastName}}</h1>
        <h2>{{this.orgName}}</h2>
        <h3>{{#if this.departmentName}}{{this.departmentName}}, {{/if}}{{this.jobName}}</h3>
    </li>
{{else}}
    <li>
       <cms:contentText key="NO_RESULTS" code="recognition.submit"/>
    </li>
{{/each}}
</ul>