/*global jest*/

jest.mock( 'react-redux' );
import React from 'react';
import RecognitionAdvisor from '../recognitionAdvisor.js';
import renderer from 'react-test-renderer';

window.recognitionAdvisor = {
  raUrl: 'ra/reminders.action',
  raTilePageDisplay: 'yes',
  raDetailPageDisplay: 'no',
  raEndModelPageDisplay: 'no',
  content: []
};

const cmStringsArrayToObject = ( propertiesArray ) => {
    const propertiesObject = {};
    if( propertiesArray ) {

        propertiesArray.forEach( property => {
            propertiesObject[ `${ property.code }.${ property.key.toLowerCase() }` ] = property.content;
        } );
    }
    return propertiesObject;
};

const defaultProps = {
    recognitionAdvisor: {
      raUrl: 'ra/reminders.action',
      raTilePageDisplay: 'yes',
      raDetailPageDisplay: 'no',
      raEndModelPageDisplay: 'no',
      content: []
    }
};
it( 'renders the dom like the snapshot when the props have default values.', () => {
    const props = {
        ...defaultProps,
        recognitionAdvisorFunc: jest.fn(),
        raEligibleProgramsFunc: jest.fn()
    };
    const component = renderer.create(
        <div>
            <RecognitionAdvisor cmStringsArrayToObject={ cmStringsArrayToObject } { ...props } />
        </div>
    );

    const tree = component.toJSON();
    expect( tree ).toMatchSnapshot();
} );