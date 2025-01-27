CREATE SEQUENCE survey_question_pk_sq INCREMENT BY 1   START WITH 5000
/

CREATE TABLE survey_question
   (survey_question_id 	NUMBER(18) NOT NULL,
   	survey_id 	   		NUMBER(18) NOT NULL,
   	status_type			VARCHAR2(30) NOT NULL,
   	cm_asset_name		VARCHAR2(255) NOT NULL,
   	sequence_num		NUMBER(10) NOT NULL,
    created_by          number(18)  ,
    date_created   	    DATE ,
    modified_by         number(18),
    date_modified  	    DATE,
    version        	    NUMBER(18) )
/

ALTER TABLE survey_question ADD CONSTRAINT qq_survey_fk
  FOREIGN KEY (survey_id) REFERENCES survey(survey_id) 
/

ALTER TABLE survey_question
ADD CONSTRAINT survey_question_id_pk PRIMARY KEY (survey_question_id)
USING INDEX
/

CREATE INDEX SURVEY_QUESTION_SURVEY_FK_idx ON SURVEY_QUESTION
  (SURVEY_ID)
/
COMMENT ON TABLE survey_question IS 'The SURVEY_QUESTION table defines a specific survey question for a survey.'
/

COMMENT ON COLUMN survey_question.survey_question_id IS 'System-generated key that identifies a specific survey question.'
/

COMMENT ON COLUMN survey_question.survey_id IS 'Foreign key to survey.'
/