ALTER TABLE PARTICIPANT ADD ( 
	IS_OPT_OUT_OF_AWARDS    NUMBER(1) DEFAULT 0 NOT NULL)
/
ALTER TABLE PARTICIPANT ADD ( 
	IS_OPT_OUT_OF_PROGRAM     NUMBER(1) DEFAULT 0 NOT NULL)
/
ALTER TABLE PARTICIPANT ADD
	DATE_OPT_OUT_OF_AWARDS   DATE
/
ALTER TABLE PARTICIPANT ADD
	DATE_OPT_OUT_OF_PROGRAM   DATE
/
