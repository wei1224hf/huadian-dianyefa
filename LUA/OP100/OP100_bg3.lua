--0 初始值
--1 调度要求 工位使能
--2 调度要求 工位下使能
--3 调度要求 暂停程序
--4 调度要求 启动或恢复运行程序
--5 调度要求 执行程序

while(1)do
	if GetAI("request") == 1 then
		SimInput("DI_ShiNeng",true)
		SetDI("DI_ShiNeng",1)
		Sleep(500)
		SetDI("DI_ShiNeng",0)
		SimInput("DI_ShiNeng",false)
	end
	if GetAI("request") == 2 then
		SimInput("di_motor_off",true)
		SetDI("di_motor_off",1)
		Sleep(500)
		SetDI("di_motor_off",0)
		SimInput("di_motor_off",false)
	end
	if GetAI("request") == 3 then
		SimInput("DI_TingZhi",true)
		SetDI("DI_TingZhi",0)
		Sleep(500)
		SetDI("DI_TingZhi",1)
		SimInput("DI_TingZhi",false)
	end
	if GetAI("request") == 4 then
		SimInput("DI_QiDong",true)
		SetDI("DI_QiDong",1)
		Sleep(500)
		SetDI("DI_QiDong",0)
		SimInput("DI_QiDong",false)
	end
	Sleep(100)
	if GetAI("request") == 5 then
		SimInput("DI_PGM_PP2MAIN",true)
		SetDI("DI_PGM_PP2MAIN",1)
		Sleep(500)
		SetDI("DI_PGM_PP2MAIN",0)
		SimInput("DI_PGM_PP2MAIN",false)
	end
	Sleep(100)
end