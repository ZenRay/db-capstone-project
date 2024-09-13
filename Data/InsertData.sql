USE LittleLemonDB;

SET FOREIGN_KEY_CHECKS = 0;

-- 插入数据，检查是否成功
INSERT INTO `LittleLemonDB`.`Bookings` (`BookingId`, `BookingDate`, `TableNo`, `PhoneNo`, `EmployeeId`) VALUES (1, '2022-10-10', 5, '18873654', 1);
INSERT INTO `LittleLemonDB`.`Bookings` (`BookingId`, `BookingDate`, `TableNo`, `PhoneNo`, `EmployeeId`) VALUES (2, '2022-11-12', 3, '18873654', 2);
INSERT INTO `LittleLemonDB`.`Bookings` (`BookingId`, `BookingDate`, `TableNo`, `PhoneNo`, `EmployeeId`) VALUES (3, '2022-10-11', 2, '18766424', 4);
INSERT INTO `LittleLemonDB`.`Bookings` (`BookingId`, `BookingDate`, `TableNo`, `PhoneNo`, `EmployeeId`) VALUES (4, '2022-10-13', 2, '18867542', 3);


-- 确认数据插入后是否正确
SELECT * FROM Customer WHERE PhoneNo = '18873654';
SELECT * FROM Bookings WHERE BookingId = 1;
SELECT * FROM Staff;
-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;
