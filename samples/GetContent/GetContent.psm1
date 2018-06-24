<#
    Modeling a tree for example:

    ContentRoot 
          - FileLeafObj
          - StringLeafObj

 
    Import-Module  SHiPS                         
    Import-Module  .\samples\GetContent.psm1

    new-psdrive -name n -psprovider SHiPS -root 'GetContent#ContentRoot'

    or 

    new-psdrive -name n -psprovider SHiPS -root 'GetContent#ContentRoot\~\document\WindowsPowerShell\Modules\GetContent\'

    cd n:
    dir
    cat FileLeafObj
    cat StringLeafObj
   
#>

using namespace Microsoft.PowerShell.SHiPS
using namespace System.Management.Automation.Provider
using namespace CodeOwls.PowerShell.Paths
using namespace CodeOwls.PowerShell.Provider.PathNodeProcessors
using namespace System.Collections.Generic;
using namespace System.Collections;

# Define dynamic parameters
class FileReaderDynamicParameter
{
    [Parameter()]
    [System.Text.Encoding]$Encoding;
}

class ContentRoot : SHiPSDirectory
{
    [string] $RootPath;

    ContentRoot() : base($this.GetType())
    {
    }

    # Optional method
    # Must define this c'tor if it can be used as a drive root, e.g.
    # new-psdrive -name abc -psprovider SHiPS -root module#type
    # Also it is good practice to define this c'tor so that you can create a drive and test it in isolation fashion.
    ContentRoot([string]$name): base($name)
    {
        write-host("Name was called: $name");
        $this.RootPath = $PSScriptRoot;
    }

    # Optional method
    # Must define this c'tor if it can be used as a drive root, e.g.
    # new-psdrive -name abc -psprovider SHiPS -root module#type
    # Also it is good practice to define this c'tor so that you can create a drive and test it in isolation fashion.
    ContentRoot([string]$name, [string]$rootPath): base($name)
    {
        $this.RootPath = $rootPath;
    }

    # Mandatory it gets called by SHiPS while a user does 'dir'
    [object[]] GetChildItem()
    {
        $obj =  @()

        $filePath = Resolve-Path (Join-Path $this.RootPath "content.txt");
        $obj += ([FileLeafObj]::new($filePath));
        $obj += ([StringLeafObj]::new("This is a constant string content"));

        return $obj;
    }
 
}

class FileLeafObj : SHiPSLeaf
{
    [string] $Path;

    FileLeafObj($path) : base($this.GetType())
    {
        $this.Path = $path;
    }

    # Define dynamic parameters for Get-Content
    [object] GetContentDynamicParameters()
    {      
        return [FileReaderDynamicParameter]::new()
    }

    [IContentReader] GetContentReader(){
        $dp = $this.ProviderContext.DynamicParameters -as [FileReaderDynamicParameter];
        return [FileReader]::new($this.Path, $dp.Encoding);
    }

}


class StringLeafObj : SHiPSLeaf
{
    [string] $Content;

    StringLeafObj($content) : base($this.GetType())
    {
        $this.Content = $content;
    }

    [IContentReader] GetContentReader(){
        return [StringReader]::new($this.Content);
    }

}

class FileReader : IContentReader{

    [System.IO.Stream] $fileStream;
    [System.IO.StreamReader] $reader;

    FileReader($filePath){
        $this.fileStream = [System.IO.File]::OpenRead($filePath);
        $this.reader = [System.IO.StreamReader]::new($this.fileStream);
    }

    FileReader($filePath, [System.Text.Encoding]$encoding){
        $this.fileStream = [System.IO.File]::OpenRead($filePath);
        $this.reader = [System.IO.StreamReader]::new($this.fileStream, $encoding);
    }

    [IList] Read([long] $readCount){
        #$res = [char[]]::new($readCount);
        #$this.reader.Read($res, 0, $readCount);

        #return $res;
        return [string[]]($this.reader.ReadLine());
    }

    [void] Seek([long] $offset,[System.IO.SeekOrigin] $origin){
        $this.fileStream.Seek($offset, $origin);
    }

    [void] Close(){
        $this.reader.Close();
    }

    [void] Dispose(){
        $this.reader.Dispose();
    }

}


class StringReader : IContentReader{

    [string]$Content;
    $isCompleted;

    StringReader($content){
        $this.isCompleted =$false;
        $this.Content = $content;
    }

    [IList] Read([long] $readCount){
        if (-not $this.isCompleted){
            $this.isCompleted = $true;
            return [string[]]($this.Content);
        }

        return $null;
    }

    [void] Seek([long] $offset,[System.IO.SeekOrigin] $origin){
        #Not supported
    }

    [void] Close(){
    }

    [void] Dispose(){
    }

}