
png(file="tech_debt.png",width=3000,height=3000,res=600,pointsize=8)
colsmap <- rainbow(3000,start=0,end=0.5)
numbers <- c(432,599,153,125,2511,6,58)
names(numbers) <- c("Complexity","Style","Compatibility","Performance","Maintainability","Accessibility","Security")
cols <- NULL
for (number in numbers){
    cols <- append(cols, colsmap[3000-number])
}
barplot(numbers,
        border=0,
        main="Tech Debt in Spark",
        ylab="Number of Issues",
        col=cols,
        cex.names=0.7)
dev.off()
