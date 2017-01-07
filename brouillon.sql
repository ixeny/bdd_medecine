--brouillon------------------------------------------------------------


CREATE TABLE "MEDECIN" (
  "ID" NUMBER(10) PRIMARY KEY
);

CREATE SEQUENCE "MEDECIN_SEQ" NOCACHE;

CREATE TRIGGER "MEDECIN_BI"
  BEFORE INSERT ON "MEDECIN"
  FOR EACH ROW
BEGIN
  IF :NEW."ID" IS NULL THEN
    SELECT "MEDECIN_SEQ".NEXTVAL INTO :NEW."ID" FROM DUAL;
  END IF;
END;


CREATE OR REPLACE TRIGGER verif_medic_medecin
BEFORE INSERT 
ON traitement 
FOR EACH ROW 
DECLARE 
numeromedecin varchar(38);
BEGIN
	select id_medecin into numeromedecin from medecin_medica where id_medicament=:New.id_medicament;
	IF (numeromedecin!=' ') THEN
		 DBMS_OUTPUT.PUT_LINE('Ce medecin est fabriquant de ce medicament,il ne peut pas le prescrire.');		
	END IF;
END;
/



--fin brouillon-------------------------------------------------------------------------
