## Small helpers

runInTerminal <- function(terminalCommand, silent = FALSE){
  if(!silent){
    cat(paste0(terminalCommand, "\n"))
  }
  system(terminalCommand)
}

operatingSystemIsWindows <- function(){
  Sys.info()["sysname"] == "Windows" # sysname is "Windows" for windows; or "Darwin","Linux" for mac
}

getLocalDSLocation <- function(){
  ifelse(operatingSystemIsWindows(), "R:", "~/.temporary-data") # R: is just a drive letter, this could be X:,Z: or whatever
}

## DataStore Operations Functions

connectDatastore <- function(username, datastoreSpace, organisationsFolder, disconnectFirst = FALSE, localHiddenFolder= getLocalDSLocation()) {
  # it might be cleanest to ensure you're disconnected first
  if (disconnectFirst) {
    disconnectDatastore(localHiddenFolder)
  }
  
  print("Connecting to datastore... (remember to be on VPN)")
  if (operatingSystemIsWindows()) {
    # Windows
    yourDatastoreUrl <- paste0("\\\\", yourOrganisationsFolder,"\\",yourDatastoreSpace) #\cmvm.datastore.ed.ac.uk\cmvm\cmvm\groups\mvm-pgt\s1234567
    runInTerminal(paste0("net use ",localHiddenFolder," ",yourDatastoreUrl))
    runInTerminal(paste0("open ",localHiddenFolder," "))
  } else {
    # Mac
    yourDatastoreUrl <- paste0("smb://",yourUsername,"@",yourOrganisationsFolder,"/",yourDatastoreSpace) #will look a bit like smb://porzecho@cmvm.datastore.ed.ac.uk/cmvm/cmvm/groups/mvm-pgt/s123467)
    runInTerminal(paste0("mkdir ", localHiddenFolder))
    runInTerminal(paste0("mount -t smbfs ",yourDatastoreUrl," ", localHiddenFolder))
    runInTerminal(paste0("open ", localHiddenFolder))
  }
}

openDatastoreFolder <- function(localHiddenFolder = getLocalDSLocation()) {
  if (operatingSystemIsWindows()) {
    # Windows
    runInTerminal(paste0("open ",localHiddenFolder))
  } else {
    # Mac
    runInTerminal(paste0("open ", localHiddenFolder))
  }
}

disconnectDatastore <- function(localHiddenFolder= getLocalDSLocation()) {
  print("Disconnecting from datastore...")
  if (operatingSystemIsWindows()) {
    # Windows
    runInTerminal(paste0("net use ",localHiddenFolder," /delete"))
  } else {
    # Mac
    runInTerminal(paste0("umount ", localHiddenFolder))
  }
}


## File Operations Functions


fileLocationOnDatastore <- function(fileName, localHiddenFolder = getLocalDSLocation()){
  paste0(localHiddenFolder, "/", fileName)
}

loadCsvWithDatastore <- function(fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  read.csv(fileLocation)
}

saveCsvWithDatastore <- function(dataToSave, fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  write.csv(x=dataToSave, file=fileLocation, row.names = FALSE)
}

# TODO: convenience methods: load and save: csv, text, rds, xlsx

loadTextWithDatastore <- function(fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  # TODO
}

saveTextWithDatastore <- function(dataToSave, fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  # TODO
}

loadRdsWithDatastore <- function(fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  # TODO
}

saveRdsWithDatastore <- function(dataToSave, fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  # TODO
}

loadXlsxWithDatastore <- function(fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  # TODO
}

saveXlsxWithDatastore <- function(dataToSave, fileName, localHiddenFolder = getLocalDSLocation()){
  fileLocation <- fileLocationOnDatastore(fileName,localHiddenFolder)
  # TODO
}
