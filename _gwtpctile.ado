 program define _gwtpctile
   version 6, missing
   syntax newvarname =/exp [if] [in]  [, p(real 50) BY(varlist) weight(varname)]
   if `p'<=0 | `p'>=100 { 
     di in red "p(`p') must be between 0 and 100"
     exit 198
   }
   tempvar touse x

   quietly {
     mark `touse' `if' `in'
     gen double `x' = `exp' if `touse'

     if "`by'"=="" {
       _pctile `x' if `touse' `wt', p(`p')
       gen `typlist' `varlist' = r(r1) if `touse'
       exit
     }

     sort `touse' `by' `x'
     tempvar N
     if "`weight'" == ""{
      by `touse' `by': gen long `N' = sum(`x'!=.)
      local rj "round(`N'[_N]*`p'/100,1)"
      #delimit ;
      by `touse' `by': gen `typlist' `varlist' =
      cond(100*`rj'==`N'[_N]*`p',
       (`x'[`rj']+`x'[`rj'+1])/2,
       `x'[int(`N'[_N]*`p'/100)+1]) if `touse' ;
      #delimit cr
      }
    else{
      by `touse' `by': gen long `N' = sum((`x'!=.) * `weight')
      local rj "round(`N'[_N]*`p'/100,1)"
      tempvar temp
      gen `temp' = .
      tempvar tempx 
      gen `tempx' = `x' if `weight' > 0
      by `touse' `by': replace `tempx' = `tempx'[_n-1] if missing(`tempx')
      by `touse' `by': replace `temp' = `tempx'[_n-1] if missing(`temp'[_n-1]) & `N' > `rj'
      by `touse' `by': replace `temp' = `temp'[_n-1] if missing(`temp')
      by `touse' `by': gen `typlist' `varlist'  = `temp'[_N]
    }

  }
end
