
png(file="tech_debt.png",width=3000,height=3000,res=600,pointsize=6)
colsmap <- heat.colors(2600)
numbers <- c(432,599,153,125,2511,6,58)
names(numbers) <- c("Complexity","Style","Compatibility","Performance","Maintainability","Accessibility","Security")
cols <- NULL
for (number in numbers){
    cols <- append(cols, colsmap[2600-number])
}
barplot(numbers,
        cex.main=2,
        main="Tech Debt in Spark",
        ylab="Number of Issues",
        col=cols,
        cex.names=1)
dev.off()
