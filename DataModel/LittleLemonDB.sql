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
  `CustomerName` VARCHAR(45) NULL,
  `Contack` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PhoneNo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `EmployeeID` INT NOT NULL,
  `EmployeeRole` VARCHAR(45) NULL,
  `Role` VARCHAR(45) NULL,
  `Salary` VARCHAR(45) NULL,
  PRIMARY KEY (`EmployeeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookingId` INT NOT NULL,
  `date` DATE NOT NULL,
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
    ON UPDATE CASCADE,
  CONSTRAINT `fk_employee`
    FOREIGN KEY (`EmployeeId`)
    REFERENCES `LittleLemonDB`.`Staff` (`EmployeeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuId` INT NOT NULL,
  `Starter` VARCHAR(45) NOT NULL,
  `Courses` VARCHAR(45) NOT NULL,
  `Drinks` VARCHAR(45) NULL,
  `Desserts` VARCHAR(45) NULL,
  `Cusion` VARCHAR(45) NULL,
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

USE `LittleLemonDB`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `LittleLemonDB`.`Bookings_BEFORE_INSERT` BEFORE INSERT ON `Bookings` FOR EACH ROW
BEGIN
	INSERT IGNORE INTO Customer(PhoneNo, CustomerName, Contact) VALUES(NEW.PhoneNo, NULL, NEW.PhoneNo);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
