/*exported SSIApprovePayoutCollection */
/*global
console,
$,
_,
G5,
Backbone,
SSISharedHelpersView,
SSIContestModel,
SSIApprovePayoutCollection: true
*/
SSIApprovePayoutCollection = Backbone.Collection.extend( {
    /**
     * Overwrite _.where to return the first result, rather than an array
     *
     * @param { object } val - matcher to look for in the models
     * @returns { object }
     */
    initialize: function ( opts ) {
        'use strict';
        //console.log( '[SSI] chart - init collection' );

        this.url = opts.dataURL;
    },

    /**
     * Over writes `Collection.fetch` to allow processing of the
     * server response before it's set on the collection.
     *
     * @param { object } opts
     * @param { object } opts.data - optional info to be sent to the server
     * @param { function } opts.success - handling for ajax response
     * @param { function } opts.error - handling for ajax response
     * @returns { object }
     */
    fetch: function ( opts ) {
        'use strict';
        var helpers = new SSISharedHelpersView(),
            request = _.bind( helpers.requestWrap, helpers );

        return request( {
                data: opts.data,
                url: this.url
            } )
            .then( _.bind( function ( resp ) {

                SSIContestModel.reformatDecimalStrings( resp.data );

                this.reset( resp.data.participants );

                this.trigger( 'fetch:success', resp.data );
            }, this ) )
            .then( opts.success || $.noop, opts.error || $.noop );
    },

    /**
     * Converts this collection to JSON and adds data used for templating
     *
     * @returns { object }
     */
    toProcessedJSON: function ( opts ) {
        'use strict';

        var json = this.toJSON();

        return json;
    }
} );
