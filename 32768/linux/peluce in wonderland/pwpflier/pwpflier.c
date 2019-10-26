#include <stdio.h>
#include <stdlib.h>
#include <time.h>

char protomap[256][256];

int rasterizer[8]={0,32,16,48,8,40,24,56};

#define LIM(a) ((a)<0?0:((a)>255?255:(a)))

void recursive_plasma(int x0,int y0,int x1,int y1,int lev)
{
   if(x1>x0 && y1>y0)
   {
      int a=protomap[x0&255][y0&255],
          b=protomap[x1&255][y0&255],
          c=protomap[x0&255][y1&255],
          d=protomap[x1&255][y1&255],

          xm=(x0+x1)>>1,
          ym=(y0+y1)>>1;

      protomap[xm][y0]=(a+b)>>1;
      protomap[xm][y1]=(c+d)>>1;
      protomap[x0][ym]=(a+c)>>1;
      protomap[x1][ym]=(b+d)>>1;

        // 4:single detail, 8:g00d, 32:mess with great contrast
      { int k=rand()%((abs(x0-x1)<<lev)+1);
        if(k&1)k=0-k;
        protomap[xm][ym]=LIM((a+b+c+d+k)>>2);
      }

      if(x1>x0+1)
      {
         recursive_plasma(x0,y0,xm,ym,lev);
         recursive_plasma(xm,y0,x1,ym,lev);
         recursive_plasma(x0,ym,xm,y1,lev);
         recursive_plasma(xm,ym,x1,y1,lev);
      }
   }
}


void drawflier(char*pic0,char*bg0,int xzoom,int yzoom)
{
   int iy=0,ix;

   char*pic=pic0,
       *bg=bg0;

   while(*pic!='\0')
   {
      char*line=pic;
      int y=yzoom;

      for(;y;y--)
      {
         pic=line;
         while(*pic!='\n')
         {
            int x=xzoom;
            for(;x;x--)
            {
               if(*pic!=' ')
               {
                  putchar(*bg);
                  bg++;
                    if(*bg=='\0')bg=bg0;
               }
                else
               {
                  int k=protomap[iy&255][ix&255]+rasterizer[(iy^(ix<<1))&7];
                  putchar(" ..:;"[(k>>6)%5]);
               }
               ix++;
            }

            pic++;
              if(pic=='\0')pic=pic0;
         }
         iy++;
         ix=0;
         putchar('\n');
      }
      pic++;
   }
}

/********************************************************************/

char*pwpflier0=

   "                               \n"
   "                               \n"
   "                               \n"
   "         ** ********           \n" 
   "         ******** **           \n"
   "             ***               \n"
   "             ***               \n"
   "          *************        \n"
   "          *******************  \n"
   "         **********            \n"
   "         xxxxxx                \n"
   "        *****                  \n"
   "        *****    x             \n"
   "       ********                \n"
   "       ************            \n"
   "       **************          \n"
   "       ****************        \n"
   "        *****                  \n"
   "        *******                \n"
   "        ***********  xx        \n"
   "        ***************        \n"
   "         ************          \n"
   "         **********            \n"
   "           ******              \n"
   "           ******              \n"
   "           ******              \n"
   "                               \n"
   "   ******** **      ** ********\n" 
   "   ******** **      ** ********\n"
   "   **    ** **      ** **    **\n"
   "   **    ** **      ** **    **\n"
   "   ******** **  **  ** ********\n"
   "   ******** **  **  ** ********\n"
   "   **       **  **  ** **      \n"
   "   **       **  **  ** **      \n"
   "   **       ********** **      \n"
   "   **       ********** **      \n"
   "                               \n";

/* 
 *  From Jeesuksen Opetuslapset ry - freely distributable text
 *
 *  http://personal.inet.fi/yhdistys/jeesuksenopetuslapsetry./
 *
 */

