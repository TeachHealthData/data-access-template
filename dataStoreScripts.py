## Small helpers


import subprocess
def runInTerminal(terminalCommand, printInsteadOfRunning = False):
    print(terminalCommand)
    if(not printInsteadOfRunning ):
        result = subprocess.run(terminalCommand, shell=True)
        print(result)

# runInTerminal(["pwd"])

import platform
def operatingSystemIsWindows():
    return platform.system() == "Windows"

# operatingSystemIsWindows()

def getLocalDSLocation():
    if operatingSystemIsWindows():
      return "R:" # R: is just a drive letter, this could be X:,Z: or whatever
    else:
      return "~/.temporary-data"

# getLocalDSLocation()

## DataStore Operations Functions

def connectDatastore(username, datastoreSpace, organisationsFolder, disconnectFirst = False, printInsteadOfRunning = False, localHiddenFolder= getLocalDSLocation()):
  # it might be cleanest to ensure you're disconnected first
  if (disconnectFirst):
    disconnectDatastore(localHiddenFolder)
  

  print("# Connecting to datastore... (remember to be on VPN)")
  if (operatingSystemIsWindows()):
    # Windows
    yourDatastoreUrl = f"\\\\{organisationsFolder}\\{datastoreSpace}"  # e.g. \\cmvm.datastore.ed.ac.uk\cmvm\cmvm\groups\mvm-pgt\s1234567
    runInTerminal(f"net use {localHiddenFolder} {yourDatastoreUrl}", printInsteadOfRunning)
    runInTerminal(f"start {localHiddenFolder}", printInsteadOfRunning)
  else:
    # Mac
    yourDatastoreUrl = f"smb://{username}@{organisationsFolder}/{datastoreSpace}" # e.g. smb://porzecho@cmvm.datastore.ed.ac.uk/cmvm/cmvm/groups/mvm-pgt/s123467)
    runInTerminal(f"mkdir {localHiddenFolder}", printInsteadOfRunning)
    runInTerminal(f"mount -t smbfs {yourDatastoreUrl} {localHiddenFolder}", printInsteadOfRunning)
    runInTerminal(f"open {localHiddenFolder}", printInsteadOfRunning)

def openDatastoreFolder(printInsteadOfRunning = False, localHiddenFolder = getLocalDSLocation()):
  if (operatingSystemIsWindows()) :
    # Windows
    runInTerminal(f"start {localHiddenFolder}", printInsteadOfRunning)
  else:
    # Mac
    runInTerminal(f"open {localHiddenFolder}", printInsteadOfRunning)  


def disconnectDatastore(printInsteadOfRunning = False, localHiddenFolder= getLocalDSLocation()):
    print("Disonnecting from datastore... Remember to close all the files and folders first")
    if (operatingSystemIsWindows()):
        # Windows
        runInTerminal(f"net use {localHiddenFolder} /delete", printInsteadOfRunning)
    else:
        # Mac
        runInTerminal(f"umount {localHiddenFolder}", printInsteadOfRunning)

# ## File Operations Functions


def fileLocationOnDatastore(fileName, localHiddenFolder = getLocalDSLocation()):
  return f"{localHiddenFolder}/{fileName}"

import pandas as pd
def loadCsvWithDatastore(fileName, localHiddenFolder = getLocalDSLocation()):
    return pd.read_csv(f"{localHiddenFolder}/{fileName}")

def saveCsvWithDatastore(dataToSave, fileName, localHiddenFolder = getLocalDSLocation()):
  fileLocation = fileLocationOnDatastore(fileName,localHiddenFolder)
  dataToSave.to_csv(fileLocation, index=False)


# # TODO: convenience methods: load and save: csv, text, rds, xlsx

