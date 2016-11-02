sysuse  nlsw88.dta, clear
egen temp1 = fastxtile(hours) if married == 0, by(race) nq(10)
egen temp2 = xtile(hours) if married == 0, by(race) nq(10)
assert temp1 == temp2
drop temp*

egen temp1 = sd(wage) if married == 0, by(race) 
egen temp2 = fastsd(wage) if married == 0, by(race) 
assert float(temp1) == float(temp2)
drop temp*

sort race
egen temp1 = corr(hours wage) if married == 0, by(race) 
egen temp2 = fastcorr(hours wage) if married == 0, by(race) 
assert temp1 == temp2 if !missing(hours) & !missing(wage)
drop temp*

