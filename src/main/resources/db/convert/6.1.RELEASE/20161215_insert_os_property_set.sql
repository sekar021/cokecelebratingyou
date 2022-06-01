INSERT INTO os_propertyset
(ENTITY_ID,ENTITY_NAME,ENTITY_KEY,KEY_TYPE,BOOLEAN_VAL,DOUBLE_VAL,STRING_VAL,LONG_VAL,INT_VAL,DATE_VAL)
VALUES
(entity_id_pk_sq.nextval,'recognition-only.enabled','DayMaker',1,0,0,NULL,0,0,NULL)
/
INSERT INTO os_propertyset
(ENTITY_ID,ENTITY_NAME,ENTITY_KEY,KEY_TYPE,BOOLEAN_VAL,DOUBLE_VAL,STRING_VAL,LONG_VAL,INT_VAL,DATE_VAL)
VALUES
(entity_id_pk_sq.nextval,'purl.comment.size.limit','PURL Max Comment length',2,0,0,NULL,0,500,NULL)
/
INSERT INTO os_propertyset
(ENTITY_ID,ENTITY_NAME,ENTITY_KEY,KEY_TYPE,BOOLEAN_VAL,DOUBLE_VAL,STRING_VAL,LONG_VAL,INT_VAL,DATE_VAL)
VALUES
(entity_id_pk_sq.nextval,'admin.ip.restrictions','IPs with access to admin',5,0,0,'127.0.0.1,0:0:0:0:0:0:0:1,172.16.*,10.20.70.*,10.20.71.*,10.20.72.*,10.20.73.*,192.168.246.*,192.168.50.*,192.168.51.*,192.168.52.*,192.168.60.*,192.168.4.*,192.168.5.*,192.168.6.*,192.168.7.*',0,0,NULL)
/