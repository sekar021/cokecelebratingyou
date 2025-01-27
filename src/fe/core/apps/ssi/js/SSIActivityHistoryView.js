/*exported SSIActivityHistoryView */
/*global
$,
_,
Backbone,
G5,
TemplateManager,
PaginationView,
SSIActivityHistoryModel,
SSIActivityHistoryView:true
*/
SSIActivityHistoryView = Backbone.View.extend( {

    //init function
    initialize: function( opts ) {
        var that = this;

        //set the appname ( getTpl() method uses this )
        this.appName = 'ssi';

        //template names
        this.ssiActivityHistoryTpl = 'ssiActivityHistoryTpl';
        this.tplPath = G5.props.URL_TPL_ROOT || G5.props.URL_APPS_ROOT + 'ssi/tpl/';

        this.model = new SSIActivityHistoryModel( {} );

        this.opts = this.options.data;

        this.model.loadData( this.opts );

        this.model.on( 'loadDataFinished', function() {
            that.render();
        } );

    },

    events: {
       'click .sortable a': 'handleTableSort'
    },

    render: function() {
        var that = this;

        G5.util.hideSpin( this.$el );

        //Push values to template
        TemplateManager.get( this.ssiActivityHistoryTpl, function( tpl, vars, subTpls ) {
            that.subTpls = subTpls;

            that.$el.empty().append( tpl( that.model.toJSON() ) );
            that.renderPagination();

        }, this.tplPath );

    },

    renderPagination: function() {
        var that = this;

        // if our data is paginated, add a special pagination view
        if ( this.model.get( 'total' ) > this.model.get( 'perPage' ) ) {
            // if no pagination view exists, create a new one
            if ( !this.paginationView ) {
                this.paginationView = new PaginationView( {
                    el: this.$el.find( '.paginationControls' ),
                    pages: Math.ceil( this.model.get( 'total' ) / this.model.get( 'perPage' ) ),
                    current: this.model.get( 'current' ),
                    per: this.model.get( 'perPage' ),
                    total: this.model.get( 'total' ),
                    ajax: true,
                    showCounts: true,
                    tpl: this.subTpls.paginationTpl || false
                } );

                this.paginationView.on( 'goToPage', function( page ) {
                    that.paginationClickHandler( page );
                } );

                this.model.on( 'loadDataFinished', function() {
                    that.paginationView.setProperties( {
                        rendered: false,
                        pages: Math.ceil( that.model.get( 'total' ) / that.model.get( 'perPage' ) ),
                        current: that.model.get( 'current' )
                    } );
                } );
            } else { // otherwise, just make sure the $el is attached correctly
                this.paginationView.setElement( this.$el.find( '.paginationControls' ) );

                // we know that pagination should exist because of the if with count, so we need to explicitly render if it has no children
                if ( !this.paginationView.$el.children().length ) {
                    this.paginationView.render();
                }
            }
        }
    },

    paginationClickHandler: function( page ) {
        G5.util.showSpin( this.$el, {
            cover: true
        } );

        this.model.loadData( {
            id: this.opts.id,
            total: this.model.get( 'total' ),
            perPage: this.model.get( 'perPage' ),
            page: page,
            sortedOn: this.model.get( 'sortedOn' ),
            sortedBy: this.model.get( 'sortedBy' )
        } );
    },

    handleTableSort: function( e ) {
        var $tar = $( e.target ).closest( '.sortable' ),
            sortOn = $tar.data( 'sortOn' ),
            sortBy = $tar.data( 'sortBy' );

        e.preventDefault();

        G5.util.showSpin( this.$el, {
            cover: true
        } );

        this.model.loadData( {
            id: this.opts.id,
            total: this.model.get( 'total' ),
            perPage: this.model.get( 'perPage' ),
            sortedOn: sortOn,
            sortedBy: sortBy
        } );
    }

} );
