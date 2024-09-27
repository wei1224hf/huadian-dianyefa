while(true) 
do
  Sleep(100)
  SetDO("MD_DO_tuici_ok",GetDI("DI_tuici_ok"))
  SetDO("MD_DO_chongci_ok",GetDI("DI_chongci_ok"))
  SetDO("MD_R_DItuopanyouliao",GetDI("R_DItuopanyouliao"))
  SetDO("MD_L_DItuopanyouliao",GetDI("L_DItuopanyouliao"))
end

local function GLOBALDATA_DEFINE()

end
print("The end!")