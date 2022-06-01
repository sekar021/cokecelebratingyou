UPDATE cms_asset
   SET pax_or_admin = 'P',
       date_modified = SYSDATE
 WHERE id IN (SELECT ca.id
                FROM cms_asset ca,
                     cms_section cs,
                     cms_application capp
               WHERE ca.section_id = cs.id
                 AND cs.application_id = capp.id
                 AND capp.code = 'beacon'
                 AND ca.code IN 
('message_data.message.138807'))
/

COMMIT
/