CREATE SEQUENCE promo_goalquest_survey_pk_sq START WITH 250 INCREMENT BY 1
/
CREATE TABLE promo_goalquest_survey
(promotion_survey_id				NUMBER(18) NOT NULL,
promotion_id						NUMBER(18) NOT NULL,
survey_id				   		    NUMBER(18) NOT NULL,
created_by                   		NUMBER(18),
date_created                 		DATE ,
modified_by 						NUMBER(18),
date_modified                		DATE,
version                      		NUMBER(18,0)
)
/
ALTER TABLE promo_goalquest_survey
ADD CONSTRAINT promotion_survey_id_pk PRIMARY KEY (promotion_survey_id)
USING INDEX
/
ALTER TABLE promo_goalquest_survey ADD CONSTRAINT promo_gq_promotion_id_fk
FOREIGN KEY (promotion_id) REFERENCES promo_goalquest(promotion_id)
/
ALTER TABLE promo_goalquest_survey ADD CONSTRAINT survey_id_fk
FOREIGN KEY (survey_id) REFERENCES survey(survey_id)
/
COMMENT ON COLUMN promo_goalquest_survey.promotion_survey_id IS 'System-generated key .'
/
COMMENT ON COLUMN promo_goalquest_survey.promotion_id IS 'Id of goalquest promotion.'
/
COMMENT ON COLUMN promo_goalquest_survey.survey_id IS 'Id of survey.'
/
