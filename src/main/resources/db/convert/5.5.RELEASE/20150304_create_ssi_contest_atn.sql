CREATE SEQUENCE SSI_CONTEST_ATN_PK_SQ INCREMENT BY 1 START WITH 1000
/
CREATE TABLE SSI_CONTEST_ATN
(
  SSI_CONTEST_ATN_ID 		NUMBER(18) NOT NULL,
  SSI_CONTEST_ID     		NUMBER(18) NOT NULL,
  ISSUANCE_NUMBER    		NUMBER(4) NOT NULL,
  ISSUANCE_DATE 			DATE,
  ISSUANCE_STATUS           VARCHAR2(40),
  APPROVED_BY_LEVEL1 		NUMBER(18, 0),
  DATE_APPROVED_LEVEL1 		DATE, 
  APPROVED_BY_LEVEL2 		NUMBER(18, 0),
  DATE_APPROVED_LEVEL2 		DATE,
  DENIED_REASON 			VARCHAR2(1000),
  APPROVAL_LEVEL_ACTION_TAKEN	   NUMBER(1) DEFAULT 0 NOT NULL,
  NOTIFICATION_MESSAGE_TEXT VARCHAR2(1000),
  CREATED_BY                NUMBER(18) NOT NULL,
  DATE_CREATED 				DATE NOT NULL,
  MODIFIED_BY 				NUMBER(18),
  DATE_MODIFIED 			DATE,
  PAYOUT_ISSUE_DATE              DATE,
  VERSION 					NUMBER(18) NOT NULL
)
/
ALTER TABLE SSI_CONTEST_ATN 
ADD CONSTRAINT SSI_CONTEST_ATN_ID_PK PRIMARY KEY ( SSI_CONTEST_ATN_ID ) 
USING INDEX 
/
ALTER TABLE SSI_CONTEST_ATN  
ADD CONSTRAINT SSI_CONTEST_FK FOREIGN KEY ( SSI_CONTEST_ID ) 
REFERENCES SSI_CONTEST ( SSI_CONTEST_ID )
/