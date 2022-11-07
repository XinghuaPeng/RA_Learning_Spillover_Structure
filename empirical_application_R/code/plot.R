
#External codes for data and variables generation
#source("~/vss/empirical_replication_R/code/main.R")

#---------------------------------------------
## Plot of Cigarette Consumption for each states
#--------------------------------------------
alph = 0.2
backcol="black"
cig_all_states <- ggplot(cp,aes(x=years), legend = F) +
  geom_line(aes(y=AL),alpha=alph,col=backcol)+    
  geom_line(aes(y=AR),alpha=alph,col=backcol)+    
  geom_line(aes(y=CO),alpha=alph,col=backcol)+    
  geom_line(aes(y=CT),alpha=alph,col=backcol)+    
  geom_line(aes(y=DE),alpha=alph,col=backcol)+    
  geom_line(aes(y=GA),alpha=alph,col=backcol)+   
  geom_line(aes(y=IA),alpha=alph,col=backcol)+    
  geom_line(aes(y=ID),alpha=alph,col=backcol)+    
  geom_line(aes(y=IL),alpha=alph,col=backcol)+    
  geom_line(aes(y=IN),alpha=alph,col=backcol)+    
  geom_line(aes(y=KS),alpha=alph,col=backcol)+    
  geom_line(aes(y=KY),alpha=alph,col=backcol)+    
  geom_line(aes(y=LA),alpha=alph,col=backcol)+   
  geom_line(aes(y=ME),alpha=alph,col=backcol)+    
  geom_line(aes(y=MN),alpha=alph,col=backcol)+    
  geom_line(aes(y=MO),alpha=alph,col=backcol)+    
  geom_line(aes(y=MS),alpha=alph,col=backcol)+    
  geom_line(aes(y=MT),alpha=alph,col=backcol)+    
  geom_line(aes(y=NC),alpha=alph,col=backcol)+    
  geom_line(aes(y=ND),alpha=alph,col=backcol)+   
  geom_line(aes(y=NE),alpha=alph,col=backcol)+    
  geom_line(aes(y=NH),alpha=alph,col=backcol)+    
  geom_line(aes(y=NM),alpha=alph,col=backcol)+    
  geom_line(aes(y=NV),alpha=alph,col=backcol)+    
  geom_line(aes(y=OH),alpha=alph,col=backcol)+    
  geom_line(aes(y=OK),alpha=alph,col=backcol)+    
  geom_line(aes(y=PA),alpha=alph,col=backcol)+   
  geom_line(aes(y=RI),alpha=alph,col=backcol)+    
  geom_line(aes(y=SC),alpha=alph,col=backcol)+    
  geom_line(aes(y=SD),alpha=alph,col=backcol)+    
  geom_line(aes(y=TN),alpha=alph,col=backcol)+    
  geom_line(aes(y=TX),alpha=alph,col=backcol)+    
  geom_line(aes(y=UT),alpha=alph,col=backcol)+    
  geom_line(aes(y=VA),alpha=alph,col=backcol)+   
  geom_line(aes(y=VT),alpha=alph,col=backcol)+    
  geom_line(aes(y=WI),alpha=alph,col=backcol)+    
  geom_line(aes(y=WV),alpha=alph,col=backcol)+    
  geom_line(aes(y=WY),alpha=alph,col=backcol)+    
  geom_line(aes(y=CA, linetype = "California" ),alpha=1,col="black",lwd=1)+
  geom_vline(aes(xintercept=1988.5),lwd=1,col="black", linetype = "dotted")+
  annotate("text", x=1980, y = 20, label = "Passage of Proposition 99") + 
  annotate('segment', x=1986, xend=1987, y=20, yend=20, arrow=arrow(length=unit(0.30,"cm"))) + 
  ylab("Per Capita Cigarette Consumption")+
  xlab("Year")+ 
  scale_x_continuous(breaks = seq(1970, 2000, 5), limits=c(1970, 2000),expand=c(0,0)) + 
  scale_y_continuous(breaks = seq(0, 300, 30), limits= c(0, 300),expand=c(0,0)) + 
  theme_bw() +
  theme(panel.grid = element_blank())+ # delete gridlines  
  theme(legend.position = c(0.9,0.9) ) + 
  theme(legend.title = element_blank()  ) + 
  theme(legend.background=element_rect(colour=1) )

ggsave(filename = "output/cig_all_states.png")

print(cig_all_states)


#---------------------------------------------------
## PLOT of CA, synthetic CA, and the rest of states
#---------------------------------------------------

trend_CA_SCM <- ggplot(data=cp.sum,aes(x=years), legend = F) + 
  geom_line(aes(y=CA, linetype = "California" ), col = 1 ,lwd=0.7) + 
  geom_line(aes(y=scm_CA, linetype = "synthetic California" ) , col = 1, lwd=0.7 ) + 
  #geom_line(aes(y=DD),col=1)+
  geom_vline(aes(xintercept=1988.5), linetype = "dotted") + 
  annotate("text", x=1980, y = 40, label = "Passage of Proposition 99") + 
  annotate('segment', x=1986, xend=1987, y=40, yend=40, arrow=arrow(length=unit(0.30,"cm"))) + 
  xlab("year") + 
  scale_x_continuous(breaks = seq(1970, 2000, 5), limits=c(1970, 2000),expand=c(0,0)) + 
  ylab("per-capita cigarette sales (in person)") + 
  scale_y_continuous(breaks = seq(0, 140, 20), limits= c(0, 140),expand=c(0,0)) + 
  #ggtitle("Figure 2. Trends in per-capita cigarette sales: California vs. synthetic California.")
  theme_bw() + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
  theme(panel.grid = element_blank()) + # delete gridlines  
  theme(legend.position = c(0.83,0.87) ) + 
  theme(legend.title = element_blank()  ) + 
  theme(legend.background=element_rect(colour=1) )


