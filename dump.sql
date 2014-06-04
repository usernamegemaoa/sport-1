-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               5.1.71-community-log - MySQL Community Server (GPL)
-- ОС Сервера:                   Win32
-- HeidiSQL Версия:              8.1.0.4545
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Дамп структуры базы данных sport
CREATE DATABASE IF NOT EXISTS `sport` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sport`;


-- Дамп структуры для таблица sport.conditions
CREATE TABLE IF NOT EXISTS `conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '0',
  `mark` int(11) DEFAULT NULL,
  `active` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Состояние утром';

-- Дамп данных таблицы sport.conditions: ~6 rows (приблизительно)
DELETE FROM `conditions`;
/*!40000 ALTER TABLE `conditions` DISABLE KEYS */;
INSERT INTO `conditions` (`id`, `value`, `mark`, `active`) VALUES
	(1, 'Бодрячком', 100, 'Y'),
	(2, 'Нормальное', 80, 'Y'),
	(3, 'Вялый', 30, 'Y'),
	(4, 'Спать охота', 20, 'Y'),
	(5, 'Вчера пил', -20, 'Y'),
	(6, 'Жесткий бадунище', -200, 'Y');
/*!40000 ALTER TABLE `conditions` ENABLE KEYS */;


-- Дамп структуры для таблица sport.morning_statistics
CREATE TABLE IF NOT EXISTS `morning_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `morning_condition` int(11) NOT NULL DEFAULT '0',
  `current_condition` int(11) NOT NULL DEFAULT '0',
  `getup_time` time NOT NULL DEFAULT '00:00:00',
  `alarm_time` time NOT NULL DEFAULT '07:30:00',
  `bed_time` time NOT NULL DEFAULT '00:00:00',
  `weather` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `morning_condition` (`morning_condition`),
  KEY `current_condition` (`current_condition`),
  KEY `weather` (`weather`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Статитистика первой авторизации в систему за день';

-- Дамп данных таблицы sport.morning_statistics: ~2 rows (приблизительно)
DELETE FROM `morning_statistics`;
/*!40000 ALTER TABLE `morning_statistics` DISABLE KEYS */;
INSERT INTO `morning_statistics` (`id`, `date`, `morning_condition`, `current_condition`, `getup_time`, `alarm_time`, `bed_time`, `weather`) VALUES
	(1, '2014-06-03 23:22:47', 2, 4, '07:45:00', '07:30:00', '00:00:00', 4),
	(2, '2014-06-04 09:55:40', 2, 2, '08:45:00', '07:30:00', '01:40:00', 4);
/*!40000 ALTER TABLE `morning_statistics` ENABLE KEYS */;


-- Дамп структуры для таблица sport.places
CREATE TABLE IF NOT EXISTS `places` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '0',
  `active` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Места занятия спортом';

-- Дамп данных таблицы sport.places: ~4 rows (приблизительно)
DELETE FROM `places`;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
INSERT INTO `places` (`id`, `name`, `active`) VALUES
	(1, 'Работа', 'Y'),
	(2, 'Улица', 'Y'),
	(3, 'Тренажерный зал', 'Y'),
	(4, 'Дом', 'Y');
/*!40000 ALTER TABLE `places` ENABLE KEYS */;


-- Дамп структуры для таблица sport.pullups
CREATE TABLE IF NOT EXISTS `pullups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` int(11) DEFAULT NULL,
  `place` int(11) DEFAULT NULL,
  `fatigue` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `where` (`place`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='Информация о подтягиваниях';

-- Дамп данных таблицы sport.pullups: ~15 rows (приблизительно)
DELETE FROM `pullups`;
/*!40000 ALTER TABLE `pullups` DISABLE KEYS */;
INSERT INTO `pullups` (`id`, `value`, `place`, `fatigue`, `timestamp`) VALUES
	(1, 10, 1, '7', '2014-06-03 10:19:11'),
	(3, 6, 1, '5', '2014-06-03 10:56:58'),
	(4, 7, 1, '5', '2014-06-03 11:22:03'),
	(5, 10, 1, '5', '2014-06-03 11:41:17'),
	(6, 3, 1, '2', '2014-06-03 14:56:48'),
	(8, 6, 1, NULL, '2014-06-03 17:26:48'),
	(9, 10, 1, NULL, '2014-06-03 17:26:51'),
	(10, 6, 1, NULL, '2014-06-03 17:36:49'),
	(11, 7, 1, NULL, '2014-06-03 17:36:53'),
	(12, 15, 1, NULL, '2014-06-04 09:57:35'),
	(13, 5, 1, '5', '2014-06-04 10:45:42'),
	(14, 5, 1, '2', '2014-06-04 12:32:26'),
	(15, 11, 1, '6', '2014-06-04 12:43:40'),
	(16, 8, 1, '7', '2014-06-04 16:22:38'),
	(17, 12, 1, '6', '2014-06-04 18:14:42');
/*!40000 ALTER TABLE `pullups` ENABLE KEYS */;


-- Дамп структуры для таблица sport.pushups
CREATE TABLE IF NOT EXISTS `pushups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` int(11) DEFAULT NULL,
  `place` int(11) DEFAULT NULL,
  `fatigue` int(11) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `place` (`place`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Отжимания';

-- Дамп данных таблицы sport.pushups: ~1 rows (приблизительно)
DELETE FROM `pushups`;
/*!40000 ALTER TABLE `pushups` DISABLE KEYS */;
INSERT INTO `pushups` (`id`, `value`, `place`, `fatigue`, `timestamp`) VALUES
	(1, 20, 4, NULL, '2014-06-03 21:44:31');
/*!40000 ALTER TABLE `pushups` ENABLE KEYS */;


-- Дамп структуры для таблица sport.ration
CREATE TABLE IF NOT EXISTS `ration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `number` tinyint(4) DEFAULT NULL,
  `kkal` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `KEY` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Дневной рацион';

