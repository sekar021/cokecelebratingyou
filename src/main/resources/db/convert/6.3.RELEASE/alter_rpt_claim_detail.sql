--liquibase formatted sql

--changeset palaniss:1
--comment Modified the CLAIM_ADDR1 and CLAIM_ADDR2 column size 
ALTER TABLE RPT_CLAIM_DETAIL MODIFY (CLAIM_ADDR1 VARCHAR2(500 CHAR) ,CLAIM_ADDR2 VARCHAR2(500 CHAR));
--rollback ALTER TABLE RPT_CLAIM_DETAIL MODIFY (CLAIM_ADDR1 VARCHAR2(100 CHAR) ,CLAIM_ADDR2 VARCHAR2(100 CHAR)); 
