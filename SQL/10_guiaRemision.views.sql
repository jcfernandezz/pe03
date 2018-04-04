
alter view dbo.gremSopIvDetalle as
	select s.SOPTYPE, s.SOPNUMBE, s.LNITMSEQ, s.QTYFULFI,
		s.itemnmbr, s.ITEMDESC, s.UOFM, ns.nsaIFNit 
	from SOP10200 s
	inner join sop10100 cab
		on cab.sopnumbe = s.SOPNUMBE
		and cab.SOPTYPE = s.SOPTYPE
	left join NSAIF02666 ns		--nsaif_customer_nit_mstr [CUSTNMBR nsaIF_Type_Nit nsaIFNit]
		on ns.custnmbr = cab.custnmbr

	union all
	select s.SOPTYPE, s.SOPNUMBE, s.LNITMSEQ, s.QTYFULFI,
		s.itemnmbr, s.ITEMDESC, s.UOFM, ns.nsaIFNit 
	from SOP30300 s
	inner join sop30200 cab
		on cab.sopnumbe = s.SOPNUMBE
		and cab.SOPTYPE = s.SOPTYPE
	left join NSAIF02666 ns		--nsaif_customer_nit_mstr [CUSTNMBR nsaIF_Type_Nit nsaIFNit]
		on ns.custnmbr = cab.custnmbr

	union all
	select a.DOCTYPE, a.DOCNUMBR, a.LNSEQNBR, a.TRXQTY,
		a.itemnmbr, b.ITEMDESC, a.UOFM, null
	from IV30300 a
		left join IV00101 b 
			on a.ITEMNMBR=b.ITEMNMBR

	union all
	select a.IVDOCTYP, a.IVDOCNBR, a.LNSEQNBR, a.TRXQTY,
		a.itemnmbr, b.ITEMDESC, a.UOFM, null
	from IV10001 a
		left join IV00101 b 
			on a.ITEMNMBR=b.ITEMNMBR

go

----------------------------------------------------------------------------------
alter view dbo.gremGuiaRemision as
	select a.GREMGuiaIndicador, a.DOCNUMBR gremNumeroGuia,
		b.CUSTNAME,
		rtrim(isnull(det.nsaIFNit, b.txrgnnum)) txrgnnum,
		b.ADDRESS1,
		b.ADDRESS2,
		b.ADDRESS3,
		b.GREM_Address_1,
		b.GREM_Address_2,
		b.GREM_Address_3,
		b.DOCDATE,
		b.PYMNTTRM,
		b.PORDNMBR, 
		c.GREMTranspRUC,
		c.GREMTranspNombre,
		rtrim(c.GREMTranspMarca)+'/'+rtrim(c.gremtranspplaca) as GREMTranspMarca,
		c.GREMTranspConst,
		c.GREMTranspLicenc,
		det.LNITMSEQ linea,
		det.QTYFULFI cant, 
		det.itemnmbr,
		det.ITEMDESC item, 
		det.UOFM as um,
		det.soptype,
		det.sopnumbe
	from tblGREM001 a
	inner join dbo.gremSopIvDetalle det
		on det.SOPTYPE = a.GREMReferenciaTipo
		and det.SOPNUMBE = a.GREMReferenciaNumb
	left join tblGREM002 b 
		on a.DOCNUMBR=b.DOCNUMBR and a.GREMGuiaIndicador=b.GREMGuiaIndicador
	left join tblGREM003 c 
		on c.GREMTranspRUC=a.GREMTranspRUC
go	

-------------------------------------------------------------------
grant select on dbo.gremGuiaRemision to rol_perucontador, dyngrp;


go

--
--dar permisos al id de tarea Peru_default
--Producto GREM
--Tió Archivos
--Serie Inventario, compras
--TODOS
--Ejecutar grants de gp

--RUTA DE GUIA DE REMISION
--update tblGrem006 set interid = 'ZPER2', RPRTNAME= 'ZPER2'
