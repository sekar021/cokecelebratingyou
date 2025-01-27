<%@page import="com.biperf.core.utils.UserManager"%>

{{! debug}}
{{#each .}}
	<div class="{{this.classes.row}}">
		{{#if this.isBoolean}}
			{{!
				"type": "boolean",
				"name":"Boolean",
				"description":"This is a characteristics description",
				"required":true
			}}
			<div class="{{this.classes.input}} offset2{{#if this.required}} validateme{{/if}}">
				<label class="checkbox" for="item-{{id}}">
					<input name="item-{{id}}"
						id="item-{{id}}"
						data-id="{{id}}"
						type="checkbox"
						{{#if this.required}}required{{/if}}
						{{#if this.value}}checked="checked"{{/if}} />
						{{this.name}} {{#unless this.required}}<span class="optional"><cms:contentText key="OPTIONAL" code="system.common.labels" /></span>{{/unless}}
				</label>
			</div>
		{{else}}
			<label for="item-{{id}}" class="{{this.classes.label}}">{{this.name}} {{#unless this.required}}<span class="optional"><cms:contentText key="OPTIONAL" code="system.common.labels" /></span>{{/unless}}</label>
			<div class="{{this.classes.input}}{{#if this.required}} validateme{{/if}}"
				{{#if this.required}}
					data-validate-flags="nonempty"
					data-validate-fail-msgs='{"nonempty":"Field is required."}'
				{{/if}}>
			{{#if this.isDate}}
				{{!
					"type": "date",
					"dateStart":"(date)",
					"dateEnd":"(date)",
					"name":"Date",
					"description":"This is a characteristics description",
					"required":true
				}}
				<span class="input-append datepickerTrigger"
					data-date-format="<%=UserManager.getUserDatePattern().toLowerCase()%>"
					data-date-language="<%=UserManager.getUserLocale()%>"
					data-date-startdate="{{dateStart}}"
					data-date-enddate="{{dateEnd}}"
					data-date-autoclose="true">
					<input class="date datepickerInp"
							name="item-{{id}}"
							id="item-{{id}}"
							data-id="{{id}}"
							type="text"
							readonly="readonly"
							{{#if this.required}}required{{/if}}
							{{#if this.value}}value="{{this.value}}"{{/if}} />
					<button data-btn-id="datepicker" class="btn datepickerBtn">
						<i class="icon-calendar"></i>
					</button>
				</span>
			{{/if}}

			{{#if this.isDecimal}}
				{{!
					"type": "decimal",
					"min":"min value",
					"max":"max value",
					"name":"decimal",
					"description":"This is a characteristics description",
					"required":true
				}}
				<input name="item-{{id}}"
					id="item-{{id}}"
					data-id="{{id}}"
					data-min="{{min}}"
					data-max="{{max}}"
					type="text"
					{{#if this.required}}required{{/if}}
					{{#if this.value}}value="{{this.value}}"{{/if}} />
			{{/if}}

			{{#if this.isInteger}}
				{{!
					"type": "int",
					"min":"min value",
					"max":"max value",
					"name":"integer",
					"description":"This is a characteristics description",
					"required":true,
					"unique":true
				}}
				<input name="item-{{id}}"
					id="item-{{id}}"
					data-id="{{id}}"
					type="text"
					{{#if this.required}}required{{/if}}
					{{#if this.value}}value="{{this.value}}"{{/if}} />
			{{/if}}

			{{#if this.isMultiSelectList}}
				{{!
				"type": "multi_select",
				"list":[
						{
							"id": 1,
							"name": "foo"
						}
					],
				"name":"multiple select",
				"description":"This is a characteristics description",
				"required":true
				}}
				<select name="item-{{id}}"
					id="item-{{id}}"
					data-id="{{id}}"
					multiple="multiple"
					{{#if this.required}}required{{/if}}>
					{{#each this.list}}
						<option value="{{id}}"{{#if value}} selected="selected"{{/if}}>{{name}}</option>
					{{/each}}
				</select>
			{{/if}}

			{{#if this.isSingleSelectList}}
				{{!
				"type": "single_select",
				"list":[
							{
								"id": 1,
								"name": "foo"
							}
						],
				"name":"single select",
				"description":"This is a characteristics description",
				"required":true
				}}
				<select name="item-{{id}}"
					id="item-{{id}}"
					data-id="{{id}}"
					{{#if this.required}}required{{/if}}>
					<option></option>
					{{#each this.list}}
					<option value="{{id}}"{{#if value}} selected="selected"{{/if}}>{{name}}</option>
					{{/each}}
				</select>
			{{/if}}

			{{#if this.isText}}
				{{!
					"type": "txt",
					"maxSize": "100",
					"name":"text",
					"description":"This is a characteristics description",
					"required":true,
					"unique":true
				}}
				<input name="item-{{id}}"
					id="item-{{id}}"
					data-id="{{id}}"
					type="text"
					{{#if this.maxSize}} maxlength="{{this.maxSize}}"{{/if}}
					{{#if this.required}}required{{/if}}
					{{#if this.value}}value="{{this.value}}"{{/if}} />
			{{/if}}
			</div>
		{{/if}}
	</div>
{{/each}}
