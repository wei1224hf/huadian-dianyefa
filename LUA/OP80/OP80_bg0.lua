while(true)
do
  Sleep(100)
  
SetAO("DI_Jiting_",GetDI("DI_Jiting"))
SetAO("DI_QiDong_",GetDI("DI_QiDong"))
SetAO("DI_TingZhi_",GetDI("DI_TingZhi"))
SetAO("DI_ShouZiDong_",GetDI("DI_ShouZiDong"))
SetAO("DI_L_GunTong_DaoWei_",GetDI("DI_L_GunTong_DaoWei"))
SetAO("DI_R_GunTong_DaoWei_",GetDI("DI_R_GunTong_DaoWei"))
SetAO("DI_ShiNeng_",GetDI("DI_ShiNeng"))
SetAO("DI_L_ShenJiang_DaoWei_",GetDI("DI_L_ShenJiang_DaoWei"))
SetAO("DI_R_ShenJiang_DaoWei_",GetDI("DI_R_ShenJiang_DaoWei"))
SetAO("DI_ZhuaPan1_DaKaiDaoWei_",GetDI("DI_ZhuaPan1_DaKaiDaoWei"))
SetAO("DI_ZhuaPan1_GuanBiWei_",GetDI("DI_ZhuaPan1_GuanBiWei"))
SetAO("DI_ZhuaPan2_DaKaiDaoWei_",GetDI("DI_ZhuaPan2_DaKaiDaoWei"))
SetAO("DI_ZhuaPan2_GuanBiWei_",GetDI("DI_ZhuaPan2_GuanBiWei"))
SetAO("DI_HengYi_YouLiao_",GetDI("DI_HengYi_YouLiao"))
SetAO("DI_LuoSiQiang_shangshen_",GetDI("DI_LuoSiQiang_shangshen"))
SetAO("DI_LuoSiQiang_xiajiang_",GetDI("DI_LuoSiQiang_xiajiang"))
SetAO("DI_HengYi_SongKaiDaoWei_",GetDI("DI_HengYi_SongKaiDaoWei"))
SetAO("DI_HengYi_JiaJinDaoWei_",GetDI("DI_HengYi_JiaJinDaoWei"))
SetAO("DI_M6_LuoSi_fenli_dakai_",GetDI("DI_M6_LuoSi_fenli_dakai"))
SetAO("DI_M6_LuoSi_fenli_guanbi_",GetDI("DI_M6_LuoSi_fenli_guanbi"))
SetAO("DI_M5_LuoSi_fenli_guanbi_",GetDI("DI_M5_LuoSi_fenli_guanbi"))
SetAO("DI_M5_LuoSi_fenli_dakai_",GetDI("DI_M5_LuoSi_fenli_dakai"))
SetAO("DI_Hengyi_shangshen_Daowei_",GetDI("DI_Hengyi_shangshen_Daowei"))
SetAO("DI_Hengyi_xiajiang_Daowei_",GetDI("DI_Hengyi_xiajiang_Daowei"))
SetAO("DI_M5_Songliao_Dakai_1_",GetDI("DI_M5_Songliao_Dakai_1"))
SetAO("DI_M5_Songliao_Guanbi_1_",GetDI("DI_M5_Songliao_Guanbi_1"))
SetAO("DI_M5_Songliao_Dakai_2_",GetDI("DI_M5_Songliao_Dakai_2"))
SetAO("DI_M5_Songliao_Guanbi_2_",GetDI("DI_M5_Songliao_Guanbi_2"))

SetAO("DI_DingWei_GuanBiDaoWei1_",GetDI("DI_DingWei_GuanBiDaoWei1"))
SetAO("DI_DingWei_DaKaiDaoWei1_",GetDI("DI_DingWei_DaKaiDaoWei1"))
SetAO("DI_DingWei_GuanBiDaoWei2_",GetDI("DI_DingWei_GuanBiDaoWei2"))
SetAO("DI_DingWei_DaKaiDaoWei2_",GetDI("DI_DingWei_DaKaiDaoWei2"))
SetAO("DI_DingWei_GuanBiDaoWei3_",GetDI("DI_DingWei_GuanBiDaoWei3"))
SetAO("DI_DingWei_DaKaiDaoWei3_",GetDI("DI_DingWei_DaKaiDaoWei3"))
SetAO("DI_M6_LuoSi_Geli_",GetDI("DI_M6_LuoSi_Geli"))
SetAO("DI_M5_LuoSi_Geli_daka_",GetDI("DI_M5_LuoSi_Geli_daka"))
SetAO("DI_M5_LuoSi_Geli_guanbi_",GetDI("DI_M5_LuoSi_Geli_guanbi"))