char*jolry_bg=
   "Ottaisin p��lleni vaikka mink�laisia ruttoja, jos saisin Jumalalta "
   "VOIMALLISTEN TEKOJEN ARMOLAHJAN! HENKIEN ULOSAJAMISEN ARMOLAHJAN! "
   "VAIKKA PUOLEKSI VUODEKSI!  ILMAN NIIT� EN VOI KUN ITKE� JA VALVOA "
   "�IT�NI! KYLL� NE MIELESS� ON NUO VUODET JA NE Y�T KUN TUOLLA K�VELIN "
   "JA N�IN KERTOMAANI! JA NYT SAAN KUULLA, ETT� T�M� TOUHU KASVAA!!! JA "
   "JUURI T�H�N AIKAAN!!!! SAATANA on vuositolkulla tiet�nyt "
   "Hengellisist� asoista enemm�n kuin uskovat!   "

   "1990 luvun alussa JUMALALTA tuli profetia: \"Nyt, MIN� JUMALA, ALAN "
   "KURITTAMAAN SUOMEN KANSAA TOSI MIELESS�, SIIT� SYYST�, ETT� SUOMEN "
   "KANSASTA EI L�YDY H�NELLE KELPAAVASSA USKOSSA OLEVIA IHMISI�, "
   "H�NELLE RIITT�V�� M��R��!   "

   "Kuinka paljon sinun perheess�si on tuhottu ��nitteit�, joilla on ns. "
   "Hevy metalli rokkia? ns. Gospel musiikkia? Joita varhaisnuoret "
   "kuuntelevat, kuin ei mit��n pahaa olisi!   "

   "SIIN� T�LL� MENETELM�LL� MENEV�T SITTEN 30 luvun Raamattu ja "
   "Herramme JEESUS MUKANA! VALITAN! N�IN VAKAVISTA ASIOISTA ON KYSE! "
   "MINK�S MIN� HEILLE VOIN?! ITKE� JA KOITTAA KUINKA KOVIA LY�NTEJ� "
   "T�M� N�PP�IMIST� KEST��! JA SY�D� PSYKOSOMAATTISIIN SAIRAUKSIINI "
   "PURKKI KAUPALLA PILLEREIT�! JOITA L��K�RINI KIELSI SY�M�ST�! Kun ei "
   "ole varaa niihin l��kkeisiin, joita tarvitsen!   "
 
   "H�VETK��! JOS OSAATTE!  RAAMATTU KERTOO, ETT� ISRAELIN KANSA "
   "EVANKELIOIDAAN AIVAN MERKILLISELL� TAVALLA! MITEN SAMASTA ASIASTA "
   "VOI OLLA KAKSI ERI VERSIOTA! PAINUKAA LUOLIIN JA TUKKIKAA SUUNNE! "
   "SANON MIN�!  JOS EI TEILL� MUUTA PUHUTTAVAA OLE! ON RAAMATUN "
   "LUKUNNEKIN OLLUT AIVAN TURHAA!  KUN ETTE YMM�RR� LUKEMAANNE! VOI "
   "PYH� YKSINKERTAISUUS!  Pystyisin kaatamaan joka ainoan v�itteenne! "
   "TE TULETTE RAAMATULLA!  JA AIVAN SAMALLA KIRJALLA MIN� KAADAN "
   "JOKAISEN VALHEELLISEN V�ITTEENNE! MUTTA EN JAKSA! MUTTA VAROITAN "
   "KYLL� N�IST� KIRJANOPPINEISTA! �LK�� KUUNNELKO HEIT�! KUUNNELKEE "
   "JEESUSTA! H�N OPETTAA TEILLE RAAMATUN PERUSTOTUUDET HYVINKIN "
   "NOPEASTI! EIK� NYT KYLL� PITKIIN KURSSEIHIN AIKAA OLEKKAAN! VAINON "
   "AJAT OVAT L�HELL�!  JA T�M� KANSA EI TIED� MIT��N!  ILMIANTAJIA ON "
   "TUHATM��RIN ENEMM�N;KUIN NIIT� AITOJA JEESUKSEN SEURAAJIA JOITA "
   "T�SS�KIN MAASSA ALETAAN VAINOTA! N�IN IK�V�STI ON NYT ASIAT! JA "
   "VIEL� YRIT�TTE SAATANAN JOUKKOJEN KEHOITUKSESTA TULEMAAN ESIIN! SE "
   "ON MIINA JOHON ME EMME NYT TULE! ANTEEKSI VAAN! TAIDAMME JOUTUA "
   "POISTUMAAN AIKAISEMMIN, KUIN OLETINKAAN!  VALMIINA KYLL� OLLAAN! EI "
   "SIIN� MIT��N! HUKASSA ON JO PALJON SUOMEN AITOJA USKOVAISIA! "
   "POISTUMME HETI KUN SILT� N�YTT��! JEESUS ANTAA MERKIN! EMME TARVITSE "
   "KUIN TIEDON Y�LL�! SEURAAVANA P�IV�N� OLEMME JO KATEISSA! NIIN "
   "YKSINKERTAISTA!   "

   "YLEINEN V�ITT�M�; JOKA TAANNOIN VIIMEKSI MINULLEKKIN TAAS POSTIN "
   "KAUTTA HEITETTIIN:\" AITO PROFEETTA EI PUHU MILLOINKAAN "
   "VALHEPROFETIOITA!\" AIVAN VARMASTI JOUTUU PUHUMAAN! ILMESTYKSI� "
   "N�KEV�; JOUTUU AIVAN VARMASTI KATSELEMAAN SAATANAN LUOMIA "
   "ILMESTYKSI�!!!! SAARNAAJAT JA OPETTAJAT JOUTUVAT AIVAN VARMASTI "
   "N�IHIN MIINOIHIN! JOUDUMME YLIHENGELLISYYTEEN! JOUDUMME LAN ALLE! "
   "IHAN VARMASTI JA AIVAN K�YT�NN�SS�! T�M� TAPAHTUU KOULUTTUKSEN "
   "AIKANA. KAIKKI N�M�! JA SENKIN J�LKEEN SAATTAA LIPSUA!   "

   "Nyt VELI TEMPAISIKIN SUOMEKSI KOMENNON: JEESUKSEN KRISTUKSEN "
   "NASARETTILAISEN NIMESS�! ANNETTIIN PIMEYDEN HENKILLE L�HT�K�SKY! "
   "Mit�s nyt tapahtui?   "

   "AMERIKASTAKIN KUULEMMA AINAKIN YKSI B�NDI TULEE! Sinne sitten vaan "
   "kuuntelemaan tuota SAATANAN LUOMAA MUSIIKKIA! Englannin sanakirjan "
   "mukaan gospel tarkoittaa suomeksi: evankeliumi! ETT� SIIHEN MALLIIN "
   "MEILL� P�IN!  T�ytyy teille kertoa ihan tosiasia! JA J�LLEEN "
   "VALITETTAVASTI HYVIN MONIEN PETTYMYKSEKSI! SANAT OSIN RAAMATUSTA! "
   "S�VELLYS SAATANAN! T�H�N EI OLE ALUSTA ALKAENKAAN YHTYNYT JUMALA! EI "
   "PYH� HENKI! EIK� TULE MILLOINKAAN YHTYM��N MIHINK��N! MISS� SAATANA "
   "TAI H�NEN JOUKKONSA OVAT MUKANA! NIIISS� LIIKKUU PIMEYDEN HENGET JA "
   "TUNTEET! PALJONHAN NIILL�KIN AIKAAN SAADAAN! Pelottavin aikaan "
   "saannos tuollakin on JUMALAN VIHA!!! Maatamme kohtaan! SINNE NYT "
   "VANHEMMAT: KAKAROITANNE P��ST�TTE! SUORASTAAN TYRKYT�TTE! JA "
   "KANNATTE USKOVAISEN NIME�! J�tt�k�� tuo nimi pois! Ihan totta! "
   "Katsokaas, kun JUMALALLA JA SAATANALLA EI OLE MIT��N TEKEMIST� "
   "TOISTENSA KANSSA! EI HIUSKARVAN VERTAA! EI OLE MILLOINKAAN OLLUT! "
   "SEN J�LKEEN KUN SAATANA JA LANGENNEET ENKELIT TAIVAASTA VISKATTIIN! "
   "EIK� TULE OLEMAAN! SAATANA ON KAIKEN MUSIIKIN JA KAIKKIEN SOITTIMIEN "
   "ASIANTUNTIJA! SIT� H�N OLI JO TAIVAASSA! ENNEN KUIN RYHTYI KAPINAAN "
   "JUMALAN KANSSA! N�in Raamattu meille kertoo! Valtavalle m��r�lle "
   "teist�, tuo asia on tuttu! Mutta se nyt ik��nkuin ei kuuluisi "
   "teille! ARVATKAAPA: KUULUUKO???   "

   "Erotkaa, rakkaat yst�v�t, noista VOUHOTTAJISTA, JOTKA EIV�T MIT��N "
   "TIED�!!!  Kasetilla on sanoittus suurista ihmeist� ja Raamatusta! "
   "S�VELLYS ON SAATANAN!  LAULU ESITYS T�YSIN TEKNINEN SUORITUS! JA "
   "KAIKEN LIS�KSI SURKEA SELLAINEN! SAMAT ARVOSANAT KIRJASTA! SAATANAN "
   "JOUKKOJEN K�TYRI! Kuuluisuudestaan huolimatta; RIKU RINNE! AINAKIN "
   "NYT! Jos muutosta tapahtuu? VIE SE TUOLTA PAIKALTA, MISS� H�N NYT "
   "ON: MELKO PITK�N AIKAA! EN TUOMITSE! MUTTA PALJASTAN! JA VAROITAN!   "

   "ELLEMME P��SE ALKUSEURAKUNNAN KALTAISEEN JUMALAN VOIMAN VAIKUTUKSEN "
   "ALLE? ON TULOSSA ILMESTYSKIRJAN MUKAAN SELLAISTA TAVARAA MY�S "
   "SUOMEEN! ETT� ILMAN T�T� VOIMAA VOIMMEKIN SITTEN SANOA AIVAN "
   "VARMASTI TOISILLEMME HYV�STI JA HYV�� Y�T�! OHJEET ANTAA JEESUS "
   "ALKUVALMISTELUT VOITTE TEHD� ALKUSEURAKUNNAN TAPAAN! KERRAN MEID�T "
   "JOKAINEN RIISUTAAN!  ELLET N�IHIN USKO? �l� vaan sitten k�yt� "
   "itsest�si nimityst� uskovainen tai kristitty! VAAN JOS V�IT�T ettei "
   "n�m� kuulu sinulle!  Eik� meille t�n� aikana?! SIN� OLET T�YSI "
   "PELLE!   "

   "JA N�M�K��N EIV�T VIEL� OLE TAKUULIPPU TAIVAASEEN! MUTTA, KUN "
   "KUULIAISESTI HERRAA T�M�N J�LKEEN SEURAILEE. Voi joku saada "
   "kerrottua asian lapsilleen sukulaisilleen jne, NIMITT�IN JOS N�M� "
   "RUKOUKSET TEET AIVAN VILPITT�M�STI !  Tarkoitan tuollaista tietoista "
   "vilppi�. KAIKKI ME NYT MUUTOIN OLLAAN KAIKKEA PAHUUTTA T�YNN� "
   "TIED�TK�? SIELT�....TAIVAASTA KAJAHTAA MAHTAVA VOIMA !   "

   "Ja raha on tuossa osavaltiossa ollut pois k�yt�ss� tuon kokeen ajan. "
   "T�M� ON ILMESTYSKIRJASSA KERROTTU PEDON MERKKI! JOLLA TUOTA MERKKI� "
   "EI OLE; H�NELT� EI OSTETA MIT��N! EIK� MYYD� MIT��N! SEH�N ON "
   "SELVI�! KUN RAHA POISTETAAN K�YT�ST�.  ON MAHDOTON ostaa tai myyd� "
   "ilman tuota pedon merkki�! Pyrin selitt�m��n t�m�n hyvin "
   "kansanomaisesti. Ja kun tuo aika tulee. Ei paljon kertomastani voi "
   "tuo menetelm� poiketa! Ja t�m� on sitten sellainen MERKKI, jota "
   "YKSIK��N USKOVAINEN EI SAA MISS��N OLOISSA OTTAA! NIMITT�IN, kun "
   "Antikristus nousee ja vaaditaan tuo pedon merkki on se kovimpia "
   "koettelemuksia uskovaisille! Kansat kumartavat tuota "
   "petoa. Tottelevat h�nt�. Siis SAATANAN JUTTU!   "

   "Ellet tietoisesti palvele ja seuraa JEESUSTA, silloin tiet�m�tt�si "
   "palvelet ja seuraat SAATANAA! H�n pystyy t�m�n asian sinulta niin "
   "h�m��m��n, ettet tied� mit��n! Jeesuksen omana olo ei ole salainen "
   "asia!   "

   "Kun yksikin taloudelliseti hyvin voiva henkil� tekee Jumalan mielen "
   "mukaisen parannuksen. Napsahtaa omaisuudet automaattiseti Jumalan "
   "Valtakunnan ty�h�n!  EIK� VAIN SINNE P�IN! NIINKUIN NYT ON "
   "KAIKENAIKAA N�HT�VISS�! N�M� SAATANAN VALTAAMAT V�LINEET EIV�T KOVIN "
   "KAUAA OLE USKOVAISTEN K�DEN ULOTTUVILLA! JA SUOMESSA AIDOT JEESUKSEN "
   "SEURAAJAT, JUMALAN PALVELIJAT VOIVAT TEHD� N�IDEN LAITTEIDEN AVULLA "
   "VALTAVIA JUTTUJA, JOITA JUMALA SIUNAA KYLL� SUOMESSA ON OLTAVA "
   "KETJUT KUNNOSSA: MITEN JAKO ETEENP�IN TAPAHTUU! Vaikka Jumala "
   "Henkens� kautta on tehnyt yht� sun toista Suomessa ilman ihmisi�! "
   "Raamatun mukaan IHMISI� K�YTET��N JUMALAN VALTAKUNNAN TY�SS� HAMAAN "
   "JEESUKSEN TULEMUKSEEN ASTI!!!   "

   "JOS TOIMITTE: LIS�TIETOA TULEE JEESUKSELTA NOPEAAN TAHTIIN! KAIKKI "
   "MUU ON T�YSIN TURHAA! Puhukoon Istala ja kumppanit mit� tykk��! "
   "Saatanan palveluksessa koko remmi ja TIUKASTI! Ja lis�� tulee! "
   "ISTALA KAATUU UUSIEN TUULIEN TULLESSA! Amerikassa jo valmiina! "
   "Levinnyt jo EUROOPPAAN! ENNUSTAN N�ILLE NYKYISILLE SAATANAN "
   "K�TYREILLE nopeaa uran p��ttymist�!   "

   "OLISIKOHAN SYYT� VIIPYMATT� MENN� RUKOILLEN N�YRASTI JEESUKSEN "
   "OPETUKSEN ALLE!  PARANNUKSEN TEON J�LKEEN! JA SAMAN TIEN ANTAA "
   "ITSENS� JUMALALLE OTOLLISEKSI UHRIKSI! Ehtii oppia PYH�N HENGEN ja "
   "saatanallisten henkien ERON! Ainakin n�in r�ikeiss� muodoissa! "
   "Varoitan edelleen! �lk�� tutkiko pimeyden henki�????!   ";

/********************************************************************/

int main(int argc,char**argv)
{
   srand(time(NULL));

   if(argc<3)
   {
      fprintf(stderr,"usage: %s <xzoom> <yzoom> [plasma]\n",argv[0]);
   }
    else
   {
      if(argc==3)
      {
         int i,j;
         for(i=0;i<256;i++)
           for(j=0;j<256;j++)
             protomap[i][j]=0;
      }
       else
      {
         protomap[0][0]=rand()&255;
         protomap[0][255]=rand()&255;
         protomap[255][0]=rand()&255;
         protomap[255][255]=rand()&255;
         recursive_plasma(0,0,255,255,3);
      }
         
      drawflier(pwpflier0,jolry_bg,atoi(argv[1]),atoi(argv[2]));
   }
   return 0;
}

