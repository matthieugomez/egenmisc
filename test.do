sysuse nlsw88.dta, clear

/* fastxtile vs xtile */
egen temp1 = fastxtile(hours) if married == 0, by(race) nq(10)
egen temp2 = xtile(hours) if married == 0, by(race) nq(10)
assert temp1 == temp2
drop temp*

/* fastsd vs sd */
egen temp1 = sd(wage) if married == 0, by(race)
egen temp2 = fastsd(wage) if married == 0, by(race)
assert reldif(temp1, temp2) < 1e-6 if !missing(temp1)
drop temp*

/* fastvar: check equals fastsd^2 */
egen temp1 = fastsd(wage) if married == 0, by(race)
egen temp2 = fastvar(wage) if married == 0, by(race)
assert reldif(temp1^2, temp2) < 1e-6 if !missing(temp1)
drop temp*

/* fastcorr vs corr */
sort race
egen temp1 = corr(hours wage) if married == 0, by(race)
egen temp2 = fastcorr(hours wage) if married == 0, by(race)
assert reldif(temp1, temp2) < 1e-6 if !missing(temp1)
drop temp*

/* fastcov: check cov = corr * sd1 * sd2 on complete cases */
keep if !missing(hours) & !missing(wage) & married == 0
sort race
egen temp_corr = fastcorr(hours wage), by(race)
egen temp_cov = fastcov(hours wage), by(race)
egen temp_sd1 = fastsd(hours), by(race)
egen temp_sd2 = fastsd(wage), by(race)
assert reldif(temp_cov, temp_corr * temp_sd1 * temp_sd2) < 1e-6
drop temp*

/* fastwpctile vs pctile */
sysuse nlsw88.dta, clear
egen temp1 = pctile(wage) if married == 0, by(race) p(75)
egen temp2 = fastwpctile(wage) if married == 0, by(race) p(75)
assert temp1 == temp2
drop temp*

/* min() option */
egen temp1 = fastsd(wage), by(race) min(2000)
assert missing(temp1)
drop temp*