-- Дамп данных таблицы sport.ration: ~0 rows (приблизительно)
DELETE FROM `ration`;
/*!40000 ALTER TABLE `ration` DISABLE KEYS */;
/*!40000 ALTER TABLE `ration` ENABLE KEYS */;


-- Дамп структуры для таблица sport.ration_types
CREATE TABLE IF NOT EXISTS `ration_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `mark` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Типы приема пищи';

-- Дамп данных таблицы sport.ration_types: ~0 rows (приблизительно)
DELETE FROM `ration_types`;
/*!40000 ALTER TABLE `ration_types` DISABLE KEYS */;
INSERT INTO `ration_types` (`id`, `value`, `mark`) VALUES
	(1, 'Полноценный завтрак', 10),
	(2, 'Быстрый завтрак', 5),
	(3, 'Чай-завтрак', 1),
	(4, 'Полноценный обед', 10),
	(5, 'Обед без второго', 7),
	(6, 'Полноценный ужин', 10),
	(7, 'Быстрый ужин', 5),
	(8, 'Перекус', 3);
/*!40000 ALTER TABLE `ration_types` ENABLE KEYS */;


-- Дамп структуры для таблица sport.water_ration
CREATE TABLE IF NOT EXISTS `water_ration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Прием воды';

-- Дамп данных таблицы sport.water_ration: ~0 rows (приблизительно)
DELETE FROM `water_ration`;
/*!40000 ALTER TABLE `water_ration` DISABLE KEYS */;
/*!40000 ALTER TABLE `water_ration` ENABLE KEYS */;


-- Дамп структуры для таблица sport.water_types
CREATE TABLE IF NOT EXISTS `water_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `kkal` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Виды приема воды\r\n';

-- Дамп данных таблицы sport.water_types: ~6 rows (приблизительно)
DELETE FROM `water_types`;
/*!40000 ALTER TABLE `water_types` DISABLE KEYS */;
INSERT INTO `water_types` (`id`, `value`, `kkal`) VALUES
	(1, 'Вода', 0),
	(2, 'Сок', 0),
	(3, 'Чай', 0),
	(4, 'Кофе', 0),
	(5, 'Газировка сладкая', 0),
	(6, 'Минералка', 0);
/*!40000 ALTER TABLE `water_types` ENABLE KEYS */;


-- Дамп структуры для таблица sport.weather
CREATE TABLE IF NOT EXISTS `weather` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '0',
  `mark` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='Состояния погоды';

-- Дамп данных таблицы sport.weather: ~5 rows (приблизительно)
DELETE FROM `weather`;
/*!40000 ALTER TABLE `weather` DISABLE KEYS */;
INSERT INTO `weather` (`id`, `value`, `mark`) VALUES
	(1, 'Жарко', 50),
	(2, 'Солнечно и жарко', 100),
	(3, 'Душно', 50),
	(4, 'Пасмурно', 30),
	(5, 'Дождь', 0);
/*!40000 ALTER TABLE `weather` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