SetAO("DI_M6_ZDP_DaoKaiDaoWei1_",GetDI("DI_M6_ZDP_DaoKaiDaoWei1"))
SetAO("DI_M6_ZDP_GuanBiDaoWei1_",GetDI("DI_M6_ZDP_GuanBiDaoWei1"))
SetAO("DI_M6_ZDP_DaoKaiDaoWei2_",GetDI("DI_M6_ZDP_DaoKaiDaoWei2"))

SetAO("DI_ZDP_ZhengFanJianCe_",GetDI("DI_ZDP_ZhengFanJianCe"))
SetAO("DI_Error_Fuwei_",GetDI("DI_Error_Fuwei"))
SetAO("DI_Lianji_",GetDI("DI_Lianji"))
SetAO("DI_ZhiXing_",GetDI("DI_ZhiXing"))
  
  
  if GetAI("DO_LvDeng_")==1 
  then
  	SetDO("DO_LvDeng",0) 
  end 
  if GetAI("DO_LvDeng_")==2 
  then
  	SetDO("DO_LvDeng",1)  
  end 
    
  if GetAI("DO_HuangDeng_")==1 
  then
  	SetDO("DO_HuangDeng",0) 
  end 
  if GetAI("DO_HuangDeng_")==2 
  then
  	SetDO("DO_HuangDeng",1)  
  end 
    
  if GetAI("DO_HongDeng_")==1 
  then
  	SetDO("DO_HongDeng",0) 
  end 
  if GetAI("DO_HongDeng_")==2 
  then
  	SetDO("DO_HongDeng",1)  
  end 
    
  if GetAI("DO_FengLiao_")==1 
  then
  	SetDO("DO_FengLiao",0) 
  end 
  if GetAI("DO_FengLiao_")==2 
  then
  	SetDO("DO_FengLiao",1)  
  end 
    
  if GetAI("DO_ZhuaPan_GuanBi_")==1 
  then
  	SetDO("DO_ZhuaPan_GuanBi",0) 
  end 
  if GetAI("DO_ZhuaPan_GuanBi_")==2 
  then
  	SetDO("DO_ZhuaPan_GuanBi",1)  
  end 
    
  if GetAI("DO_ZhuaPan_DaKai_")==1 
  then
  	SetDO("DO_ZhuaPan_DaKai",0) 
  end 
  if GetAI("DO_ZhuaPan_DaKai_")==2 
  then
  	SetDO("DO_ZhuaPan_DaKai",1)  
  end 
    
  if GetAI("DO_HengYi_JiaJin_")==1 
  then
  	SetDO("DO_HengYi_JiaJin",0) 
  end 
  if GetAI("DO_HengYi_JiaJin_")==2 
  then
  	SetDO("DO_HengYi_JiaJin",1)  
  end 
    
  if GetAI("DO_HengYi_SongKai_")==1 
  then
  	SetDO("DO_HengYi_SongKai",0) 
  end 
  if GetAI("DO_HengYi_SongKai_")==2 
  then
  	SetDO("DO_HengYi_SongKai",1)  
  end 
    
  if GetAI("DO_HengYi_ShangShen_")==1 
  then
  	SetDO("DO_HengYi_ShangShen",0) 
  end 
  if GetAI("DO_HengYi_ShangShen_")==2 
  then
  	SetDO("DO_HengYi_ShangShen",1)  
  end 
    
  if GetAI("DO_HengYi_XiaJiang_")==1 
  then
  	SetDO("DO_HengYi_XiaJiang",0) 
  end 
  if GetAI("DO_HengYi_XiaJiang_")==2 
  then
  	SetDO("DO_HengYi_XiaJiang",1)  
  end 
    
  if GetAI("DO_GangYuan_XYZ_")==1 
  then
  	SetDO("DO_GangYuan_XYZ",0) 
  end 
  if GetAI("DO_GangYuan_XYZ_")==2 
  then
  	SetDO("DO_GangYuan_XYZ",1)  
  end 
    
  if GetAI("DO_L_GunTong_JinRu_")==1 
  then
  	SetDO("DO_L_GunTong_JinRu",0) 
  end 
  if GetAI("DO_L_GunTong_JinRu_")==2 
  then
  	SetDO("DO_L_GunTong_JinRu",1)  
  end 
    
  if GetAI("DO_L_GunTong_SongChu_")==1 
  then
  	SetDO("DO_L_GunTong_SongChu",0) 
  end 
  if GetAI("DO_L_GunTong_SongChu_")==2 
  then
  	SetDO("DO_L_GunTong_SongChu",1)  
  end 
    
  if GetAI("DO_GangYuan_ROB_")==1 
  then
  	SetDO("DO_GangYuan_ROB",0) 
  end 
  if GetAI("DO_GangYuan_ROB_")==2 
  then
  	SetDO("DO_GangYuan_ROB",1)  
  end 
    
  if GetAI("DO_M5_FenLi_")==1 
  then
  	SetDO("DO_M5_FenLi",0) 
  end 
  if GetAI("DO_M5_FenLi_")==2 
  then
  	SetDO("DO_M5_FenLi",1)  
  end 
    
  if GetAI("DO_NJQ_PiTouDingWei_")==1 
  then
  	SetDO("DO_NJQ_PiTouDingWei",0) 
  end 
  if GetAI("DO_NJQ_PiTouDingWei_")==2 
  then
  	SetDO("DO_NJQ_PiTouDingWei",1)  
  end 
    
  if GetAI("DO_M5_SongLiao_")==1 
  then
  	SetDO("DO_M5_SongLiao",0) 
  end 
  if GetAI("DO_M5_SongLiao_")==2 
  then
  	SetDO("DO_M5_SongLiao",1)  
  end 
    
  if GetAI("DO_M5_TouLiao_")==1 
  then
  	SetDO("DO_M5_TouLiao",0) 
  end 
  if GetAI("DO_M5_TouLiao_")==2 
  then
  	SetDO("DO_M5_TouLiao",1)  
  end 
    
  if GetAI("DO_NJQ_ShenChu_")==1 
  then
  	SetDO("DO_NJQ_ShenChu",0) 
  end 
  if GetAI("DO_NJQ_ShenChu_")==2 
  then
  	SetDO("DO_NJQ_ShenChu",1)  
  end 
    
  if GetAI("DO_M6_FenLi_")==1 
  then
  	SetDO("DO_M6_FenLi",0) 
  end 
  if GetAI("DO_M6_FenLi_")==2 
  then
  	SetDO("DO_M6_FenLi",1)  
  end 
    
  if GetAI("DO_NJQ_SuoHui_")==1 
  then
  	SetDO("DO_NJQ_SuoHui",0) 
  end 
  if GetAI("DO_NJQ_SuoHui_")==2 
  then
  	SetDO("DO_NJQ_SuoHui",1)  
  end 
    
  if GetAI("DO_M6_Luosi_Jiajing1_")==1 
  then
  	SetDO("DO_M6_Luosi_Jiajing1",0) 
  end 
  if GetAI("DO_M6_Luosi_Jiajing1_")==2 
  then
  	SetDO("DO_M6_Luosi_Jiajing1",1)  
  end 
    
  if GetAI("DO_erci_LR_Jiajing_")==1 
  then
  	SetDO("DO_erci_LR_Jiajing",0) 
  end 
  if GetAI("DO_erci_LR_Jiajing_")==2 
  then
  	SetDO("DO_erci_LR_Jiajing",1)  
  end 
    
  if GetAI("DO_erci_LR_Songkai_")==1 
  then
  	SetDO("DO_erci_LR_Songkai",0) 
  end 
  if GetAI("DO_erci_LR_Songkai_")==2 
  then
  	SetDO("DO_erci_LR_Songkai",1)  
  end 
    
  if GetAI("DO_erci_ZJ_Jiajing_")==1 
  then
  	SetDO("DO_erci_ZJ_Jiajing",0) 
  end 
  if GetAI("DO_erci_ZJ_Jiajing_")==2 
  then
  	SetDO("DO_erci_ZJ_Jiajing",1)  
  end 
    
  if GetAI("DO_erci_ZJ_Songkai_")==1 
  then
  	SetDO("DO_erci_ZJ_Songkai",0) 
  end 
  if GetAI("DO_erci_ZJ_Songkai_")==2 
  then
  	SetDO("DO_erci_ZJ_Songkai",1)  
  end 
    
  if GetAI("DO_M5_LuoSi_Chuiru_")==1 
  then
  	SetDO("DO_M5_LuoSi_Chuiru",0) 
  end 
  if GetAI("DO_M5_LuoSi_Chuiru_")==2 
  then
  	SetDO("DO_M5_LuoSi_Chuiru",1)  
  end 
    
  if GetAI("DO_M6_LuoSi_Geli_")==1 
  then
  	SetDO("DO_M6_LuoSi_Geli",0) 
  end 
  if GetAI("DO_M6_LuoSi_Geli_")==2 
  then
  	SetDO("DO_M6_LuoSi_Geli",1)  
  end 
    
  if GetAI("DO_M6_Hengyi_1_")==1 
  then
  	SetDO("DO_M6_Hengyi_1",0) 
  end 
  if GetAI("DO_M6_Hengyi_1_")==2 
  then
  	SetDO("DO_M6_Hengyi_1",1)  
  end 
    
  if GetAI("DO_M6_Hengyi_2_")==1 
  then
  	SetDO("DO_M6_Hengyi_2",0) 
  end 
  if GetAI("DO_M6_Hengyi_2_")==2 
  then
  	SetDO("DO_M6_Hengyi_2",1)  
  end 
    
  if GetAI("DO_M6_LuoSi_Chuiru_")==1 
  then
  	SetDO("DO_M6_LuoSi_Chuiru",0) 
  end 
  if GetAI("DO_M6_LuoSi_Chuiru_")==2 
  then
  	SetDO("DO_M6_LuoSi_Chuiru",1)  
  end 
    
  if GetAI("DO_M5_LuoSi_Geli_")==1 
  then
  	SetDO("DO_M5_LuoSi_Geli",0) 
  end 
  if GetAI("DO_M5_LuoSi_Geli_")==2 
  then
  	SetDO("DO_M5_LuoSi_Geli",1)  
  end 
    
  if GetAI("DO_GangYuan_JianCe_")==1 
  then
  	SetDO("DO_GangYuan_JianCe",0) 
  end 
  if GetAI("DO_GangYuan_JianCe_")==2 
  then
  	SetDO("DO_GangYuan_JianCe",1)  
  end 
    
  if GetAI("DO_ROB_GuanBi_")==1 
  then
  	SetDO("DO_ROB_GuanBi",0) 
  end 
  if GetAI("DO_ROB_GuanBi_")==2 
  then
  	SetDO("DO_ROB_GuanBi",1)  
  end 
    
  if GetAI("DO_ROB_DaKai_")==1 
  then
  	SetDO("DO_ROB_DaKai",0) 
  end 
  if GetAI("DO_ROB_DaKai_")==2 
  then
  	SetDO("DO_ROB_DaKai",1)  
  end 
    
  if GetAI("DO_R_GunTong_tuichu_")==1 
  then
  	SetDO("DO_R_GunTong_tuichu",0) 
  end 
  if GetAI("DO_R_GunTong_tuichu_")==2 
  then
  	SetDO("DO_R_GunTong_tuichu",1)  
  end 
    
  if GetAI("DO_R_GunTong_jinru_")==1 
  then
  	SetDO("DO_R_GunTong_jinru",0) 
  end 
  if GetAI("DO_R_GunTong_jinru_")==2 
  then
  	SetDO("DO_R_GunTong_jinru",1)  
  end 

end