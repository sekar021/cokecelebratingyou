/* ==========================================================
 * Animate Number - animates (counts) a number
 *
 * ==========================================================
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* AnimateNumber
  * ====================== */

    /*var addCommas = function(nStr) {
        return $.format.number(nStr);
    };

    var updateNumber = function($el){
        var d = $el.data('animateNumber'),
            newNum;

        if(!d) return;

        d.isAnimating = true;

        d.curNum += d.incNum;
        d.curTime += d.incTime;

        //end case
        if(d.curTime>d.maxTime || (d.incNum>0&&d.curNum>d.targetNum) || (d.incNum<0&&d.curNum<d.targetNum) ){
            $el.text(d.isCommas?addCommas(d.targetNum):d.targetNum);
            d.isAnimating = false;
            if(typeof d.callback === 'function') d.callback();
            return;
        }

        newNum = d.isCommas?addCommas(d.curNum):d.curNum;

        //update
        $el.text(newNum);

        //call myself with updated data
        setTimeout( function(){updateNumber($el);} ,d.incTime);

    };*/

    /* ANIMATE NUMBER PLUGIN DEFINITION
    * ======================= */

    $.fn.animateNumber = function (number,howLong,opts,callback) {
        var //updateRate = 50,//ms
            isCommas = (opts&&opts.addCommas)||false;


        howLong = howLong === undefined ? G5.props.ANIMATION_DURATION : howLong;

        number = parseInt((''+number).replace(',',''), 10);
        number = isNaN(number) ? 0 : number;

        return this.each(function () {
            var $this = $(this),
                curNum = parseInt($this.text().replace(',',''), 10),
                diff,
                inc,
                data;

            curNum = isNaN(curNum) ? 0 : curNum;
            diff = number - curNum;
            // inc = Math.floor(diff/(howLong/updateRate));//how much change every N ms

            // if no change from old number to new, bail
            if(diff === 0) {
                return false;
            }

            // if duration is nothing, set the new text and bail
            if(howLong === 0) {
                $this.text(isCommas ? $.format.number(number) : number);
                return;
            }

            // no time to make this a full proper object atm, just attch vars for now
            $this.data('animateNumber',{
                // curNum: curNum,
                targetNum: number,
                // incNum: inc,
                // curTime: 0,
                maxTime: howLong,
                // incTime: updateRate,
                callback: callback,
                isCommas: isCommas,
                easing: opts&&opts.easing ? opts.easing : 'swing'
            });

            data = $this.data('animateNumber');

            //initialize 'recursive' animation callback if not running
            // if(!data.isAnimating) updateNumber($this);

            $this
                .css({
                    'text-indent': 0
                })
                .animate({
                    'text-indent': 0.01
                },
                {
                    step: function(now,fx) {
                        var data = $this.data('animateNumber');

                        if(!data) {
                            $this.stop();
                            return false;
                        }

                        var startNum = data && data.targetNum;
                        var newNum = Math.round(startNum * now * 100);

                        $this.text(data.isCommas ? $.format.number(newNum) : newNum);
                    },
                    duration: data.maxTime,
                    easing: data.easing,
                    complete: data.callback
                });
        });
    };

}(window.jQuery);
