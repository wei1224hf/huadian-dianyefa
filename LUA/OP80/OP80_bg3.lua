--0 初始值
--1 调度要求 工位使能
--2 调度要求 工位下使能
--3 调度要求 暂停程序
--4 调度要求 启动或恢复运行程序
--5 调度要求 执行程序

while(1)do
	if GetAI("LCS_command") == 1 then
		SimInput("SYS_SAFE_MOTOR_ON",true)
		SetDI("SYS_SAFE_MOTOR_ON",1)
		Sleep(500)
		SetDI("SYS_SAFE_MOTOR_ON",0)
		SimInput("SYS_SAFE_MOTOR_ON",false)
	end
	if GetAI("LCS_command") == 2 then
		SimInput("SYS_SAFE_MOTOR_OFF",true)
		SetDI("SYS_SAFE_MOTOR_OFF",1)
		Sleep(500)
		SetDI("SYS_SAFE_MOTOR_OFF",0)
		SimInput("SYS_SAFE_MOTOR_OFF",false)
	end
	if GetAI("LCS_command") == 3 then
		SimInput("DI_TingZhi",true)
		SetDI("DI_TingZhi",0)
		Sleep(500)
		SetDI("DI_TingZhi",1)
		SimInput("DI_TingZhi",false)
	end
	if GetAI("LCS_command") == 4 then
		SimInput("DI_QiDong",true)
		SetDI("DI_QiDong",1)
		Sleep(500)
		SetDI("DI_QiDong",0)
		SimInput("DI_QiDong",false)
	end
	Sleep(100)
end