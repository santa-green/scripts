insert r_CRs 
select 33 ChID,11 CRID,'КП (ТЦ "Мост-Сити модем")'CRName,Notes,'3000098240' FinID,'1140030721' FacID,CRPort,CRCode,SrvID,AutoCreateNewCheque,StockID,SecID,CashType,UseProdNotes,BaudRate,LEDType,CredCardMask,MaxChange,CanEditWeightQty,CanEditPrice,CanEditProdID,CanEnterPosDiscount,AskPWDCn,PrintTextAnull,AskPWDAnull,PrintReport,UseDecQtyBarCode,PaperWarning,AlwaysShowPosEditor,AskPWDCnCheque,AskPWDSuspend,AskPWDBalance,AskPWDRet,MaxSuspended,AskParamsAfterOpen,AskParamsBeforeClose,ShowPosDisc,ShowChequeDisc,AutoSelDiscs,AskDCardsAfterOpen,AskDCardsBeforeClose,CanEnterDCard,CanEnterCodeID1,CanEnterCodeID2,CanEnterCodeID3,CanEnterCodeID4,CanEnterCodeID5,CanEnterNotes,NoManualDCardEnter,ShowCancels,PreviewReport,DecQtyFromRef,AskVisitorsAfterOpen,AskPWDPeriodRep,PrintReportRet,MixedPays,PrintReportMonRec,PrintReportMonExp,AskPWDFind,UseBarCode,UseStockPL,OpenMoneyBoxOnDeposit,AskPWDMoneyBox,AskPWDDCardFind,PrintReportX,PrintReportZ,AutoFillPays,ShowPosEditOnCancel,CheckRetSum,AllowInvalidMonExp,CashRegMode,NetPort,ModemID,ModemPassword,CheckRetPayForms,PrintDiscs,AskPWDDeposit,PrintAfterSendOrder,NFOurID,ScaleID,AllowQtyReduction,ZReportWarning,PosEmpIDType,UseEmps,PosEmpID,ChequeEmp,IP,PrintCopyForCard,GroupProds,ZRepAfterShift,ZRepExecInTime,ZRepShiftEndTime,ZRepExecTime,ZRepShiftTimeCheck,ProcessingID,UserName,UserPassword,ChangeSumWarning,AskPWDPosRePay,CancelMDiscsWarning,PrintInfoAnull,AutoUpdateTaxes,CollectMetrics,MetricMaxDays,AsyncChequeInput
 from r_CRs where CRID =10

union
select * from r_CRs where CRID =10

insert r_OperCRs
select 11 CRID,OperID,CROperID,OperMaxQty,CanEditDiscount,CRVisible,OperPwd,AllowChequeClose,AllowAddToChequeFromCat
from r_OperCRs where CRID =10

select * from r_OperCRs where CRID =10

SOS - нужны данные по продаже в Кофейне Мост за 06.03.15 чек № 196849 сумма 28,00 грн