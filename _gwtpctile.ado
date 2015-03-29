 program _gwtpctile, byable(onecall) sortpreserve
version 8.2
gettoken type 0 : 0
gettoken h    0 : 0 
gettoken eqs  0 : 0

syntax varname(numeric) [if] [in] [, ///
p(real 50) ///
Weights(string) ALTdef by(varlist) ]

marksample touse 

// Error Checks

if "`altdef'" ~= "" & "`weights'" ~= "" {
    di as error "weights are not allowed with altdef"
    exit 111
}


// Default Settings etc.

if "`weights'" ~= "" {
    local weight "[aw = `weights']"
}

if "`percentiles'" != "" {
    local percnum "`percentiles'"
}


if "`nquantiles'" == ""{
    local percnum 50
}

quietly {
    gen `type' `h' = .

    // Without by

    if "`by'"=="" {
        local i 1
        _pctile `varlist' `weight' if `touse', percentiles(`percnum') `altdef'
        gen `h' = r(r1) 
    }
    else{
        // With by
        count if `touse'
        local samplesize=r(N)
        local touse_first=_N-`samplesize'+1
        local touse_last=_N

        local nby `: word count `by''
        if `nby' >1 {
            sort `touse' `by'
            tempvar byvar
            local nby `:word count `by''
            bys `touse' `by': gen `byvar' = 1 if _n==1 & `touse'
            replace `byvar' = sum(`byvar') in `touse_first'/`touse_last'
        }
        else{
          if !(`touse_first'==1 & word("`:sortedby'",1)=="`by'") sort `touse' `by'
            local byvar `by'
            cap confirm numeric variable `by'
            if _rc{
                local prefix s
            }
        }

   
        mata: `prefix'characterize_unique_vals_sorted("`byvar'", `touse_first', `touse_last', `samplesize')
        tempname boundaries
        mat `boundaries' = r(boundaries)
        forvalues i = 1/`=r(r)'{
            _pctile `varlist' `weight' in `=`boundaries'[`i',1]'/`=`boundaries'[`i',2]', percentiles(`percnum') `altdef'
            replace `h' = r(r1)  in `=`boundaries'[`i',1]'/`=`boundaries'[`i',2]'
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



version 12.1
set matastrict on

mata:
    void scharacterize_unique_vals_sorted(string scalar var, real scalar first, real scalar last, real scalar maxuq) {
       // Inputs: a string variable, a starting & ending obs #, and a maximum number of unique values
       // Requires: the data to be sorted on the specified variable within the observation boundaries given
       //             (no check is made that this requirement is satisfied)
       // Returns: the number of unique values found
       //         the unique values found
       //         the observation boundaries of each unique value in the dataset


       // initialize returned results
       real scalar Nunique
       Nunique=0

       // changes here
       string matrix values
       values=J(maxuq,1,"")

       real matrix boundaries
       boundaries=J(maxuq,2,.)

       // initialize computations
       real scalar var_index
       var_index=st_varindex(var)

       // change here
       string scalar prevvalue
       string scalar curvalue

       // perform computations
       real scalar obs
       for (obs=first; obs<=last; obs++) {
            // change here
           curvalue=_st_sdata(obs,var_index)
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
    st_matrix("r(boundaries)",boundaries[1..Nunique,.])
}

end
