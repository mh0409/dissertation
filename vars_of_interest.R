
# Define variables of interest
vars_of_interest <- c("country", "gor_dv", "urban_dv", "racel_recat", "sex_dv", "marstat_recat", "fihhmnnet1_dv",
                      "houscost1_dv", "is_mtgprisoner", "wavenumber", "pidp", "age_dv", "hiqual_dv", "hsyr04",
                      "hscost", "health", "hhsize", "ukborn") 
saveRDS(vars_of_interest, "vars_of_interest.rds")

# Define categorical variables
cat_vars <- c("hsyr04", # year mortgage began
              "mgtype", # mortgage type
              "hiqual_dv", #Highest qualification
              "jbsoc00_cc", # Standard socio-economic classification (SOC 2000) of current job; condensed 3 digit version
              "jbnssec8_dv", # Current job (eight class ns-sec)
              "jbnssec5_dv", # Current job (five class ns-sec)
              "jbnssec3_dv", # Current job (three class ns-sec)
              "health", # Long-standing illness or disability
              "country", # Country in the UK
              "gor_dv", # Region in the UK
              "urban_dv", # Urban or rural area, derived
              "sex_dv", # sex, derived
              # "marstat", # Marital status
              "marstat_recat", # marital status recategorised
              # "jbstat", # Employment status
              "jbstat_recat", # jbstat recategorised
              "jbsemp", # Employed or self-employed
              # "racel_dv.x", # Ethnic group (self-reported) (indresp)
              # "ethn_dv.x", # Ethnic group - derived from multiple sources (indresp)
              "racel_recat", # recategorised ethnic group
              # Need to re-run code to get this var #   "j1soc00_cc", # Standard Socio-economic Classification (SOC 2000) of first job after leaving full-time education. Condensed three-digit version (xwavedat)
              "maid", # mother's ethnic group (xwavedat)
              "macob", # mother's country of birth (xwavedat)
              "maedqf", # mother's educational qualification when respondent was aged 14 (xwavedat)
              "masoc00_cc", # Standard Occupational Classification 2000 of mother's job when respondent was aged 14 (xwavedat)
              "paid", # father's ethnic group (xwavedat)
              "pacob", # father's country of birth (xwavedat)
              "paedqf", # father's educational qualification when respondent was aged 14 (xwavedat)
              "pasoc00_cc", # Standard Occupational Classification 2000 of father's job when respondent was aged 14 (xwavedat)
              "wavenumber")
saveRDS(cat_vars, "cat_vars.rds")

