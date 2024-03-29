CREATE OR REPLACE FORCE VIEW STRANG.CONVOY_DETAILS_VW
(CONVOY_ID, RNO, TRUCK_ID, TRAILER_ID, ORDER_ID, 
 TRUCK_TANKER, CONVOY_SECTION, WEIGHBRIDGE, FUEL_PUMP, FUEL_TYPE, 
 FUEL_LITRES, OPERATOR, REMOVE1, LOOKUP1, MOVEMENT_NO1, 
 SEAL1, FULL_MT1, ISO_CONTAINER_TYPE1, WEIGHT1, VOLUME1, 
 TARE1, CONTAINER_TYPE1, HAZARD1, OVERDIMENSIONAL1, SET_POINT1, 
 CONSIGNEE1, CONSIGNEE_LOCATION1, WAREHOUSE_DESTINATION1, URGENCY1, VESSEL1, 
 REMOVE2, LOOKUP2, MOVEMENT_NO2, SEAL2, FULL_MT2, 
 ISO_CONTAINER_TYPE2, WEIGHT2, VOLUME2, TARE2, CONTAINER_TYPE2, 
 HAZARD2, OVERDIMENSIONAL2, SET_POINT2, CONSIGNEE2, CONSIGNEE_LOCATION2, 
 WAREHOUSE_DESTINATION2, URGENCY2, VESSEL2, TANKER_WEIGHT, REMOVE3, 
 LOOKUP3, MOVEMENT_NO3, SEAL3, FULL_MT3, ISO_CONTAINER_TYPE3, 
 WEIGHT3, VOLUME3, TARE3, CONTAINER_TYPE3, HAZARD3, 
 OVERDIMENSIONAL3, SET_POINT3, CONSIGNEE3, CONSIGNEE_LOCATION3, WAREHOUSE_DESTINATION3, 
 URGENCY3, VESSEL3, REMOVE4, LOOKUP4, MOVEMENT_NO4, 
 SEAL4, FULL_MT4, ISO_CONTAINER_TYPE4, WEIGHT4, VOLUME4, 
 TARE4, CONTAINER_TYPE4, HAZARD4, OVERDIMENSIONAL4, SET_POINT4, 
 CONSIGNEE4, CONSIGNEE_LOCATION4, WAREHOUSE_DESTINATION4, URGENCY4, VESSEL4, 
 REMOVE5, LOOKUP5, MOVEMENT_NO5, SEAL5, FULL_MT5, 
 ISO_CONTAINER_TYPE5, WEIGHT5, VOLUME5, TARE5, CONTAINER_TYPE5, 
 HAZARD5, OVERDIMENSIONAL5, SET_POINT5, CONSIGNEE5, CONSIGNEE_LOCATION5, 
 WAREHOUSE_DESTINATION5, URGENCY5, VESSEL5, REMOVE6, LOOKUP6, 
 MOVEMENT_NO6, SEAL6, FULL_MT6, ISO_CONTAINER_TYPE6, WEIGHT6, 
 VOLUME6, TARE6, CONTAINER_TYPE6, HAZARD6, OVERDIMENSIONAL6, 
 SET_POINT6, CONSIGNEE6, CONSIGNEE_LOCATION6, WAREHOUSE_DESTINATION6, URGENCY6, 
 VESSEL6, CONTAINER_OWNER1, CONTAINER_OWNER2, CONTAINER_OWNER3, CONTAINER_OWNER4, 
 CONTAINER_OWNER5, CONTAINER_OWNER6, RNO2)
