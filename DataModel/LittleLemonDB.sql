-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8mb4 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `PhoneNo` VARCHAR(20) NOT NULL,
  `FullName` VARCHAR(45) NULL,
  `ContactNumber` VARCHAR(45) NULL,
  `CustomerId` INT NULL AUTO_INCREMENT,
  PRIMARY KEY (`PhoneNo`),
  UNIQUE INDEX `CustomerId_UNIQUE` (`CustomerId` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `EmployeeId` INT NOT NULL,
  `EmployeeRole` VARCHAR(45) NULL,
  `Role` VARCHAR(45) NULL,
  `Salary` VARCHAR(45) NULL,
  PRIMARY KEY (`EmployeeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookingId` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  `TableNo` INT NOT NULL,
  `PhoneNo` VARCHAR(20) NOT NULL,
  `EmployeeId` INT NULL,
  INDEX `fk_customer_idx` (`PhoneNo` ASC) VISIBLE,
  PRIMARY KEY (`BookingId`),
  INDEX `fk_employee_idx` (`EmployeeId` ASC) VISIBLE,
  CONSTRAINT `fk_customer`
    FOREIGN KEY (`PhoneNo`)
    REFERENCES `LittleLemonDB`.`Customer` (`PhoneNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_employee`
    FOREIGN KEY (`EmployeeId`)
    REFERENCES `LittleLemonDB`.`Staff` (`EmployeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuId` INT NOT NULL,
  `Courses` VARCHAR(45) NOT NULL,
  `Cuision` VARCHAR(45) NULL,
  `MenuName` VARCHAR(45) NULL,
  `MenuItemId` INT NULL,
  PRIMARY KEY (`MenuId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OrderDelivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrderDelivery` (
  `OrderId` INT NOT NULL,
  `DeliveryDate` DATE NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`OrderId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderId` INT NOT NULL,
  `OrderDate` DATE NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL(10,2) NOT NULL,
  `BookingId` INT NOT NULL,
  `MenuId` INT NOT NULL,
  `CustomerId` INT NOT NULL,
  PRIMARY KEY (`OrderId`),
  INDEX `fk_booking_idx` (`BookingId` ASC) VISIBLE,
  INDEX `fk_menu_idx` (`MenuId` ASC) VISIBLE,
  CONSTRAINT `fk_booking`
    FOREIGN KEY (`BookingId`)
    REFERENCES `LittleLemonDB`.`Bookings` (`BookingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_menu`
    FOREIGN KEY (`MenuId`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery`
    FOREIGN KEY (`OrderId`)
    REFERENCES `LittleLemonDB`.`OrderDelivery` (`OrderId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MeunItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MeunItem` (
  `MenuItemId` INT NOT NULL,
  `CourseName` VARCHAR(45) NULL,
  `StarterName` VARCHAR(45) NULL,
  `DesertName` VARCHAR(45) NULL,
  `DrinkName` VARCHAR(45) NULL,
  PRIMARY KEY (`MenuItemId`))
ENGINE = InnoDB;

USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Placeholder table for view `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrdersView` (`OrderId` INT, `Quantity` INT, `Cost` INT);

-- -----------------------------------------------------
-- Placeholder table for view `LittleLemonDB`.`MenuOver2Quantity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuOver2Quantity` (`MenuName` INT);

-- -----------------------------------------------------
-- procedure LowestCostAmount
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE `LowestCostAmount` ()
BEGIN
	SELECT
		t1.CustomerId AS CustomerID
		,t1.FullName
		,t2.OrderId AS OrderID
		,t2.TotalCost AS Cost
		,t3.MenuName
		,t4.CourseName
	FROM Bookings t0
	JOIN Customer t1
		USING(PhoneNo)
	JOIN Orders t2
		ON t2.BookingId = t0.BookingId
	JOIN Menu t3
		ON t3.MenuId = t2.MenuId
	JOIN MenuItem t4
		ON t4.MenuItemId = t3.MenuItemId
	WHERE t2.TotalCost > 150
	;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE GetMaxQuantity ()
BEGIN
SELECT MAX(Quantity) FROM Orders;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE `CancelOrder` (IN id INT)
BEGIN
	UPDATE Orders SET status="CANCEL" WHERE OrderId=id;
    SELECT CONCAT("Order ", id, "is Cancelled");
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE `CheckBooking` (IN dates DATE, IN table_no INT)
BEGIN
	SELECT
		IF(
			COUNT(1)>=1, CONCAT("Table ", table_no, " is already booked"), CONCAT("Table ", table_no, " is not booked")
        ) AS `Booking Status`
	FROM Bookings
    WHERE BookingDate = dates AND TableNo = table_no;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddValidBooking
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE `AddValidBooking` (
    IN booking_date DATE, 
    IN table_no INT
)
BEGIN
    -- 声明变量
    DECLARE booking_count INT;
    DECLARE phone_no VARCHAR(20); 
    DECLARE employee_id INT;
    DECLARE booking_id INT;
    
    -- 开始事务
    START TRANSACTION;

    -- 生成随机电话号码 (格式为: XXX-XXX-XXXX)
    SELECT CONCAT(
        LPAD(FLOOR(RAND() * 900) + 100, 3, '0'), '-', 
        LPAD(FLOOR(RAND() * 900) + 100, 3, '0'), '-', 
        LPAD(FLOOR(RAND() * 10000), 4, '0')
    ) INTO phone_no;

    -- 生成随机员工ID (假设1-100为有效ID)
    SELECT FLOOR(1 + RAND() * 100) INTO employee_id;
    
    -- 获取 booking ID
    SELECT MAX(BookingId) + 1 INTO booking_id FROM Bookings;

    -- 检查预订冲突
    SELECT COUNT(1) INTO booking_count
    FROM Bookings
    WHERE BookingDate = booking_date AND TableNo = table_no;

    -- IF ELSE 逻辑判断
    IF booking_count > 0 THEN
        -- 如果已预订，回滚事务
        ROLLBACK;
        SELECT CONCAT('Table ', table_no, ' is already booked - booking cancelled') AS `Booking Status`;
    ELSE
        -- 如果未预订，插入新预订并提交事务
        INSERT INTO Bookings (BookingId, BookingDate, TableNo, PhoneNo, EmployeeId)
        VALUES (booking_id, booking_date, table_no, phone_no, employee_id);

        -- 提交事务
        COMMIT;
        SELECT CONCAT('Booking confirmed for table ', table_no, ' on ', booking_date) AS `Booking Status`;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddBooking
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE `AddBooking` (
	IN booking_id INT,
    IN customer_id INT,
    IN table_no INT,
    IN booking_date DATE
)
BEGIN
    DECLARE phone_no VARCHAR(20);
    DECLARE employee_id INT;
    
    -- 用户数量
    DECLARE customer_count INT;
    -- 订单数量
    DECLARE booking_count INT;
    
    
    -- 开始事务
    START TRANSACTION;

	-- 检查重复用户
	SELECT
		COUNT(1) INTO customer_count
	FROM Customer
    WHERE CustomerId = customer_id;
    
    -- 获取电话号码，如果没有用户ID，那么生成随机电话号码 (格式为: XXX-XXX-XXXX)
    IF customer_count = 0 THEN
		SELECT CONCAT(
			LPAD(FLOOR(RAND() * 900) + 100, 3, '0'), '-', 
			LPAD(FLOOR(RAND() * 900) + 100, 3, '0'), '-', 
			LPAD(FLOOR(RAND() * 10000), 4, '0')
		) INTO phone_no;
	ELSE
		SELECT
			PhoneNo INTO phone_no
		FROM Customer
        WHERE CustomerId = customer_id
        GROUP BY 1;
	END IF;
    
    -- 生成随机员工ID (假设1-100为有效ID)
    SELECT FLOOR(1 + RAND() * 100) INTO employee_id;
    

    -- 检查预订冲突
    SELECT COUNT(1) INTO booking_count
    FROM Bookings
    WHERE (BookingDate = booking_date AND TableNo = table_no) OR BookingId=booking_id;

    -- IF ELSE 逻辑判断
    IF booking_count > 0 THEN
        -- 如果已预订，回滚事务
        ROLLBACK;
        SELECT CONCAT('Booking Duplicated, Commissiong Failed') AS `Confirmation`;
    ELSE
        -- 如果未预订，插入新预订并提交事务
        INSERT INTO Bookings (BookingId, BookingDate, TableNo, PhoneNo, EmployeeId)
        VALUES (booking_id, booking_date, table_no, phone_no, employee_id);

        -- 提交事务
        COMMIT;
        SELECT "New Booking Added" AS `Confirmation`;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateBooking
-- -----------------------------------------------------

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE `UpdateBooking` (
	IN booking_id INT,
    IN booking_date DATE
)
BEGIN
    -- 订单数量
    DECLARE booking_count INT;
    
    -- 开始事务
    START TRANSACTION;

    -- 检查预订冲突
    SELECT COUNT(1) INTO booking_count
    FROM Bookings
    WHERE BookingId=booking_id;

    -- IF ELSE 逻辑判断
    IF booking_count = 0 THEN
        -- 如果未提交，回滚事务
        ROLLBACK;
        SELECT CONCAT('Booking Information Uncommitted') AS `Confirmation`;
    ELSE
        -- 如果已预订，更新信息
        UPDATE Bookings
        SET BookingDate = booking_date
        WHERE BookingId = booking_id;
        
        -- 提交事务
        COMMIT;
        SELECT CONCAT("Booking ", booking_id, " Updated") AS `Confirmation`;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`OrdersView`;
USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW `OrdersView` AS
SELECT
	OrderId
    ,Quantity
    ,TotalCost AS Cost
FROM Orders
WHERE Quantity > 2
;

-- -----------------------------------------------------
-- View `LittleLemonDB`.`MenuOver2Quantity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`MenuOver2Quantity`;
USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW `MenuOver2Quantity` AS
SELECT
	t1.MenuName
FROM Menu t1
WHERE t1.Menuid =ANY (
SELECT
	t2.MenuId
FROM Orders t2
GROUP BY 1
HAVING SUM(t2.Quantity) > 2
)
;
USE `LittleLemonDB`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `LittleLemonDB`.`Bookings_BEFORE_INSERT` BEFORE INSERT ON `Bookings` FOR EACH ROW
BEGIN
	IF (SELECT COUNT(1) FROM Customer WHERE PhoneNo = NEW.PhoneNo)=0 THEN
		INSERT INTO Customer(PhoneNo, FullName, ContactNumber) VALUES(NEW.PhoneNo, NULL, NEW.PhoneNo);
	END IF;
    
	IF (SELECT COUNT(1) FROM Staff WHERE EmployeeId = NEW.EmployeeId)=0 THEN
		INSERT INTO Staff(EmployeeId) VALUES(NEW.EmployeeId);
	END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
