/*classement des clients par nombre d occupation*/


/*classement des clients par montant dépensé dansl hotel*/


/*classement des occupations par mois*/

/*
SELECT CHB_PLN_CLI_NB_PERS, CHB_ID, PLN_JOUR
FROM CLI_PLN_CHB
ORDER BY CHB_PLN_CLI_NB_PERS desc; */

SELECT CHB_PLN_CLI_NB_PERS, CHB_ID, PLN_JOUR
FROM CLI_PLN_CHB
GROUP BY strftime("%m")
ORDER BY CHB_PLN_CLI_NB_PERS desc;



/*classement des occupations par trimestre*/

SELECT CHB_PLN_CLI_NB_PERS, CHB_ID, PLN_JOUR
FROM CLI_PLN_CHB
ORDER BY CHB_PLN_CLI_NB_PERS desc;




/*montant ttc de chaque ligne de facture (avec remise)*/

/*pour obtenir un résultat affiché retirez -LIF_REMISE_MONTANT)*(1-(LIF_REMISE_POURCENT/100)*LIF_QTE) et ajoutez une paranthèse en fin de ligne
je n'ai pu trouver la source du problème empechant l'affichage du résultat du calcul*/

SELECT LIF_ID, (((LIF_MONTANT*((LIF_TAUX_TVA/100)+1))-LIF_REMISE_MONTANT)*(1-(LIF_REMISE_POURCENT/100))*LIF_QTE) as Montant_TTC
FROM LIGNE_FACTURE

/*classement du montant ttc (avec remise) des factures*/

/*Idem qu'a la question pécédente */

SELECT LIF_ID, (((LIF_MONTANT*((LIF_TAUX_TVA/100)+1))-LIF_REMISE_MONTANT)*(1-(LIF_REMISE_POURCENT/100))*LIF_QTE) as Montant_TTC
FROM LIGNE_FACTURE
ORDER BY Montant_TTC desc;



/*tarif moyen des chambres par année croissante*/

SELECT avg(TRF_CHB_PRIX), TRF_DATE_DEBUT
FROM CHB_TRF
ORDER BY TRF_DATE_DEBUT asc;




/*tarif moyen des chambres par étage et années croissantes*/

SELECT avg(TRF_CHB_PRIX), TRF_DATE_DEBUT, CHB_ETAGE
FROM CHB_TRF, CHAMBRE
ORDER BY TRF_DATE_DEBUT asc;



/*chambre la plus cher et en quelle année*/

SELECT CHB_ID, TRF_DATE_DEBUT, max(TRF_CHB_PRIX)
FROM CHB_TRF




/*chambres réservées mais pas occupés*/

SELECT CHB_ID
FROM CLI_PLN_CHB
WHERE CHB_PLN_CLI_RESERVE=1 AND CHB_PLN_CLI_OCCUPE=0;



/*taux de résa par chambre*/

SELECT  CHB_ID, count(CHB_ID), count(*), ((count(CHB_ID)/count(*))*100) as TauxRes
FROM CHB_TRF
ORDER BY TauxRes desc;



/*facture réglées avant leur édition*/

SELECT FAC_ID
FROM FACTURE
WHERE FAC_PMT_DATE<FAC_DATE;



/*par qui ont été payées ces factures réglées en avance?*/

SELECT FAC_ID, CLI_NOM
FROM FACTURE, CLIENT
WHERE FAC_PMT_DATE<FAC_DATE;



/*classement des modes de paiement (par le mode et le montant total généré)*/

SELECT PMT_LIBELLE, LIF_MONTANT
FROM FACTURE, LIGNE_FACTURE, MODE_PAIEMENT
GROUP BY PMT_LIBELLE
ORDER BY LIF_MONTANT desc;


/*vous vous créez en tant que client de l hôtel*/

INSERT INTO CLIENT(CLI_ID,CLI_NOM,CLI_PRENOM,CLI_ENSEIGNE,TIT_CODE)
VALUES (104, 'RENCUREL', 'Pierre', 'Ludus', 'M.');



/*ne pas oublier vos moyens de communication*/

INSERT INTO TELEPHONE(TEL_ID,TEL_NUMERO,TEL_LOCALISATION,CLI_ID,TYP_CODE)
VALUES (251, '06-76-08-45-12',' ' , '104', 'GSM');

INSERT INTO EMAIL(EML_ID,EML_ADRESSE,EML_LOCALISATION,CLI_ID)
VALUES (40, 'p.rencurel@ludus-academie.com','Bureau' , '104');



/*vous créez une nouvelle chambre a la date du jour*/

INSERT INTO CHAMBRE(CHB_ID,CHB_NUMERO,CHB_ETAGE,CHB_BAIN,CHB_DOUCHE,CHB_WC,CHB_COUCHAGE,CHB_POSTE_TEL)
VALUES (21, 22,'3e' , 0,1,1,2,99);

INSERT INTO CHB_TRF(TRF_CHB_PRIX,CHB_ID,TRF_DATE_DEBUT)
VALUES (261, 21,strftime("%Y - %m - %d"));



/*vous serez 3 occupants et souhaitez le maximum de confort pour cette chambre dont le prix est 30% superieur a la chambre la plus cher*/


/*le reglement de votre facture sera effectué en CB*/

INSERT INTO FACTURE (FAC_ID,FAC_DATE,FAC_PMT_DATE,CLI_ID,PMT_CODE)
VALUES (2375,2017/05/11,2017/05/15,104,'CB');


/*une seconde facture a été éditée car le tarif a changé : rabais de 10%*/


/*comment faites vous? (ceci ne remplace pas les traitements précédents)*/

UPDATE LIGNE_FACTURE
SET LIF_MONTANT = LIF_MONTANT * 0.90
WHERE FAC_ID like '%2375%';