*******************************************************************************
*                                                                             *
*                   Frank and Goyal 2003 Replication                          *  
*                              David Zynda                                    *
*                                                                             *
*******************************************************************************;





libname rep_1 'C:/Users/dzynda/Desktop/replication1';

%let wrds = wrds.wharton.upenn.edu 4016;
options comamid=TCP remote=wrds;
signon username='bdzynda2' password='J0hnP@ul2';
Libname rwork slibref=work server=wrds;



* Macro provided by Acct. Dept to trim/winsorize data;
%include "C:/Users/dzynda/Desktop/replication1/MacroRepository.sas";



*#######################################################
#             Get Code and Complete Table 1            #
#######################################################;

*The assets look great. The liabilities look awful. ;

/*Remote submit for annual compustat data. 
Limit to years 1971-1998 (fyear)
Exclude regulated utilities and financial firms (sic)
Exclude major merger firms (footnote AB)
Exclude format codes 4,5,6 (scf)
Exclude firms missing book value of assets (at)
*/

rsubmit;

data compa_tmp; 
	set comp.funda;
	if indfmt = 'INDL';
	if datafmt = 'STD';
	if popsrc = 'D';
	if consol = 'C';
	if gvkey = . then delete;
	if cusip = '' then delete;
	if fyear ge 1971 and fyear le 1998;
	if sic ge 6000 and sic le 6999 then delete;
	if sic ge 4900 and sic le 4999 then delete;
	if scf ge 4 and scf le 6 then delete; 
	if at = . then delete;
	keep gvkey fyear ch ivst rect invt aco act ppent ivaeq ivao intan ao at
		 dlc ap txp lco lct dltt lo txditc mib lt pstk ceq seq;
run;

* Get footnote codes AB indicating major merger, make year variable from datadate;
data footnote;
	set comp.co_afntind2;
	year = year(datadate);
	keep gvkey sale_fn year;
	
run;

proc download data = compa_tmp;
run;

proc download data = footnote;
run;

endrsubmit;



*QUESTION: IS IT OKAY TO MERGE ON FYEAR AND DATADATE - DO THEY MEAN THE SAME THING?;
*Join compa dataset and footnotes (to screen out footnote AB mergers);
proc sql;
	create table compa as
	select a.*, b.sale_fn
	from compa_tmp as a left join footnote as b
	on (a.gvkey = b.gvkey) and (a.fyear = b.year);
quit;



*Remove firms with AB;
*Make sure short term inv. (inst) is not already included in cash per specification in Table 1 description;
/*Record as zero when missing or combined with other data: 
investment and advances, intagibles, other assets, debt in current liabilities, 
income taxes payable, other current liabilities, other liabilites, deferred taxes 
and ITC, minority interest */


*Obs for which variables had no data were deleted - no instruction to do so, but makes results more consistent;
data compa;
	set compa;
	if at = . then delete;
	if at = 0 then delete;
	if ch = . then delete;
	if rect = . then delete;
	if invt = . then delete;
	if aco = . then delete;
	if act = . then delete;
	if ppent = . then delete;
	if ap = . then delete;
	if lct = . then delete;
	if dltt = . then delete;
	if lt = . then delete;
	if pstk = . then delete;
	if ceq = . then delete;
	if seq = . then delete;

	if sale_fn = 'AB' then delete;
	if (ch + ivst + rect + invt + aco > act) then inst = 0;
	if ivaeq = . then ivaeq = 0;
	if ivao = . then ivao = 0;
	if intan = . then intan = 0;
	if ao = . then ao = 0;
	if dlc = . then dlc = 0;
	if txp = . then txp = 0;
	if lco = . then lco = 0;
	if lo = . then lo = 0;
	if txditc = . then txditc = 0;
	if mib = . then mib = 0;

run;



*New dataset - Make all cash flow statement variables as a percentage of assets;

data compa_per_assets;
	set compa;
	ch = ch / at;
	ivst = ivst / at;
	rect = rect / at;
	invt = invt / at;
	aco = aco / at;
	act = act / at;
	ppent = ppent / at;
	ivaeq = ivaeq / at;
	ivao = ivao / at;
	intan = intan / at;
	ao = ao / at;
	dlc = dlc / at;
	ap = ap / at;
	txp = txp / at;
	lco = lco / at;
	lct = lct / at;
	dltt = dltt / at;
	lo = lo / at;
	txditc = txditc / at;
	mib = mib / at;
	lt = lt / at;
	pstk = pstk / at;
	ceq = ceq / at;
	seq = seq / at;
	total_assets = at /at; 
run;



*Use accounting dept's macro to trim the data;
%WT(data=compa_per_assets, out=compa_per_assets, byvar=none, vars=ch ivst rect invt aco act ppent ivaeq ivao intan ao at
		 dlc ap txp lco lct dltt lo txditc mib lt pstk ceq seq, type = T, pctl = .5 99.5, drop= Y);
run;

proc sort data = compa_per_assets;
	by fyear gvkey;
run;

proc means data = compa_per_assets;
	by fyear;
	var ch ivst rect invt aco act ppent ivaeq ivao intan ao at
		 dlc ap txp lco lct dltt lo txditc mib lt pstk ceq seq;
run;








*#######################################################
#             Get Code and Complete Table 2            #
#######################################################;



























