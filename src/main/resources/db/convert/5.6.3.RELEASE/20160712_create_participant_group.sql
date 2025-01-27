CREATE SEQUENCE Participant_GROUP_ID_PK_SQ START WITH 1 INCREMENT BY 1
/
CREATE TABLE Participant_GROUP
    (
     group_id         NUMBER(18) NOT NULL,
     group_name       VARCHAR2(4000) ,
     group_creator_id     NUMBER(18) NOT NULL,  	 
     created_by number(18) NOT NULL,
	 date_created                DATE NOT NULL,
	 modified_by                 number(18),
	 date_modified               DATE
     )
/
ALTER TABLE Participant_GROUP ADD CONSTRAINT Participant_group_id_pk PRIMARY KEY (group_id)
/
ALTER TABLE Participant_GROUP ADD CONSTRAINT nominator_id_fk  FOREIGN KEY (group_creator_id) REFERENCES participant (user_id)
/
COMMENT ON TABLE Participant_GROUP IS 'The GROUP_NOM_PARTICIPANT table defines list of participant grouped by  nominator'
/
COMMENT ON COLUMN Participant_GROUP.group_creator_id IS '  Nominator creates this group'
/
CREATE INDEX PAX_GROUP_NOMINATOR_IDX ON Participant_GROUP(group_creator_id)
/


CREATE SEQUENCE Participant_GROUP_dtl_ID_PK_SQ START WITH 1 INCREMENT BY 1
/
  CREATE TABLE PARTICIPANT_GROUP_DTLS
    (
     group_detail_id  NUMBER(18) NOT NULL,     
     group_id        	NUMBER(18) NOT NULL,     
     PAX_id     NUMBER(18) NOT NULL
     )
/
ALTER TABLE PARTICIPANT_GROUP_DTLS ADD CONSTRAINT Participant_group_dtl_id_pk PRIMARY KEY (group_detail_id)
/
ALTER TABLE PARTICIPANT_GROUP_DTLS ADD CONSTRAINT participant_group_id_fk  FOREIGN KEY (group_id) REFERENCES Participant_GROUP (group_id)
/
ALTER TABLE PARTICIPANT_GROUP_DTLS ADD CONSTRAINT pax_group_PAX_id_fk  FOREIGN KEY (PAX_id) REFERENCES participant (user_id)
/
