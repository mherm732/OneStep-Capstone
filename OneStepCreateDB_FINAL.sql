-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema onestepdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema onestepdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `onestepdb` DEFAULT CHARACTER SET utf8mb3 ;
USE `onestepdb` ;

-- -----------------------------------------------------
-- Table `onestepdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `onestepdb`.`user` (
  `userId` CHAR(36) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `userPassword` VARCHAR(255) NOT NULL,
  `registrationDate` DATETIME NOT NULL,
  `lastLogin` DATETIME NOT NULL,
  PRIMARY KEY (`userId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `onestepdb`.`goal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `onestepdb`.`goal` (
  `goalId` CHAR(36) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `goalDescription` VARCHAR(255) NULL DEFAULT NULL,
  `dateCreated` DATETIME NOT NULL,
  `dateCompleted` DATETIME NULL DEFAULT NULL,
  `totalSteps` INT NOT NULL,
  `stepsCompleted` INT NOT NULL,
  `userId` CHAR(36) NOT NULL,
  `goalStatus` ENUM('CANCELLED', 'COMPLETED', 'IN_PROGRESS') NULL DEFAULT NULL,
  PRIMARY KEY (`goalId`),
  INDEX `fk_Goals_Account_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `fk_Goals_Account`
    FOREIGN KEY (`userId`)
    REFERENCES `onestepdb`.`user` (`userId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `onestepdb`.`step`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `onestepdb`.`step` (
  `stepId` CHAR(36) NOT NULL,
  `stepDescription` VARCHAR(255) NULL DEFAULT NULL,
  `dateCreated` DATETIME NOT NULL,
  `dateCompleted` DATETIME NULL DEFAULT NULL,
  `dueDate` DATETIME NULL DEFAULT NULL,
  `status` ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED') NOT NULL,
  `isAiGenerated` BIT(1) NULL DEFAULT NULL,
  `goalId` CHAR(36) NOT NULL,
  `stepOrder` INT NOT NULL,
  PRIMARY KEY (`stepId`, `goalId`),
  INDEX `fk_Steps_Goals1_idx` (`goalId` ASC) VISIBLE,
  CONSTRAINT `fk_Steps_Goals1`
    FOREIGN KEY (`goalId`)
    REFERENCES `onestepdb`.`goal` (`goalId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
