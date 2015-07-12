#include "FiveMac.ch"

function Main()

   local cTest := "Hello world!"
   local cSeed := "123456qwerty"
   local cString1 := cTest

   cString1 := Encrypt(cTest, cSeed)
   // MsgInfo(cString1)
   cTest := Decrypt(cString1, cSeed)
   MsgInfo(cTest)
     
return nil     