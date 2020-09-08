#' @param taxa
#' @param genes
#' @param maxseqs
#' @param




Hughes_etal_species <-
  read.csv("~/MEGAsync/Projects/14_HymenopteranTree/Hughes_etal_species.csv")

library (rentrez)
library(pbapply)
species <-
  c(
    paste0(Hughes_etal_species$Genus, ' ', Hughes_etal_species$Species),
    "Gyrinus marinus",
    "Tribolium castaneum",
    "Corydalus cornutus",
    "Xanthostigma xanthostigma",
    "Pseudomallada prasinus"
  )

genes<-c('16S','COI','28S','RPS23','CAD','ITS1','ITS2','18S','COII','Cytb')

##Download sequences
Full_sequences<-lapply(seq_along(genes), function(y){
  Hym_seqs <- pblapply(seq_along(species), function(x) {
    targetsp <- paste0(species[x], " [Organism] ", genes[y])

    lizard_search <-
      entrez_search(db = "nuccore",
                    term = targetsp,
                    retmax = 10)
    lizard_search
    lizard_search$ids #gives you the NCBI ids

    if (length(lizard_search$ids) == 0) {
      return(list(species=species[x],gene=genes[y], data = F, sequences = NULL))

    } else{
      lizard_seqs <-
        entrez_fetch(db = "nuccore",
                     id = lizard_search$ids,
                     rettype = "fasta")
      return(list(species=species[x],gene=genes[y],data = F, sequences = lizard_seqs))
    }
  })
  names(Hym_seqs)<-genes[y]
  Hym_seqs
})

#Write sequences
lapply(seq_along(genes), function(y){
  lapply(seq_along(species), function(x){
    write(Full_sequences[[y]][[x]]$sequences, paste0("Sequences/Full_dataset.fasta"), sep="\n", append = TRUE)
  } )
})

##Outgroup: "Gyrinus marinus", "Tribolium castaneum", "Corydalus cornutus",
#"Xanthostigma xanthostigma", "Pseudomallada prasinus"
#https://www.cell.com/cms/10.1016/j.cub.2017.01.027/attachment/15ff2939-c6f6-453b-be2d-69e7b3ebcbfe/mmc1.pdf

##Target genes
#https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6451838/
#16S and COI, and nuclear markers 28S, RPS23, CAD

##Fossils
#Hymenoptera: min. 226.4 Ma (Triassoxyela foveolata)
#Bombus/Bombini: 16–18 Ma (Bombus (Bombus) randeckensis)


