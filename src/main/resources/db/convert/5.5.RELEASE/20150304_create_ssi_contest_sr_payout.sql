CREATE SEQUENCE ssi_contest_sr_payout_pk_sq INCREMENT BY 1 START WITH 5000
/
CREATE TABLE ssi_contest_sr_payout
(	
    ssi_contest_sr_payout_id number(18,0) not null, 
	ssi_contest_id number(18,0) not null, 
	rank_position number(18,0) not null,
	payout_amount number(18,0),
	payout_desc VARCHAR2(100),
	BADGE_RULE_ID NUMBER(18,0),
	created_by number(18,0) not null, 
	date_created date not null, 
	modified_by number(18,0), 
	date_modified date, 
	version number(18,0) not null,
	CONSTRAINT ssi_contest_sr_payout_pk PRIMARY KEY (ssi_contest_sr_payout_id)
)
/
ALTER TABLE ssi_contest_sr_payout ADD CONSTRAINT ssi_contest_sr_payout_cntst_fk
  FOREIGN KEY (ssi_contest_id) REFERENCES ssi_contest (ssi_contest_id)
/
ALTER TABLE ssi_contest_sr_payout ADD CONSTRAINT ssi_contest_sr_payout_rank_unq
  UNIQUE (ssi_contest_id, rank_position)
/
ALTER TABLE ssi_contest_sr_payout ADD CONSTRAINT ssi_contest_sr_badge_rule_fk
  FOREIGN KEY (BADGE_RULE_ID) REFERENCES BADGE_RULE (BADGE_RULE_ID)
/
