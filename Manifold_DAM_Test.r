#!/usr/bin/env Rscript
#From within R you must install the ggplot package before this script will work.
#Do it like this: install.packages("ggplot2")

library(ggplot2)
library(gridExtra)
library(grid)
library(gtable)
library(cowplot)
######################################
args = commandArgs(trailingOnly=TRUE)

filename=paste0(args[1])

# test if there is at least one argument: if not, return an error
	if (length(args)==0) {
		cat("-----------------------------------------------\n\n")
		cat("You must include at least one argument.\n")
		cat("The first argument is the filename.\n")
		cat("If you give me JUST this then I will use default group names and tube numbers\n\n")
		cat("If you append any 2nd argument, then I will ask you for group names,\n")
		cat("but I will provide default tube numbers.\n\n")
		cat("If you give me any third argument,\n")
		cat("then I will ask you for groups names AND the tube numbers for each group.\n\n")
		cat("-----------------------------------------------\n\n")
  		stop("At least one argument must be supplied (input file).\n\n", call.=FALSE)
	} else if(length(args)==1) {
		cat("Default names and tube numbers are going to be used\n")
		gp1name="One"
		gp2name="Two"
		gp3name="Three"
		gp4name="Four"
		
		group1<-c(13,17,22,26,31,35,40,44)
		group2<-c(14,18,23,27,32,36,37,41)
		group3<-c(15,19,24,28,29,33,38,42)
		group4<-c(16,20,21,25,30,34,39,43)

	} else if (length(args)==2) {
		cat("Input group names. I will use the default tube numbers\n")
		cat("What is the name of group 1? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp1name<-(paste(inp))

		cat("What is the name of group 2? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp2name<-(paste(inp))

		cat("What is the name of group 3? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp3name<-(paste(inp))
		
		cat("What is the name of group 4? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp4name<-(paste(inp))
		
		group1<-c(13,17,22,26,31,35,40,44)
		group2<-c(14,18,23,27,32,36,37,41)
		group3<-c(15,19,24,28,29,33,38,42)
		group4<-c(16,20,21,25,30,34,39,43)

		#Begin entering the columns that we should use.
	} else if (length(args)==3) {
		cat("Input both group names and tube numbers\n")
		cat("What is the name of group 1? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp1name<-(paste(inp))

		cat("What is the name of group 2? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp2name<-(paste(inp))

		cat("What is the name of group 3? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp3name<-(paste(inp))
		
		cat("What is the name of group 4? > ")
		inp <- readLines(file("stdin"), n = 1L)
		gp4name<-(paste(inp))
		
		group1<-c()
		group2<-c()
		group3<-c()
		group4<-c()
		flag="x"
		n<-c()
		numbers<-c()
		numbers1=""

		readinteger <- function()
		{ 
			while(!flag=="q")
			{
				numbers=c(numbers,(as.integer(n)))
			  	n <- readLines(file("stdin"), n = 1L)
				flag=n
			}
			 return(numbers)
		}

  		cat("Enter group1's tube numbers. Type q to stop.\n")
		group1<-readinteger()
		cat("\n")

  		cat("Enter group2's tube numbers. Type q to stop.\n")
		group2<-readinteger()
		cat("\n")

  		cat("Enter group3's tube numbers. Type q to stop.\n")
		group3<-readinteger()
		cat("\n")

  		cat("Enter group4's tube numbers. Type q to stop.\n")
		group4<-readinteger()
		cat("\n")

		}
	
######################################

#setwd("~/Documents/R/Trikinetics_data/")
Trik<-read.table(filename)

#Box and Wisker Plot of the average last movements for each tube in the Trikinetics device.
##Need this to make max1 available.
max1<-0
#The for loop reads each entry in group1 one at a time.
#max1 is an array that we can store data in.
#which can identify columnsin a dataframe that meet the conditions(==0).
#! negates it.
#[,group1[i]] says look at every row (,) in column group1[i]. The columns to be examined are 13,17,22,26,31,35,40,and 44.
for(i in 1:length(group1)){max1[i]<-(0.5*(max(which(!Trik[,group1[i]]==0))))}
#The row in which the hit occurs matches the sample number. Each sample = 30s. To convert to minutes multiple the row where the max occurs by 0.5.

#max1 may contain a -Inf. This occurs with columns that have no max (all zeros).
#Since the fly did not move we will discard these.
#Prepare a variable to put in non -Inf entries. Prepare a counter.
max1_noinf<-0
counter<-1

#Go through each value in max1. If not -Inf then add it to max1_noinf The ! with == means "when this is not true". Separate counter for max1_noinf insures that when a -Inf is omitted, that max1_noinf does not grow in size. the counter<-counter+1 is just how I am incrementing the counter.
for(i in 1:length(max1)){if(!max1[i]==-Inf){max1_noinf[counter]<-max1[i]; counter<-counter+1}}

#Repeat for the remaining three.
max2<-0
for(i in 1:length(group2)){max2[i]<-0.5*(max(which(!Trik[,group2[i]]==0)))}
max2_noinf<-0
counter<-1
for(i in 1:length(max2)){if(!max2[i]==-Inf){max2_noinf[counter]<-max2[i]; counter<-counter+1}}

max3<-0
for(i in 1:length(group3)){max3[i]<-0.5*(max(which(!Trik[,group3[i]]==0)))}
max3_noinf<-0
counter<-1
for(i in 1:length(max3)){if(!max3[i]==-Inf){max3_noinf[counter]<-max3[i]; counter<-counter+1}}

max4<-0
for(i in 1:length(group4)){max4[i]<-0.5*(max(which(!Trik[,group4[i]]==0)))}
max4_noinf<-0
counter<-1
for(i in 1:length(max4)){if(!max4[i]==-Inf){max4_noinf[counter]<-max4[i]; counter<-counter+1}}

#Put all of the data in a dataframe.
dfA<-data.frame(gp1name, max1_noinf)
dfB<-data.frame(gp2name, max2_noinf)
dfC<-data.frame(gp3name, max3_noinf)
dfD<-data.frame(gp4name, max4_noinf)
#Make the names of each one the same.
colnames(dfA)<-c("Group", "Sedation")
colnames(dfB)<-c("Group", "Sedation")
colnames(dfC)<-c("Group", "Sedation")
colnames(dfD)<-c("Group", "Sedation")
#Merge all into one dataframe
A<-merge(dfA, dfB, all="True")
B<-merge(dfC, dfD, all="True")
C<-merge(A, B, all="True")

#Generate the boxplot
#Q<-ggplot(C,aes(Group,Sedation)) + geom_boxplot()
#This one adds a diamond for the mean.
#Q<-ggplot(C,aes(Group,Sedation)) + geom_boxplot() + stat_summary(fun.y="mean", geom="point", shape=23, size=3, fill="white")

#This one overplots the data as dots.
boxPlot<-ggplot(C,aes(Group,Sedation)) + geom_boxplot() + geom_dotplot(binaxis="y", binwidth=.5, stackdir="center", fill=NA) + geom_point(size=5)
#All plots are going to be printed at the bottom together.

#save the max times and ttest to a file
sink('TimesANDttest.txt')
	#This is probably a good way to present the data.
	#But to do this we have to move this section down because it has not yet been declared.
	#dfgroupALL

	#cat(sprintf("args[2] %s\n", args[2]))
	cat(sprintf("\nfilename is %s\n", filename))

	cat(sprintf("\n%s's tube numbers are ", gp1name))
	cat(sprintf("%s, ", group1))
	cat(sprintf("\n"))

	cat(sprintf("%s's tube numbers are ", gp2name))
	cat(sprintf("%s, ", group2))
	cat(sprintf("\n"))

	cat(sprintf("%s's tube numbers are ", gp3name))
	cat(sprintf("%s, ", group3))
	cat(sprintf("\n"))

	cat(sprintf("%s's tube numbers are ", gp4name))
	cat(sprintf("%s, ", group4))
	cat(sprintf("\n"))

	#------------------------------------------------
	cat(sprintf("\nmax for group %s are ", gp1name))
	cat(sprintf("%s, ", max1))
	cat(sprintf("\n"))

	cat(sprintf("max for group %s are ", gp2name))
	cat(sprintf("%s, ", max2))
	cat(sprintf("\n"))

	cat(sprintf("max for group %s are ", gp3name))
	cat(sprintf("%s, ", max3))
	cat(sprintf("\n"))

	cat(sprintf("max for group %s are ", gp4name))
	cat(sprintf("%s, ", max4))
	cat(sprintf("\n\n"))

#------------------------------------------------------------------------------------------
#generate a file with the t-test information.
#Do this if you really want to do a student t-test and this for Welch correct which corrects for differences in the variance of each sample.
 # student's t-test        t.test(max1_noinf, max2_noinf, var.equal=TRUE)
 # Welch's t-test          t.test(max1_noinf, max2_noinf)
#sink('ttest_analysis.txt')
#sink(paste(filename),"ttest.txt") <-- This does not work.
cat("This is student's t-test. We could do Welch's correction with a simple change.\n")
cat("================================================================\n")
cat("t-test comparison of ", gp1name, " and ", gp2name, "\n")
cat(sprintf("%s has %d elements. ", gp1name, length(max1_noinf)))
cat(sprintf("%s has %d elements.\n", gp2name, length(max2_noinf)))
ttest_no12<-t.test(max1_noinf, max2_noinf, var.equal=TRUE)
ttest_no12

cat("================================================================\n")
cat("t-test comparison of ", gp1name, " and ", gp3name, "\n")
cat(sprintf("%s has %d elements.", gp1name, length(max1_noinf)))
cat(sprintf("%s has %d elements.\n", gp3name, length(max3_noinf)))
ttest_no13<-t.test(max1_noinf, max3_noinf, var.equal=TRUE)
ttest_no13

cat("================================================================\n")
cat("t-test comparison of ", gp1name, " and ", gp4name, "\n")
cat(sprintf("%s has %d elements.", gp1name, length(max1_noinf)))
cat(sprintf("%s has %d elements.\n", gp4name, length(max4_noinf)))
ttest_no14<-t.test(max1_noinf, max4_noinf, var.equal=TRUE)
ttest_no14

cat("================================================================\n")
cat("t-test comparison of ", gp2name, " and ", gp3name, "\n")
cat(sprintf("%s has %d elements.", gp2name, length(max2_noinf)))
cat(sprintf("%s has %d elements.\n", gp3name, length(max3_noinf)))
ttest_no23<-t.test(max2_noinf, max3_noinf, var.equal=TRUE)
ttest_no23

cat("================================================================\n")
cat("t-test comparison of ", gp2name, " and ", gp4name, "\n")
cat(sprintf("%s has %d elements.", gp2name, length(max2_noinf)))
cat(sprintf("%s has %d elements.\n", gp4name, length(max4_noinf)))
ttest_no24<-t.test(max2_noinf, max4_noinf, var.equal=TRUE)
ttest_no24

cat("================================================================\n")
cat("t-test comparison of ", gp3name, " and ", gp4name, "\n")
cat(sprintf("%s has %d elements.", gp3name, length(max3_noinf)))
cat(sprintf("%s has %d elements.\n", gp4name, length(max4_noinf)))
ttest_no34<-t.test(max3_noinf, max4_noinf, var.equal=TRUE)
ttest_no34
cat("================================================================\n")

sink()

#Save a graphical table that contains the means, N, and P values.
dfgroup12<-data.frame(paste(gp1name, " vs ",gp2name), mean(max1_noinf), length(max1_noinf), mean(max2_noinf), length(max2_noinf), round(ttest_no12$p.value, 6))
colnames(dfgroup12)<-c("Groups", "Mean1", "N1", "Mean2", "N2", "pvalue")

dfgroup13<-data.frame(paste(gp1name, " vs ",gp3name), mean(max1_noinf), length(max1_noinf), mean(max3_noinf), length(max3_noinf), round(ttest_no13$p.value, 6))
colnames(dfgroup13)<-c("Groups", "Mean1", "N1", "Mean2", "N2", "pvalue")

dfgroup14<-data.frame(paste(gp1name, " vs ",gp4name), mean(max1_noinf), length(max1_noinf), mean(max4_noinf), length(max4_noinf), round(ttest_no14$p.value, 6))
colnames(dfgroup14)<-c("Groups", "Mean1", "N1", "Mean2", "N2", "pvalue")

dfgroup23<-data.frame(paste(gp2name, " vs ",gp3name), mean(max2_noinf), length(max2_noinf), mean(max3_noinf), length(max3_noinf), round(ttest_no23$p.value, 6))
colnames(dfgroup23)<-c("Groups", "Mean1", "N1", "Mean2", "N2", "pvalue")

dfgroup24<-data.frame(paste(gp2name, " vs ",gp4name), mean(max2_noinf), length(max2_noinf), mean(max4_noinf),  length(max4_noinf), round(ttest_no24$p.value, 6))
colnames(dfgroup24)<-c("Groups", "Mean1", "N1", "Mean2", "N2", "pvalue")

dfgroup34<-data.frame(paste(gp3name, " vs ",gp4name), mean(max3_noinf),length(max3_noinf), mean(max4_noinf), length(max4_noinf), round(ttest_no34$p.value, 6))
colnames(dfgroup34)<-c("Groups", "Mean1", "N1", "Mean2", "N2", "pvalue")

#Need to find a less verbose way to merge a bunch of dataframes.
dfgroupALL1<-merge(dfgroup12, dfgroup13, all="True")
dfgroupALL2<-merge(dfgroup14, dfgroup23, all="True")
dfgroupALL3<-merge(dfgroup24, dfgroup34, all="True")

dfgroupALL4<-merge(dfgroupALL1, dfgroupALL2, all="True")
dfgroupALL<-merge(dfgroupALL4, dfgroupALL3, all="True")

#I had to use pdf() and dev.of() to get the table to disk.
#Three methods to generate the graphical table.

#Method 1
#This is one way to generate the table. Another appears below
#pdf("savedTable.pdf")
# grid.table(dfgroup12)
#dev.off()

#Method2
mytable<-tableGrob(dfgroupALL)
#This will be saved to disk at the end.

#Method3 allows to put a plot with a table. The plot is a bit squashed in the default state.
#pdf("savedTable3.pdf")
# grid.arrange(boxPlot, mytable, nrow=2)
#dev.off()

#********************************************************************
#Generate the histogram.

#Calculate the MEANS
meanmax1<-mean(max1_noinf)
meanmax2<-mean(max2_noinf)
meanmax3<-mean(max3_noinf)
meanmax4<-mean(max4_noinf)
#Put all of the data in a dataframe.
dfmeanof1<-data.frame(gp1name, meanmax1)
dfmeanof2<-data.frame(gp2name, meanmax2)
dfmeanof3<-data.frame(gp3name, meanmax3)
dfmeanof4<-data.frame(gp4name, meanmax4)
#Make all of the column names the same.
colnames(dfmeanof1)<-c("Group", "Sedation")
colnames(dfmeanof2)<-c("Group", "Sedation")
colnames(dfmeanof3)<-c("Group", "Sedation")
colnames(dfmeanof4)<-c("Group", "Sedation")
#Merge all into one dataframe.
A<-merge(dfmeanof1, dfmeanof2, all="True")
B<-merge(dfmeanof3, dfmeanof4, all="True")
C<-merge(A, B, all="True")

#Calculate the SEM using N-1.
semA<-sd(max1_noinf)/sqrt(length(max1_noinf-1))
semB<-sd(max2_noinf)/sqrt(length(max2_noinf-1))
semC<-sd(max3_noinf)/sqrt(length(max3_noinf-1))
semD<-sd(max4_noinf)/sqrt(length(max4_noinf-1))
#Put all of the data in a dataframe.
dfsemof1<-data.frame(gp1name, semA)
dfsemof2<-data.frame(gp2name, semB)
dfsemof3<-data.frame(gp3name, semC)
dfsemof4<-data.frame(gp4name, semD)
#Fix the column names
colnames(dfsemof1)<-c("Group", "SEM")
colnames(dfsemof2)<-c("Group", "SEM")
colnames(dfsemof3)<-c("Group", "SEM")
colnames(dfsemof4)<-c("Group", "SEM")
#Merge them together
A<-merge(dfsemof1, dfsemof2, all="True")
B<-merge(dfsemof3, dfsemof4, all="True")
D<-merge(A,B,all="True")
#Merge these with the dataframe that contains the means.
E<-merge(C,D,all="True")

#These work but just give black bars.
#ggplot(E,aes(Group, Sedation)) + stat_summary(fun.y=mean, geom="bar")
#Next one has black bars with black error bars -- the stat_summary is an alternative to geom_bar in some sense.
#ggplot(E,aes(Group, Sedation)) + stat_summary(fun.y=mean, geom="bar")+geom_errorbar(aes(ymin=Sedation-SEM, ymax=Sedation+SEM), width=.3, color="darkblue")

#With this one we can control the bar color.
histoGramPlot<-ggplot(E,aes(Group, Sedation)) + geom_bar(stat="identity", fill="lightblue") +geom_errorbar(aes(ymin=Sedation-SEM, ymax=Sedation+SEM), width=.3, color="darkblue")

#All plots are going to be printed at the bottom together.

#------------------------------------------------------------------------------------------
#Plot the response over time as an XY plot over time.
means1=rowMeans(Trik[,group1])
df1<-data.frame(Trik[,1], means1)
#Add a new column and fill it with the group 1's name.
df1["Label"]<-gp1name
colnames(df1)<-c("Time", "Mean", "Label")

means2=rowMeans(Trik[,group2])
df2<-data.frame(Trik[,1], means2)
df2["Label"]<-gp2name
colnames(df2)<-c("Time", "Mean", "Label")

means3=rowMeans(Trik[,group3])
df3<-data.frame(Trik[,1], means3)
df3["Label"]<-gp3name
colnames(df3)<-c("Time", "Mean", "Label")

means4=rowMeans(Trik[,group4])
df4<-data.frame(Trik[,1], means4)
df4["Label"]<-gp4name
colnames(df4)<-c("Time", "Mean", "Label")

x<-merge(df1, df2, all="True")
y<-merge(df3, df4, all="True")
z<-merge(x, y, all="True")

z$Time<-z$Time*0.5

#Nice page on color manipulaton here.
#http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
#timeCourse<-ggplot(z,aes(Time,Mean,color=Label))+geom_point()+stat_smooth(method=loess)+ scale_color_brewer(palette="Dark2")
timeCourse<-ggplot(z,aes(Time,Mean,color=Label))+geom_point()+geom_smooth(method=loess)+ scale_color_brewer(palette="Dark2")

#------------------------------------------------------------------------------
#Here is where we are plotting everyting and saving them to files.
#------------------------------------------------------------------------------
# Now generate all of the saved plots
# Here are the things that we will plot.
# boxPlot = boxplot  Q
# histoGramPlot = histogram
# timeCourse = Timecourse  p
# mytable = Data in table form

#------------------------------------------------------------------------------
#First save the pdf files.
	ggsave(paste(filename,"Hist.pdf"), plot=histoGramPlot)
	ggsave(paste(filename,"BoxPlot.pdf"), plot=boxPlot)
	ggsave(paste(filename,"savedTimeCourseplot.pdf"), plot=timeCourse)

	pdf(paste(filename,"savedTable2.pdf"))
		grid.arrange(mytable, nrow=1)
	dev.off()

	#Here is an alternative way to save pdfs.
	#I am not 100% sure of what advantages or disadvantages that this has over the other way.
	#This will put graphs together with the table.
	pdf(paste(filename,"onePage.pdf"))
		#Both of the next two work well.
		grid.arrange(boxPlot,histoGramPlot,mytable,ncol=2,nrow=2)
		#grid.arrange(boxPlot,histoGramPlot,timeCourse,mytable,ncol=2,nrow=2)
		#grid.arrange(boxPlot,histoGramPlot,timeCourse,mytable, nrow=2, layout_matrix = cbind(c(1,2),c(3)))
		#grid.arrange(boxPlot,histoGramPlot,timeCourse,ytable,ncol=2,nrow=2)
		#grid.arrange(boxPlot, mytable, nrow=2)
	dev.off()

	pdf(paste(filename,"onePage2.pdf"))
		grid.newpage()
		pushViewport(viewport(layout = grid.layout(2, 2)))
		vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
		print(boxPlot, vp = vplayout(1, 1))
		print(histoGramPlot, vp = vplayout(1, 2))
		print(timeCourse, vp = vplayout(2, 1:2))  # key is to define vplayout
	dev.off()

	#pdf("What.pdf")
	 #plot_grid(boxPlot, histoGramPlot, timeCourse, ncol=2, nrow=2)
	 #plot_grid(boxPlot, histoGramPlot, timeCourse, ncol=1, align='v')
	 #plot_grid(boxPlot, histoGramPlot, timeCourse)
	#dev.off()

	#Another way
	 #bboxPlot<-ggplotGrob(boxPlot)
	 #hhistoGramPlot=ggplotGrob(histoGramPlot)
	 #mmytable<-ggplotGrob(mytable)
	 #g<-gtable_matrix(name="demo", grobs= matrix(list(bboxPlot, hhistoGramPlot), nrow=2),  widths = unit(7, "in"), heights = unit(c(2, 5), "in"))
	 #pdf("What.pdf")
	 #grid.newpage()
	 #grid.draw(g)
	#dev.off()

#------------------------------------------------------------------------------
##Now save SVG files
	##Don't need cowplot to do this
	svg(paste(filename,"savedTable2.svg"))
		grid.arrange(mytable, nrow=1)
	dev.off()
	svg(paste(filename,"savedTable2.svg"))
		grid.arrange(mytable, nrow=1)
	dev.off()
	svg(paste(filename,"onePage.svg"))
		grid.arrange(boxPlot,histoGramPlot,mytable,ncol=2,nrow=2)
	dev.off()
	svg(paste(filename,"onePage2.svg"))
		grid.newpage()
		pushViewport(viewport(layout = grid.layout(2, 2)))
		vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
		print(boxPlot, vp = vplayout(1, 1))
		print(histoGramPlot, vp = vplayout(1, 2))
		print(timeCourse, vp = vplayout(2, 1:2))  # key is to define vplayout
	dev.off()

	##Need cowplot to do this
	ggsave(paste(filename,"Hist.svg"), plot=histoGramPlot)
	ggsave(paste(filename,"BoxPlot.svg"), plot=boxPlot)
	ggsave(paste(filename,"savedTimeCourseplot.svg"), plot=timeCourse)
##End save SVG files

#------------------------------------------------------------------------------
##Now I would like to safe the data as a csv file. I believe that this dataframe contains all of it.
write.csv(dfgroupALL, file = paste(filename,".csv"))
dfgroupALL

#This site shows how to put the table in the plot.
#http://stackoverflow.com/questions/12318120/adding-table-within-the-plotting-region-of-a-ggplot-in-r
#Shows how to do 2 on top and 1 on bottom.
#https://github.com/baptiste/gridextra/wiki/arranging-ggplot
#This is it. It looks like viewport is what we need.
#http://www.sthda.com/english/wiki/ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page-r-software-and-data-visualization
