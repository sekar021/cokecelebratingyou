<%@ include file="/include/taglib.jspf"%>
<div class="row-fluid">
    <div class="span12 no-pointer-event">
        <h3 class="sectionTitle"><cms:contentText key="PAX" code="ssi_contest.creator"/></h3>
    </div>
</div>

<div class="row-fluid">
    <div class="span12">
        <div class="pagination pagination-right paginationControls"></div>
        {{! NOTE: the Handlebars tags in this block are broken onto different lines in a strange way because of an IE whitespace bug}}
        <table id="ssiContestDetailsTable" class="table table-striped">
            {{#if tabularData.columns}}
            <thead>
                <tr>
                    {{#each tabularData.columns}}<th class="{{name}} {{type}} {{#if sortable}}sortable{{/if}} {{#eq ../sortedOn name}}sorted {{../sortedBy}}{{else}}asc{{/eq}}" data-sort-on="{{name}}" data-sort-by="{{#eq ../sortedOn name}}{{#eq ../sortedBy "asc"}}desc{{else}}asc{{/eq}}{{else}}asc{{/eq}}" {{#unless parentColumn}}rowspan="2"{{else}} {{#eq ../payoutType "points"}} colspan="2" {{else}} colspan="3"{{/eq}}{{/unless}}>
                        {{#if sortable}}
                            <a href="#">
                                {{tableDisplayName}}
                                 <i class="icon-arrow-1-up"></i><i class="icon-arrow-1-down"></i>
                            </a>
                        {{else}}
                            {{tableDisplayName}}
                        {{/if}}
                    </th>{{/each}}
                </tr><tr>
                    {{#each tabularData.subColumns}}<th class="{{name}} {{type}} {{#if sortable}}sortable{{/if}} {{#eq ../sortedOn name}}sorted {{../sortedBy}}{{else}}asc{{/eq}}" data-sort-on="{{name}}" data-sort-by="{{#eq ../sortedOn name}}{{#eq ../sortedBy "asc"}}desc{{else}}asc{{/eq}}{{else}}asc{{/eq}}">
                        {{#if sortable}}
                            <a href="#">
                                {{tableDisplayName}}
                                 <i class="icon-arrow-1-up"></i><i class="icon-arrow-1-down"></i>
                            </a>
                        {{else}}
                            {{tableDisplayName}}
                        {{/if}}
                    </th>{{/each}}
                </tr>
            </thead>
            {{/if}}

            {{#if tabularData.footerActive}}
            <tfoot>
                <tr>
                    {{#each tabularData.columns}}<td {{#unless parentColumn}}rowspan="2" class="{{type}}"{{else}} class="emptyCell"{{#eq ../payoutType "points"}} colspan="2" {{else}} colspan="3" {{/eq}}{{/unless}}>{{footerDisplayText}}</td>{{/each}}
                </tr><tr>
                    {{#each tabularData.subColumns}}<td class="{{type}}">{{footerDisplayText}}</td>{{/each}}
                </tr>
            </tfoot>
            {{/if}}

            <tbody>
                {{#each tabularData.paxResults}}
                    <tr>
                        <td><a href="{{contestUrl}}">{{participantName}}</a></td><td>{{orgUnit}}</td>{{#each activityDescription}}{{#eq ../../payoutType "points"}}<td class="number">{{activity}}</td><td class="number">{{payout}}</td>{{else}}<td class="number">{{activity}}</td><td class="number">{{payoutQuantity}}</td><td class="number">{{payout}}</td>{{/eq}}{{/each}}<td class="number">{{payoutAmount}}</td>
                    </tr>
                {{/each}}
            </tbody>
        </table>

        <div class="pagination pagination-right paginationControls"></div>
        <div class="breadCrumbsWrap"></div>
    </div>
</div>