AS 
select cn."CONVOY_ID",cn."RNO",cn."TRUCK_ID",cn."TRAILER_ID",cn."ORDER_ID",cn."TRUCK_TANKER",cn."CONVOY_SECTION",cn."WEIGHBRIDGE",cn."FUEL_PUMP",cn."FUEL_TYPE",cn."FUEL_LITRES",cn."OPERATOR",cn."REMOVE1",cn."LOOKUP1",cn."MOVEMENT_NO1",cn."SEAL1",cn."FULL_MT1",cn."ISO_CONTAINER_TYPE1",cn."WEIGHT1",cn."VOLUME1",cn."TARE1",cn."CONTAINER_TYPE1",cn."HAZARD1",cn."OVERDIMENSIONAL1",cn."SET_POINT1",cn."CONSIGNEE1",cn."CONSIGNEE_LOCATION1",cn."WAREHOUSE_DESTINATION1",cn."URGENCY1",cn."VESSEL1",cn."REMOVE2",cn."LOOKUP2",cn."MOVEMENT_NO2",cn."SEAL2",cn."FULL_MT2",cn."ISO_CONTAINER_TYPE2",cn."WEIGHT2",cn."VOLUME2",cn."TARE2",cn."CONTAINER_TYPE2",cn."HAZARD2",cn."OVERDIMENSIONAL2",cn."SET_POINT2",cn."CONSIGNEE2",cn."CONSIGNEE_LOCATION2",cn."WAREHOUSE_DESTINATION2",cn."URGENCY2",cn."VESSEL2",cn."TANKER_WEIGHT",cn."REMOVE3",cn."LOOKUP3",cn."MOVEMENT_NO3",cn."SEAL3",cn."FULL_MT3",cn."ISO_CONTAINER_TYPE3",cn."WEIGHT3",cn."VOLUME3",cn."TARE3",cn."CONTAINER_TYPE3",cn."HAZARD3",cn."OVERDIMENSIONAL3",cn."SET_POINT3",cn."CONSIGNEE3",cn."CONSIGNEE_LOCATION3",cn."WAREHOUSE_DESTINATION3",cn."URGENCY3",cn."VESSEL3",cn."REMOVE4",cn."LOOKUP4",cn."MOVEMENT_NO4",cn."SEAL4",cn."FULL_MT4",cn."ISO_CONTAINER_TYPE4",cn."WEIGHT4",cn."VOLUME4",cn."TARE4",cn."CONTAINER_TYPE4",cn."HAZARD4",cn."OVERDIMENSIONAL4",cn."SET_POINT4",cn."CONSIGNEE4",cn."CONSIGNEE_LOCATION4",cn."WAREHOUSE_DESTINATION4",cn."URGENCY4",cn."VESSEL4",cn."REMOVE5",cn."LOOKUP5",cn."MOVEMENT_NO5",cn."SEAL5",cn."FULL_MT5",cn."ISO_CONTAINER_TYPE5",cn."WEIGHT5",cn."VOLUME5",cn."TARE5",cn."CONTAINER_TYPE5",cn."HAZARD5",cn."OVERDIMENSIONAL5",cn."SET_POINT5",cn."CONSIGNEE5",cn."CONSIGNEE_LOCATION5",cn."WAREHOUSE_DESTINATION5",cn."URGENCY5",cn."VESSEL5",cn."REMOVE6",cn."LOOKUP6",cn."MOVEMENT_NO6",cn."SEAL6",cn."FULL_MT6",cn."ISO_CONTAINER_TYPE6",cn."WEIGHT6",cn."VOLUME6",cn."TARE6",cn."CONTAINER_TYPE6",cn."HAZARD6",cn."OVERDIMENSIONAL6",cn."SET_POINT6",cn."CONSIGNEE6",cn."CONSIGNEE_LOCATION6",cn."WAREHOUSE_DESTINATION6",cn."URGENCY6",cn."VESSEL6",cn."CONTAINER_OWNER1",cn."CONTAINER_OWNER2",cn."CONTAINER_OWNER3",cn."CONTAINER_OWNER4",cn."CONTAINER_OWNER5",cn."CONTAINER_OWNER6", dense_rank() over (partition by convoy_id order by rno) rno2
 from strang.convoy_details cn;


GRANT SELECT ON STRANG.CONVOY_DETAILS_VW TO WEBSYS;
