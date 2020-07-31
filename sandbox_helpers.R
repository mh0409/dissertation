library("haven")
library("tidyverse")
library("naniar")



# Wave 1

# Get file names
w1_ind_file <- "/Users/mariajoseherrera/Documents/LSE_new/03_Dissertation/Understanding_Society/UKDA-6614-stata/stata/stata11_se/ukhls_w1/a_indresp.dta"

w1_hh_file <- "/Users/mariajoseherrera/Documents/LSE_new/03_Dissertation/Understanding_Society/UKDA-6614-stata/stata/stata11_se/ukhls_w1/a_hhresp.dta"

# Load and clean data

####### INDRESP ###########
w1_key_indresp <- get_key_indvars(w1_ind_file, 1)

###########################

####### HHRESP ############
w1_key_hhresp <- get_key_hhvars(w1_hh_file, 1)

###########################

### COMBINE IND AND HH ####
w1_clean <- clean_and_compile(w1_key_hhresp, w1_key_indresp, 1)

###########################

### DELETE IND & HH #######

rm(w1_key_indresp) # remove from memory to free up space
rm(w1_key_hhresp)


###########################


## SAVE COMBO IND/HH FILE ##

# Save file
saveRDS(w1_clean, "/Users/mariajoseherrera/Documents/LSE_new/03_Dissertation/Understanding_Society/w1_clean.rds")

rm(w1_clean)


###########################


####### GET XWAVE #########

# Get file names 
xwave_file <- "/Users/mariajoseherrera/Documents/LSE_new/03_Dissertation/Understanding_Society/UKDA-6614-stata/stata/stata11_se/ukhls_wx/xwavedat.dta"

# Load and clean data
key_xwave <- get_key_xwavevars(xwave_file)

df_xwave_clean <- replace_with_na_all(key_xwave, condition = ~.x %in% c(-21, -20, -11, -10, -9, -8, -7, -2, -1)) # replace "missing values" with NAs

# Save file
saveRDS(df_xwave_clean, "/Users/mariajoseherrera/Documents/LSE_new/03_Dissertation/Understanding_Society/xwave_clean.rds")

rm(df_xwave_clean)

#####

get_key_indvars <- function(file_path, wave_number){
  
  # Load data
  data <- read_dta(file_path)
  
  # Define key vars
  w_key_indresp <- c( "hidp",
                      "fimnlabnet_dv",
                      "hiqual_dv",
                      "jbsoc00_cc",
                      "jbnssec8_dv",
                      "jbnssec5_dv",
                      "jbnssec3_dv",
                      "fimnnet_dv",
                      "fimnlabnet_dv",
                      "sf12mcs_dv",
                      "sf12pcs_dv",
                      "health",
                      "scghq1_dv",
                      "scghq2_dv",
                      "country",
                      "gor_dv",
                      "urban_dv",
                      "age_dv",
                      "sex_dv",
                      "marstat",
                      "jbstat",
                      "nchild_dv",
                      "jbsemp",
                      "prfitba",
                      "racel_dv",
                      "ethn_dv",
                      "fimngrs_dv",
                      "hrpid") # head renter / mortgage holder
  # vars that have wave prefix
  
  non_w_indresp <- c("pidp")
  
  # Prepare individual variables to pull from full data set
  wave_alpha <- paste0(letters[wave_number], "_") # prepare variable name wave prefix
  w_key_indresp <- paste0(wave_alpha, w_key_indresp) # add wave prefix to variable
  key_indresp <- append(w_key_indresp, non_w_indresp) # compile all variables
  df_key_indresp <- select(data, one_of(key_indresp)) # select only key variables from df
  
  return(df_key_indresp)
}

get_key_hhvars <- function(file_path, wave_number){
  # Load data
  data <- read_dta(file_path)
  
  # Define key vars
  w_key_hhresp <- c("hidp", # household identifier
                    "fihhmnnet1_dv", # total monthly income, no deductions
                    "mgtype", # mortgage type
                    "hscost", # original purchase price of property
                    "hsval", # value of property: home owners
                    "hsyr04", # year mortgage began	
                    "mglife", # years left to pay: mortgage
                    "mgold", # initial mortgage,
                    "hhsize", # household size
                    "houscost1_dv", # monthly housing cost /in/cluding mortgage principal payments 
                    "houscost2_dv", # monthly housing cost /ex/cluding mortgage principal payments
                    "xpmg_dv") # monthly mortgage payment including imputations
  # "xphsdb") # omitting this var since for  NA all observations
  # vars that have wave prefix
  
  
  
  # Prepare household variables to pull from full data set
  wave_alpha <- paste0(letters[wave_number], "_")
  key_hhresp <- paste0(wave_alpha, w_key_hhresp)
  df_key_hhresp <- select(data, one_of(key_hhresp))
  return(df_key_hhresp)
}

get_key_xwavevars <- function(file_path){
  # Load data
  data <- read_dta(file_path)
  
  # Define key vars
  key_xwave <- c("pidp", # personal identifier
                 "racel_dv", # ethnic group (self-reported)
                 "scend_dv", # school leaving age 
                 "j1soc00_cc", # SOC 200 of first job after leavin full time educ; 3 digit version
                 "maid", # mother's ethnic group
                 "macob", # years left to pay: mortgage
                 "maedqf", # initial mortgage	
                 "masoc00_cc", # monthly housing cost /in/cluding mortgage principal payments 
                 "paid", # monthly housing cost /ex/cluding mortgage principal payments
                 "pacob", # father's country of birth
                 "paedqf", # father's educational qualification when respondent was aged 14
                 "pasoc00_cc", # SOC 2000 of father's job when responded was aged 14
                 "ethn_dv",
                 "ukborn") # ethnicity
  df_key_xwave <- select(data, one_of(key_xwave))
  
  return(df_key_xwave)
}


clean_and_compile <- function(df_hh, df_ind, df_xwave, wave_number){
  # Clean data by removing NAs
  df_hh_clean <- replace_with_na_all(data = df_hh, condition = ~.x %in% c(-21, -20, -11, -10, -9, -8, -7, -2, -1)) # replace "missing values" with NAs
  # df_hh_clean <- na.omit(df_hh_clean) # omit any rows that are incomplete observations
  
  # TODO: determine if i wanna omit incomplete observations
  
  df_ind_clean <- replace_with_na_all(df_ind, condition = ~.x %in% c(-21, -20, -11, -10, -9, -8, -7, -2, -1)) # replace "missing values" with NAs
  # df_ind_clean <- na.omit(df_ind_clean) # omit any rows that are incomplete observations
  
  df_xwave_clean <- replace_with_na_all(df_xwave, condition = ~.x %in% c(-21, -20, -11, -10, -9, -8, -7, -2, -1)) # replace "missing values" with NAs
  # df_ind_clean <- na.omit(df_ind_clean) # omit any rows that are incomplete observations
  
  
  # Combine indresp and hhresp data frames
  wave_hidp <- paste0(letters[wave_number], "_hidp")
  df_combined <- merge(x = df_ind_clean, y = df_hh_clean, by.x = wave_hidp, by.y = wave_hidp, all = TRUE )
  
  # Combine with xwave df
  wave_pidp <- paste0(letters[wave_number], "_pidp") 
  df_combined < merge(x = df_combined, y = df_xwave_clean, by.x = wave_pidp, by.y = wave_pidp, all = TRUE)
  df_combined$wavenumber <- wave_number
  
  return(df_combined)
}


