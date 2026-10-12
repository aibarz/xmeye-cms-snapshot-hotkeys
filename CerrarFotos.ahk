#Persistent
#SingleInstance Force

SetTimer, CerrarFotos, 50
return

CerrarFotos:
Process, Exist, Microsoft.Photos.exe
if (ErrorLevel)
{
    Process, Close, Microsoft.Photos.exe
}
return
