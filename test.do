sysuse  nlsw88.dta, clear
egen temp1 = fastxtile(hours) if married == 0, by(race) nq(10)
egen temp2 = xtile(hours) if married == 0, by(race) nq(10)
assert temp1 == temp2
drop temp*

egen temp1 = wtmean(wage) if married == 0, by(race) weight(hours)
egen temp2 = namean(wage) if married == 0, by(race) weight(hours)
assert temp1 == temp2 
drop temp*

egen temp1 = sum(wage) if married == 0, by(race) 
egen temp2 = sum(wage) if married == 0, by(race) 
assert temp1 == temp2 
drop temp*

egen temp1 = sd(wage) if married == 0, by(race) 
egen temp2 = nasd(wage) if married == 0, by(race) 
assert float(temp1) == float(temp2)
drop temp*

sort race
egen temp1 = corr(hours wage) if married == 0, by(race) 
egen temp2 = nacorr(hours wage) if married == 0, by(race) 
assert temp1 == temp2 if !missing(hours) & !missing(wage)
drop temp*

