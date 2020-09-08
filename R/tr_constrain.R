library(taxize)
library(ape)

gen<-unique(unlist(lapply(strsplit(GenBank_Accession_Table$Taxon,' '), function(x)x[[1]][1])))


taxonomy<-do.call(rbind,pblapply(gen, function(x){
  tryCatch({
    tax_name(query = x, get = c('family',"superfamily"), db = "ncbi")
  }, error=function(e){})
}))

added<-cbind.data.frame(Genus=unlist(lapply(strsplit(GenBank_Accession_Table$Taxon,' '), function(x)x[[1]][1])),
                        GenBank_Accession_Table)

full_ds<-do.call(rbind,lapply(seq_len(nrow(added)), function(x){
  cbind.data.frame(taxonomy[ taxonomy$query == added$Genus[x] ,c(3,4)], added[x,])
}))

write.csv(full_ds, 'acc.num.csv')


acc.num$Taxon<-sub(' ', '_' , acc.num$Taxon)
Aln<-read.FASTA('Concatenated_Alignment.fasta')
Aln2<-Aln[names(Aln) %in% acc.num$Taxon]


write.FASTA(Aln2,'Concatenated_Alignment_subset.fasta')


##Combine all species per family
fams<-unique(acc.num$family)
sppwithinfams<-lapply(fams, function(x){
  paste0('(',paste(acc.num[ acc.num$family == x, 'Taxon'], collapse = ','),')')
})
names(sppwithinfams)<-fams

##Combine all families per superfamily
superfams<-unique(acc.num$superfamily)

famswithinsupfams<-lapply(superfams, function(x){
  targetFams<-unique(acc.num[ acc.num$superfamily == x,'family' ])
  paste(unlist(sppwithinfams[names(sppwithinfams) %in% targetFams]), collapse = ',')
})
names(famswithinsupfams)<-superfams

Topology<-"((((Formicoidea, Apoidea),Vespoidea),Chrysidoidea), (Ichneumonoidea,Chalcidoidea), Outgroup);"

for(i in seq_along(superfams)){
  Topology<- gsub(superfams[i],famswithinsupfams[names(famswithinsupfams) == superfams[i]] ,Topology)
}


write(Topology, 'tree.tre')



