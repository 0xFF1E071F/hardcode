/*
        Demosysteemin musiikki- ja ajoitusfunktiot.
        (c) The Fiture crew 1998
*/

#ifndef COOL_MZX_H
#define COOL_MZX_H

#define MZX_CONDITION_ANY (-1)

/* Riitt��ks toi? */
#define MAXCALLBACKS 1024

typedef struct MZX_RANGE
{
        int min, max;
} MZX_RANGE;

/* Olisi varmaan helpompi tehd� lauseparseri. */
typedef struct MZX_CONDITION
{ /* n�m� ovatten konjunkteja */
        MZX_RANGE channel;    /* -1 tarkoittaa "mik� tahansa" */
        MZX_RANGE instrument;
        MZX_RANGE volume;
        MZX_RANGE command;
        MZX_RANGE parameter;
        MZX_RANGE songpos;
        int rowmod;  /* callback, kun (rowcount % rowmod) == rowmodeq */
        MZX_RANGE rowmodeq;
        MZX_RANGE tick;
} MZX_CONDITION;

typedef struct MZX_CALLBACKREC
{
        void (*cbptr)(void);
        int numconditions;
        MZX_CONDITION *conditions;
} MZX_CALLBACKREC;

extern char *mzx_errorstr;

/*      Alustaa musiikkisysteemin, kyselee laitteet yms.        */
extern int mzx_init(void);

/*      Ottaa biisin muistista  */
extern int mzx_get(void *data);

/*      Aloittaa soiton ja k�ynnist�� timerin taajuudella freq 	*/
extern void mzx_start(int freq);

/*      Lopettaa soiton ja sulkee laitteen      */
extern void mzx_close(void);

/*      Palauttaa musiikin soitosta alkaen kuluneet tikit */
extern unsigned int mzx_time(void); /* miss�k�h�n se sen palauttaa? t:yzi */

/* yzi  Asettaa master volumen (feidej� varten) */
extern void mzx_set_mastervolume(double vol);

/* yzi  Palauttaa modinsoiton vaiheen, eli 100*songcount + rowcount. */
extern unsigned int mzx_position();

/* yzi  Kaikkien callbackien �iti. callbackrecin muistia ei saa vapauttaa! */
extern int mzx_set_callback(MZX_CALLBACKREC *callbackrec);

/* yzi  Helppo tapa laittaa pystyyn vbi �kki�. ("aina"-ehto) */
extern void mzx_set_default_callback(void (*cbptr)(void));

#endif

/*      EOH     */
