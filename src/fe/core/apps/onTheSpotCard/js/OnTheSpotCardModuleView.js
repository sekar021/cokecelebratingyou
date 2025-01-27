/*exported OnTheSpotCardModuleView*/
/*global
LaunchModuleView,
OnTheSpotCardModuleView:true
*/
OnTheSpotCardModuleView = LaunchModuleView.extend( {

    //override super-class initialize function
    initialize: function( opts ) {

        //this is how we call the super-class initialize function (inherit its magic)
        LaunchModuleView.prototype.initialize.apply( this, arguments );

        //inherit events from the superclass LaunchModuleView
        this.events = _.extend( {}, LaunchModuleView.prototype.events, this.events );

        //allowed dimensions, sorted from smallest - biggest

        //on template loaded and attached
        this.on( 'templateLoaded', function( tpl, vars, subTpls ) {
            // resize the text to fit
            // the delay is to wait for custom fonts to load
            //G5.util.textShrink( this.$el.find('.wide-view .bottom-text') );
            //_.delay(G5.util.textShrink, 100, this.$el.find('.wide-view .bottom-text'));

            this.$el.find( '.inputCertNum' ).placeholder();
            var placeholderText = $( '.OTSfieldText' ).text();
            $( '.inputCertNum' ).attr( 'placeholder', placeholderText );
            this.modalTpl = subTpls.modal;
        }, this );

        // resize the text to fit
        this.moduleCollection.on( 'filterChanged', function() {
            //G5.util.textShrink( this.$el.find('.wide-view .bottom-text') );
        }, this );
    },

    events: {
        'click #btnSendCert': 'doSendCert',
        'keyup .inputCertNum': 'doInputCertNumKeyup',
        'keydown .inputCertNum': 'doInputCertNumKeySink',
        'keypress .inputCertNum': 'doInputCertNumKeySink'
    },

    //send a certificate number
    doSendCert: function( e ) {
        var $certInput = this.$el.find( '.inputCertNum' ),
            $form = this.$el.find( '.onTheSpotCertForm' ),
            $otpSubmitBtm = this.$el.find( '.otpSubmitBtm' ),
            that = this;

        this.dataLoad( true );    
        $otpSubmitBtm.attr( 'disabled', 'disabled' );

        $.ajax( {
            dataType: 'g5json', //this causes .ajax to return a G5.ServerResponse obj to success()
            //uncomment for post
            type: 'post',
            //try to get the URL from the form action first, else use G5.prop
            url: $form.attr( 'action' ) || G5.props.URL_JSON_ON_THE_SPOT_CERT,
            //data-attrs, and form inputs will be joining us
            //serialize and param produce query strings
            data: $form.serialize() + '&' + $.param( $form.data() ),
            success: function( serverResponse ) {
                var err = serverResponse.getFirstError(), //we expect only one error, if any
                    suc = serverResponse.getFirstSuccess();//we expect only one success, if any
                if( err ) {
                    that.showResponse( err.name, err.text, 'error' );
                }else if( suc ) {
                    that.showResponse( suc.name, suc.text, 'success' );
                    //clear out certificate entry on success
                    $certInput.val( '' );
                }else{
                    that.showResponse( 'Unknown', 'server has responded ambiguously', 'info' );
                }
            },
            error: function( err ) {
            	$otpSubmitBtm.removeAttr( 'disabled' );
                var errMsg = err.status + ' - ' + err.statusText;
                //ModuleView has a method to show popovers
                that.showResponse( 'Server Error', errMsg, 'error' );
            },
            complete: function() {
                that.dataLoad( false );
                $certInput.val( '' );
                $otpSubmitBtm.removeAttr( 'disabled' ); 
            }
        } );

        e.preventDefault();
    },

    doInputCertNumKeyup: function( e ) {
        if( e.keyCode === 13 ) {//is enter?
            this.$el.find( '#btnSendCert' ).click();//click submit button
            e.preventDefault();
        }
    },

    doInputCertNumKeySink: function( e ) {
        if( e.keyCode === 13 ) {//is enter?
            e.preventDefault();
        }
    },

    showResponse: function( title, text ) {
        var $mod;
        if( this.modalTpl ) {
            $mod = $( this.modalTpl( { title: title, text: text } ) );
            $mod.modal();
        }
    }

} );
