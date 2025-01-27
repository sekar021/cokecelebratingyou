<div class="item {{classes}}" id="{{id}}">

    <div class="item-link"
        data-image="{{bannerImageUrl}}"
        data-image-mobile="{{bannerImageUrl_mobile}}"
        data-image-max="{{bannerImageUrl_max}}">

    {{#if linkUrl}}
        <a href="{{linkUrl}}" target="{{target}}"><p>{{linkText}}</p></a>
    {{else}}
        <span class="noLink"><p>{{linkText}}</p></span>
    {{/if}}

    </div>
</div>
