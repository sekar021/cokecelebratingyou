{{! NOTE: subTpl.leaderTpl is passed back to JavaScript through the TemplateManager }}
{{! NOTE: this is modeled after the leaderboard template in leaderboard/leaderboardModel.html }}
{{! NOTE: `payout` is set in the JavaScript based on the payouts passed with the contest data }}

{{! generic leaderboard row }}
<!--subTpl.leaderTpl=
    {{#each this}}
    <li value="{{rank}}" {{#if classes.length}}class="{{#classes}}{{this}} {{/classes}}"{{/if}}>
        {{#if score}}<span class="score">{{score}}</span>{{/if}}
        {{#if rank}}<b class="rank">{{rank}}.</b>{{/if}}
        <div class='avatarwrap'>
        {{#if avatarUrl}}
            <img alt="{{firstName}} {{lastName}}" src="{{#timeStamp avatarUrl}}{{/timeStamp}}">
        {{else}}
            <span class="avatar-initials">{{trimString firstName 0 1}}{{trimString lastName 0 1}}</span>
        {{/if}}
        </div>
        {{#if contestUrl}}
        <a class="leaderName" href="{{contestUrl}}">{{firstName}} {{lastName}}</a>
        {{else}}
        <span class="leaderName">{{firstName}} {{lastName}}</span>
        {{/if}}
    </li>
    {{/each}}
subTpl-->

<div class="splitColWrap{{#classes}} {{this}}{{/classes}}{{#if filter}} filter-{{filter}}{{/if}}" id="leaderboard{{id}}" data-id="{{id}}">
    <!-- Account info and ranking -->
    <div class="clearfix">
        <!-- <ol class="leaders-col leaders-col-a leadersColA"> -->
        <ol class="splitCol splitColA">
            <!-- dynamic -->
        </ol>
        <!-- second col, responsive (float left) -->
        <!-- <ol class="leaders-col leaders-col-b leadersColB"> -->
        <ol class="splitCol splitColB">
            <!-- dynamic -->
        </ol>
    </div>
</div>