ggsave(filename = "output/trend_CA_SCM.png")

print(trend_CA_SCM)

#--------------------
## PLOT of GAP between CA & synthetic CA
#--------------------

CA_gap <- ggplot(data=cp.sum,aes(x=years), legend = F) + 
  geom_line(aes(y=gap_CA), col = 1 ,lwd=0.7) + 
  geom_vline(aes(xintercept=1988.5), linetype = "dotted") + 
  geom_hline(aes(yintercept=0), linetype = "dashed") + 
  annotate("text", x=1980, y = -15, label = "Passage of Proposition 99") + 
  annotate('segment', x=1986, xend=1987, y=-15, yend=-15, arrow=arrow(length=unit(0.30,"cm"))) + 
  xlab("year") + 
  scale_x_continuous(breaks = seq(1970, 2000, 5), limits=c(1970, 2000),expand=c(0,0)) + 
  ylab("gap in per-capita cigarette sales (in person)") + 
  scale_y_continuous(breaks = seq(-30, 30, 10), limits= c(-30, 30),expand=c(0,0)) + 
  #ggtitle("Figure 2. Trends in per-capita cigarette sales: California vs. synthetic California.")
  theme_bw() + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
  theme(panel.grid = element_blank()) + # delete gridlines  
  theme(legend.position = c(0.83,0.87) ) + 
  theme(legend.title = element_blank()  ) + 
  theme(legend.background=element_rect(colour=1) )
#geom_errorbar(aes(ymin = lowIC, ymax = topIC))  


ggsave("output/CA_gap.png")

print(CA_gap)

#--------------------
## PLOT of Placebo Test
#--------------------

placebo_gaps <- ggplot(cp.sum,aes(x=years)) +
  geom_line(aes(y=gap_1),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_2),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_4),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_5),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_6),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_7),alpha=alph,col=backcol)+   
  geom_line(aes(y=gap_8),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_9),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_10),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_11),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_12),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_13),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_14),alpha=alph,col=backcol)+   
  geom_line(aes(y=gap_15),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_16),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_17),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_18),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_19),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_20),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_21),alpha=alph,col=backcol)+   
  geom_line(aes(y=gap_22),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_23),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_24),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_25),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_26),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_27),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_28),alpha=alph,col=backcol)+   
  geom_line(aes(y=gap_29),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_30),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_31),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_32),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_33),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_34),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_35),alpha=alph,col=backcol)+   
  geom_line(aes(y=gap_36),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_37),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_38),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_39),alpha=alph,col=backcol)+    
  geom_line(aes(y=gap_3, linetype = "Gap between CA and synthetic CA"),alpha=1,col="black",lwd=1)+ # CA GAP  
  geom_vline(aes(xintercept=1988.5),lwd=1, linetype = "dashed")+
  annotate("text", x=1980, y = -20, label = "Passage of Proposition 99") + 
  annotate('segment', x=1986, xend=1987, y=-20, yend=-20, arrow=arrow(length=unit(0.30,"cm"))) + 
  ylab("gap in Per Capita Cigarette Consumption")+
  xlab("Year")+ 
  scale_x_continuous(breaks = seq(1970, 2000, 5), limits=c(1970, 2000),expand=c(0,0)) + 
  scale_y_continuous(breaks = seq(-30, 30, 5), limits= c(-30, 30),expand=c(0,0)) + 
  theme_bw() + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
  theme(panel.grid = element_blank()) + # delete gridlines  
  theme(legend.position = c(0.25,0.9) ) + 
  theme(legend.title = element_blank() ) + 
  theme(legend.background=element_rect(colour=1) )


ggsave(filename ="output/placebo_gaps.png")

print(placebo_gaps)

#--------------------
## PLOT of Confidence Interval by Placebo Test
#--------------------

CA_gap_CI <- ggplot(data=cp.sum,aes(x=years), legend = F) + 
  geom_line(aes(y=gap_CA), col = 1 ,lwd=0.7) + 
  geom_vline(aes(xintercept=1988.5), linetype = "dotted") + 
  geom_hline(aes(yintercept=0), linetype = "dashed") + 
  annotate("text", x=1980, y = -15, label = "Passage of Proposition 99") + 
  annotate('segment', x=1986, xend=1987, y=-15, yend=-15, arrow=arrow(length=unit(0.30,"cm"))) + 
  xlab("year") + 
  #scale_x_continuous(breaks = seq(1970, 2000, 5), limits=c(1970, 2000),expand=c(0,0)) + 
  ylab("gap in per-capita cigarette sales (in person)") + 
  #scale_y_continuous(breaks = seq(-30, 30, 10), limits= c(-30, 30),expand=c(0,0)) + 
  #ggtitle("Figure 2. Trends in per-capita cigarette sales: California vs. synthetic California.")
  theme_bw() + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
  theme(panel.grid = element_blank()) + # delete gridlines  
  theme(legend.position = c(0.83,0.87) ) + 
  theme(legend.title = element_blank()  ) + 
  theme(legend.background=element_rect(colour=1) ) + 
  geom_errorbar(aes(ymin = lower, ymax = upper))  


ggsave("output/CA_gap_CI.png")
print(CA_gap_CI)














