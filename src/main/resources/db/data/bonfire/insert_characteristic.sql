delete characteristic
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,IS_REQUIRED,IS_ACTIVE,CREATED_BY,DATE_CREATED,VERSION,CM_ASSET_CODE,NAME_CM_KEY)
VALUES
(CHARACTERISTIC_PK_SQ.nextval,'USER',NULL,'GENDER','single_select',NULL,NULL,NULL,'picklist.gendertype.items',0,'1',0,'22-APR-05',1,'characteristic_data.user.data.gender','CHARACTERISTIC_NAME')
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,IS_REQUIRED,IS_ACTIVE,CREATED_BY,DATE_CREATED,VERSION,CM_ASSET_CODE,NAME_CM_KEY)
VALUES
(CHARACTERISTIC_PK_SQ.nextval,'USER',NULL,'INTERESTS','multi_select',NULL,NULL,NULL,'picklist.positiontype.items',0,'1',0,'22-APR-05',1,'characteristic_data.user.data.interests','CHARACTERISTIC_NAME')
/
insert into user_characteristic(user_characteristic_id, user_id, characteristic_id,characteristic_value, created_by, date_created,modified_by, date_modified, version)
values(USER_CHARACTERISTIC_PK_SQ.nextval,1,CHARACTERISTIC_PK_SQ.currval,'Value 1',0,sysdate,null,null,0)
/

INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,IS_REQUIRED,IS_ACTIVE,CREATED_BY,DATE_CREATED,VERSION,CM_ASSET_CODE,NAME_CM_KEY)
VALUES
(CHARACTERISTIC_PK_SQ.nextval,'USER',NULL,'HAIR COLOR','txt',NULL,NULL,50,NULL,0,'1',0,'21-APR-05',1,'characteristic_data.user.data.haircolor','CHARACTERISTIC_NAME')
/
insert into user_characteristic(user_characteristic_id, user_id, characteristic_id,characteristic_value, created_by, date_created,modified_by, date_modified, version)
values(USER_CHARACTERISTIC_PK_SQ.nextval,1,CHARACTERISTIC_PK_SQ.currval,'Value 2',0,sysdate,null,null,0)
/

INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,IS_REQUIRED,IS_ACTIVE,CREATED_BY,DATE_CREATED,VERSION,CM_ASSET_CODE,NAME_CM_KEY)
VALUES
(CHARACTERISTIC_PK_SQ.nextval,'NT',NULL,'STORESIZE','txt',NULL,NULL,50,NULL,0,'1',0,'21-APR-05',1,'characteristic_data.nodetype.data.storesize','CHARACTERISTIC_NAME')
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,IS_REQUIRED,IS_ACTIVE,CREATED_BY,DATE_CREATED,VERSION,CM_ASSET_CODE,NAME_CM_KEY)
VALUES
(CHARACTERISTIC_PK_SQ.nextval,'USER',NULL,'AGE','int',1,10,NULL,NULL,0,'1',0,'22-APR-05',1,'characteristic_data.user.data.age','CHARACTERISTIC_NAME')
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,IS_REQUIRED,IS_ACTIVE,CREATED_BY,DATE_CREATED,VERSION,CM_ASSET_CODE,NAME_CM_KEY)
VALUES
(CHARACTERISTIC_PK_SQ.nextval,'USER',NULL,'BOOLEAN CHAR','boolean',NULL,NULL,NULL,NULL,0,'1',0,'22-APR-05',1,'characteristic_data.user.data.booleanchar','CHARACTERISTIC_NAME')
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,CM_ASSET_CODE,NAME_CM_KEY,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,DATE_START,DATE_END,IS_REQUIRED,IS_ACTIVE,IS_UNIQUE,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED,VERSION)
VALUES
(6400,'NT',5045,'Max Nbr of Trainers','int','characteristic_data.nodetype.data.10000853','CHARACTERISTIC_NAME',NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,TO_DATE('29-SEP-05 15:23:11', 'DD-MM-YY HH24:MI:SS'),NULL,NULL,0)
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,CM_ASSET_CODE,NAME_CM_KEY,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,DATE_START,DATE_END,IS_REQUIRED,IS_ACTIVE,IS_UNIQUE,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED,VERSION)
VALUES
(6401,'NT',5045,'Consultant Trainer Count','int','characteristic_data.nodetype.data.10000854','CHARACTERISTIC_NAME',NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,TO_DATE('29-SEP-05 15:24:04', 'DD-MM-YY HH24:MI:SS'),NULL,NULL,0)
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,CM_ASSET_CODE,NAME_CM_KEY,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,DATE_START,DATE_END,IS_REQUIRED,IS_ACTIVE,IS_UNIQUE,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED,VERSION)
VALUES
(6402,'NT',5045,'Employee Trainer Count','int','characteristic_data.nodetype.data.10000855','CHARACTERISTIC_NAME',NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,TO_DATE('29-SEP-05 15:24:55', 'DD-MM-YY HH24:MI:SS'),NULL,NULL,0)
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,CM_ASSET_CODE,NAME_CM_KEY,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,DATE_START,DATE_END,IS_REQUIRED,IS_ACTIVE,IS_UNIQUE,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED,VERSION)
VALUES
(6403,'NT',5045,'Max Nbr of Trainees','int','characteristic_data.nodetype.data.10000856','CHARACTERISTIC_NAME',NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,TO_DATE('29-SEP-05 15:26:11', 'DD-MM-YY HH24:MI:SS'),NULL,NULL,0)
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,CM_ASSET_CODE,NAME_CM_KEY,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,DATE_START,DATE_END,IS_REQUIRED,IS_ACTIVE,IS_UNIQUE,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED,VERSION)
VALUES
(6404,'NT',5045,'New Employee Trainees','int','characteristic_data.nodetype.data.10000857','CHARACTERISTIC_NAME',NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,TO_DATE('29-SEP-05 15:27:08', 'DD-MM-YY HH24:MI:SS'),NULL,NULL,0)
/
INSERT INTO characteristic
(CHARACTERISTIC_ID,CHARACTERISTIC_TYPE,DOMAIN_ID,DESCRIPTION,CHARACTERISTIC_DATA_TYPE,CM_ASSET_CODE,NAME_CM_KEY,MIN_VALUE,MAX_VALUE,MAX_SIZE,PL_NAME,DATE_START,DATE_END,IS_REQUIRED,IS_ACTIVE,IS_UNIQUE,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED,VERSION)
VALUES
(6405,'NT',5045,'Reassigned Employee Trainees','int','characteristic_data.nodetype.data.10000858','CHARACTERISTIC_NAME',NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,TO_DATE('29-SEP-05 15:27:56', 'DD-MM-YY HH24:MI:SS'),NULL,NULL,0)
/