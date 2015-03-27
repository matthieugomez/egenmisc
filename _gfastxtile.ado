*! _gxtile version 1.2 UK 08 Mai 2006
* categorizes exp by its quantiles - byable

* 1.2: Bug: Opt percentiles were treated incorrectely after implement. of option nq
*          Allows By-Variables that are strings
* 1.1: Bug: weights are treated incorectelly in version 1.0. -> fixed
*     New option nquantiles() implemented                
* 1.0: initial version
program _gfastxtile, byable(onecall) sortpreserve
version 8.2
gettoken type 0 : 0
gettoken h    0 : 0 
gettoken eqs  0 : 0

syntax varname(numeric) [if] [in] [, ///
Percentiles(string) ///
Nquantiles(string) ///
Weights(string) ALTdef by(varlist) ]

marksample touse 

// Error Checks

if "`altdef'" ~= "" & "`weights'" ~= "" {
    di as error "weights are not allowed with altdef"
    exit 111
}

if "`percentiles'" != "" & "`nquantiles'" != "" {
    di as error "do not specify percentiles and nquantiles"
    exit 198
}

// Default Settings etc.

if "`weights'" ~= "" {
    local weight "[aw = `weights']"
}

if "`percentiles'" != "" {
    local percnum "`percentiles'"
}
else if "`nquantiles'" != "" {
    local perc = 100/`nquantiles'
    local first = `perc'
    local step = `perc'
    local last = 100-`perc'
    local percnum "`first'(`step')`last'"
}

if "`nquantiles'" == "" & "`percentiles'" == "" {
    local percnum 50
}

quietly {

    gen `type' `h' = .

    // Without by

    if "`by'"=="" {
        local i 1
        _pctile `varlist' `weight' if `touse', percentiles(`percnum') `altdef'
        foreach p of numlist `percnum' {
            if `i' == 1 {
                replace `h' = `i' if `varlist' <= r(r`i') & `touse'
            }
            replace `h' = `++i' if `varlist' > r(r`--i')  & `touse'
            local i = `i' + 1
        }
        exit
    }

    // With by
    tempvar byvar
    local nby `:word count `by''
    if `nby'>1{
        by `touse' `by', sort: gen `byvar' = 1 if _n==1 & `touse'
        by `touse' (`by'): replace `byvar' = sum(`byvar')
    }
    else{
        sort `touse' `by'
        local byvar `by'
    }

    count if `touse'
    local samplesize=r(N)
    local touse_first=_N-`samplesize'+1
    local touse_last=_N
    mata: characterize_unique_vals_sorted("`byvar'", `touse_first', `touse_last', `samplesize')
    tempname boundaries
    mat `boundaries' = r(boundaries)
    forvalues i = 1/`=r(r)'{
        _pctile `varlist' `weight' in `=`boundaries'[`i',1]'/`=`boundaries'[`i',2]', percentiles(`percnum') `altdef'
        foreach p of numlist `percnum' {
            local j = 1
            if `j' == 1 {
                replace `h' = `j' if `varlist' <= r(r`j') in `=`boundaries'[`i',1]'/`=`boundaries'[`i',2]'
            }
            replace `h' = `++j' if `varlist' > r(r`--j')  in `=`boundaries'[`i',1]'/`=`boundaries'[`i',2]'
            local j = `j' + 1
        }
    }
}
end

/***************************************************************************************************

***************************************************************************************************/
version 12.1
set matastrict on

mata:

    void characterize_unique_vals_sorted(string scalar var, real scalar first, real scalar last, real scalar maxuq) {
     // Inputs: a numeric variable, a starting & ending obs #, and a maximum number of unique values
     // Requires: the data to be sorted on the specified variable within the observation boundaries given
     //				(no check is made that this requirement is satisfied)
     // Returns: the number of unique values found
     //			the unique values found
     //			the observation boundaries of each unique value in the dataset


     // initialize returned results
     real scalar Nunique
     Nunique=0

     real matrix values
     values=J(maxuq,1,.)

     real matrix boundaries
     boundaries=J(maxuq,2,.)

     // initialize computations
     real scalar var_index
     var_index=st_varindex(var)

     real scalar curvalue
     real scalar prevvalue

     // perform computations
     real scalar obs
     for (obs=first; obs<=last; obs++) {
      curvalue=_st_data(obs,var_index)

      if (curvalue!=prevvalue) {
       Nunique++
       if (Nunique<=maxuq) {
        prevvalue=curvalue
        values[Nunique,1]=curvalue
        boundaries[Nunique,1]=obs
        if (Nunique>1) boundaries[Nunique-1,2]=obs-1
    }
    else {
        exit(error(134))
    }

}
}
boundaries[Nunique,2]=last

// return results
stata("return clear")

st_numscalar("r(r)",Nunique)
st_matrix("r(values)",values[1..Nunique,.])
st_matrix("r(boundaries)",boundaries[1..Nunique,.])

}

end
