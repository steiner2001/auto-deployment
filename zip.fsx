open System
open System.IO
open System.IO.Compression

match fsi.CommandLineArgs with
| [|file|] -> failwith (sprintf "missing argument: file path")
| [|file;filePath|] ->
    File.Delete("./archive.zip")
    ZipFile.CreateFromDirectory(filePath, @"./archive.zip")
| _ -> failwith (sprintf "too many arguments")