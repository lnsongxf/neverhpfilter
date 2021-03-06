
# Hamilton Table 2
Hamilton_table_2 <- read.table(paste0(getwd(),"/data-raw/Hamilton-table-2.txt"),
                               skip=1, row.names=1, stringsAsFactors=FALSE,
                               col.names = c("cycle.sd", "gdp.cor",
                                             "random.sd", "gdp.rand.cor",
                                             "Sample"))

# transform date sample column into xts compatible syntax.
Hamilton_table_2$Sample <- gsub("-","/", Hamilton_table_2$Sample)
Hamilton_table_2$Sample <- gsub(":", "-", Hamilton_table_2$Sample)


library(xts)
# Real GDP
Real_Gross_Domestic_Product <- "https://research.stlouisfed.org/fred2/data/GDPC1.txt"
GDPC1 <- as.xts(read.zoo(Real_Gross_Domestic_Product, skip = 17, index.column = 1,
                        header = TRUE, format = "%Y-%m-%d", FUN = as.yearqtr))
colnames(GDPC1) <- "GDPC1"


# Employment Rate
Total_nonfarm_Payrolls   <- "https://fred.stlouisfed.org/data/PAYEMS.txt"
PAYEMS <- as.xts(read.zoo(Total_nonfarm_Payrolls , sep = "", skip = 42, index.column = 1,
                                            header = TRUE, format = "%Y-%m-%d", FUN = as.yearmon))
colnames(PAYEMS) <- "PAYEMS"


# US Recessions
Recession_Indicators <- "https://fred.stlouisfed.org/data/USREC.txt"
USREC <- as.xts(read.zoo(Recession_Indicators , sep = "", skip = 69, index.column = 1,
                                   header = TRUE, format = "%Y-%m-%d", FUN = as.yearmon))
colnames(USREC) <- "USREC"


# Real Gross Private Domestic Investment
GPDIC1 <- as.xts(read.zoo("https://fred.stlouisfed.org/data/GPDIC1.txt", skip = 13, index.column = 1,
                          header = TRUE, format = "%Y-%m-%d", FUN = as.yearqtr))

colnames(GPDIC1) <- "GPDIC1"

# Real Personal Consumption Expenditures
PCECC96 <- as.xts(read.zoo("https://fred.stlouisfed.org/data/PCECC96.txt", skip = 13, index.column = 1,
                        header = TRUE, format = "%Y-%m-%d", FUN = as.yearqtr))


# Real Exports of Goods and Services
EXPGSC1 <- as.xts(read.zoo("https://fred.stlouisfed.org/data/EXPGSC1.txt", skip = 13, index.column = 1,
                             header = TRUE, format = "%Y-%m-%d", FUN = as.yearqtr))

# Real imports of goods and services
IMPGSC1 <- as.xts(read.zoo("https://fred.stlouisfed.org/data/IMPGSC1.txt", skip = 13, index.column = 1,
                             header = TRUE, format = "%Y-%m-%d", FUN = as.yearqtr))

# Real Government Consumption Expenditures and Gross Investment
GCEC1 <- as.xts(read.zoo("https://fred.stlouisfed.org/data/GCEC1.txt", skip = 13, index.column = 1,
                            header = TRUE, format = "%Y-%m-%d", FUN = as.yearqtr))


# Civilian Unemployment Rate
UNRATENSA <- as.xts(read.zoo("https://fred.stlouisfed.org/data/UNRATENSA.txt",
                             skip = 24, index.column = 1, header = TRUE,
                             format = "%Y-%m-%d", FUN = as.yearmon))

# Gross Domestic Product: Implicit Price Deflator
GDPDEF <- as.xts(read.zoo("https://fred.stlouisfed.org/data/GDPDEF.txt", skip = 15,
                          index.column = 1, header = TRUE, format = "%Y-%m-%d",
                          FUN = as.yearqtr))

# 10-Year Treasury Constant Maturity Rate
GS10 <- as.xts(read.zoo("https://fred.stlouisfed.org/data/GS10.txt", skip = 14,
                          index.column = 1, header = TRUE, format = "%Y-%m-%d",
                          FUN = as.yearmon))

# Effective Federal Funds Rate
FEDFUNDS <- as.xts(read.zoo("https://fred.stlouisfed.org/data/FEDFUNDS.txt", skip = 60,
                        index.column = 1, header = TRUE, format = "%Y-%m-%d",
                        FUN = as.yearmon))

# S&P 500
library(readxl)
ie_data <- paste0(getwd(),"/data-raw/ie_data.xls")
SP <- read_excel(ie_data, sheet = 3, skip = 7)[,-6]
names(SP) <- c("Date", "SP500", "Dividend", "Earnings", "CPI", "GS10",
"Real_SP500", "Real_Dividend", "Real_Earnings", "CAPE")

SP$CAPE <- as.numeric(SP$CAPE)

# clean up non-standard excel Date formate. Example 2018.1, for January 2018.
SP$Date <- as.character(SP$Date)
SP$Date <- gsub("\\.", "-", SP$Date)
SP$Date <- gsub("-1$", "-10", SP$Date)

# conver to xts
SP500 <- as.xts(SP[-NROW(SP),-1], order.by = as.yearmon(SP$Date[-NROW(SP)], "%Y-%m"))
SP500 <- SP500["/2017"]

rm(SP, ie_data)
  ###################################################
 # compression data sets to xz level 9 .Rdata files #
####################################################

dir.create("data")

dataset_list <- ls()

for (i in dataset_list) {

  save(list = i, file = paste0("data/", i, ".RData"), compress = "xz", compression_level = 9)

}
