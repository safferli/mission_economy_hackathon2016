# require(devtools)
# library(httr)
# set_config(use_proxy(url="10.26.0.16", port=3128))
# install_github("ramnathv/slidify")
# install_github("ramnathv/slidifyLibraries")

library(slidify)

wd <- "c:/github/mission_economy_hackathon2016/presentation"
setwd(wd)

author("BYOOSC")
slidify("index.Rmd")

# The YAML parsing is done by the yaml package which will treat true as TRUE. 
# The easiest thing to make this work on the javascript side is to use 
# page.foo === "TRUE", or even better write a function that will return true 
# when the input is TRUE.
# https://github.com/ramnathv/slidify/issues/455#issuecomment-140250538

# http://stackoverflow.com/questions/22567127/slidify-how-to-customize-a-slide-background

# http://www.cbc.ca/news/world/panama-papers-offshore-tax-scope-1.3520001