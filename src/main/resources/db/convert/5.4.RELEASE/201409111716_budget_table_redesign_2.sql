DROP INDEX BUDGET_BUDGET_MASTER_FK_IDX
/
ALTER TABLE BUDGET
DROP CONSTRAINT BUDGET_UK
/
ALTER TABLE BUDGET
DROP CONSTRAINT BUDGET_BUDGETMASTER_FK
/
ALTER TABLE BUDGET
DROP CONSTRAINT BUDGET_ID_PK CASCADE
/
CREATE UNIQUE INDEX BUDGET_ID_PK ON BUDGET
(BUDGET_ID)
/
CREATE UNIQUE INDEX BUDGET_UK ON BUDGET
(BUDGET_SEGMENT_ID, USER_ID, NODE_ID)
/
ALTER TABLE BUDGET ADD (
  CONSTRAINT BUDGET_ID_PK
  PRIMARY KEY
  (BUDGET_ID)
  USING INDEX BUDGET_ID_PK
  ENABLE VALIDATE,
  CONSTRAINT BUDGET_UK
  UNIQUE (BUDGET_SEGMENT_ID, USER_ID, NODE_ID)
  USING INDEX BUDGET_UK
  ENABLE VALIDATE)
/
ALTER TABLE BUDGET ADD (
  CONSTRAINT BUDGET_SEGMENT_FK 
  FOREIGN KEY (BUDGET_SEGMENT_ID) 
  REFERENCES BUDGET_SEGMENT (BUDGET_SEGMENT_ID)
  ENABLE VALIDATE)
/
ALTER TABLE BUDGET
DROP (START_DATE, END_DATE, BUDGET_MASTER_ID)
/
ALTER TABLE BUDGET_MASTER
DROP (IS_ALLOW_BUDGET_REALLOCATION,BUDGET_REALLOCATION_ELIG_TYPE)
/
ALTER TABLE rpt_budget_promotion ADD (
budget_segment_id               NUMBER(18,0) NOT NULL,
distribution_type                VARCHAR2(10)
)
/
ALTER TABLE rpt_budget_trans_detail ADD ( 
budget_segment_id              NUMBER(18,0)
)
/
ALTER TABLE rpt_budget_usage_detail ADD ( 
budget_segment_id              NUMBER(18,0)
)
/