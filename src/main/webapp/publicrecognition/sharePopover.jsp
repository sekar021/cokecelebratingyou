<!-- sharePopover TPL -->
<!-- used in the sharePopover plugin -->
<!-- NOTE: urls on the query strings need to be URL encoded -->
<div class="sharePopover">
	{{#shareLinks}} <a target="_blank" alt="{{this.name}}"
		class="social-icon {{this.nameId}} icon-size-32" href="{{this.url}}"></a>
	{{/shareLinks}}
</div>
<!-- /sharePopover TPL -->